class DriveModel {
  int? id;
  String? name;
  DateTime? createdAt;
  String? siteUrl;
  String? link;

  DriveModel({
    this.id,
    this.name,
    this.createdAt,
    this.siteUrl,
    this.link,
  });

  factory DriveModel.fromJson(Map<String, dynamic> json) => DriveModel(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        siteUrl: json["site_url"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "site_url": siteUrl,
        "link": link,
      };
}
