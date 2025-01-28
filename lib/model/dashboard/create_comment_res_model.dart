// To parse this JSON data, do
//
//     final createCommentResModel = createCommentResModelFromJson(jsonString);

import 'dart:convert';

import 'package:teqtop_team/model/dashboard/comment_list.dart';

CreateCommentResModel createCommentResModelFromJson(String str) =>
    CreateCommentResModel.fromJson(json.decode(str));

String createCommentResModelToJson(CreateCommentResModel data) =>
    json.encode(data.toJson());

class CreateCommentResModel {
  String? status;
  String? message;
  List<dynamic>? comments;
  CommentList? latestComment;
  int? count;
  List<dynamic>? observers;

  CreateCommentResModel({
    this.status,
    this.message,
    this.comments,
    this.latestComment,
    this.count,
    this.observers,
  });

  factory CreateCommentResModel.fromJson(Map<String, dynamic> json) =>
      CreateCommentResModel(
        status: json["status"],
        message: json["message"],
        comments: json["comments"] == null
            ? null
            : List<dynamic>.from(json["comments"].map((x) => x)),
        latestComment: json["latestComment"] == null
            ? null
            : CommentList.fromJson(json["latestComment"]),
        count: json["count"],
        observers: json["observers"] == null
            ? null
            : List<dynamic>.from(json["observers"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "comments": comments == null
            ? null
            : List<dynamic>.from(comments!.map((x) => x)),
        "latestComment": latestComment == null ? null : latestComment!.toJson(),
        "count": count,
        "observers": observers == null
            ? null
            : List<dynamic>.from(observers!.map((x) => x)),
      };
}
