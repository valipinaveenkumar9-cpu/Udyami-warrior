import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../api/api_client.dart';

class ApiService {
  final ApiClient _api = ApiClient();

  Future<void> createCpOnboardingForm({
    required String userId,
    required String title,
    required String description,
    required List<Map<String, dynamic>> formSchema,
  }) async {
    final response = await _api.post('/cp-on-boarding/create-form', {
      'userId': userId,
      'title': title,
      'description': description,
      'formSchema': formSchema,
      'isActive': true,
    });
    if (response == null || response['success'] == false) {
      throw Exception('Failed to create form: ${response?['error']}');
    }
  }

  // Fetch the created form schema
  Future<Map<String, dynamic>> getCpOnboardingForm(String userId) async {
    final response = await _api.get('/cp-on-boarding/assigned-forms/$userId');
    if (response == null || response['success'] == false) {
      throw Exception('Failed to load form: ${response?['error']}');
    }
    return response;
  }

  // Submit filled dynamic form data
  Future<void> submitCpOnboardingForm({
    required String formId,
    required String userId,
    required Map<String, dynamic> answers,
    String? photoPath,
  }) async {
    List<http.MultipartFile>? files;
    if (photoPath != null && photoPath.isNotEmpty) {
      files = [await http.MultipartFile.fromPath('files', photoPath)];
    }
    
    final response = await _api.postMultipart(
      '/cp-on-boarding/submit',
      fields: {
        'formId': formId,
        'userId': userId,
        'answers': jsonEncode(answers),
      },
      files: files,
    );

    if (response == null || response['success'] == false) {
      throw Exception('Failed to submit form: ${response?['error']}');
    }
  }

  // Fetch all submitted data by CP
  Future<List<dynamic>> getAllCPData(String userId) async {
    final response = await _api.get('/cp-on-boarding/getAllCPSubmittedDataCreatedBYWardChairman/$userId');
    if (response == null) return [];
    if (response is List) {
      return response;
    }
    if (response is Map && response['success'] == false) {
      throw Exception('Failed to load CP data: ${response['error']}');
    }
    return response as List<dynamic>;
  }

  // Fetch the assigned route for a channel partner
  Future<Map<String, dynamic>?> getAssignedRoute(String channelPartnerId) async {
    final response = await _api.get('/create-route/getAssignedRoute/$channelPartnerId');
    if (response == null || response['success'] == false) return null;
    
    if (response['data'] is List) {
      print("DEV DEBUG - getAssignedRoute - Available Routes:");
      for (var route in response['data']) {
        print(" -> Route ID: ${route['routeId']} | Name: ${route['routeName']} | Status: ${route['status']}");
      }
    }
    
    return response;
  }

  // Fetch all wards
  Future<dynamic> getAllWards() async {
    return await _api.get('/ward/getAllWards?limit=1000');
  }

  // Fetch ward boundaries (GeoJSON)
  Future<dynamic> getWardMap(String wardName, {String type = 'ward'}) async {
    return await _api.get('/ward/map/$wardName?type=$type');
  }

  // Start the journey
  Future<bool> startJourney(String routeId, String channelPartnerId) async {
    final response = await _api.patch('/create-route/start-journey/$routeId?channelPartnerId=$channelPartnerId', {});
    return response != null && response['success'] != false;
  }

  // Complete the journey
  Future<bool> completeJourney(String routeId, String channelPartnerId) async {
    final response = await _api.patch('/create-route/complete-journey/$routeId?channelPartnerId=$channelPartnerId', {});
    return response != null && response['success'] != false;
  }

  // Update Route (Live tracking)
  Future<bool> updateRoute({
    required String routeId,
    String? channelPartnerId,
    String? wardChairmanId,
    String? routeName,
    required List<List<double>> coordinates,
    double plannedDistance = 0,
    double estimatedDuration = 0,
  }) async {
    final response = await _api.patch('/create-route/updateRoute', {
      "routeId": routeId,
      if (channelPartnerId != null) "channelPartnerId": channelPartnerId,
      if (wardChairmanId != null) "wardChairmanId": wardChairmanId,
      if (routeName != null) "routeName": routeName,
      "routePath": {
        "type": "LineString",
        "coordinates": coordinates,
      },
      "plannedDistance": plannedDistance,
      "estimatedDuration": estimatedDuration,
    });
    return response != null && response['success'] != false;
  }

  // Update live location
  Future<bool> updateLiveLocation({
    required String routeId,
    required String channelPartnerId,
    required double latitude,
    required double longitude,
    required double accuracy,
    required double speed,
    required double battery,
  }) async {
    final response = await _api.post('/create-route/updateLiveLocation', {
      "routeId": routeId,
      "channelPartnerId": channelPartnerId,
      "latitude": latitude,
      "longitude": longitude,
      "accuracy": accuracy,
      "speed": speed,
      "battery": battery,
    });
    return response != null && response['success'] != false;
  }

  // Track Channel Partner Route
  Future<Map<String, dynamic>?> trackCPRoute(String channelPartnerId) async {
    final response = await _api.get('/create-route/trackCPRoute/$channelPartnerId');
    if (response == null || response['success'] == false) return null;
    return response;
  }

  // Get journey reports
  Future<Map<String, dynamic>?> getJourneyReports(String type, String userId) async {
    final response = await _api.get('/create-route/journey-reports/$type/$userId');
    if (response == null || response['success'] == false) return null;
    return response;
  }
  // Submit CP Survey Data
  Future<void> submitSurveyData({
    required String cpUserId,
    String? subBusinessId,
    required String latitude,
    required String longitude,
    required String surveyNumber,
    required String locationAddress,
    required String locationType,
    required int numberOfFloors,
    required String floors,
    String? houseImagePath,
  }) async {
    List<http.MultipartFile>? files;
    if (houseImagePath != null && houseImagePath.isNotEmpty) {
      String extension = houseImagePath.split('.').last.toLowerCase();
      String mimeType = 'jpeg';
      if (extension == 'png') {
        mimeType = 'png';
      } else if (extension == 'webp') mimeType = 'webp';
      else if (extension == 'jpg') mimeType = 'jpeg';
      
      files = [
        await http.MultipartFile.fromPath(
          'houseImages', 
          houseImagePath,
          contentType: MediaType('image', mimeType),
        )
      ];
    }
    
    final Map<String, String> fields = {
      'cpUserId': cpUserId,
      'latitude': latitude,
      'longitude': longitude,
      'surveyNumber': surveyNumber,
      'locationAddress': locationAddress,
      'locationType': locationType,
      'numberOfFloors': numberOfFloors.toString(),
      'floors': floors,
    };
    if (subBusinessId != null) {
      fields['subBusinessId'] = subBusinessId;
    }
    
    final response = await _api.postMultipart(
      '/cp-on-boarding/submitServeyData',
      fields: fields,
      files: files,
    );

    if (response == null || response['success'] == false) {
      throw Exception('Failed to submit survey: ${response?['error']}');
    }
  }

  // Get CPSubmittedData
  Future<List<dynamic>> getCPSubmittedData(String cpUserId) async {
    final response = await _api.get('/cp-on-boarding/getCPSubmittedData/$cpUserId');
    if (response == null) return [];
    if (response is List) {
      return response;
    }
    if (response is Map) {
      if (response['success'] == false) {
        throw Exception('Failed to load surveys: ${response['error']}');
      }
      return response['data'] ?? [];
    }
    return response as List<dynamic>;
  }

  // Get Reward Points
  Future<Map<String, dynamic>?> getAllMyRewardPoints(String cpUserId) async {
    final response = await _api.get('/cp-on-boarding/getAllMyRewardPoints/$cpUserId');
    if (response == null || response['success'] == false) return null;
    return response;
  }
}
