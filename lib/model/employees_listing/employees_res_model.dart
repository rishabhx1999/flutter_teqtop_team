// To parse this JSON data, do
//
//     final employeesResModel = employeesResModelFromJson(jsonString);

import 'dart:convert';

import 'package:teqtop_team/model/employees_listing/employee_model.dart';
import 'package:teqtop_team/model/employees_listing/input_data.dart';

EmployeesResModel employeesResModelFromJson(String str) =>
    EmployeesResModel.fromJson(json.decode(str));

String employeesResModelToJson(EmployeesResModel data) =>
    json.encode(data.toJson());

class EmployeesResModel {
  InputData? input;
  int? draw;
  int? recordsTotal;
  int? recordsFiltered;
  List<EmployeeModel?>? data;

  EmployeesResModel({
    this.input,
    this.draw,
    this.recordsTotal,
    this.recordsFiltered,
    this.data,
  });

  factory EmployeesResModel.fromJson(Map<String, dynamic> json) =>
      EmployeesResModel(
        input: json["input"] == null
            ? null
            : InputData.fromJson(json["input"]),
        draw: json["draw"],
        recordsTotal: json["recordsTotal"],
        recordsFiltered: json["recordsFiltered"],
        data: json["data"] == null
            ? null
            : List<EmployeeModel>.from(
                json["data"].map((x) => EmployeeModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "input": input?.toJson(),
        "draw": draw,
        "recordsTotal": recordsTotal,
        "recordsFiltered": recordsFiltered,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x!.toJson())),
      };
}
