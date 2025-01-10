import 'package:teqtop_team/model/employees_listing/data_row_attribute.dart';

import '../enum_values.dart';

class ProjectModel {
  DataRowAttribute? dtRowAttr;
  int? id;
  String? url;
  String? name;
  Portal? portal;
  int? project;
  int? assignedTo;
  int? user;
  String? observers;
  String? participants;
  String? client;
  String? profile;
  int? folderId;
  String? folderName;
  DateTime? createdAt;

  ProjectModel({
    this.dtRowAttr,
    this.id,
    this.url,
    this.name,
    this.portal,
    this.project,
    this.assignedTo,
    this.user,
    this.observers,
    this.participants,
    this.client,
    this.profile,
    this.folderId,
    this.folderName,
    this.createdAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        dtRowAttr: json["DT_RowAttr"] == null
            ? null
            : DataRowAttribute.fromJson(json["DT_RowAttr"]),
        id: json["id"],
        url: json["url"],
        name: json["name"],
        portal:
            json["portal"] == null ? null : portalValues.map[json["portal"]],
        project: json["project"],
        assignedTo: json["assigned_to"],
        user: json["user"],
        observers: json["observers"],
        participants: json["participants"],
        client: json["client"],
        profile: json["profile"],
        folderId: json["folder_id"],
        folderName: json["folder_name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "DT_RowAttr": dtRowAttr == null ? null : dtRowAttr!.toJson(),
        "id": id,
        "url": url,
        "name": name,
        "portal": portal == null ? null : portalValues.reverse[portal],
        "project": project,
        "assigned_to": assignedTo,
        "user": user,
        "observers": observers,
        "participants": participants,
        "client": client,
        "profile": profile,
        "folder_id": folderId,
        "folder_name": folderName,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
      };
}

enum Portal { IULU, SALES, UPWORK }

final portalValues = EnumValues(
    {"iulu": Portal.IULU, "sales": Portal.SALES, "Upwork": Portal.UPWORK});
