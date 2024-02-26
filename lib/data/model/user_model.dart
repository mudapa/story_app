class UserModel {
  bool? error;
  String? message;
  LoginResult? loginResult;

  UserModel({
    this.error,
    this.message,
    this.loginResult,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        error: json["error"],
        message: json["message"],
        loginResult: json["loginResult"] == null
            ? null
            : LoginResult.fromJson(json["loginResult"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "loginResult": loginResult?.toJson(),
      };
}

class LoginResult {
  final String? userId;
  final String? name;
  final String? token;

  LoginResult({
    this.userId,
    this.name,
    this.token,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) => LoginResult(
        userId: json["userId"],
        name: json["name"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "token": token,
      };
}
