class LikeUser {
  int? id;
  int? userId;
  String? component;
  int? componentId;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? name;
  String? profile;

  LikeUser({
    this.id,
    this.userId,
    this.component,
    this.componentId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.profile,
  });

  factory LikeUser.fromJson(Map<String, dynamic> json) => LikeUser(
        id: json["id"],
        userId: json["user_id"],
        component: json["component"],
        componentId: json["component_id"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        name: json["name"],
        profile: json["profile"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "component": component,
        "component_id": componentId,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "name": name,
        "profile": profile,
      };
}
