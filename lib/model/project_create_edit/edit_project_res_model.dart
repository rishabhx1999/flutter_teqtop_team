// To parse this JSON data, do
//
//     final editProjectResModel = editProjectResModelFromJson(jsonString);

import 'dart:convert';

EditProjectResModel editProjectResModelFromJson(String str) =>
    EditProjectResModel.fromJson(json.decode(str));

String editProjectResModelToJson(EditProjectResModel data) =>
    json.encode(data.toJson());

class EditProjectResModel {
  String? status;

  EditProjectResModel({
    this.status,
  });

  factory EditProjectResModel.fromJson(Map<String, dynamic> json) =>
      EditProjectResModel(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}
