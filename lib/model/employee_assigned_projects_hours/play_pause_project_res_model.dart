// To parse this JSON data, do
//
//     final playPauseProjectResModel = playPauseProjectResModelFromJson(jsonString);

import 'dart:convert';

PlayPauseProjectResModel playPauseProjectResModelFromJson(String str) => PlayPauseProjectResModel.fromJson(json.decode(str));

String playPauseProjectResModelToJson(PlayPauseProjectResModel data) => json.encode(data.toJson());

class PlayPauseProjectResModel {
  String? status;

  PlayPauseProjectResModel({
    this.status,
  });

  factory PlayPauseProjectResModel.fromJson(Map<String, dynamic> json) => PlayPauseProjectResModel(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}
