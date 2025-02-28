import 'package:get/get.dart';
import 'package:teqtop_team/controllers/global_search/global_search_controller.dart';
import 'package:teqtop_team/controllers/projects_listing/projects_listing_controller.dart';
import 'package:teqtop_team/model/project_detail/project_detail_res_model.dart';
import 'package:teqtop_team/network/post_requests.dart';

import '../../config/app_routes.dart';
import '../../consts/app_consts.dart';
import '../../network/get_requests.dart';
import '../../utils/helpers.dart';
import '../../views/dialogs/common/common_alert_dialog.dart';

class ProjectDetailController extends GetxController {
  int? projectId;
  RxBool isLoading = false.obs;
  Rx<ProjectDetailResModel?> projectDetail = Rx<ProjectDetailResModel?>(null);
  bool shouldClearPreviousRoutes = false;

  @override
  void onInit() {
    getProjectId();
    checkPreviousRoutes();

    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void checkPreviousRoutes() {
    var previousRoute = Get.previousRoute;
    if (previousRoute == AppRoutes.routeNotifications ||
        previousRoute == AppRoutes.routeLogsListing ||
        previousRoute == AppRoutes.routeTaskDetail) {
      shouldClearPreviousRoutes = true;
    }
  }

  void getProjectId() {
    Map? data = Get.arguments;
    if (data != null && data.isNotEmpty) {
      if (data.containsKey(AppConsts.keyProjectId)) {
        projectId = data[AppConsts.keyProjectId];
      }
    }
    getProjectDetail();
  }

  Future<void> getProjectDetail() async {
    if (projectId != null) {
      isLoading.value = true;
      try {
        var response = await GetRequests.getProjectDetail(projectId!);
        if (response != null) {
          projectDetail.value = response;
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } finally {
        isLoading.value = false;
      }
    }
  }

  void handleTaskOnTap() {
    if (shouldClearPreviousRoutes == true) {
      Get.offNamedUntil(AppRoutes.routeTasksListing,
          (route) => route.settings.name == AppRoutes.routeDashboard,
          arguments: {
            AppConsts.keyProjectId: projectId,
          });
      shouldClearPreviousRoutes = false;
    } else {
      Get.toNamed(AppRoutes.routeTasksListing, arguments: {
        AppConsts.keyProjectId: projectId,
      });
    }
  }

  void handleDriveOnTap() {
    if (projectDetail.value != null) {
      Get.toNamed(AppRoutes.routeDriveDetail, arguments: {
        AppConsts.keyDriveURL: projectDetail.value!.drive,
      });
      // Helpers.printLog(
      //     description: "PROJECT_DETAIL_CONTROLLER_HANDLE_DRIVE_ON_TAP",
      //     message: "DATA_NOT_NULL");
    }
  }

  void handleOnDelete() {
    CommonAlertDialog.showDialog(
      message: "message_project_delete_confirmation",
      positiveText: "yes",
      positiveBtnCallback: () async {
        deleteProject();
      },
      isShowNegativeBtn: true,
      negativeText: 'no',
    );
  }

  void refreshPreviousPageData() {
    ProjectsListingController? projectsListingController;
    try {
      projectsListingController = Get.find<ProjectsListingController>();
    } catch (e) {
      // Helpers.printLog(
      //     description: "PROJECT_DETAIL_CONTROLLER_REFRESH_PREVIOUS_PAGE_DATA",
      //     message: "COULD_NOT_FIND_PROJECTS_LISTING_CONTROLLER");
    }
    if (projectsListingController != null) {
      projectsListingController.getProjects();
    }
    GlobalSearchController? globalSearchController;
    try {
      globalSearchController = Get.find<GlobalSearchController>();
    } catch (e) {
      // Helpers.printLog(
      //     description: "PROJECT_DETAIL_CONTROLLER_REFRESH_PREVIOUS_PAGE_DATA",
      //     message: "COULD_NOT_FIND_GLOBAL_SEARCH_CONTROLLER");
    }
    if (globalSearchController != null) {
      globalSearchController.searchGlobally();
    }
  }

  Future<void> deleteProject() async {
    Get.back();
    if (projectId != null) {
      Map<String, dynamic> requestBody = {
        '_method': 'DELETE',
      };
      isLoading.value = true;
      try {
        var response =
            await PostRequests.deleteProject(projectId!, requestBody);
        if (response != null) {
          if (response.status == "success") {
            Get.back();
            refreshPreviousPageData();
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
}
