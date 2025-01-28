// To parse this JSON data, do
//
//     final createDriveFolderResModel = createDriveFolderResModelFromJson(jsonString);

import 'dart:convert';

import 'package:teqtop_team/model/drive_detail/file_or_folder_model.dart';

CreateDriveFolderResModel createDriveFolderResModelFromJson(String str) =>
    CreateDriveFolderResModel.fromJson(json.decode(str));

String createDriveFolderResModelToJson(CreateDriveFolderResModel data) =>
    json.encode(data.toJson());

class CreateDriveFolderResModel {
  List<FileOrFolderModel?>? driveFolders;
  List<dynamic>? test;

  CreateDriveFolderResModel({
    this.driveFolders,
    this.test,
  });

  factory CreateDriveFolderResModel.fromJson(Map<String, dynamic> json) =>
      CreateDriveFolderResModel(
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
        "test": test == null ? null : List<dynamic>.from(test!.map((x) => x)),
      };
}
