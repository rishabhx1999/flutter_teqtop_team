import 'package:teqtop_team/model/employees_listing/data_row_attribute.dart';

class AssignHours {
  DataRowAttribute? dtRowAttr;
  int? id;
  String? userName;
  dynamic userProfile;
  String? projects;
  DateTime? addedDate;
  DateTime? updatededDate;
  int? userId;
  DateTime? deletedAt;
  String? action;

  AssignHours({
    this.dtRowAttr,
    this.id,
    this.userName,
    this.userProfile,
    this.projects,
    this.addedDate,
    this.updatededDate,
    this.userId,
    this.deletedAt,
    this.action,
  });

  factory AssignHours.fromJson(Map<String, dynamic> json) => AssignHours(
        dtRowAttr: json["DT_RowAttr"] == null
            ? null
            : DataRowAttribute.fromJson(json["DT_RowAttr"]),
        id: json["id"],
        userName: json["userName"],
        userProfile: json["userProfile"],
        projects: json["projects"],
        addedDate: json["addedDate"] == null
            ? null
            : DateTime.parse(json["addedDate"]),
        updatededDate: json["updatededDate"] == null
            ? null
            : DateTime.parse(json["updatededDate"]),
        userId: json["user_id"],
        deletedAt: json["deleted_at"] == null
            ? null
            : DateTime.parse(json["deleted_at"]),
        action: json["action"],
      );

  Map<String, dynamic> toJson() => {
        "DT_RowAttr": dtRowAttr == null ? null : dtRowAttr!.toJson(),
        "id": id,
        "userName": userName,
        "userProfile": userProfile,
        "projects": projects,
        "addedDate": addedDate == null ? null : addedDate!.toIso8601String(),
        "updatededDate":
            updatededDate == null ? null : updatededDate!.toIso8601String(),
        "user_id": userId,
        "deleted_at": deletedAt == null ? null : deletedAt!.toIso8601String(),
        "action": action,
      };
}
