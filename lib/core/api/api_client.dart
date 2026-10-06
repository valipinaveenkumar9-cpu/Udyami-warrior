import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/network_utils.dart';
import '../utils/session_manager.dart';

class ApiClient {
  final String baseUrl = NetworkUtils.baseUrl;

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    final token = SessionManager.token;
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('DEV DEBUG - post - api.dart - API POST Request to: $url');
    print('DEV DEBUG - post - api.dart - API POST Body: ${jsonEncode(body)}');
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(body),
      );
      print('DEV DEBUG - post - api.dart - API POST Response Status: ${response.statusCode}');
      print('DEV DEBUG - post - api.dart - API POST Response Body: ${response.body}');
      return _processResponse(response);
    } catch (e) {
      print('DEV DEBUG - post - api.dart - API POST Exception: $e');
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('DEV DEBUG - get - api.dart - API GET Request to: $url');
    try {
      final response = await http.get(url, headers: _headers);
      print('DEV DEBUG - get - api.dart - API GET Response Status [${response.statusCode}] from: $url');
      print('DEV DEBUG - get - api.dart - API GET Response Body: ${response.body}');
      return _processResponse(response);
    } catch (e) {
      print('DEV DEBUG - get - api.dart - API GET Exception for $url: $e');
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('DEV DEBUG - put - api.dart - API PUT Request to: $url');
    print('DEV DEBUG - put - api.dart - API PUT Body: ${jsonEncode(body)}');
    try {
      final response = await http.put(
        url,
        headers: _headers,
        body: jsonEncode(body),
      );
      print('DEV DEBUG - put - api.dart - API PUT Response Status [${response.statusCode}] from: $url');
      print('DEV DEBUG - put - api.dart - API PUT Response Body: ${response.body}');
      return _processResponse(response);
    } catch (e) {
      print('DEV DEBUG - put - api.dart - API PUT Exception for $url: $e');
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  Future<dynamic> patch(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('DEV DEBUG - patch - api.dart - API PATCH Request to: $url');
    print('DEV DEBUG - patch - api.dart - API PATCH Body: ${jsonEncode(body)}');
    try {
      final response = await http.patch(
        url,
        headers: _headers,
        body: jsonEncode(body),
      );
      print('DEV DEBUG - patch - api.dart - API PATCH Response Status [${response.statusCode}] from: $url');
      print('DEV DEBUG - patch - api.dart - API PATCH Response Body: ${response.body}');
      return _processResponse(response);
    } catch (e) {
      print('DEV DEBUG - patch - api.dart - API PATCH Exception for $url: $e');
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  Future<dynamic> delete(String endpoint, {Map<String, dynamic>? data}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('DEV DEBUG - delete - api.dart - API DELETE Request to: $url');
    try {
      final response = await http.delete(
        url,
        headers: _headers,
        body: data != null ? jsonEncode(data) : null,
      );
      print('DEV DEBUG - delete - api.dart - API DELETE Response Status [${response.statusCode}] from: $url');
      print('DEV DEBUG - delete - api.dart - API DELETE Response Body: ${response.body}');
      return _processResponse(response);
    } catch (e) {
      print('DEV DEBUG - delete - api.dart - API DELETE Exception for $url: $e');
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  Future<dynamic> postMultipart(
    String endpoint, {
    required Map<String, String> fields,
    List<http.MultipartFile>? files,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('DEV DEBUG - postMultipart - api.dart - API POST Multipart to: $url');
    print('DEV DEBUG - postMultipart - api.dart - Fields: $fields');
    try {
      final request = http.MultipartRequest('POST', url);
      final token = SessionManager.token;
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Accept'] = 'application/json';

      fields.forEach((key, value) {
        request.fields[key] = value;
      });

      if (files != null) {
        for (var file in files) {
          request.files.add(file);
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print('DEV DEBUG - postMultipart - api.dart - Response Status [${response.statusCode}] from: $url');
      print('DEV DEBUG - postMultipart - api.dart - Response Body: ${response.body}');
      return _processResponse(response);
    } catch (e) {
      print('DEV DEBUG - postMultipart - api.dart - Exception for $url: $e');
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  Future<dynamic> patchMultipart(
    String endpoint, {
    required Map<String, String> fields,
    List<http.MultipartFile>? files,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('DEV DEBUG - patchMultipart - api.dart - API PATCH Multipart to: $url');
    print('DEV DEBUG - patchMultipart - api.dart - Fields: $fields');
    try {
      final request = http.MultipartRequest('PATCH', url);
      final token = SessionManager.token;
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Accept'] = 'application/json';

      fields.forEach((key, value) {
        request.fields[key] = value;
      });

      if (files != null) {
        for (var file in files) {
          request.files.add(file);
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print('DEV DEBUG - patchMultipart - api.dart - Response Status [${response.statusCode}] from: $url');
      print('DEV DEBUG - patchMultipart - api.dart - Response Body: ${response.body}');
      return _processResponse(response);
    } catch (e) {
      print('DEV DEBUG - patchMultipart - api.dart - Exception for $url: $e');
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      try {
        return jsonDecode(response.body);
      } catch (e) {
        return response.body; 
      }
    } else {
      String errorMsg = 'Error ${response.statusCode}';
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map) {
          final msg = decoded['message'] ?? decoded['error'] ?? errorMsg;
          return {
            'success': false,
            'statusCode': response.statusCode,
            'message': msg.toString(),
            'error': msg.toString(),
            'data': decoded,
          };
        }
      } catch (_) {}
      return {'success': false, 'statusCode': response.statusCode, 'error': errorMsg, 'message': errorMsg};
    }
  }
}
