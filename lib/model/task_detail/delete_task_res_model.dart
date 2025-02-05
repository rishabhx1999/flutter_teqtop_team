// To parse this JSON data, do
//
//     final deleteTaskResModel = deleteTaskResModelFromJson(jsonString);

import 'dart:convert';

DeleteTaskResModel deleteTaskResModelFromJson(String str) =>
    DeleteTaskResModel.fromJson(json.decode(str));

String deleteTaskResModelToJson(DeleteTaskResModel data) =>
    json.encode(data.toJson());

class DeleteTaskResModel {
  String? status;

  DeleteTaskResModel({
    this.status,
  });

  factory DeleteTaskResModel.fromJson(Map<String, dynamic> json) =>
      DeleteTaskResModel(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}
