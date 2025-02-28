// To parse this JSON data, do
//
//     final editEmployeeAssignedProjectsHoursResModel = editEmployeeAssignedProjectsHoursResModelFromJson(jsonString);

import 'dart:convert';

EditEmployeeAssignedProjectsHoursResModel editEmployeeAssignedProjectsHoursResModelFromJson(String str) => EditEmployeeAssignedProjectsHoursResModel.fromJson(json.decode(str));

String editEmployeeAssignedProjectsHoursResModelToJson(EditEmployeeAssignedProjectsHoursResModel data) => json.encode(data.toJson());

class EditEmployeeAssignedProjectsHoursResModel {
  String? status;

  EditEmployeeAssignedProjectsHoursResModel({
    this.status,
  });

  factory EditEmployeeAssignedProjectsHoursResModel.fromJson(
          Map<String, dynamic> json) =>
      EditEmployeeAssignedProjectsHoursResModel(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}
