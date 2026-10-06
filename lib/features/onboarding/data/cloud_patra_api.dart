import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uk_circle_partners/core/utils/session_manager.dart';
import 'package:uk_circle_partners/core/utils/network_utils.dart';

class CloudPatraApi {
  static String get baseUrl => NetworkUtils.baseUrl;

  /// Get All Business Verticals
  static Future<List<dynamic>> getBusinessVerticals() async {
    try {
      final url = Uri.parse('$baseUrl/cp-on-boarding/business-verticals');
      print('DEV DEBUG - get - cloud_patra_api.dart - API GET Request to: $url');
      final token = SessionManager.token;
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rawList = (data['data'] as List<dynamic>?) ?? [];
        return rawList.where((c) {
          final name = (c['verticalName'] ?? c['name'] ?? c['title'] ?? '').toString().toLowerCase();
          final id = (c['verticalId'] ?? c['_id'] ?? '').toString().toLowerCase();
          final isCloud = name.contains('cloud') || name.contains('patra') || id.contains('cloud');
          final isOwnify = name.contains('ownify') || id.contains('ownify');
          final isCircle = name.contains('circlepac') || name.contains('circle pac') || id.contains('circlepac');
          final isBhoomi = name.contains('bhoomi') || name.contains('vault') || id.contains('bhoomi');
          final isFirstGo = (name.contains('first go') || name.contains('firstgo') || name.contains('stay') || id.contains('first_go_stay') || id.contains('firstgo')) && !name.contains('choice') && !name.contains('bank');
          final isFirstChoice = (name.contains('first choice') || name.contains('firstchoice') || name.contains('bank') || id.contains('firstchoice') || id.contains('first_choice')) && !name.contains('stay') && !name.contains('go');
          final isBuildAi = name.contains('build ai') || name.contains('build_ai') || name.contains('build aihomes') || id.contains('build_ai') || id.contains('buildai');
          return isCloud || isOwnify || isCircle || isBhoomi || isFirstGo || isFirstChoice || isBuildAi;
        }).toList();
      } else {
        print('DEV DEBUG - error - cloud_patra_api.dart - Error fetching business verticals: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('DEV DEBUG - error - cloud_patra_api.dart - Exception fetching business verticals: $e');
      return [];
    }
  }

  /// Get Sub-Business Verticals by Vertical ID
  static Future<List<dynamic>> getSubBusinessVerticals(String verticalId) async {
    try {
      final url = Uri.parse('$baseUrl/cp-on-boarding/sub-business-vertical/$verticalId');
      print('DEV DEBUG - get - cloud_patra_api.dart - API GET Request to: $url');
      final token = SessionManager.token;
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data']['subVerticals'] != null) {
          return data['data']['subVerticals'];
        }
        return [];
      } else {
        print('DEV DEBUG - error - cloud_patra_api.dart - Error fetching sub verticals: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('DEV DEBUG - error - cloud_patra_api.dart - Exception fetching sub verticals: $e');
      return [];
    }
  }

  /// Get All Wards
  static Future<Map<String, dynamic>?> getAllWards() async {
    try {
      final url = Uri.parse('$baseUrl/ward/getAllWards?limit=1000');
      print('DEV DEBUG - get - cloud_patra_api.dart - API GET Request to: $url');
      final token = SessionManager.token;
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('DEV DEBUG - error - cloud_patra_api.dart - Error fetching wards: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('DEV DEBUG - error - cloud_patra_api.dart - Exception fetching wards: $e');
      return null;
    }
  }

  /// Get Ward Map GeoJSON
  static Future<Map<String, dynamic>?> getWardMap(String wardName, {String type = 'ward'}) async {
    try {
      final url = Uri.parse('$baseUrl/ward/map/$wardName?type=$type');
      print('DEV DEBUG - get - cloud_patra_api.dart - API GET Request to: $url');
      final token = SessionManager.token;
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('DEV DEBUG - error - cloud_patra_api.dart - Error fetching ward map: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('DEV DEBUG - error - cloud_patra_api.dart - Exception fetching ward map: $e');
      return null;
    }
  }

  /// Register Cloud Patra CP Application
  static Future<bool> registerCloudPatraCpApplication(Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('$baseUrl/cloud-patra/registerCloudPatraCp/application');
      print('DEV DEBUG - post - cloud_patra_api.dart - API POST Request to: $url');
      String? token;
      try {
        token = SessionManager.token;
      } catch (_) {}
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('DEV DEBUG - post - cloud_patra_api.dart - Application registered successfully');
        return true;
      } else {
        print('DEV DEBUG - error - cloud_patra_api.dart - Error registering application: ${response.body}');
        return false;
      }
    } catch (e) {
      print('DEV DEBUG - error - cloud_patra_api.dart - Exception registering application: $e');
      return false;
    }
  }

  /// Get My Applications
  static Future<List<dynamic>?> getMyApplications(String userId) async {
    try {
      final url = Uri.parse('$baseUrl/cloud-patra/getMyApplications/$userId');
      print('DEV DEBUG - get - cloud_patra_api.dart - API GET Request to: $url');
      final token = SessionManager.token;
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['data']; // Returns a list of applications
        }
        return null;
      } else {
        print('DEV DEBUG - error - cloud_patra_api.dart - Error fetching applications: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('DEV DEBUG - error - cloud_patra_api.dart - Exception fetching applications: $e');
      return null;
    }
  }

  /// Verify Member ID (strictly against logged-in user only)
  static Future<Map<String, dynamic>?> verifyMemberId(String memberId) async {
    print('DEV DEBUG - verifyMemberId - cloud_patra_api.dart - Starting strict verification for Member ID: $memberId');
    try {
      final currentUser = SessionManager.user;
      if (currentUser != null) {
        final currentMemberId = currentUser['memberId']?.toString().toUpperCase();
        final currentUserId = currentUser['userId']?.toString();
        
        print('DEV DEBUG - verifyMemberId - cloud_patra_api.dart - Checking against active session (Session MemberId: $currentMemberId, Session UserId: $currentUserId)');
        
        if (currentMemberId == memberId.toUpperCase() || currentUserId == memberId) {
          print('DEV DEBUG - verifyMemberId - cloud_patra_api.dart - SUCCESS: Verified from local session');
          return currentUser;
        } else {
          print('DEV DEBUG - verifyMemberId - cloud_patra_api.dart - FAILED: Entered $memberId does not match the currently logged-in user.');
          return null;
        }
      } else {
        print('DEV DEBUG - verifyMemberId - cloud_patra_api.dart - FAILED: No active session found to verify against.');
        return null;
      }
    } catch (e) {
      print('DEV DEBUG - error - cloud_patra_api.dart - FAILED: Exception occurred verifying member ID: $e');
      return null;
    }
  }

  /// Get Interview Schedule by Application ID
  static Future<List<dynamic>?> getInterviewDetails(String applicationId) async {
    try {
      final url = Uri.parse('$baseUrl/cloud-patra/getAllScheduleInterviewsBy/$applicationId');
      print('DEV DEBUG - get - cloud_patra_api.dart - API GET Request to: $url');
      final token = SessionManager.token;
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print('DEV DEBUG - get - cloud_patra_api.dart - API Response Status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          if (data['data'] is List) {
            return data['data'];
          } else {
            return [data['data']];
          }
        }
      }
      return null;
    } catch (e) {
      print('DEV DEBUG - error - cloud_patra_api.dart - Exception fetching interview details: $e');
      return null;
    }
  }
}
