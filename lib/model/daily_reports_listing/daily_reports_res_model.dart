// To parse this JSON data, do
//
//     final dailyReportsResModel = dailyReportsResModelFromJson(jsonString);

import 'dart:convert';

import 'package:teqtop_team/model/daily_reports_listing/daily_report.dart';
import 'package:teqtop_team/model/employees_listing/input_data.dart';

DailyReportsResModel dailyReportsResModelFromJson(String str) =>
    DailyReportsResModel.fromJson(json.decode(str));

String dailyReportsResModelToJson(DailyReportsResModel data) =>
    json.encode(data.toJson());

class DailyReportsResModel {
  InputData? input;
  int? draw;
  int? recordsTotal;
  int? recordsFiltered;
  List<DailyReport?>? data;

  DailyReportsResModel({
    this.input,
    this.draw,
    this.recordsTotal,
    this.recordsFiltered,
    this.data,
  });

  factory DailyReportsResModel.fromJson(Map<String, dynamic> json) =>
      DailyReportsResModel(
        input: json["input"] == null ? null : InputData.fromJson(json["input"]),
        draw: json["draw"],
        recordsTotal: json["recordsTotal"],
        recordsFiltered: json["recordsFiltered"],
        data: json["data"] == null
            ? null
            : List<DailyReport>.from(
                json["data"].map((x) => DailyReport.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "input": input == null ? null : input!.toJson(),
        "draw": draw,
        "recordsTotal": recordsTotal,
        "recordsFiltered": recordsFiltered,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x!.toJson())),
      };
}
