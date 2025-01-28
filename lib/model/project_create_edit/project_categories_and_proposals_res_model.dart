// To parse this JSON data, do
//
//     final projectCategoriesAndProposalsResModel = projectCategoriesAndProposalsResModelFromJson(jsonString);

import 'dart:convert';

import 'package:teqtop_team/model/project_create_edit/project_category_model.dart';
import 'package:teqtop_team/model/project_create_edit/proposal_model.dart';

ProjectCategoriesAndProposalsResModel
    projectCategoriesAndProposalsResModelFromJson(String str) =>
        ProjectCategoriesAndProposalsResModel.fromJson(json.decode(str));

String projectCategoriesAndProposalsResModelToJson(
        ProjectCategoriesAndProposalsResModel data) =>
    json.encode(data.toJson());

class ProjectCategoriesAndProposalsResModel {
  List<ProposalModel?>? proposals;
  List<ProjectCategoryModel?>? categories;

  ProjectCategoriesAndProposalsResModel({
    this.proposals,
    this.categories,
  });

  factory ProjectCategoriesAndProposalsResModel.fromJson(
          Map<String, dynamic> json) =>
      ProjectCategoriesAndProposalsResModel(
        proposals: json["proposals"] == null
            ? null
            : List<ProposalModel>.from(
                json["proposals"].map((x) => ProposalModel.fromJson(x))),
        categories: json["categories"] == null
            ? null
            : List<ProjectCategoryModel>.from(json["categories"]
                .map((x) => ProjectCategoryModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "proposals": proposals == null
            ? null
            : List<dynamic>.from(proposals!.map((x) => x!.toJson())),
        "categories": categories == null
            ? null
            : List<dynamic>.from(categories!.map((x) => x!.toJson())),
      };
}
