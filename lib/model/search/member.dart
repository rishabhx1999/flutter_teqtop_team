class Member {
  int? id;
  String? name;
  String? profile;
  bool? isEdit;

  Member({
    this.id,
    this.name,
    this.profile,
    this.isEdit,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json["id"],
        name: json["name"],
        profile: json["profile"],
        isEdit: json["is_edit"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "profile": profile,
        "is_edit": isEdit,
      };
}
