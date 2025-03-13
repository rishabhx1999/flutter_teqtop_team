import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/config/app_routes.dart';
import 'package:teqtop_team/model/employees_listing/employee_model.dart';

import '../../consts/app_consts.dart';
import '../../model/global_search/drive_model.dart';
import '../../model/global_search/project_model.dart';
import '../../model/global_search/task_model.dart';
import '../../network/post_requests.dart';
import '../../utils/helpers.dart';
import '../../utils/preference_manager.dart';

class GlobalSearchController extends GetxController {
  late TextEditingController searchTextController;
  RxBool showSearchFieldTrailing = false.obs;
  late Worker searchTextChangeListenerWorker;
  RxBool isLoading = false.obs;
  RxList<EmployeeModel?> employees = <EmployeeModel>[].obs;
  RxList<TaskModel?> tasks = <TaskModel>[].obs;
  RxList<DriveModel?> drives = <DriveModel>[].obs;
  RxList<ProjectModel?> projects = <ProjectModel>[].obs;
  RxBool areTasksShowing = true.obs;
  RxBool areDrivesShowing = true.obs;
  RxBool areProjectsShowing = true.obs;
  RxBool areEmployeesShowing = true.obs;
  RxBool areGroupsShowing = true.obs;
  RxString searchText = ''.obs;

  @override
  void onInit() {
    initializeSearchTextController();
    setupSearchTextChangeListener();

    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    disposeSearchTextChangeListenerWorker();
    disposeSearchTextController();

    super.onClose();
  }

  void setupSearchTextChangeListener() {
    searchTextChangeListenerWorker =
        debounce(searchText, (callback) => searchGlobally());

    searchTextController.addListener(() {
      searchText.value = searchTextController.text.toString().trim();
    });
  }

  void disposeSearchTextChangeListenerWorker() {
    searchTextChangeListenerWorker.dispose();
  }

  void initializeSearchTextController() {
    searchTextController = TextEditingController();
  }

  void disposeSearchTextController() {
    searchTextController.dispose();
  }

  void handleSearchTextChange(String text) {
    showSearchFieldTrailing.value = text.isNotEmpty;
  }

  void handleClearSearchField() {
    searchTextController.clear();
    showSearchFieldTrailing.value = false;
    employees.clear();
  }

  void searchGlobally() async {
    if (searchText.isNotEmpty) {
      isLoading.value = true;
      try {
        if (await Helpers.isInternetWorking()) {
          Map<String, dynamic> requestBody = {
            'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
                as String?,
            'search': searchText.value,
          };
          var response = await PostRequests.searchGlobal(requestBody);
          if (response != null) {
            employees.assignAll(response.members as Iterable<EmployeeModel?>);
            tasks.assignAll(response.tasks as Iterable<TaskModel?>);
            projects.assignAll(response.projects as Iterable<ProjectModel?>);
            drives.assignAll(response.drives as Iterable<DriveModel?>);
            employees.refresh();
            tasks.refresh();
            projects.refresh();
            drives.refresh();
          } else {
            Get.snackbar('error'.tr, 'message_server_error'.tr);
          }
        } else {
          Get.snackbar("error".tr, "message_check_internet".tr);
        }
      } finally {
        isLoading.value = false;
      }
    } else {
      employees.clear();
      projects.clear();
      tasks.clear();
      drives.clear();
    }
  }

  void handleEmployeeOnTap(int? employeeId, int? id) {
    Get.toNamed(AppRoutes.routeEmployeeDetail, arguments: {
      AppConsts.keyEmployeeId: employeeId,
      AppConsts.keyId: id,
    });
  }

  void handleProjectOnTap(int? projectId) {
    Get.toNamed(AppRoutes.routeProjectDetail, arguments: {
      AppConsts.keyProjectId: projectId,
    });
  }

  void handleGroupOnTap(int? projectId) {
    Get.toNamed(AppRoutes.routeTasksListing, arguments: {
      AppConsts.keyProjectId: projectId,
    });
  }

  void handleTaskOnTap(int? taskId) {
    Get.toNamed(AppRoutes.routeTaskDetail, arguments: {
      AppConsts.keyTaskId: taskId,
    });
  }

  void handleDriveOnTap(String? driveURL) {
    Get.toNamed(AppRoutes.routeDriveDetail, arguments: {
      AppConsts.keyDriveURL: driveURL,
    });
  }
}
