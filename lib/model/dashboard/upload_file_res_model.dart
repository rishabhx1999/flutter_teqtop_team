// To parse this JSON data, do
//
//     final uploadFileResModel = uploadFileResModelFromJson(jsonString);

import 'dart:convert';

UploadFileResModel uploadFileResModelFromJson(String str) => UploadFileResModel.fromJson(json.decode(str));

String uploadFileResModelToJson(UploadFileResModel data) => json.encode(data.toJson());

class UploadFileResModel {
  String? src;
  String? format;
  dynamic fileName;

  UploadFileResModel({
    this.src,
    this.format,
    this.fileName,
  });

  factory UploadFileResModel.fromJson(Map<String, dynamic> json) => UploadFileResModel(
    src: json["src"],
    format: json["format"],
    fileName: json["file_name"],
  );

  Map<String, dynamic> toJson() => {
    "src": src,
    "format": format,
    "file_name": fileName,
  };
}
