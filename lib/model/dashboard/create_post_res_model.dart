// To parse this JSON data, do
//
//     final createPostResModel = createPostResModelFromJson(jsonString);

import 'dart:convert';

CreatePostResModel createPostResModelFromJson(String str) => CreatePostResModel.fromJson(json.decode(str));

String createPostResModelToJson(CreatePostResModel data) => json.encode(data.toJson());

class CreatePostResModel {
  String? status;

  CreatePostResModel({
    this.status,
  });

  factory CreatePostResModel.fromJson(Map<String, dynamic> json) => CreatePostResModel(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}