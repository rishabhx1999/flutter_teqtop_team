class Project {
  int? id;
  String? name;
  int? project;
  int? assignedTo;
  int? user;
  String? observers;
  String? participants;
  String? client;
  String? profile;

  Project({
    this.id,
    this.name,
    this.project,
    this.assignedTo,
    this.user,
    this.observers,
    this.participants,
    this.client,
    this.profile,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json["id"],
        name: json["name"],
        project: json["project"],
        assignedTo: json["assigned_to"],
        user: json["user"],
        observers: json["observers"],
        participants: json["participants"],
        client: json["client"],
        profile: json["profile"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "project": project,
        "assigned_to": assignedTo,
        "user": user,
        "observers": observers,
        "participants": participants,
        "client": client,
        "profile": profile,
      };
}
