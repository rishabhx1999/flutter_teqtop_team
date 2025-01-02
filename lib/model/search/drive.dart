class Drive {
  int? id;
  String? name;

  Drive({
    this.id,
    this.name,
  });

  factory Drive.fromJson(Map<String, dynamic> json) => Drive(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
