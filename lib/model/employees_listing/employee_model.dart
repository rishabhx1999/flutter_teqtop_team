import 'dart:convert';

import 'package:get/get.dart';

import '../enum_values.dart';
import 'data_row_attribute.dart';

EmployeeModel employeeFromJson(String str) =>
    EmployeeModel.fromJson(json.decode(str));

String employeeToJson(EmployeeModel data) => json.encode(data.toJson());

class EmployeeModel {
  DataRowAttribute? dtRowAttr;
  int? userId;
  int? id;
  int? you;
  String? employeeId;
  String? name;
  String? email;
  String? positionName;
  dynamic emailVerifiedAt;
  dynamic apiToken;
  dynamic deviceToken;
  dynamic mobileToken;
  DateTime? registered;
  String? roles;
  String? isActive;
  dynamic isLogged;
  dynamic assignees;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  dynamic profile;
  String? thumbnail;
  String? action;
  dynamic status;
  dynamic contactNo;
  dynamic alternateNo;
  int? position;
  dynamic userPosition;
  dynamic department;
  dynamic departmentId;
  dynamic birthDate;
  dynamic joiningDate;
  dynamic appraiselDate;
  dynamic additionalInfo;
  String? panCard;
  String? adharCard;
  String? officialDocs;
  String? otherDocs;
  dynamic currentAddress;
  dynamic permanentAddress;
  dynamic remarks;
  dynamic shift;
  bool? isEdit;
  RxBool multiUse = false.obs;

  EmployeeModel({
    this.dtRowAttr,
    this.userId,
    this.id,
    this.you,
    this.employeeId,
    this.name,
    this.email,
    this.positionName,
    this.emailVerifiedAt,
    this.apiToken,
    this.deviceToken,
    this.mobileToken,
    this.registered,
    this.roles,
    this.isActive,
    this.isLogged,
    this.assignees,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.profile,
    this.thumbnail,
    this.action,
    this.status,
    this.contactNo,
    this.alternateNo,
    this.position,
    this.userPosition,
    this.department,
    this.departmentId,
    this.birthDate,
    this.joiningDate,
    this.appraiselDate,
    this.additionalInfo,
    this.panCard,
    this.adharCard,
    this.officialDocs,
    this.otherDocs,
    this.currentAddress,
    this.permanentAddress,
    this.remarks,
    this.shift,
    this.isEdit,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        dtRowAttr: json["DT_RowAttr"] == null
            ? null
            : DataRowAttribute.fromJson(json["DT_RowAttr"]),
        userId: json["userId"] ?? json["user_id"],
        id: json["id"],
        you: json["you"],
        employeeId: json["employee_id"],
        name: json["name"],
        email: json["email"],
        positionName: json["position_name"],
        emailVerifiedAt: json["email_verified_at"],
        apiToken: json["api_token"],
        deviceToken: json["device_token"],
        mobileToken: json["mobile_token"],
        registered: json["registered"] == null
            ? null
            : DateTime.parse(json["registered"]),
        roles: json["roles"] ?? json["menuroles"],
        isActive: json["is_active"],
        isLogged: json["is_logged"],
        assignees: json["assignees"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        profile: json["profile"],
        thumbnail: json["thumbnail"],
        action: json["action"],
        status:
            json["status"] == null ? null : statusValues.map[json["status"]],
        contactNo: json["contact_no"],
        alternateNo: json["alternate_no"],
        position: json["position"],
        userPosition: json["user_position"],
        department: json["department"],
        departmentId: json["department_id"],
        birthDate: json["birth_date"],
        joiningDate: json["joining_date"],
        appraiselDate: json["appraisel_date"],
        additionalInfo: json["additional_info"],
        panCard: json["pan_card"],
        adharCard: json["adhar_card"],
        officialDocs: json["official_docs"],
        otherDocs: json["other_docs"],
        currentAddress: json["current_address"],
        permanentAddress: json["permanent_address"],
        remarks: json["remarks"],
        shift: json["shift"],
        isEdit: json["is_edit"],
      );

  Map<String, dynamic> toJson() => {
        "DT_RowAttr": dtRowAttr?.toJson(),
        "userId": userId,
        "id": id,
        "you": you,
        "employee_id": employeeId,
        "name": name,
        "email": email,
        "position_name": positionName,
        "email_verified_at": emailVerifiedAt,
        "api_token": apiToken,
        "device_token": deviceToken,
        "mobile_token": mobileToken,
        "registered": registered?.toIso8601String(),
        "roles": roles,
        "is_active": isActive,
        "is_logged": isLogged,
        "assignees": assignees,
        "created_at": createdAt?.toIso8601String(),
        "updated_at":
            updatedAt == null ? updatedAt : updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
        "menuroles": roles,
        "profile": profile,
        "thumbnail": thumbnail,
        "action": action,
        "status": status ?? statusValues.reverse[status],
        "contact_no": contactNo,
        "alternate_no": alternateNo,
        "position": position,
        "user_position": userPosition,
        "department": department,
        "department_id": departmentId,
        "birth_date": birthDate,
        "joining_date": joiningDate,
        "appraisel_date": appraiselDate,
        "additional_info": additionalInfo,
        "pan_card": panCard,
        "adhar_card": adharCard,
        "official_docs": officialDocs,
        "other_docs": otherDocs,
        "current_address": currentAddress,
        "permanent_address": permanentAddress,
        "remarks": remarks,
        "shift": shift,
        "is_edit": isEdit,
      };
}

enum Status { SPAN_CLASS_BADGE_BADGE_SUCCESS_ACTIVE_SPAN }

final statusValues = EnumValues({
  "<span class=\"badge badge-success\">Active</span>":
      Status.SPAN_CLASS_BADGE_BADGE_SUCCESS_ACTIVE_SPAN
});
