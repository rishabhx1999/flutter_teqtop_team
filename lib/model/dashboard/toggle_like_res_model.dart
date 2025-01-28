// To parse this JSON data, do
//
//     final toggleLikeResModel = toggleLikeResModelFromJson(jsonString);

import 'dart:convert';

ToggleLikeResModel toggleLikeResModelFromJson(String str) => ToggleLikeResModel.fromJson(json.decode(str));

String toggleLikeResModelToJson(ToggleLikeResModel data) => json.encode(data.toJson());

class ToggleLikeResModel {
  String? status;
  int? counts;
  String? likefeedUsers;

  ToggleLikeResModel({
    this.status,
    this.counts,
    this.likefeedUsers,
  });

  factory ToggleLikeResModel.fromJson(Map<String, dynamic> json) => ToggleLikeResModel(
    status: json["status"],
    counts: json["counts"],
    likefeedUsers: json["likefeed_users"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "counts": counts,
    "likefeed_users": likefeedUsers,
  };
}
