import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uk_circle_partners/core/utils/network_utils.dart';
import 'package:uk_circle_partners/core/utils/session_manager.dart';

/// Result wrapper so the UI can show the backend's own error message
/// (e.g. "You already have an EXPO Ambassador application ...").
class ExpoApiResult<T> {
  final bool success;
  final String message;
  final T? data;

  const ExpoApiResult({required this.success, required this.message, this.data});
}

class ExpoAmbassadorApi {
  static String get _baseUrl => NetworkUtils.baseUrl;

  static Map<String, String> _headers() {
    final token = SessionManager.token;
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static String _extractMessage(dynamic body, String fallback) {
    if (body is Map) {
      final msg = body['message'];
      if (msg is List && msg.isNotEmpty) return msg.first.toString();
      if (msg is String && msg.isNotEmpty) return msg;
    }
    return fallback;
  }

  /// POST /expo-ambassador/applications
  static Future<ExpoApiResult<Map<String, dynamic>>> submitApplication(
      Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('$_baseUrl/expo-ambassador/applications');
      final response = await http.post(url, headers: _headers(), body: jsonEncode(body));
      final decoded = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ExpoApiResult(
          success: true,
          message: _extractMessage(decoded, 'Application submitted'),
          data: (decoded?['data'] as Map?)?.cast<String, dynamic>(),
        );
      }
      return ExpoApiResult(
        success: false,
        message: _extractMessage(decoded, 'Could not submit application (${response.statusCode}).'),
      );
    } catch (e) {
      return const ExpoApiResult(
        success: false,
        message: 'Network error. Please check your connection and try again.',
      );
    }
  }

  /// GET /expo-ambassador/applications/my
  static Future<ExpoApiResult<List<dynamic>>> getMyApplications() async {
    try {
      final url = Uri.parse('$_baseUrl/expo-ambassador/applications/my');
      final response = await http.get(url, headers: _headers());
      final decoded = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        return ExpoApiResult(
          success: true,
          message: _extractMessage(decoded, ''),
          data: (decoded?['data'] as List?) ?? const [],
        );
      }
      return ExpoApiResult(
        success: false,
        message: _extractMessage(decoded, 'Could not load applications (${response.statusCode}).'),
      );
    } catch (e) {
      return const ExpoApiResult(success: false, message: 'Network error.');
    }
  }
}
