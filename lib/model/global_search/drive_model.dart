class DriveModel {
  int? id;
  String? name;

  DriveModel({
    this.id,
    this.name,
  });

  factory DriveModel.fromJson(Map<String, dynamic> json) => DriveModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
