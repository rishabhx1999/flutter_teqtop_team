import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/config/app_routes.dart';
import 'package:teqtop_team/model/search/member.dart';
import 'package:teqtop_team/model/search/project.dart';
import 'package:teqtop_team/model/search/task.dart';

import '../../model/search/drive.dart';
import '../../network/post_requests.dart';
import '../../utils/preference_manager.dart';

class GlobalSearchController extends GetxController {
  late TextEditingController searchTextController;
  RxBool showSearchFieldTrailing = false.obs;
  late Worker searchTextChangeListenerWorker;
  RxBool isLoading = false.obs;
  RxList<Member?> employees = <Member>[].obs;
  RxList<Task?> tasks = <Task>[].obs;
  RxList<Drive?> drives = <Drive>[].obs;
  RxList<Project?> projects = <Project>[].obs;

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
    RxString searchText = ''.obs;
    searchTextChangeListenerWorker =
        debounce(searchText, (callback) => searchGlobally(searchText.value));

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

  void searchGlobally(String searchText) async {
    if (searchText.isNotEmpty) {
      isLoading.value = true;
      try {
        Map<String, dynamic> requestBody = {
          'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
              as String?,
          'search': searchText,
        };
        var response = await PostRequests.searchGlobal(requestBody);
        if (response != null) {
          employees.assignAll(response.members as Iterable<Member?>);
          tasks.assignAll(response.tasks as Iterable<Task?>);
          projects.assignAll(response.projects as Iterable<Project?>);
          drives.assignAll(response.drives as Iterable<Drive?>);
        } else {
          Get.snackbar('error'.tr, 'message_server_error'.tr);
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

  void handleEmployeeOnTap() {
    Get.toNamed(AppRoutes.routeEmployeeDetail);
  }
}
