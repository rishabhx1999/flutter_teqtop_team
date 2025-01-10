// To parse this JSON data, do
//
//     final projectsResModel = projectsResModelFromJson(jsonString);

import 'dart:convert';

import 'package:teqtop_team/model/employees_listing/input_data.dart';
import 'package:teqtop_team/model/global_search/project_model.dart';

ProjectsResModel projectsResModelFromJson(String str) =>
    ProjectsResModel.fromJson(json.decode(str));

String projectsResModelToJson(ProjectsResModel data) =>
    json.encode(data.toJson());

class ProjectsResModel {
  InputData? input;
  int? draw;
  int? recordsTotal;
  int? recordsFiltered;
  List<ProjectModel?>? data;

  ProjectsResModel({
    this.input,
    this.draw,
    this.recordsTotal,
    this.recordsFiltered,
    this.data,
  });

  factory ProjectsResModel.fromJson(Map<String, dynamic> json) =>
      ProjectsResModel(
        input: json["input"] == null ? null : InputData.fromJson(json["input"]),
        draw: json["draw"],
        recordsTotal: json["recordsTotal"],
        recordsFiltered: json["recordsFiltered"],
        data: json["data"] == null
            ? null
            : List<ProjectModel>.from(
                json["data"].map((x) => ProjectModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "input": input == null ? null : input!.toJson(),
        "draw": draw,
        "recordsTotal": recordsTotal,
        "recordsFiltered": recordsFiltered,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x!.toJson())),
      };
}
