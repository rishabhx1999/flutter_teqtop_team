// To parse this JSON data, do
//
//     final feedsResModel = feedsResModelFromJson(jsonString);

import 'dart:convert';

import 'package:teqtop_team/model/dashboard/sidebar_data.dart';
import 'package:teqtop_team/model/dashboard/user_model.dart';

import 'feed_model.dart';

FeedResModel feedResModelFromJson(String str) =>
    FeedResModel.fromJson(json.decode(str));

String feedResModelToJson(FeedResModel data) => json.encode(data.toJson());

class FeedResModel {
  List<FeedModel?>? feeds;
  int? feedCt;
  bool? permission;
  String? time;
  List<UserModel?>? users;
  String? userName;
  SidebarData? sidebarData;

  FeedResModel({
    this.feeds,
    this.feedCt,
    this.permission,
    this.time,
    this.users,
    this.userName,
    this.sidebarData,
  });

  factory FeedResModel.fromJson(Map<String, dynamic> json) => FeedResModel(
        feeds: json["feeds"] == null
            ? null
            : List<FeedModel>.from(
                json["feeds"].map((x) => FeedModel.fromJson(x))),
        feedCt: json["feed_ct"],
        permission: json["permission"],
        time: json["time"],
        users: json["users"] == null
            ? null
            : List<UserModel>.from(
                json["users"].map((x) => UserModel.fromJson(x))),
        userName: json["user_name"],
        sidebarData: json["sidebar_data"] == null
            ? null
            : SidebarData.fromJson(json["sidebar_data"]),
      );

  Map<String, dynamic> toJson() => {
        "feeds": feeds == null
            ? null
            : List<dynamic>.from(feeds!.map((x) => x!.toJson())),
        "feed_ct": feedCt,
        "permission": permission,
        "time": time,
        "users": users == null
            ? null
            : List<dynamic>.from(users!.map((x) => x!.toJson())),
        "user_name": userName,
        "sidebar_data": sidebarData?.toJson(),
      };
}
