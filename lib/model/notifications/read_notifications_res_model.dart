// To parse this JSON data, do
//
//     final readNotificationsResModel = readNotificationsResModelFromJson(jsonString);

import 'dart:convert';

ReadNotificationsResModel readNotificationsResModelFromJson(String str) =>
    ReadNotificationsResModel.fromJson(json.decode(str));

String readNotificationsResModelToJson(ReadNotificationsResModel data) =>
    json.encode(data.toJson());

class ReadNotificationsResModel {
  String? success;

  ReadNotificationsResModel({
    this.success,
  });

  factory ReadNotificationsResModel.fromJson(Map<String, dynamic> json) =>
      ReadNotificationsResModel(
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
      };
}
