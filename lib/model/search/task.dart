class Task {
  int? id;
  String? name;

  Task({
    this.id,
    this.name,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
