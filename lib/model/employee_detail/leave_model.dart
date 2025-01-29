import 'package:teqtop_team/model/employees_listing/data_row_attribute.dart';

class LeaveModel {
  DataRowAttribute? dtRowAttr;
  int? id;
  String? name;
  DateTime? from;
  DateTime? to;
  String? status;
  String? description;
  String? subject;
  int? user;
  List<Profile?>? profile;

  LeaveModel({
    this.dtRowAttr,
    this.id,
    this.name,
    this.from,
    this.to,
    this.status,
    this.description,
    this.subject,
    this.user,
    this.profile,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) => LeaveModel(
        dtRowAttr: json["DT_RowAttr"] == null
            ? null
            : DataRowAttribute.fromJson(json["DT_RowAttr"]),
        id: json["id"],
        name: json["name"],
        from: json["from"] == null ? null : DateTime.parse(json["from"]),
        to: json["to"] == null ? null : DateTime.parse(json["to"]),
        status: json["status"],
        description: json["description"],
        subject: json["subject"],
        user: json["user"],
        profile: json["profile"] == null
            ? null
            : List<Profile>.from(
                json["profile"].map((x) => Profile.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "DT_RowAttr": dtRowAttr == null ? null : dtRowAttr!.toJson(),
        "id": id,
        "name": name,
        "from": from == null ? null : from!.toIso8601String(),
        "to": to == null ? null : to!.toIso8601String(),
        "status": status,
        "description": description,
        "subject": subject,
        "user": user,
        "profile": profile == null
            ? null
            : List<dynamic>.from(profile!.map((x) => x!.toJson())),
      };
}

class Profile {
  String? profile;

  Profile({
    this.profile,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        profile: json["profile"],
      );

  Map<String, dynamic> toJson() => {
        "profile": profile,
      };
}
