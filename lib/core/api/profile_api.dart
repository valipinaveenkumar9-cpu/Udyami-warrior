import 'package:http/http.dart' as http;
import 'dart:io';
import 'api_client.dart';

class ProfileAPI {
  final ApiClient _api = ApiClient();

  Future<dynamic> getUserProfileById(String userId) async {
    return await _api.get('/userprofile/getUserProfileById/$userId');
  }
  
  Future<dynamic> updateUserProfile(String userId, Map<String, dynamic> data) async {
    return await _api.patch('/userprofile/updateUserProfile/$userId', data);
  }

  Future<dynamic> uploadProfileImage(String userId, File imageFile) async {
    print('DEV DEBUG - ProfileAPI: uploadProfileImage called for userId: $userId, file: ${imageFile.path}');
    final multipartFile = await http.MultipartFile.fromPath(
      'profileImage',
      imageFile.path,
    );
    return await _api.patchMultipart(
      '/userprofile/updateUserProfile/$userId',
      fields: {},
      files: [multipartFile],
    );
  }

  Future<dynamic> createProfileWithImage(String userId, File imageFile) async {
    print('DEV DEBUG - ProfileAPI: createProfileWithImage called for userId: $userId, file: ${imageFile.path}');
    final multipartFile = await http.MultipartFile.fromPath(
      'profileImage',
      imageFile.path,
    );
    return await _api.postMultipart(
      '/userprofile/createUserProfile',
      fields: {'userId': userId},
      files: [multipartFile],
    );
  }

  Future<dynamic> deleteUserProfile(String userId) async {
    return await _api.delete('/userprofile/deleteUserProfile/$userId');
  }

  Future<dynamic> uploadBusinessImages(String userId, List<File> imageFiles, {String? businessDetailsJson, Map<String, String>? profileFields}) async {
    print('DEV DEBUG - ProfileAPI: uploadBusinessImages called for userId: $userId, files: ${imageFiles.length}');
    final List<http.MultipartFile> multipartFiles = [];
    for (var imageFile in imageFiles) {
      multipartFiles.add(await http.MultipartFile.fromPath(
        'businessImages',
        imageFile.path,
      ));
    }
    
    final fields = <String, String>{
      'userId': userId,
      'hasBusiness': 'true',
    };
    
    if (businessDetailsJson != null) {
      fields['businessDetails'] = businessDetailsJson;
    }

    if (profileFields != null) {
      fields.addAll(profileFields);
    }
    
    return await _api.postMultipart(
      '/userprofile/createUserProfile',
      fields: fields,
      files: multipartFiles,
    );
  }
}
