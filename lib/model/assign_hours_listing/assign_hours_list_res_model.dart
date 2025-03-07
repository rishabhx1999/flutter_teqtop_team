// To parse this JSON data, do
//
//     final assignHoursListResModel = assignHoursListResModelFromJson(jsonString);

import 'dart:convert';

import 'package:teqtop_team/model/assign_hours_listing/assign_hours.dart';
import 'package:teqtop_team/model/employees_listing/input_data.dart';

AssignHoursListResModel assignHoursListResModelFromJson(String str) =>
    AssignHoursListResModel.fromJson(json.decode(str));

String assignHoursListResModelToJson(AssignHoursListResModel data) =>
    json.encode(data.toJson());

class AssignHoursListResModel {
  InputData? input;
  int? draw;
  int? recordsTotal;
  int? recordsFiltered;
  List<AssignHours>? data;

  AssignHoursListResModel({
    this.input,
    this.draw,
    this.recordsTotal,
    this.recordsFiltered,
    this.data,
  });

  factory AssignHoursListResModel.fromJson(Map<String, dynamic> json) =>
      AssignHoursListResModel(
        input: json["input"] == null ? null : InputData.fromJson(json["input"]),
        draw: json["draw"],
        recordsTotal: json["recordsTotal"],
        recordsFiltered: json["recordsFiltered"],
        data: json["data"] == null
            ? null
            : List<AssignHours>.from(
                json["data"].map((x) => AssignHours.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "input": input?.toJson(),
        "draw": draw,
        "recordsTotal": recordsTotal,
        "recordsFiltered": recordsFiltered,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}
