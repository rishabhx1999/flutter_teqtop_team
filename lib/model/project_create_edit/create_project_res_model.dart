// To parse this JSON data, do
//
//     final createProjectResModel = createProjectResModelFromJson(jsonString);

import 'dart:convert';

import 'package:teqtop_team/model/global_search/project_model.dart';

CreateProjectResModel createProjectResModelFromJson(String str) =>
    CreateProjectResModel.fromJson(json.decode(str));

String createProjectResModelToJson(CreateProjectResModel data) =>
    json.encode(data.toJson());

class CreateProjectResModel {
  String? status;
  String? message;
  ProjectModel? project;

  CreateProjectResModel({
    this.status,
    this.message,
    this.project,
  });

  factory CreateProjectResModel.fromJson(Map<String, dynamic> json) =>
      CreateProjectResModel(
        status: json["status"],
        message: json["message"],
        project: json["project"] == null
            ? null
            : ProjectModel.fromJson(json["project"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "project": project == null ? null : project!.toJson(),
      };
}
