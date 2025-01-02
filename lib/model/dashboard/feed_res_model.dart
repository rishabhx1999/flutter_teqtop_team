// To parse this JSON data, do
//
//     final feedsResModel = feedsResModelFromJson(jsonString);

import 'dart:convert';

import 'feed.dart';

FeedResModel feedResModelFromJson(String str) =>
    FeedResModel.fromJson(json.decode(str));

String feedResModelToJson(FeedResModel data) => json.encode(data.toJson());

class FeedResModel {
  List<Feed?>? feeds;
  int? feedCt;
  bool? permission;
  String? time;

  FeedResModel({
    this.feeds,
    this.feedCt,
    this.permission,
    this.time,
  });

  factory FeedResModel.fromJson(Map<String, dynamic> json) => FeedResModel(
        feeds: json["feeds"] == null
            ? null
            : List<Feed>.from(json["feeds"].map((x) => Feed.fromJson(x))),
        feedCt: json["feed_ct"],
        permission: json["permission"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "feeds": feeds == null
            ? null
            : List<dynamic>.from(feeds!.map((x) => x!.toJson())),
        "feed_ct": feedCt,
        "permission": permission,
        "time": time,
      };
}
