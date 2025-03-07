class ProjectCategoryModel {
  int? id;
  String? name;
  dynamic url;
  String? categoryType;
  String? description;
  String? catFor;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProjectCategoryModel({
    this.id,
    this.name,
    this.url,
    this.categoryType,
    this.description,
    this.catFor,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ProjectCategoryModel.fromJson(Map<String, dynamic> json) =>
      ProjectCategoryModel(
        id: json["id"],
        name: json["name"],
        url: json["url"],
        categoryType: json["category_type"],
        description: json["description"],
        catFor: json["catFor"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
        "category_type": categoryType,
        "description": description,
        "catFor": catFor,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
