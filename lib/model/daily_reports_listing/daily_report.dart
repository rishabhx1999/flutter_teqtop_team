class DailyReport {
  int? id;
  int? userId;
  String? name;
  String? report;
  DateTime? createdAt;
  String? profile;

  DailyReport({
    this.id,
    this.userId,
    this.name,
    this.report,
    this.createdAt,
    this.profile,
  });

  factory DailyReport.fromJson(Map<String, dynamic> json) => DailyReport(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        report: json["report"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        profile: json["profile"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "report": report,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "profile": profile,
      };
}
