// To parse this JSON data, do
//
//     final notificationsResModel = notificationsResModelFromJson(jsonString);

import 'dart:convert';

import 'package:teqtop_team/model/dashboard/notification_model.dart';

NotificationsResModel notificationsResModelFromJson(String str) =>
    NotificationsResModel.fromJson(json.decode(str));

String notificationsResModelToJson(NotificationsResModel data) =>
    json.encode(data.toJson());

class NotificationsResModel {
  List<NotificationModel?>? userNotification;
  int? unCheck;
  int? chatCount;
  int? totalCount;
  int? feedscount;

  NotificationsResModel({
    this.userNotification,
    this.unCheck,
    this.chatCount,
    this.totalCount,
    this.feedscount,
  });

  factory NotificationsResModel.fromJson(Map<String, dynamic> json) =>
      NotificationsResModel(
        userNotification: json["userNotification"] == null
            ? null
            : List<NotificationModel>.from(json["userNotification"]
                .map((x) => NotificationModel.fromJson(x))),
        unCheck: json["unCheck"],
        chatCount: json["chatCount"],
        totalCount: json["totalCount"],
        feedscount: json["feedscount"],
      );

  Map<String, dynamic> toJson() => {
        "userNotification": userNotification == null
            ? null
            : List<dynamic>.from(userNotification!.map((x) => x!.toJson())),
        "unCheck": unCheck,
        "chatCount": chatCount,
        "totalCount": totalCount,
        "feedscount": feedscount,
      };
}
