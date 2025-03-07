class FileOrFolderModel {
  int? id;
  String? drive;
  int? userId;
  int? parentId;
  int? projectId;
  String? name;
  String? isFolder;
  String? isFile;
  String? link;
  String? path;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic parentLink;
  int? keyVal;
  int? mobKeyVal;
  String? projectUrl;

  FileOrFolderModel({
    this.id,
    this.drive,
    this.userId,
    this.parentId,
    this.projectId,
    this.name,
    this.isFolder,
    this.isFile,
    this.link,
    this.path,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.parentLink,
    this.keyVal,
    this.mobKeyVal,
    this.projectUrl,
  });

  factory FileOrFolderModel.fromJson(Map<String, dynamic> json) =>
      FileOrFolderModel(
        id: json["id"],
        drive: json["drive"],
        userId: json["user_id"],
        parentId: json["parent_id"],
        projectId: json["project_id"],
        name: json["name"],
        isFolder: json["isFolder"],
        isFile: json["isFile"],
        link: json["link"],
        path: json["path"],
        type: json["type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        parentLink: json["parentLink"],
        keyVal: json["keyVal"],
        mobKeyVal: json["mobKeyVal"],
        projectUrl: json["project_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "drive": drive,
        "user_id": userId,
        "parent_id": parentId,
        "project_id": projectId,
        "name": name,
        "isFolder": isFolder,
        "isFile": isFile,
        "link": link,
        "path": path,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "parentLink": parentLink,
        "keyVal": keyVal,
        "mobKeyVal": mobKeyVal,
        "project_url": projectUrl,
      };
}
