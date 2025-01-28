// To parse this JSON data, do
//
//     final taskCommentsResModel = taskCommentsResModelFromJson(jsonString);

import 'dart:convert';

import 'package:teqtop_team/model/dashboard/comment_list.dart';

TaskCommentsResModel taskCommentsResModelFromJson(String str) =>
    TaskCommentsResModel.fromJson(json.decode(str));

String taskCommentsResModelToJson(TaskCommentsResModel data) =>
    json.encode(data.toJson());

class TaskCommentsResModel {
  String? status;
  List<CommentList?>? comments;
  int? count;
  String? time;

  TaskCommentsResModel({
    this.status,
    this.comments,
    this.count,
    this.time,
  });

  factory TaskCommentsResModel.fromJson(Map<String, dynamic> json) =>
      TaskCommentsResModel(
        status: json["status"],
        comments: json["comments"] == null
            ? null
            : List<CommentList>.from(
                json["comments"].map((x) => CommentList.fromJson(x))),
        count: json["count"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "comments": comments == null
            ? null
            : List<dynamic>.from(comments!.map((x) => x!.toJson())),
        "count": count,
        "time": time,
      };
}
