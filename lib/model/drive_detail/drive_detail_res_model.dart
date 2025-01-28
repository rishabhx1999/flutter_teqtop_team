// To parse this JSON data, do
//
//     final driveDetailResModel = driveDetailResModelFromJson(jsonString);

import 'dart:convert';

import 'package:teqtop_team/model/drive_detail/file_or_folder_model.dart';

DriveDetailResModel driveDetailResModelFromJson(String str) =>
    DriveDetailResModel.fromJson(json.decode(str));

String driveDetailResModelToJson(DriveDetailResModel data) =>
    json.encode(data.toJson());

class DriveDetailResModel {
  List<FileOrFolderModel?>? driveFolders;
  List<dynamic>? test;
  FileOrFolderModel? parentFolder;

  DriveDetailResModel({
    this.driveFolders,
    this.test,
    this.parentFolder,
  });

  factory DriveDetailResModel.fromJson(Map<String, dynamic> json) =>
      DriveDetailResModel(
        driveFolders: json["driveFolders"] == null
            ? null
            : List<FileOrFolderModel>.from(
                json["driveFolders"].map((x) => FileOrFolderModel.fromJson(x))),
        test: List<dynamic>.from(json["test"].map((x) => x)),
        parentFolder: json["parentFolder"] == null
            ? null
            : FileOrFolderModel.fromJson(json["parentFolder"]),
      );

  Map<String, dynamic> toJson() => {
        "driveFolders": driveFolders == null
            ? null
            : List<dynamic>.from(driveFolders!.map((x) => x!.toJson())),
        "test": test == null ? null : List<dynamic>.from(test!.map((x) => x)),
        "parentFolder": parentFolder == null ? null : parentFolder!.toJson(),
      };
}
