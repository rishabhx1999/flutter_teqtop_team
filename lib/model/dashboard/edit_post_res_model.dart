// To parse this JSON data, do
//
//     final editPostResModel = editPostResModelFromJson(jsonString);

import 'dart:convert';

import 'package:teqtop_team/model/dashboard/feed_model.dart';

EditPostResModel editPostResModelFromJson(String str) =>
    EditPostResModel.fromJson(json.decode(str));

String editPostResModelToJson(EditPostResModel data) =>
    json.encode(data.toJson());

class EditPostResModel {
  String? status;
  EditPostResValues? values;

  EditPostResModel({
    this.status,
    this.values,
  });

  factory EditPostResModel.fromJson(Map<String, dynamic> json) =>
      EditPostResModel(
        status: json["status"],
        values: json["values"] == null
            ? null
            : EditPostResValues.fromJson(json["values"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "values": values == null ? null : values!.toJson(),
      };
}

class EditPostResValues {
  List<FeedModel?>? feeds;
  int? feedCt;

  EditPostResValues({
    this.feeds,
    this.feedCt,
  });

  factory EditPostResValues.fromJson(Map<String, dynamic> json) =>
      EditPostResValues(
        feeds: json["feeds"] == null
            ? null
            : List<FeedModel>.from(
                json["feeds"].map((x) => FeedModel.fromJson(x))),
        feedCt: json["feed_ct"],
      );

  Map<String, dynamic> toJson() => {
        "feeds": feeds == null
            ? null
            : List<dynamic>.from(feeds!.map((x) => x!.toJson())),
        "feed_ct": feedCt,
      };
}
