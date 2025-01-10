// To parse this JSON data, do
//
//     final userResModel = userResModelFromJson(jsonString);

import 'dart:convert';

import 'package:teqtop_team/model/dashboard/user_model.dart';

UserResModel userResModelFromJson(String str) =>
    UserResModel.fromJson(json.decode(str));

String userResModelToJson(UserResModel data) => json.encode(data.toJson());

class UserResModel {
  UserModel? user;
  int? id;

  UserResModel({
    this.user,
    this.id,
  });

  factory UserResModel.fromJson(Map<String, dynamic> json) => UserResModel(
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "user": user == null ? null : user!.toJson(),
        "id": id,
      };
}
