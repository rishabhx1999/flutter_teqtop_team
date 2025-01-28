// To parse this JSON data, do
//
//     final addDriveFilesResModel = addDriveFilesResModelFromJson(jsonString);

import 'dart:convert';

import 'package:teqtop_team/model/drive_detail/file_or_folder_model.dart';

AddDriveFilesResModel addDriveFilesResModelFromJson(String str) =>
    AddDriveFilesResModel.fromJson(json.decode(str));

String addDriveFilesResModelToJson(AddDriveFilesResModel data) =>
    json.encode(data.toJson());

class AddDriveFilesResModel {
  List<FileOrFolderModel?>? driveFolders;
  List<dynamic>? test;

  AddDriveFilesResModel({
    this.driveFolders,
    this.test,
  });

  factory AddDriveFilesResModel.fromJson(Map<String, dynamic> json) =>
      AddDriveFilesResModel(
        driveFolders: json["driveFolders"] == null
            ? null
            : List<FileOrFolderModel>.from(
                json["driveFolders"].map((x) => FileOrFolderModel.fromJson(x))),
        test: json["test"] == null
            ? null
            : List<dynamic>.from(json["test"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "driveFolders": driveFolders == null
            ? null
            : List<dynamic>.from(driveFolders!.map((x) => x!.toJson())),
        "test": test == null
            ? null
            : List<dynamic>.from(test!.map((x) => x.toJson())),
      };
}
