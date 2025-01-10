// To parse this JSON data, do
//
//     final leavesResModel = leavesResModelFromJson(jsonString);

import 'dart:convert';

import 'package:teqtop_team/model/employee_detail/leave_model.dart';
import 'package:teqtop_team/model/employees_listing/input_data.dart';

LeavesResModel leavesResModelFromJson(String str) =>
    LeavesResModel.fromJson(json.decode(str));

String leavesResModelToJson(LeavesResModel data) => json.encode(data.toJson());

class LeavesResModel {
  InputData? input;
  int? draw;
  int? recordsTotal;
  int? recordsFiltered;
  List<LeaveModel?>? data;

  LeavesResModel({
    this.input,
    this.draw,
    this.recordsTotal,
    this.recordsFiltered,
    this.data,
  });

  factory LeavesResModel.fromJson(Map<String, dynamic> json) => LeavesResModel(
        input: json["input"] == null ? null : InputData.fromJson(json["input"]),
        draw: json["draw"],
        recordsTotal: json["recordsTotal"],
        recordsFiltered: json["recordsFiltered"],
        data: json["data"] == null
            ? null
            : List<LeaveModel>.from(
                json["data"].map((x) => LeaveModel.fromJson(x))),
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
