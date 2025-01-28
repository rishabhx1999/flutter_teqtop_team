// To parse this JSON data, do
//
//     final editTaskResModel = editTaskResModelFromJson(jsonString);

import 'dart:convert';

EditTaskResModel editTaskResModelFromJson(String str) => EditTaskResModel.fromJson(json.decode(str));

String editTaskResModelToJson(EditTaskResModel data) => json.encode(data.toJson());

class EditTaskResModel {
  String? status;
  String? message;
  String? files;

  EditTaskResModel({
    this.status,
    this.message,
    this.files,
  });

  factory EditTaskResModel.fromJson(Map<String, dynamic> json) => EditTaskResModel(
    status: json["status"],
    message: json["message"],
    files: json["files"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "files": files,
  };
}
