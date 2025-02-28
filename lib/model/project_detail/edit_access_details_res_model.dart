// To parse this JSON data, do
//
//     final editAccessDetailsResModel = editAccessDetailsResModelFromJson(jsonString);

import 'dart:convert';

EditAccessDetailsResModel editAccessDetailsResModelFromJson(String str) =>
    EditAccessDetailsResModel.fromJson(json.decode(str));

String editAccessDetailsResModelToJson(EditAccessDetailsResModel data) =>
    json.encode(data.toJson());

class EditAccessDetailsResModel {
  int? id;
  String? proposalId;
  int? categoryId;
  dynamic userId;
  String? name;
  String? client;
  String? url;
  String? portal;
  String? profile;
  String? status;
  String? description;
  String? accessDetail;
  dynamic deletedAt;
  int? folderId;
  String? folderName;

  EditAccessDetailsResModel({
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
    this.folderName,
  });

  factory EditAccessDetailsResModel.fromJson(Map<String, dynamic> json) =>
      EditAccessDetailsResModel(
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
        "folder_name": folderName,
      };
}
