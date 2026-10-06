import 'api_client.dart';

class AuthAPI {
  final ApiClient _api = ApiClient();

  Future<dynamic> sendOtp(String mobileNumber, String purpose) async {
    return await _api.post('/auth/send-otp', {
      'mobileNumber': mobileNumber,
      'purpose': purpose,
    });
  }

  Future<dynamic> verifyOtp(String mobileNumber, String otp, String purpose) async {
    return await _api.post('/auth/verify-otp', {
      'mobileNumber': mobileNumber,
      'otp': otp,
      'purpose': purpose,
    });
  }

  Future<dynamic> login(String mobileNumber, {String? otp, String? verificationId, bool? testMode}) async {
    final body = <String, dynamic>{
      'mobileNumber': mobileNumber,
    };
    
    if (testMode == true) {
      body['testMode'] = true;
    }

    if (verificationId != null && verificationId.isNotEmpty) {
      body['verificationId'] = verificationId;
    }

    if (otp != null && otp.isNotEmpty) {
      body['otp'] = otp;
    }
    
    return await _api.post('/auth/loginUser', body);
  }

  Future<dynamic> createUser(Map<String, dynamic> data) async {
    return await _api.post('/auth/createUser', data);
  }

  Future<dynamic> createUserProfile(Map<String, dynamic> data) async {
    return await _api.post('/userprofile/createUserProfile', data);
  }

  String _normalizeMobile(String num) {
    final clean = num.replaceAll(RegExp(r'\D'), '');
    if (clean.length > 10) {
      return clean.substring(clean.length - 10);
    }
    return clean;
  }

  Future<bool> isTestUser(String mobileNumber) async {
    final target = _normalizeMobile(mobileNumber);
    if (target.isEmpty) return false;

    int page = 1;
    const limit = 50;
    while (true) {
      try {
        final response = await _api.get('/test-users/getAllTestUsers?page=$page&limit=$limit');
        if (response != null && response is Map && response['success'] == true) {
          final List<dynamic> data = response['data'] as List<dynamic>? ?? [];
          if (data.isEmpty) break;

          for (final item in data) {
            if (item is Map) {
              final rawMob = item['mobileNumber']?.toString() ?? '';
              if (_normalizeMobile(rawMob) == target) {
                print('DEV DEBUG - isTestUser - Found test user match for: $mobileNumber (target: $target)');
                return true;
              }
            }
          }

          if (data.length < limit) break;
          page++;
        } else {
          break;
        }
      } catch (e) {
        print('DEV DEBUG - isTestUser exception: $e');
        break;
      }
    }
    return false;
  }
}
