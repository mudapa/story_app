import 'package:json_annotation/json_annotation.dart';

import 'login_result.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  bool? error;
  String? message;
  LoginResult? loginResult;

  UserModel({
    this.error,
    this.message,
    this.loginResult,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
