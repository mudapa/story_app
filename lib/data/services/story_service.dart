import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_app/data/model/list_story_model.dart';

import '../../shared/api_path.dart';
import '../../shared/helper.dart';
import '../model/detail_story_model.dart';
import '../model/story.dart';
import '../model/upload_response.dart';

class StoryService {
  Future<List<Story>> getAllStory({
    int? page,
    int? size,
  }) async {
    var headers = {'Authorization': 'Bearer ${settings.get('user')['token']}'};
    final response = await http.get(
      Uri.parse('${ApiPath.baseUrl}/stories?page=$page&size=$size'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return ListStoryModel.fromJson(jsonDecode(response.body)).listStory!;
    } else {
      var message = json.decode(response.body)['message'];
      throw Exception(message);
    }
  }

  Future<DetailStoryModel> getStoryById(String id) async {
    var headers = {'Authorization': 'Bearer ${settings.get('user')['token']}'};
    final response = await http.get(
      Uri.parse('${ApiPath.baseUrl}/stories/$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return DetailStoryModel.fromJson(jsonDecode(response.body));
    } else {
      var message = json.decode(response.body)['message'];
      throw Exception(message);
    }
  }

  Future<UploadResponse> uploadStory({
    required String description,
    required List<int> bytes,
    required String fileName,
    double? lat,
    double? lon,
  }) async {
    var headers = {
      'Authorization': 'Bearer ${settings.get('user')['token']}',
      'Content-Type': 'multipart/form-data',
    };

    var multiPartFile = http.MultipartFile.fromBytes(
      'photo',
      bytes,
      filename: fileName,
    );

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiPath.baseUrl}/stories'),
    )
      ..headers.addAll(headers)
      ..fields['description'] = description
      ..files.add(multiPartFile);

    if (lat != null && lon != null) {
      request.fields.addAll({
        'lat': lat.toString(),
        'lon': lon.toString(),
      });
    }

    var response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 201) {
      var responseData = json.decode(response.body);
      return UploadResponse.fromJson(responseData);
    } else {
      var message = json.decode(response.body)['message'];
      throw Exception(message);
    }
  }
}
