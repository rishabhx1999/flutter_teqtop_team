// To parse this JSON data, do
//
//     final globalSearchResModel = globalSearchResModelFromJson(jsonString);

import 'dart:convert';

import 'package:teqtop_team/model/employees_listing/employee_model.dart';
import 'package:teqtop_team/model/global_search/project_model.dart';
import 'package:teqtop_team/model/global_search/task_model.dart';

import 'drive_model.dart';

GlobalSearchResModel globalSearchResModelFromJson(String str) =>
    GlobalSearchResModel.fromJson(json.decode(str));

String globalSearchResModelToJson(GlobalSearchResModel data) =>
    json.encode(data.toJson());

class GlobalSearchResModel {
  List<EmployeeModel?>? members;
  String? search;
  List<TaskModel?>? tasks;
  List<DriveModel?>? drives;
  List<ProjectModel?>? projects;

  GlobalSearchResModel({
    this.members,
    this.search,
    this.tasks,
    this.drives,
    this.projects,
  });

  factory GlobalSearchResModel.fromJson(Map<String, dynamic> json) =>
      GlobalSearchResModel(
        members: json["members"] == null
            ? null
            : List<EmployeeModel>.from(
                json["members"].map((x) => EmployeeModel.fromJson(x))),
        search: json["_search"],
        tasks: json["tasks"] == null
            ? null
            : List<TaskModel>.from(json["tasks"].map((x) => TaskModel.fromJson(x))),
        drives: json["drives"] == null
            ? null
            : List<DriveModel>.from(json["drives"].map((x) => DriveModel.fromJson(x))),
        projects: json["projects"] == null
            ? null
            : List<ProjectModel>.from(
                json["projects"].map((x) => ProjectModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "members": members == null
            ? null
            : List<dynamic>.from(members!.map((x) => x!.toJson())),
        "_search": search,
        "tasks": tasks == null
            ? null
            : List<dynamic>.from(tasks!.map((x) => x!.toJson())),
        "drives": drives == null
            ? null
            : List<dynamic>.from(drives!.map((x) => x!.toJson())),
        "projects": projects == null
            ? null
            : List<dynamic>.from(projects!.map((x) => x!.toJson())),
      };
}
