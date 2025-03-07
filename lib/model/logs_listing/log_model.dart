class LogModel {
  int? id;
  String? user;
  int? projectId;
  String? projectName;
  String? component;
  DateTime? createdAt;

  LogModel({
    this.id,
    this.user,
    this.projectId,
    this.projectName,
    this.component,
    this.createdAt,
  });

  factory LogModel.fromJson(Map<String, dynamic> json) => LogModel(
        id: json["id"],
        user: json["user"],
        projectId: json["project_id"],
        projectName: json["project_name"],
        component: json["component"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "project_id": projectId,
        "project_name": projectName,
        "component": component,
        "created_at": createdAt?.toIso8601String(),
      };
}
