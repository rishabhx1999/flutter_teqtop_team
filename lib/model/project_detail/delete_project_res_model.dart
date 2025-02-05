// To parse this JSON data, do
//
//     final deleteProjectResModel = deleteProjectResModelFromJson(jsonString);

import 'dart:convert';

DeleteProjectResModel deleteProjectResModelFromJson(String str) => DeleteProjectResModel.fromJson(json.decode(str));

String deleteProjectResModelToJson(DeleteProjectResModel data) => json.encode(data.toJson());

class DeleteProjectResModel {
  String? status;

  DeleteProjectResModel({
    this.status,
  });

  factory DeleteProjectResModel.fromJson(Map<String, dynamic> json) => DeleteProjectResModel(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}
