import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/api/auth_api.dart';
import '../../../../core/utils/session_manager.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  String? _currentMobileNumber;

  AuthBloc() : super(AuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<LoginWithCpIdEvent>(_onLoginWithCpId);
    on<ResetAuthEvent>(_onResetAuth);
  }

  bool _isCpRoleString(String? val) {
    if (val == null) return false;
    final normalized = val.toLowerCase().replaceAll('_', '').replaceAll(' ', '').replaceAll('-', '');
    return normalized == 'channelpartner' || normalized == 'cp';
  }

  bool _isChannelPartnerRole(Map<String, dynamic>? user) {
    if (user == null) return false;

    // 1. Check roles array (e.g. ["channel_partner"])
    final roles = user['roles'] as List<dynamic>? ?? [];
    for (final r in roles) {
      if (_isCpRoleString(r?.toString())) return true;
    }

    // 2. Check userRoles array (e.g. [{"role": {"roleName": "channel_partner", "role": "ChannelPartner"}}])
    final userRoles = user['userRoles'] as List<dynamic>? ?? [];
    for (final ur in userRoles) {
      if (ur is Map) {
        if (_isCpRoleString(ur['roleName']?.toString())) return true;
        if (_isCpRoleString(ur['role']?.toString())) return true;
        if (ur['role'] is Map) {
          final roleMap = ur['role'] as Map<String, dynamic>;
          if (_isCpRoleString(roleMap['roleName']?.toString())) return true;
          if (_isCpRoleString(roleMap['role']?.toString())) return true;
        }
      } else if (ur is String) {
        if (_isCpRoleString(ur)) return true;
      }
    }

    // 3. Check single role string
    if (_isCpRoleString(user['role']?.toString())) return true;
    if (_isCpRoleString(user['roleName']?.toString())) return true;

    // 4. Check cpId
    final cpId = user['cpId']?.toString() ?? '';
    if (cpId.isNotEmpty && cpId.toLowerCase() != 'null') return true;

    return false;
  }

  void _onLoginWithCpId(LoginWithCpIdEvent event, Emitter<AuthState> emit) async {
    print('DEV DEBUG - _onLoginWithCpId - auth_bloc.dart - Logging in CP ID: ${event.cpId}');
    emit(AuthLoading());
    emit(const AuthError('CP ID login is not available. Please use mobile number login.'));
  }

  void _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    print(
      'DEV DEBUG - _onSendOtp - auth_bloc.dart - Sending OTP for: ${event.mobileNumber} (isApplying: ${event.isApplying})',
    );
    emit(AuthLoading());

    try {
      final authApi = AuthAPI();

      // 1. Check if user is a Test User FIRST
      print('DEV DEBUG - [TEST-USER CHECK STARTED] Checking if ${event.mobileNumber} is a test user...');
      final isTestUser = await authApi.isTestUser(event.mobileNumber);
      print('DEV DEBUG - [TEST-USER CHECK RESULT] isTestUser: $isTestUser');

      if (isTestUser) {
        print('DEV DEBUG - [TEST-USER BYPASS] Test user detected for: ${event.mobileNumber}. Skipping real sendOtp() API call and pre-filling OTP as 123456.');
        _currentMobileNumber = event.mobileNumber;
        emit(OtpSentState(event.mobileNumber, providedOtp: '123456'));
        return;
      }

      // 2. Not a Test User -> Run existing CP role pre-check BEFORE sending OTP
      print('DEV DEBUG - [PRE-CHECK STARTED] Checking user status for: ${event.mobileNumber}');
      
      Map<String, dynamic>? userObj;
      try {
        final preCheckRes = await authApi.login(event.mobileNumber, testMode: true);
        print('DEV DEBUG - [PRE-CHECK RESPONSE] $preCheckRes');
        if (preCheckRes != null && preCheckRes is Map) {
          if (preCheckRes['user'] is Map<String, dynamic>) {
            userObj = preCheckRes['user'] as Map<String, dynamic>;
          } else if (preCheckRes['data'] is Map<String, dynamic>) {
            final dataMap = preCheckRes['data'] as Map<String, dynamic>;
            userObj = (dataMap['user'] is Map<String, dynamic>)
                ? dataMap['user'] as Map<String, dynamic>
                : dataMap;
          }
        }
      } catch (e) {
        print('DEV DEBUG - [PRE-CHECK EXCEPTION] $e');
      }

      bool isCpInDb = _isChannelPartnerRole(userObj);
      print('DEV DEBUG - [PRE-CHECK RESULT] User is Channel Partner: $isCpInDb');

      if (!event.isApplying) {
        // Requirement 1: Channel Partner Login Screen
        if (!isCpInDb) {
          print('DEV DEBUG - [PRE-CHECK BLOCKED] OTP sending BLOCKED for CP Login - User is not a Channel Partner.');
          emit(const AuthError('Your number is not registered as a Channel Partner. Please apply here to become a Channel Partner.'));
          return;
        }
        print('DEV DEBUG - [PRE-CHECK PASSED] User is a Channel Partner. Proceeding to send OTP for CP Login...');
      } else {
        // Requirement 2: Become a Channel Partner Screen
        if (isCpInDb) {
          print('DEV DEBUG - [PRE-CHECK BLOCKED] OTP sending BLOCKED for Become CP - User is ALREADY a Channel Partner.');
          emit(const AuthError('You are already a Channel Partner. Please login.'));
          return;
        }
        print('DEV DEBUG - [PRE-CHECK PASSED] User is not a Channel Partner. Proceeding to send OTP for Become CP...');
      }

      // 3. Send real OTP for normal users
      final response = await authApi.sendOtp(event.mobileNumber, event.purpose);
      if (response != null && response['success'] == true) {
        _currentMobileNumber = event.mobileNumber;
        print('DEV DEBUG - _onSendOtp - OTP sent successfully');
        
        final rawOtp = response['otp']?.toString();
        final String? providedOtp = (rawOtp != null && rawOtp.isNotEmpty) ? rawOtp : null;
        
        emit(OtpSentState(event.mobileNumber, providedOtp: providedOtp));
      } else {
        emit(AuthError(response?['message'] ?? response?['error'] ?? 'Failed to send OTP'));
      }
    } catch (e) {
      emit(AuthError('Failed to send OTP: $e'));
    }
  }

  void _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    print(
      'DEV DEBUG - _onVerifyOtp - auth_bloc.dart - Verifying OTP: ${event.otp}',
    );
    if (_currentMobileNumber == null) {
      emit(const AuthError('Something went wrong, please try again.'));
      return;
    }

    emit(AuthLoading());

    try {
      final authApi = AuthAPI();

      final isTestUser = await authApi.isTestUser(_currentMobileNumber!);

      dynamic verifyResponse;
      if (!isTestUser) {
        // 1. Verify real-time OTP first via /auth/verify-otp for normal users
        verifyResponse = await authApi.verifyOtp(
          _currentMobileNumber!,
          event.otp,
          'LOGIN',
        );
        
        if (verifyResponse == null || verifyResponse['success'] != true) {
          final errorMsg = verifyResponse?['message'] ?? verifyResponse?['error'] ?? 'Invalid OTP';
          emit(OtpVerificationError(errorMsg, _currentMobileNumber!));
          return;
        }
      }

      // 2. Call loginUser with OTP, verificationId, and testMode
      final verificationId = verifyResponse?['verificationId']?.toString();
      final isTestMode = isTestUser || verifyResponse?['testMode'] == true;
      final response = await authApi.login(
        _currentMobileNumber!,
        otp: event.otp,
        verificationId: verificationId,
        testMode: isTestMode,
      );

      print('DEV DEBUG - loginUser response: $response');

      if (response != null && response['success'] != false) {
        final token = response['accessToken'] as String?;
        final user = response['user'] as Map<String, dynamic>?;

        if (token == null || user == null) {
          await SessionManager.clearSession();
          emit(const AuthError('Your number is not registered as a Channel Partner. Please apply here to become a Channel Partner.'));
          return;
        }

        bool isChannelPartner = _isChannelPartnerRole(user);

        if (!event.isApplying) {
          // Channel Partner Login: Must have CHANNEL_PARTNER role in database (unless test user)
          if (!isChannelPartner && !isTestUser) {
            print('DEV DEBUG - _onVerifyOtp - RBAC Failed: User is not a channel partner');
            await SessionManager.clearSession();
            emit(const AuthError('Your number is not registered as a Channel Partner. Please apply here to become a Channel Partner.'));
            return;
          }
          await SessionManager.saveSession(token, user);
          emit(OtpVerifiedState());
        } else {
          // Become a Channel Partner: If already a CP, block and prompt to login (unless test user)
          if (isChannelPartner && !isTestUser) {
            print('DEV DEBUG - _onVerifyOtp - Apply tab: User already has CHANNEL_PARTNER');
            await SessionManager.clearSession();
            emit(const AuthError('You are already a Channel Partner. Please login.'));
            return;
          }
          await SessionManager.saveSession(token, user);
          emit(OtpVerifiedForApplicationState());
        }
      } else {
        await SessionManager.clearSession();
        final errorMsg = response?['message'] ?? response?['error'] ?? 'Your number is not registered as a Channel Partner. Please apply here to become a Channel Partner.';
        print('DEV DEBUG - _onVerifyOtp - Error: $errorMsg');
        emit(OtpVerificationError(errorMsg, _currentMobileNumber!));
      }
    } catch (e) {
      await SessionManager.clearSession();
      emit(
        OtpVerificationError(
          'Your number is not registered as a Channel Partner. Please apply here to become a Channel Partner.',
          _currentMobileNumber!,
        ),
      );
    }
  }

  void _onResetAuth(ResetAuthEvent event, Emitter<AuthState> emit) {
    print('DEV DEBUG - _onResetAuth - auth_bloc.dart - Resetting Auth state');
    _currentMobileNumber = null;
    emit(AuthInitial());
  }
}
