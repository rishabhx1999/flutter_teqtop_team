// To parse this JSON data, do
//
//     final commentsResModel = commentsResModelFromJson(jsonString);

import 'dart:convert';

import 'package:teqtop_team/model/dashboard/comment_list.dart';

CommentsResModel commentsResModelFromJson(String str) =>
    CommentsResModel.fromJson(json.decode(str));

String commentsResModelToJson(CommentsResModel data) =>
    json.encode(data.toJson());

class CommentsResModel {
  String? status;
  List<CommentList?>? comments;
  int? count;

  CommentsResModel({
    this.status,
    this.comments,
    this.count,
  });

  factory CommentsResModel.fromJson(Map<String, dynamic> json) =>
      CommentsResModel(
        status: json["status"],
        comments: json["comments"] == null
            ? null
            : List<CommentList>.from(
                json["comments"].map((x) => CommentList.fromJson(x))),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "comments": comments == null
            ? null
            : List<dynamic>.from(comments!.map((x) => x!.toJson())),
        "count": count,
      };
}
