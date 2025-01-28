import 'package:teqtop_team/model/employees_listing/data_row_attribute.dart';

class TaskModel {
  DataRowAttribute? dtRowAttr;
  int? id;
  String? trash;
  dynamic project;
  int? projectId;
  int? user;
  int? assignedTo;
  String? number;
  String? participants;
  String? observers;
  String? name;
  String? description;
  dynamic completedOn;
  dynamic deadline;
  DateTime? createdAt;
  String? priority;
  String? status;
  String? files;
  String? extras;
  dynamic taggedDate;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? userName;
  String? userRole;
  String? assigneeRole;
  String? userProfile;
  String? assigneeName;
  int? folderId;
  String? assigneeProfile;
  String? createdBy;
  String? responsiblePerson;
  String? drive;
  int? commentsCount;

  TaskModel({
    this.dtRowAttr,
    this.id,
    this.trash,
    this.project,
    this.projectId,
    this.user,
    this.assignedTo,
    this.number,
    this.participants,
    this.observers,
    this.name,
    this.description,
    this.completedOn,
    this.deadline,
    this.createdAt,
    this.priority,
    this.status,
    this.files,
    this.extras,
    this.taggedDate,
    this.updatedAt,
    this.deletedAt,
    this.userName,
    this.userRole,
    this.assigneeRole,
    this.userProfile,
    this.assigneeName,
    this.folderId,
    this.assigneeProfile,
    this.createdBy,
    this.responsiblePerson,
    this.drive,
    this.commentsCount,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        dtRowAttr: json["DT_RowAttr"] == null
            ? null
            : DataRowAttribute.fromJson(json["DT_RowAttr"]),
        id: json["id"],
        trash: json["trash"],
        project: json["project"],
        projectId: json["projectId"],
        user: json["user"],
        assignedTo: json["assigned_to"],
        number: json["number"],
        participants: json["participants"],
        observers: json["observers"],
        name: json["name"],
        description: json["description"],
        completedOn: json["completed_on"],
        deadline: json["deadline"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        priority: json["priority"],
        status: json["status"],
        files: json["files"],
        extras: json["extras"],
        taggedDate: json["taggedDate"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        userName: json["user_name"],
        userRole: json["user_role"],
        assigneeRole: json["assignee_role"],
        userProfile: json["user_profile"],
        assigneeName: json["assignee_name"],
        folderId: json["folder_id"],
        assigneeProfile: json["assignee_profile"],
        createdBy: json["created_by"],
        responsiblePerson: json["responsible_person"],
        drive: json["drive"],
        commentsCount: json["comment_count"],
      );

  Map<String, dynamic> toJson() => {
        "DT_RowAttr": dtRowAttr == null ? null : dtRowAttr!.toJson(),
        "id": id,
        "trash": trash,
        "project": project,
        "projectId": projectId,
        "user": user,
        "assigned_to": assignedTo,
        "number": number,
        "participants": participants,
        "observers": observers,
        "name": name,
        "description": description,
        "completed_on": completedOn,
        "deadline": deadline,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "priority": priority,
        "status": status,
        "files": files,
        "extras": extras,
        "taggedDate": taggedDate,
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
        "user_name": userName,
        "user_role": userRole,
        "assignee_role": assigneeRole,
        "user_profile": userProfile,
        "assignee_name": assigneeName,
        "folder_id": folderId,
        "assignee_profile": assigneeProfile,
        "created_by": createdBy,
        "responsible_person": responsiblePerson,
        "drive": drive,
        "comment_count": commentsCount,
      };
}
