import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../shared/api_path.dart';
import '../../shared/helper.dart';
import '../model/user_model.dart';

class AuthService {
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiPath.baseUrl}/register'),
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 201) {
      final user = UserModel.fromJson(json.decode(response.body));
      return user;
    } else {
      var message = json.decode(response.body)['message'];
      throw message;
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiPath.baseUrl}/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final user = UserModel.fromJson(json.decode(response.body));
      settings.put('user', user.loginResult?.toJson());
      return user;
    } else {
      var message = json.decode(response.body)['message'];
      throw message;
    }
  }
}
