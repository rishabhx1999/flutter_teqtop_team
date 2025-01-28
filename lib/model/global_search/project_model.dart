import 'package:teqtop_team/model/employees_listing/data_row_attribute.dart';

import '../enum_values.dart';

class ProjectModel {
  DataRowAttribute? dtRowAttr;
  int? id;
  String? proposalId;
  int? categoryId;
  int? userId;
  String? url;
  String? name;
  Portal? portal;
  int? project;
  int? assignedTo;
  int? user;
  String? responsiblePerson;
  String? createdBy;
  String? observers;
  String? participants;
  String? client;
  String? profile;
  String? status;
  dynamic description;
  dynamic accessDetail;
  dynamic deletedAt;
  int? folderId;
  String? folderName;
  DateTime? createdAt;
  DateTime? projectCreatedAt;

  ProjectModel({
    this.dtRowAttr,
    this.id,
    this.proposalId,
    this.categoryId,
    this.userId,
    this.url,
    this.name,
    this.portal,
    this.project,
    this.assignedTo,
    this.user,
    this.responsiblePerson,
    this.createdBy,
    this.observers,
    this.participants,
    this.client,
    this.profile,
    this.status,
    this.description,
    this.accessDetail,
    this.deletedAt,
    this.folderId,
    this.folderName,
    this.createdAt,
    this.projectCreatedAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        dtRowAttr: json["DT_RowAttr"] == null
            ? null
            : DataRowAttribute.fromJson(json["DT_RowAttr"]),
        id: json["id"],
        proposalId: json["proposal_id"],
        categoryId: json["category_id"],
        userId: json["user_id"],
        url: json["url"],
        name: json["name"],
        portal:
            json["portal"] == null ? null : portalValues.map[json["portal"]],
        project: json["project"],
        assignedTo: json["assigned_to"],
        user: json["user"],
        responsiblePerson: json["responsible_person"],
        createdBy: json["created_by"],
        observers: json["observers"],
        participants: json["participants"],
        client: json["client"],
        profile: json["profile"],
        status: json["status"],
        description: json["description"],
        accessDetail: json["access_detail"],
        deletedAt: json["deleted_at"],
        folderId: json["folder_id"],
        folderName: json["folder_name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        projectCreatedAt: json["project_created_at"] == null
            ? null
            : DateTime.parse(json["project_created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "DT_RowAttr": dtRowAttr == null ? null : dtRowAttr!.toJson(),
        "id": id,
        "proposal_id": proposalId,
        "category_id": categoryId,
        "user_id": userId,
        "url": url,
        "name": name,
        "portal": portal == null ? null : portalValues.reverse[portal],
        "project": project,
        "assigned_to": assignedTo,
        "user": user,
        "responsible_person": responsiblePerson,
        "created_by": createdBy,
        "observers": observers,
        "participants": participants,
        "client": client,
        "profile": profile,
        "status": status,
        "description": description,
        "access_detail": accessDetail,
        "deleted_at": deletedAt,
        "folder_id": folderId,
        "folder_name": folderName,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "project_created_at": projectCreatedAt == null
            ? null
            : projectCreatedAt!.toIso8601String(),
      };
}

enum Portal { IULU, SALES, UPWORK }

final portalValues = EnumValues(
    {"iulu": Portal.IULU, "sales": Portal.SALES, "Upwork": Portal.UPWORK});
