// To parse this JSON data, do
//
//     final deleteTaskCommentResModel = deleteTaskCommentResModelFromJson(jsonString);

import 'dart:convert';

DeletePostCommentResModel deletePostCommentResModelFromJson(String str) =>
    DeletePostCommentResModel.fromJson(json.decode(str));

String deletePostCommentResModelToJson(DeletePostCommentResModel data) =>
    json.encode(data.toJson());

class DeletePostCommentResModel {
  String? status;
  List<dynamic>? comments;
  int? count;

  DeletePostCommentResModel({
    this.status,
    this.comments,
    this.count,
  });

  factory DeletePostCommentResModel.fromJson(Map<String, dynamic> json) =>
      DeletePostCommentResModel(
        status: json["status"],
        comments: json["comments"] == null
            ? null
            : List<dynamic>.from(json["comments"].map((x) => x)),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "comments": comments == null
            ? null
            : List<dynamic>.from(comments!.map((x) => x)),
        "count": count,
      };
}
