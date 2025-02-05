// To parse this JSON data, do
//
//     final editCommentResModel = editCommentResModelFromJson(jsonString);

import 'dart:convert';

import 'package:teqtop_team/model/dashboard/comment_list.dart';

EditTaskCommentResModel editTaskCommentResModelFromJson(String str) =>
    EditTaskCommentResModel.fromJson(json.decode(str));

String editTaskCommentResModelToJson(EditTaskCommentResModel data) =>
    json.encode(data.toJson());

class EditTaskCommentResModel {
  String? status;
  String? message;
  List<CommentList?>? comments;
  int? count;
  List<dynamic>? feeds;
  List<dynamic>? observers;

  EditTaskCommentResModel({
    this.status,
    this.message,
    this.comments,
    this.count,
    this.feeds,
    this.observers,
  });

  factory EditTaskCommentResModel.fromJson(Map<String, dynamic> json) =>
      EditTaskCommentResModel(
        status: json["status"],
        message: json["message"],
        comments: json["comments"] == null
            ? null
            : List<CommentList>.from(
                json["comments"].map((x) => CommentList.fromJson(x))),
        count: json["count"],
        feeds: json["feeds"] == null
            ? null
            : List<dynamic>.from(json["feeds"].map((x) => x)),
        observers: json["observers"] == null
            ? null
            : List<dynamic>.from(json["observers"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "comments": comments == null
            ? null
            : List<dynamic>.from(comments!.map((x) => x!.toJson())),
        "count": count,
        "feeds":
            feeds == null ? null : List<dynamic>.from(feeds!.map((x) => x)),
        "observers": observers == null
            ? null
            : List<dynamic>.from(observers!.map((x) => x)),
      };
}
