// To parse this JSON data, do
//
//     final createTaskCommentResModel = createTaskCommentResModelFromJson(jsonString);

import 'dart:convert';

import 'package:teqtop_team/model/dashboard/comment_list.dart';
import 'package:teqtop_team/model/employees_listing/employee_model.dart';

CreateTaskCommentResModel createTaskCommentResModelFromJson(String str) =>
    CreateTaskCommentResModel.fromJson(json.decode(str));

String createTaskCommentResModelToJson(CreateTaskCommentResModel data) =>
    json.encode(data.toJson());

class CreateTaskCommentResModel {
  String? status;
  String? message;
  List<dynamic>? comments;
  CommentList? latestComment;
  int? count;
  List<dynamic>? feeds;
  List<EmployeeModel?>? observers;

  CreateTaskCommentResModel({
    this.status,
    this.message,
    this.comments,
    this.latestComment,
    this.count,
    this.feeds,
    this.observers,
  });

  factory CreateTaskCommentResModel.fromJson(Map<String, dynamic> json) =>
      CreateTaskCommentResModel(
        status: json["status"],
        message: json["message"],
        comments: json["comments"] == null
            ? null
            : List<dynamic>.from(json["comments"].map((x) => x)),
        latestComment: json["latestComment"] == null
            ? null
            : CommentList.fromJson(json["latestComment"]),
        count: json["count"],
        feeds: json["feeds"] == null
            ? null
            : List<dynamic>.from(json["feeds"].map((x) => x)),
        observers: json["observers"] == null
            ? null
            : List<EmployeeModel>.from(
                json["observers"].map((x) => EmployeeModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "comments": comments == null
            ? null
            : List<dynamic>.from(comments!.map((x) => x)),
        "latestComment": latestComment?.toJson(),
        "count": count,
        "feeds":
            feeds == null ? null : List<dynamic>.from(feeds!.map((x) => x)),
        "observers": observers == null
            ? null
            : List<dynamic>.from(observers!.map((x) => x!.toJson())),
      };
}
