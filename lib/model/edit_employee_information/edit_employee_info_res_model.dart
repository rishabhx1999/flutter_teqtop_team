// To parse this JSON data, do
//
//     final editEmployeeInfoResModel = editEmployeeInfoResModelFromJson(jsonString);

import 'dart:convert';

EditEmployeeInfoResModel editEmployeeInfoResModelFromJson(String str) => EditEmployeeInfoResModel.fromJson(json.decode(str));

String editEmployeeInfoResModelToJson(EditEmployeeInfoResModel data) => json.encode(data.toJson());

class EditEmployeeInfoResModel {
  String? status;

  EditEmployeeInfoResModel({
    this.status,
  });

  factory EditEmployeeInfoResModel.fromJson(Map<String, dynamic> json) => EditEmployeeInfoResModel(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}
