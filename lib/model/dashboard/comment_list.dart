import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentList {
  //Don't delete these variables
  TextEditingController? editController;
  RxBool isEditing = false.obs;
  FocusNode focusNode = FocusNode();
  RxBool showTextFieldSuffix = true.obs;

  int? id;
  int? user;
  int? componentId;
  String? component;
  String? comment;
  String? files;
  String? status;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? userName;
  String? profile;

  CommentList({
    this.id,
    this.user,
    this.componentId,
    this.component,
    this.comment,
    this.files,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.userName,
    this.profile,
    this.editController,
  });

  factory CommentList.fromJson(Map<String, dynamic> json) => CommentList(
        id: json["id"],
        user: json["user"],
        componentId: json["component_id"],
        component: json["component"],
        comment: json["comment"],
        files: json["files"],
        status: json["status"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        userName: json["user_name"],
        profile: json["profile"] ?? json["user_profile"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "component_id": componentId,
        "component": component,
        "comment": comment,
        "files": files,
        "status": status,
        "deleted_at": deletedAt,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "user_name": userName,
        "profile": profile,
        "user_profile": profile
      };
}
