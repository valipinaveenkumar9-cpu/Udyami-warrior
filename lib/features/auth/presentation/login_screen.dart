import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';
import '../view_model/auth_bloc/auth_bloc.dart';
import '../view_model/auth_bloc/auth_event.dart';
import '../view_model/auth_bloc/auth_state.dart';
import '../../home/presentation/main_screen.dart';
import '../../onboarding/presentation/company_selection_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: const _LoginScreenView(),
    );
  }
}

class _LoginScreenView extends StatefulWidget {
  const _LoginScreenView();

  @override
  State<_LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<_LoginScreenView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Apply for CP
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  // CP Login
  final TextEditingController _cpMobileController = TextEditingController();
  final TextEditingController _cpOtpController = TextEditingController();
  final TextEditingController _cpIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _useCpIdLogin = false;
  bool _isListeningForSms = false;

  Timer? _resendTimer;
  int _resendIn = 0;

  // Color Palette matching HTML design
  static const Color ink = Color(0xFF1E2A44);
  static const Color inkSoft = Color(0xFF3E4A63);
  static const Color paper = Color(0xFFF3EEDD);
  static const Color paperAlt = Color(0xFFFBF8EE);
  static const Color seal = Color(0xFF0E5C4A);
  static const Color sealDark = Color(0xFF0A4438);
  static const Color stamp = Color(0xFFA13D2E);
  static const Color gold = Color(0xFFA9791F);
  static const Color goldTint = Color(0xFFF1E7CC);
  static const Color line = Color(0xFFD9D0B8);
  static const Color muted = Color(0xFF7A7360);
  static const Color saffron = Color(0xFFE67722);

  @override
  void initState() {
    super.initState();
    _mobileController.addListener(_onMobileChanged);
    _cpMobileController.addListener(_onCpMobileChanged);
  }

  void _onMobileChanged() {
    final state = context.read<AuthBloc>().state;
    if (state is OtpSentState || state is OtpVerificationError) {
      _stopListeningForOtp();
      _stopResendTimer();
      context.read<AuthBloc>().add(ResetAuthEvent());
      _otpController.clear();
    }
  }

  void _onCpMobileChanged() {
    final state = context.read<AuthBloc>().state;
    if (state is OtpSentState || state is OtpVerificationError) {
      _stopListeningForOtp();
      _stopResendTimer();
      context.read<AuthBloc>().add(ResetAuthEvent());
      _cpOtpController.clear();
    }
  }

  void _startResendTimer() {
    _stopResendTimer();
    setState(() => _resendIn = 30);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendIn > 0) {
        setState(() => _resendIn--);
      } else {
        timer.cancel();
      }
    });
  }

  void _stopResendTimer() {
    _resendTimer?.cancel();
    if (_resendIn != 0) {
      setState(() => _resendIn = 0);
    }
  }

  Future<void> _startListeningForOtp() async {
    if (kIsWeb || !Platform.isAndroid) return;
    await _stopListeningForOtp();
    _isListeningForSms = true;

    try {
      final res = await SmartAuth.instance.getSmsWithUserConsentApi(
        matcher: r'\b\d{6}\b',
      );

      if (!_isListeningForSms) return;

      if (res.hasData && res.data?.code != null) {
        final code = res.data!.code!;
        if (code.length == 6 && mounted) {
          setState(() {
            _otpController.text = code;
            _cpOtpController.text = code;
          });
        }
      }
    } catch (e) {
      debugPrint('SMS auto-detection error: $e');
    } finally {
      _isListeningForSms = false;
    }
  }

  Future<void> _stopListeningForOtp() async {
    if (kIsWeb || !Platform.isAndroid) return;
    _isListeningForSms = false;
    try {
      await SmartAuth.instance.removeUserConsentApiListener();
      await SmartAuth.instance.removeSmsRetrieverApiListener();
    } catch (e) {
      debugPrint('Error stopping SMS listener: $e');
    }
  }

  @override
  void dispose() {
    _stopListeningForOtp();
    _stopResendTimer();
    _pageController.dispose();
    _mobileController.removeListener(_onMobileChanged);
    _mobileController.dispose();
    _otpController.dispose();
    _cpMobileController.removeListener(_onCpMobileChanged);
    _cpMobileController.dispose();
    _cpOtpController.dispose();
    _cpIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _getOtp({required bool isApplying}) {
    final controller = isApplying ? _mobileController : _cpMobileController;
    final text = controller.text.trim();
    if (text.length != 10 || int.tryParse(text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You entered an invalid phone number. Please enter 10 digits.'),
          backgroundColor: stamp,
        ),
      );
      return;
    }
    _stopListeningForOtp();
    if (isApplying) {
      _otpController.clear();
    } else {
      _cpOtpController.clear();
    }
    context.read<AuthBloc>().add(SendOtpEvent(text, isApplying: isApplying));
  }

  void _verifyOtp({required bool isApplying}) {
    final controller = isApplying ? _otpController : _cpOtpController;
    final otp = controller.text.trim();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 6-digit OTP'),
          backgroundColor: stamp,
        ),
      );
      return;
    }
    context.read<AuthBloc>().add(VerifyOtpEvent(otp, isApplying: isApplying));
  }

  void _onCpIdLogin() {
    final cpId = _cpIdController.text.trim();
    final password = _passwordController.text.trim();
    if (cpId.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both CP ID and Password'),
          backgroundColor: stamp,
        ),
      );
      return;
    }
    context.read<AuthBloc>().add(LoginWithCpIdEvent(cpId, password));
  }

  void _slideToPage(int page) {
    _stopListeningForOtp();
    _stopResendTimer();
    context.read<AuthBloc>().add(ResetAuthEvent());
    _otpController.clear();
    _cpOtpController.clear();
    setState(() => _currentPage = page);
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  Widget _buildTricolorBar() {
    return SizedBox(
      height: 4,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(child: Container(color: saffron)),
          Expanded(child: Container(color: paper)),
          Expanded(child: Container(color: seal)),
        ],
      ),
    );
  }

  Widget _buildBrandHeader() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: seal.withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.asset(
              'assets/logo/uk_warrior_logo_512x512.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: sealDark,
                child: const Center(
                  child: Text(
                    'UB',
                    style: TextStyle(
                      color: paper,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Serif',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'UB WARRIORS',
          style: TextStyle(
            color: ink,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            fontFamily: 'Serif',
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 14, height: 1, color: gold),
            const SizedBox(width: 6),
            const Text(
              'PARTNERS FOR A STRONGER BHARAT',
              style: TextStyle(
                color: gold,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(width: 6),
            Container(width: 14, height: 1, color: gold),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCardTitle(String title, {Widget? trailing}) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: line, width: 1.0),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: gold,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Serif',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: sealDark,
              ),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildMobileInput({
    required TextEditingController controller,
    required bool enabled,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 48,
              width: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: errorText != null ? stamp : line, width: 1.5),
              ),
              child: const Text(
                '+91',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: inkSoft,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: errorText != null ? stamp : line, width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(30, 42, 68, 0.04),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller,
                  enabled: enabled,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: enabled ? ink : inkSoft,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Enter 10-digit mobile number',
                    hintStyle: TextStyle(color: Color(0xFFB3A98F), fontSize: 14),
                    border: InputBorder.none,
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText,
            style: const TextStyle(color: stamp, fontSize: 11.5),
          ),
        ],
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: inkSoft,
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: line, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(30, 42, 68, 0.04),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            enabled: enabled,
            style: const TextStyle(fontSize: 14.5, color: ink),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFFB3A98F), fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpSection({
    required TextEditingController controller,
    required bool isLoading,
    required bool isApplying,
    String? errorText,
  }) {
    final defaultPinTheme = PinTheme(
      width: 44,
      height: 50,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: ink,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: errorText != null ? stamp : line, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(30, 42, 68, 0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter OTP',
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: inkSoft,
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: AutofillGroup(
            child: Pinput(
              length: 6,
              controller: controller,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  border: Border.all(color: seal, width: 2.0),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  border: Border.all(color: stamp, width: 2.0),
                ),
              ),
              enabled: !isLoading,
              onCompleted: (_) => _verifyOtp(isApplying: isApplying),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Center(
            child: Text(
              errorText,
              style: const TextStyle(color: stamp, fontSize: 11.5),
            ),
          ),
        ],
        const SizedBox(height: 12),
        Center(
          child: InkWell(
            onTap: (_resendIn <= 0 && !isLoading)
                ? () {
                    _getOtp(isApplying: isApplying);
                    _startResendTimer();
                  }
                : null,
            child: Text(
              _resendIn > 0 ? 'Resend OTP in ${_resendIn}s' : 'Resend OTP',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: _resendIn <= 0 ? FontWeight.w600 : FontWeight.normal,
                color: _resendIn <= 0 ? sealDark : muted,
                decoration: _resendIn <= 0 ? TextDecoration.underline : TextDecoration.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: _buildButton(
            text: isApplying ? 'Verify & Continue' : 'Login',
            isLoading: isLoading,
            onPressed: () => _verifyOtp(isApplying: isApplying),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: () {
              _stopResendTimer();
              _stopListeningForOtp();
              context.read<AuthBloc>().add(ResetAuthEvent());
              if (isApplying) {
                _otpController.clear();
              } else {
                _cpOtpController.clear();
              }
            },
            child: Text(
              isApplying ? 'Change Mobile Number' : 'Change Login Method',
              style: const TextStyle(
                fontSize: 12.5,
                color: sealDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required bool isLoading,
    required VoidCallback onPressed,
    bool isGhost = false,
  }) {
    if (isGhost) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: seal, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: sealDark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF169873), Color(0xFF12735E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          minimumSize: const Size(150, 44),
        ),
        child: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
      ),
    );
  }

  Widget _buildApplyBox() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            const Expanded(child: Divider(color: line, thickness: 1)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'NEW TO UB WARRIORS?',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: muted,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const Expanded(child: Divider(color: line, thickness: 1)),
          ],
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: gold, width: 1.5),
          ),
          child: Column(
            children: [
              const Text(
                'Want to become a Channel Partner?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Serif',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5B4415),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Apply now and start your journey with UB WARRIORS.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF6B5624),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 15),
              _buildButton(
                text: 'Apply Here',
                isLoading: false,
                isGhost: true,
                onPressed: () => _slideToPage(1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpSentState) {
            if (state.providedOtp != null && state.providedOtp!.isNotEmpty) {
              _otpController.text = state.providedOtp!;
              _cpOtpController.text = state.providedOtp!;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.providedOtp != null
                    ? 'Test user detected. OTP pre-filled with ${state.providedOtp}.'
                    : 'OTP sent successfully to your mobile number.'),
                backgroundColor: seal,
              ),
            );
            _startListeningForOtp();
            _startResendTimer();
          } else if (state is OtpVerifiedState) {
            _stopListeningForOtp();
            _stopResendTimer();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login Successful! Welcome back.'),
                backgroundColor: seal,
              ),
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          } else if (state is OtpVerifiedForApplicationState) {
            _stopListeningForOtp();
            _stopResendTimer();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Mobile verified! Choose a company to begin.'),
                backgroundColor: seal,
              ),
            );
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CompanySelectionScreen()),
            );
          } else if (state is AuthError) {
            _stopListeningForOtp();
            if (state.message.contains('already')) {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  backgroundColor: paperAlt,
                  title: Row(
                    children: const [
                      Icon(Icons.info_outline, color: seal, size: 28),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Already a Channel Partner',
                          style: TextStyle(
                            fontFamily: 'Serif',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                  content: const Text(
                    'You are already a Channel Partner. Please login.',
                    style: TextStyle(fontSize: 14, color: inkSoft, height: 1.4),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        context.read<AuthBloc>().add(ResetAuthEvent());
                      },
                      child: const Text('Cancel', style: TextStyle(color: muted)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: seal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        context.read<AuthBloc>().add(ResetAuthEvent());
                        _slideToPage(0);
                      },
                      child: const Text('Login Here', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            } else if (state.message.contains('not registered') ||
                state.message.contains('apply') ||
                state.message.contains('not a cp') ||
                state.message.contains('pending approval')) {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  backgroundColor: paperAlt,
                  title: Row(
                    children: const [
                      Icon(Icons.error_outline, color: stamp, size: 28),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Not Registered as CP',
                          style: TextStyle(
                            fontFamily: 'Serif',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                  content: const Text(
                    'Your number is not registered as a Channel Partner. Please apply here to become a Channel Partner.',
                    style: TextStyle(fontSize: 14, color: inkSoft, height: 1.4),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        context.read<AuthBloc>().add(ResetAuthEvent());
                      },
                      child: const Text('Cancel', style: TextStyle(color: muted)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: seal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        context.read<AuthBloc>().add(ResetAuthEvent());
                        _slideToPage(1);
                      },
                      child: const Text('Apply Here', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: stamp),
              );
            }
          } else if (state is OtpVerificationError) {
            if (_currentPage == 1) {
              _otpController.clear();
            } else {
              _cpOtpController.clear();
            }
            _startListeningForOtp();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: stamp),
            );
          }
        },
        builder: (context, state) {
          final isOtpSent = state is OtpSentState || state is OtpVerificationError;
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildTricolorBar(),
                  _buildBrandHeader(),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        // Panel 1: CP Login
                        SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Welcome to UB WARRIORS',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Serif',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: ink,
                                ),
                              ),
                              const SizedBox(height: 18),
                              _buildCardTitle(
                                'Channel Partner Login',
                                trailing: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _useCpIdLogin = !_useCpIdLogin;
                                    });
                                    context.read<AuthBloc>().add(ResetAuthEvent());
                                  },
                                  child: Text(
                                    _useCpIdLogin ? 'Use Mobile OTP' : 'Use CP ID',
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      color: sealDark,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              if (!_useCpIdLogin) ...[
                                const Text(
                                  'Mobile Number',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: inkSoft,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                _buildMobileInput(
                                  controller: _cpMobileController,
                                  enabled: !isLoading && !isOtpSent,
                                ),
                                const SizedBox(height: 16),
                                if (isOtpSent) ...[
                                  _buildOtpSection(
                                    controller: _cpOtpController,
                                    isLoading: isLoading,
                                    isApplying: false,
                                  ),
                                ] else ...[
                                  Center(
                                    child: _buildButton(
                                      text: 'Send OTP',
                                      isLoading: isLoading,
                                      onPressed: () => _getOtp(isApplying: false),
                                    ),
                                  ),
                                ],
                              ] else ...[
                                _buildInputField(
                                  label: 'CP ID',
                                  hint: 'e.g. CP1234',
                                  controller: _cpIdController,
                                  enabled: !isLoading,
                                ),
                                const SizedBox(height: 16),
                                _buildInputField(
                                  label: 'Password',
                                  hint: 'Enter your password',
                                  controller: _passwordController,
                                  obscureText: true,
                                  enabled: !isLoading,
                                ),
                                const SizedBox(height: 24),
                                Center(
                                  child: _buildButton(
                                    text: 'Login',
                                    isLoading: isLoading,
                                    onPressed: _onCpIdLogin,
                                  ),
                                ),
                              ],
                              _buildApplyBox(),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),

                        // Panel 2: Become a Channel Partner / Apply (Mobile Verification)
                        SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Become a Channel Partner',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Serif',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: ink,
                                ),
                              ),
                              const SizedBox(height: 18),
                              _buildCardTitle('Mobile Verification'),
                              const Text(
                                'Mobile Number',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: inkSoft,
                                  letterSpacing: 0.1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              _buildMobileInput(
                                controller: _mobileController,
                                enabled: !isLoading && !isOtpSent,
                              ),
                              const SizedBox(height: 16),
                              if (isOtpSent) ...[
                                _buildOtpSection(
                                  controller: _otpController,
                                  isLoading: isLoading,
                                  isApplying: true,
                                ),
                              ] else ...[
                                Center(
                                  child: _buildButton(
                                    text: 'Send OTP',
                                    isLoading: isLoading,
                                    onPressed: () => _getOtp(isApplying: true),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 24),
                              Center(
                                child: TextButton.icon(
                                  onPressed: () => _slideToPage(0),
                                  icon: const Icon(Icons.arrow_back, size: 16, color: sealDark),
                                  label: const Text(
                                    'Back to CP Login',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: sealDark,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
