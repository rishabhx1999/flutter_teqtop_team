import 'package:teqtop_team/utils/in_app_notification_type.dart';

class NotificationModel {
  int? id;
  int? userId;
  int? createdBy;
  String? type;
  String? text;
  String? read;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? profile;
  String? name;
  InAppNotificationType? notificationType;
  String? taskId;
  String? projectId;

  NotificationModel({
    this.id,
    this.userId,
    this.createdBy,
    this.type,
    this.text,
    this.read,
    this.createdAt,
    this.updatedAt,
    this.profile,
    this.name,
    this.notificationType,
    this.taskId,
    this.projectId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        userId: json["user_id"],
        createdBy: json["created_by"],
        type: json["type"],
        text: json["text"],
        read: json["read"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        profile: json["profile"],
        name: json["name"],
        notificationType: json["notification_type"] == null
            ? null
            : notificationTypeValues.map[json["notification_type"]],
        taskId: json["task_id"],
        projectId: json["project_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "created_by": createdBy,
        "type": type,
        "text": text,
        "read": read,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "profile": profile,
        "name": name,
        "notification_type": notificationTypeValues.reverse[notificationType],
        "task_id": taskId,
        "project_id": projectId,
      };
}
