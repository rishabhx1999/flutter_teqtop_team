// To parse this JSON data, do
//
//     final createEmployeeAssignedProjectsHoursResModel = createEmployeeAssignedProjectsHoursResModelFromJson(jsonString);

import 'dart:convert';

CreateEmployeeAssignedProjectsHoursResModel
    createEmployeeAssignedProjectsHoursResModelFromJson(String str) =>
        CreateEmployeeAssignedProjectsHoursResModel.fromJson(json.decode(str));

String createEmployeeAssignedProjectsHoursResModelToJson(
        CreateEmployeeAssignedProjectsHoursResModel data) =>
    json.encode(data.toJson());

class CreateEmployeeAssignedProjectsHoursResModel {
  String? status;

  CreateEmployeeAssignedProjectsHoursResModel({
    this.status,
  });

  factory CreateEmployeeAssignedProjectsHoursResModel.fromJson(
          Map<String, dynamic> json) =>
      CreateEmployeeAssignedProjectsHoursResModel(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}
