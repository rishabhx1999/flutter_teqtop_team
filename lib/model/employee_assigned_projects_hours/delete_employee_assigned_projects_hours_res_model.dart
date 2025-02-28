// To parse this JSON data, do
//
//     final deleteEmployeeAssignedProjectsHoursResModel = deleteEmployeeAssignedProjectsHoursResModelFromJson(jsonString);

import 'dart:convert';

DeleteEmployeeAssignedProjectsHoursResModel
    deleteEmployeeAssignedProjectsHoursResModelFromJson(String str) =>
        DeleteEmployeeAssignedProjectsHoursResModel.fromJson(json.decode(str));

String deleteEmployeeAssignedProjectsHoursResModelToJson(
        DeleteEmployeeAssignedProjectsHoursResModel data) =>
    json.encode(data.toJson());

class DeleteEmployeeAssignedProjectsHoursResModel {
  String? status;

  DeleteEmployeeAssignedProjectsHoursResModel({
    this.status,
  });

  factory DeleteEmployeeAssignedProjectsHoursResModel.fromJson(
          Map<String, dynamic> json) =>
      DeleteEmployeeAssignedProjectsHoursResModel(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}
