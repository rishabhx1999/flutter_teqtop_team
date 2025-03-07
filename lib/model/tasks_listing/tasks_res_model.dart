// To parse this JSON data, do
//
//     final taskResModel = taskResModelFromJson(jsonString);

import 'dart:convert';

import 'package:teqtop_team/model/employees_listing/input_data.dart';
import 'package:teqtop_team/model/global_search/task_model.dart';

TasksResModel tasksResModelFromJson(String str) =>
    TasksResModel.fromJson(json.decode(str));

String tasksResModelToJson(TasksResModel data) => json.encode(data.toJson());

class TasksResModel {
  InputData? input;
  int? draw;
  int? recordsTotal;
  int? recordsFiltered;
  List<TaskModel?>? data;

  TasksResModel({
    this.input,
    this.draw,
    this.recordsTotal,
    this.recordsFiltered,
    this.data,
  });

  factory TasksResModel.fromJson(Map<String, dynamic> json) => TasksResModel(
        input: json["input"] == null ? null : InputData.fromJson(json["input"]),
        draw: json["draw"],
        recordsTotal: json["recordsTotal"],
        recordsFiltered: json["recordsFiltered"],
        data: json["data"] == null
            ? null
            : List<TaskModel>.from(
                json["data"].map((x) => TaskModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "input": input?.toJson(),
        "draw": draw,
        "recordsTotal": recordsTotal,
        "recordsFiltered": recordsFiltered,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x!.toJson())),
      };
}
