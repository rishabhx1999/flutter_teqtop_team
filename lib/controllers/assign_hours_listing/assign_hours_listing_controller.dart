import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/model/global_search/project_model.dart';
import '../../config/app_routes.dart';
import '../../consts/app_consts.dart';
import '../../network/get_requests.dart';
import '../../utils/preference_manager.dart';
import '../dashboard/dashboard_controller.dart';

class AssignHoursListingController extends GetxController {
  late final scaffoldKey = GlobalKey<ScaffoldState>();
  late final String? profilePhoto;
  late TextEditingController searchTextController;
  RxBool showSearchFieldTrailing = false.obs;
  late Worker searchTextChangeListenerWorker;
  RxBool isLoading = false.obs;
  RxInt notificationsCount = 0.obs;
  RxString searchText = ''.obs;

  @override
  void onInit() {
    getProfilePhoto();
    initializeSearchTextController();
    setupSearchTextChangeListener();
    getNotificationsCount();

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

  void getProfilePhoto() {
    profilePhoto =
        (PreferenceManager.getPref(PreferenceManager.prefUserProfilePhoto)
                as String?) ??
            '';
  }

  void setupSearchTextChangeListener() {
    searchTextChangeListenerWorker =
        debounce(searchText, (callback) => getAssignHours());

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
  }

  Future<void> getAssignHours() async {}

  void getNotificationsCount() {
    final dashboardController = Get.find<DashboardController>();
    notificationsCount = dashboardController.notificationsCount;
  }
}
