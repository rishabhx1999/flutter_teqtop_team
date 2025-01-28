// To parse this JSON data, do
//
//     final createTaskResModel = createTaskResModelFromJson(jsonString);

import 'dart:convert';

CreateTaskResModel createTaskResModelFromJson(String str) => CreateTaskResModel.fromJson(json.decode(str));

String createTaskResModelToJson(CreateTaskResModel data) => json.encode(data.toJson());

class CreateTaskResModel {
  String? status;
  String? message;

  CreateTaskResModel({
    this.status,
    this.message,
  });

  factory CreateTaskResModel.fromJson(Map<String, dynamic> json) => CreateTaskResModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
