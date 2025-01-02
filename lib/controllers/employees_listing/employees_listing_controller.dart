import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app_routes.dart';
import '../../utils/preference_manager.dart';

class EmployeesListingController extends GetxController {
  late final scaffoldKey = GlobalKey<ScaffoldState>();
  late final String? profilePhoto;
  late TextEditingController searchTextController;
  RxBool showSearchFieldTrailing = false.obs;
  late Worker searchTextChangeListenerWorker;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getProfilePhoto();
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

  void getProfilePhoto() {
    profilePhoto =
        (PreferenceManager.getPref(PreferenceManager.prefUserProfilePhoto)
                as String?) ??
            '';
  }

  void setupSearchTextChangeListener() {
    RxString searchText = ''.obs;
    // searchTextChangeListenerWorker =
    //     debounce(searchText, (callback) => searchGlobally(searchText.value));

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
    // employees.clear();
  }

  void handleEmployeeOnTap() {
    Get.toNamed(AppRoutes.routeEmployeeDetail);
  }
}
