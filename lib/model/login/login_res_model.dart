// To parse this JSON data, do
//
//     final loginResModel = loginResModelFromJson(jsonString);

import 'dart:convert';

LoginResModel loginResModelFromJson(String str) =>
    LoginResModel.fromJson(json.decode(str));

String loginResModelToJson(LoginResModel data) => json.encode(data.toJson());

class LoginResModel {
  String? accessToken;
  int? user;
  bool? type;
  String? dateFormat;
  String? tokenType;
  int? expiresIn;
  String? error;

  LoginResModel(
      {this.accessToken,
      this.user,
      this.type,
      this.dateFormat,
      this.tokenType,
      this.expiresIn,
      this.error});

  factory LoginResModel.fromJson(Map<String, dynamic> json) => LoginResModel(
        accessToken: json["access_token"],
        user: json["user"],
        type: json["type"],
        dateFormat: json["date_format"],
        tokenType: json["token_type"],
        expiresIn: json["expires_in"],
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "user": user,
        "type": type,
        "date_format": dateFormat,
        "token_type": tokenType,
        "expires_in": expiresIn,
        "error": error
      };
}
