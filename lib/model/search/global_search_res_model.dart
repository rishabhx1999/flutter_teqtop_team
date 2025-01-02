// To parse this JSON data, do
//
//     final globalSearchResModel = globalSearchResModelFromJson(jsonString);

import 'dart:convert';

import 'package:teqtop_team/model/search/project.dart';
import 'package:teqtop_team/model/search/task.dart';

import 'drive.dart';
import 'member.dart';

GlobalSearchResModel globalSearchResModelFromJson(String str) =>
    GlobalSearchResModel.fromJson(json.decode(str));

String globalSearchResModelToJson(GlobalSearchResModel data) =>
    json.encode(data.toJson());

class GlobalSearchResModel {
  List<Member?>? members;
  String? search;
  List<Task?>? tasks;
  List<Drive?>? drives;
  List<Project?>? projects;

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
            : List<Member>.from(json["members"].map((x) => Member.fromJson(x))),
        search: json["_search"],
        tasks: json["tasks"] == null
            ? null
            : List<Task>.from(json["tasks"].map((x) => Task.fromJson(x))),
        drives: json["drives"] == null
            ? null
            : List<Drive>.from(json["drives"].map((x) => Drive.fromJson(x))),
        projects: json["projects"] == null
            ? null
            : List<Project>.from(
                json["projects"].map((x) => Project.fromJson(x))),
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
