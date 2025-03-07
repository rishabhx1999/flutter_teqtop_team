// To parse this JSON data, do
//
//     final taskDetailResModel = taskDetailResModelFromJson(jsonString);

import 'dart:convert';

import 'package:teqtop_team/model/global_search/task_model.dart';

TaskDetailResModel taskDetailResModelFromJson(String str) =>
    TaskDetailResModel.fromJson(json.decode(str));

String taskDetailResModelToJson(TaskDetailResModel data) =>
    json.encode(data.toJson());

class TaskDetailResModel {
  String? status;
  TaskModel? task;
  dynamic project;

  TaskDetailResModel({
    this.status,
    this.task,
    this.project,
  });

  factory TaskDetailResModel.fromJson(Map<String, dynamic> json) =>
      TaskDetailResModel(
        status: json["status"],
        task: json["task"] == null ? null : TaskModel.fromJson(json["task"]),
        project: json["project"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "task": task?.toJson(),
        "project": project,
      };
}
