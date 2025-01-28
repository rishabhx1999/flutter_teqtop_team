// To parse this JSON data, do
//
//     final logsReModel = logsReModelFromJson(jsonString);

import 'dart:convert';

import 'package:teqtop_team/model/employees_listing/input_data.dart';
import 'package:teqtop_team/model/logs_listing/log_model.dart';

LogsResModel logsResModelFromJson(String str) =>
    LogsResModel.fromJson(json.decode(str));

String logsResModelToJson(LogsResModel data) => json.encode(data.toJson());

class LogsResModel {
  InputData? input;
  int? draw;
  int? recordsTotal;
  int? recordsFiltered;
  List<LogModel?>? data;

  LogsResModel({
    this.input,
    this.draw,
    this.recordsTotal,
    this.recordsFiltered,
    this.data,
  });

  factory LogsResModel.fromJson(Map<String, dynamic> json) => LogsResModel(
        input: json["input"] == null ? null : InputData.fromJson(json["input"]),
        draw: json["draw"],
        recordsTotal: json["recordsTotal"],
        recordsFiltered: json["recordsFiltered"],
        data: json["data"] == null
            ? null
            : List<LogModel>.from(
                json["data"].map((x) => LogModel.fromJson(x))),
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
