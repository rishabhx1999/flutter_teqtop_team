// To parse this JSON data, do
//
//     final projectDetailResModel = projectDetailResModelFromJson(jsonString);

import 'dart:convert';

ProjectDetailResModel projectDetailResModelFromJson(String str) =>
    ProjectDetailResModel.fromJson(json.decode(str));

String projectDetailResModelToJson(ProjectDetailResModel data) =>
    json.encode(data.toJson());

class ProjectDetailResModel {
  int? id;
  String? proposalId;
  int? categoryId;
  int? userId;
  String? name;
  String? client;
  String? url;
  String? portal;
  String? profile;
  String? status;
  dynamic description;
  dynamic accessDetail;
  dynamic deletedAt;
  int? folderId;
  String? drive;
  String? folderName;

  ProjectDetailResModel({
    this.id,
    this.proposalId,
    this.categoryId,
    this.userId,
    this.name,
    this.client,
    this.url,
    this.portal,
    this.profile,
    this.status,
    this.description,
    this.accessDetail,
    this.deletedAt,
    this.folderId,
    this.drive,
    this.folderName,
  });

  factory ProjectDetailResModel.fromJson(Map<String, dynamic> json) =>
      ProjectDetailResModel(
        id: json["id"],
        proposalId: json["proposal_id"],
        categoryId: json["category_id"],
        userId: json["user_id"],
        name: json["name"],
        client: json["client"],
        url: json["url"],
        portal: json["portal"],
        profile: json["profile"],
        status: json["status"],
        description: json["description"],
        accessDetail: json["access_detail"],
        deletedAt: json["deleted_at"],
        folderId: json["folder_id"],
        drive: json["drive"],
        folderName: json["folder_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "proposal_id": proposalId,
        "category_id": categoryId,
        "user_id": userId,
        "name": name,
        "client": client,
        "url": url,
        "portal": portal,
        "profile": profile,
        "status": status,
        "description": description,
        "access_detail": accessDetail,
        "deleted_at": deletedAt,
        "folder_id": folderId,
        "drive": drive,
        "folder_name": folderName,
      };
}
