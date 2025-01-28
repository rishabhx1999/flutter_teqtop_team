import 'package:get/get.dart';
import 'package:teqtop_team/model/project_detail/project_detail_res_model.dart';

import '../../config/app_routes.dart';
import '../../consts/app_consts.dart';
import '../../network/get_requests.dart';
import '../../utils/helpers.dart';

class ProjectDetailController extends GetxController {
  int? projectId;
  RxBool isLoading = false.obs;
  Rx<ProjectDetailResModel?> projectDetail = Rx<ProjectDetailResModel?>(null);
  bool shouldClearPreviousRoutes = false;

  @override
  void onInit() {
    getProjectId();
    checkIfClearPreviousRoutes();

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

  void checkIfClearPreviousRoutes() {
    var previousRoute = Get.previousRoute;
    if (previousRoute == AppRoutes.routeNotifications ||
        previousRoute == AppRoutes.routeLogsListing) {
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
      Helpers.printLog(
          description: "PROJECT_DETAIL_CONTROLLER_HANDLE_DRIVE_ON_TAP",
          message: "DATA_NOT_NULL");
    }
  }
}
