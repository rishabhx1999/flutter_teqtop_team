import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/config/app_routes.dart';
import 'package:teqtop_team/controllers/project_detail/project_detail_controller.dart';
import 'package:teqtop_team/controllers/projects_listing/projects_listing_controller.dart';
import 'package:teqtop_team/model/project_create_edit/project_category_model.dart';
import 'package:teqtop_team/model/project_create_edit/proposal_model.dart';
import 'package:teqtop_team/model/project_detail/project_detail_res_model.dart';
import 'package:teqtop_team/network/put_requests.dart';

import '../../network/get_requests.dart';
import '../../network/post_requests.dart';
import '../../utils/preference_manager.dart';

class ProjectCreateEditController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey();
  late TextEditingController nameController;
  late TextEditingController clientController;
  late TextEditingController urlController;
  late TextEditingController portalController;
  late TextEditingController profileController;
  late TextEditingController descriptionController;
  dynamic accessDetail;
  RxBool isLoading = false.obs;
  RxBool areProjectCategoriesAndProposalLoading = false.obs;
  RxList<ProjectCategoryModel> projectCategories = <ProjectCategoryModel>[].obs;
  RxList<ProposalModel> proposals = <ProposalModel>[].obs;
  Rx<ProposalModel?> selectedProposal = Rx<ProposalModel?>(null);
  Rx<ProjectCategoryModel?> selectedProjectCategory =
      Rx<ProjectCategoryModel?>(null);
  RxBool showSelectProjectCategoryMessage = false.obs;
  RxBool showSelectProposalMessage = false.obs;
  RxBool fromProjectDetail = false.obs;
  Rx<ProjectDetailResModel?> editProjectDetail =
      Rx<ProjectDetailResModel?>(null);

  @override
  void onInit() {
    initializeTextEditingControllers();
    getProjectCategoriesAndProposals();
    getProjectDetail();

    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    disposeTextEditingControllers();
    super.onClose();
  }

  void getProjectDetail() {
    var previousRoute = Get.previousRoute;
    if (previousRoute == AppRoutes.routeProjectDetail) {
      fromProjectDetail.value = true;
      final projectDetailController = Get.find<ProjectDetailController>();
      editProjectDetail = projectDetailController.projectDetail;
    }
  }

  void setInitialFieldValues() {
    if (editProjectDetail.value != null && fromProjectDetail.value) {
      nameController.text = editProjectDetail.value!.name ?? "";
      var projectCategory = projectCategories.firstWhereOrNull(
          (projectCategory) =>
              projectCategory.id != null &&
              projectCategory.id == editProjectDetail.value!.categoryId);
      if (projectCategory != null) {
        onChangeProjectCategory(projectCategory);
      }
      clientController.text = editProjectDetail.value!.client ?? "";
      urlController.text = editProjectDetail.value!.url ?? "";
      portalController.text = editProjectDetail.value!.portal ?? "";
      profileController.text = editProjectDetail.value!.profile ?? "";
      descriptionController.text = editProjectDetail.value!.description ?? "";
      accessDetail = editProjectDetail.value!.accessDetail;
      var proposal = proposals.firstWhereOrNull((proposal) =>
          proposal.id != null &&
          proposal.id.toString() == editProjectDetail.value!.proposalId);
      if (proposal != null) {
        onChangeProposal(proposal);
      }
    }
  }

  bool areRequiredFieldsFilled() {
    bool isProjectCategorySelected = selectedProjectCategory.value != null &&
        selectedProjectCategory.value!.name != "select_category".tr;
    showSelectProjectCategoryMessage.value = !isProjectCategorySelected;

    bool isProposalSelected = selectedProposal.value != null &&
        selectedProposal.value!.title != "select_proposal".tr;
    showSelectProposalMessage.value = !isProposalSelected;

    bool areTextFieldsFilled = formKey.currentState!.validate();

    return isProjectCategorySelected &&
        isProposalSelected &&
        areTextFieldsFilled;
  }

  void initializeTextEditingControllers() {
    nameController = TextEditingController();
    clientController = TextEditingController();
    urlController = TextEditingController();
    portalController = TextEditingController();
    profileController = TextEditingController();
    descriptionController = TextEditingController();
  }

  void disposeTextEditingControllers() {
    nameController.dispose();
    clientController.dispose();
    urlController.dispose();
    portalController.dispose();
    profileController.dispose();
    descriptionController.dispose();
  }

  Future<void> createProject() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (areRequiredFieldsFilled()) {
      Map<String, dynamic> requestBody = {
        'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
            as String?,
        'name': nameController.text.toString().trim(),
        'description': descriptionController.text.toString().trim(),
        'category_id': selectedProjectCategory.value!.id,
        'client': clientController.text.toString().trim(),
        'portal': portalController.text.toString().trim(),
        'profile': profileController.text.toString().trim(),
        'proposal_id': selectedProposal.value!.id,
        'url': urlController.text.toString().trim(),
      };

      isLoading.value = true;
      try {
        var response = await PostRequests.createProject(requestBody);
        if (response != null) {
          if (response.status == "success") {
            Get.back();
            final projectsListingController =
                Get.find<ProjectsListingController>();
            projectsListingController.projects.clear();
            projectsListingController.getProjects();
          } else {
            Get.snackbar("error".tr, "message_server_error".tr);
          }
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> editProject() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (areRequiredFieldsFilled() && editProjectDetail.value!.id != null) {
      Map<String, dynamic> requestBody = {
        'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
            as String?,
        'name': nameController.text.toString().trim(),
        'description': descriptionController.text.toString().trim(),
        'category_id': selectedProjectCategory.value!.id,
        'client': clientController.text.toString().trim(),
        'portal': portalController.text.toString().trim(),
        'profile': profileController.text.toString().trim(),
        'proposal_id': selectedProposal.value!.id,
        'url': urlController.text.toString().trim(),
        'access_detail': accessDetail,
      };

      isLoading.value = true;
      try {
        var response = await PutRequests.editProject(
            requestBody, editProjectDetail.value!.id!);
        if (response != null) {
          if (response.status == "success") {
            Get.back();
            final projectDetailController = Get.find<ProjectDetailController>();
            projectDetailController.getProjectDetail();
          } else {
            Get.snackbar("error".tr, "message_server_error".tr);
          }
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> getProjectCategoriesAndProposals() async {
    areProjectCategoriesAndProposalLoading.value = true;
    try {
      var response = await GetRequests.getProjectCategoriesAndProposals();
      if (response != null) {
        if (response.proposals != null || response.categories != null) {
          if (response.proposals != null) {
            proposals.assignAll(response.proposals! as Iterable<ProposalModel>);
            proposals.insert(0, ProposalModel(title: "select_proposal".tr));
            selectedProposal.value = proposals[0];
          }
          if (response.categories != null) {
            projectCategories.assignAll(
                response.categories! as Iterable<ProjectCategoryModel>);
            projectCategories.insert(
                0, ProjectCategoryModel(name: "select_category".tr));
            selectedProjectCategory.value = projectCategories[0];
          }
          setInitialFieldValues();
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } else {
        Get.snackbar("error".tr, "message_server_error".tr);
      }
    } finally {
      areProjectCategoriesAndProposalLoading.value = false;
    }
  }

  void onChangeProjectCategory(var newProjectCategory) {
    selectedProjectCategory.value = newProjectCategory as ProjectCategoryModel;
  }

  void onChangeProposal(var newProposal) {
    selectedProposal.value = newProposal as ProposalModel;
  }

  String truncateDropdownSelectedValue(String text) {
    if (text == "select_proposal".tr || text == "select_category".tr) {
      return text;
    }
    if (text.length > 16) {
      return '${text.substring(0, 16)}...';
    }
    return text;
  }
}
