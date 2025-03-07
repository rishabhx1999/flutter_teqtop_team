// To parse this JSON data, do
//
//     final editProfileResModel = editProfileResModelFromJson(jsonString);

import 'dart:convert';

EditProfileResModel editProfileResModelFromJson(String str) =>
    EditProfileResModel.fromJson(json.decode(str));

String editProfileResModelToJson(EditProfileResModel data) =>
    json.encode(data.toJson());

class EditProfileResModel {
  int? id;
  String? name;
  String? email;
  String? roles;
  String? status;
  int? userId;
  String? profile;
  String? thumbnail;
  String? contactNo;
  String? alternateNo;
  int? position;
  dynamic department;
  dynamic departmentId;
  DateTime? birthDate;
  dynamic joiningDate;
  dynamic appraiselDate;
  String? additionalInfo;
  String? panCard;
  String? adharCard;
  dynamic officialDocs;
  dynamic otherDocs;
  String? currentAddress;
  String? permanentAddress;
  dynamic remarks;
  dynamic shift;
  DateTime? createdAt;
  DateTime? updatedAt;

  EditProfileResModel({
    this.id,
    this.name,
    this.email,
    this.roles,
    this.status,
    this.userId,
    this.profile,
    this.thumbnail,
    this.contactNo,
    this.alternateNo,
    this.position,
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
    this.createdAt,
    this.updatedAt,
  });

  factory EditProfileResModel.fromJson(Map<String, dynamic> json) =>
      EditProfileResModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        roles: json["roles"],
        status: json["status"],
        userId: json["user_id"],
        profile: json["profile"],
        thumbnail: json["thumbnail"],
        contactNo: json["contact_no"],
        alternateNo: json["alternate_no"],
        position: json["position"],
        department: json["department"],
        departmentId: json["department_id"],
        birthDate: json["birth_date"] == null
            ? null
            : DateTime.parse(json["birth_date"]),
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
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "roles": roles,
        "status": status,
        "user_id": userId,
        "profile": profile,
        "thumbnail": thumbnail,
        "contact_no": contactNo,
        "alternate_no": alternateNo,
        "position": position,
        "department": department,
        "department_id": departmentId,
        "birth_date": birthDate?.toIso8601String(),
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
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
