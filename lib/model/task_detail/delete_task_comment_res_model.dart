// To parse this JSON data, do
//
//     final deleteTaskCommentResModel = deleteTaskCommentResModelFromJson(jsonString);

import 'dart:convert';

DeleteTaskCommentResModel deleteTaskCommentResModelFromJson(String str) =>
    DeleteTaskCommentResModel.fromJson(json.decode(str));

String deleteTaskCommentResModelToJson(DeleteTaskCommentResModel data) =>
    json.encode(data.toJson());

class DeleteTaskCommentResModel {
  String? status;
  List<dynamic>? comments;
  int? count;
  List<dynamic>? feeds;

  DeleteTaskCommentResModel({
    this.status,
    this.comments,
    this.count,
    this.feeds,
  });

  factory DeleteTaskCommentResModel.fromJson(Map<String, dynamic> json) =>
      DeleteTaskCommentResModel(
        status: json["status"],
        comments: json["comments"] == null
            ? null
            : List<dynamic>.from(json["comments"].map((x) => x)),
        count: json["count"],
        feeds: json["feeds"] == null
            ? null
            : List<dynamic>.from(json["feeds"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "comments": comments == null
            ? null
            : List<dynamic>.from(comments!.map((x) => x)),
        "count": count,
        "feeds":
            feeds == null ? null : List<dynamic>.from(feeds!.map((x) => x)),
      };
}
