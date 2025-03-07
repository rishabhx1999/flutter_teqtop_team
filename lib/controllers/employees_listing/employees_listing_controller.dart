import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/model/employees_listing/employee_model.dart';
import 'package:teqtop_team/network/get_requests.dart';

import '../../config/app_routes.dart';
import '../../consts/app_consts.dart';
import '../../utils/preference_manager.dart';
import '../dashboard/dashboard_controller.dart';

class EmployeesListingController extends GetxController {
  late final scaffoldKey = GlobalKey<ScaffoldState>();
  late final String? profilePhoto;
  late TextEditingController searchTextController;
  RxBool showSearchFieldTrailing = false.obs;
  late Worker searchTextChangeListenerWorker;
  RxBool isLoading = false.obs;
  RxList<EmployeeModel?> employees = <EmployeeModel>[].obs;
  RxInt employeeCountLoadingDotIndex = 0.obs;
  final List<String> employeeCountLoadingDots = [".", "..", "..."];
  Timer? employeeCountLoadingDotsTimer;
  RxInt notificationsCount = 0.obs;

  @override
  void onInit() {
    getProfilePhoto();
    initializeSearchTextController();
    setupSearchTextChangeListener();
    getEmployees('');
    startEmployeeCountLoadingAnimation();
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
    cancelEmployeeCountLoadingDotsTimer();

    super.onClose();
  }

  void cancelEmployeeCountLoadingDotsTimer() {
    employeeCountLoadingDotsTimer?.cancel();
  }

  void startEmployeeCountLoadingAnimation() {
    employeeCountLoadingDotsTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      employeeCountLoadingDotIndex.value =
          (employeeCountLoadingDotIndex.value + 1) %
              employeeCountLoadingDots.length;
    });
  }

  void getProfilePhoto() {
    profilePhoto =
        (PreferenceManager.getPref(PreferenceManager.prefUserProfilePhoto)
                as String?) ??
            '';
  }

  void setupSearchTextChangeListener() {
    RxString searchText = ''.obs;
    searchTextChangeListenerWorker =
        debounce(searchText, (callback) => getEmployees(searchText.value));

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

  void handleEmployeeOnTap(int? employeeId, int? id) {
    Get.toNamed(AppRoutes.routeEmployeeDetail, arguments: {
      AppConsts.keyEmployeeId: employeeId,
      AppConsts.keyId: id,
    });
  }

  Future<void> getEmployees(String searchText) async {
    Map<String, String> requestBody = {
      // 'draw': '20',
      // 'columns%5B0%5D%5Bdata%5D': 'DT_RowIndex',
      // 'columns%5B0%5D%5Bname%5D': '',
      // 'columns%5B0%5D%5Bsearchable%5D': 'true',
      // 'columns%5B0%5D%5Borderable%5D': 'true',
      // 'columns%5B0%5D%5Bsearch%5D%5Bvalue%5D': '',
      // 'columns%5B0%5D%5Bsearch%5D%5Bregex%5D': 'false',
      // 'columns%5B1%5D%5Bdata%5D': 'employee_id',
      // 'columns%5B1%5D%5Bname%5D': '',
      // 'columns%5B1%5D%5Bsearchable%5D': 'true',
      // 'columns%5B1%5D%5Borderable%5D': 'true',
      // 'columns%5B1%5D%5Bsearch%5D%5Bvalue%5D': '',
      // 'columns%5B1%5D%5Bsearch%5D%5Bregex%5D': 'false',
      // 'columns%5B2%5D%5Bdata%5D': 'name',
      // 'columns%5B2%5D%5Bname%5D': 'name',
      // 'columns%5B2%5D%5Bsearchable%5D': 'true',
      // 'columns%5B2%5D%5Borderable%5D': 'true',
      // 'columns%5B2%5D%5Bsearch%5D%5Bvalue%5D': '',
      // 'columns%5B2%5D%5Bsearch%5D%5Bregex%5D': 'false',
      // 'columns%5B3%5D%5Bdata%5D': 'registered',
      // 'columns%5B3%5D%5Bname%5D': 'registered',
      // 'columns%5B3%5D%5Borderable%5D': 'true',
      // 'columns%5B3%5D%5Bsearch%5D%5Bvalue%5D': '',
      // 'columns%5B3%5D%5Bsearch%5D%5Bregex%5D': 'false',
      // 'columns%5B4%5D%5Bdata%5D': 'roles',
      // 'columns%5B4%5D%5Bname%5D': '',
      // 'columns%5B4%5D%5Bsearchable%5D': 'true',
      // 'columns%5B4%5D%5Borderable%5D': 'true',
      // 'columns%5B4%5D%5Bsearch%5D%5Bvalue%5D': '',
      // 'columns%5B4%5D%5Bsearch%5D%5Bregex%5D': 'false',
      // 'columns%5B5%5D%5Bdata%5D': 'status',
      // 'columns%5B5%5D%5Bname%5D': '',
      // 'columns%5B5%5D%5Bsearchable%5D': 'true',
      // 'columns%5B5%5D%5Borderable%5D': 'true',
      // 'columns%5B5%5D%5Bsearch%5D%5Bvalue%5D': '',
      // 'columns%5B5%5D%5Bsearch%5D%5Bregex%5D': 'false',
      // 'columns%5B6%5D%5Bdata%5D': 'action',
      // 'columns%5B6%5D%5Bname%5D': '',
      // 'columns%5B6%5D%5Bsearchable%5D': 'false',
      // 'columns%5B6%5D%5Borderable%5D': 'false',
      // 'columns%5B6%5D%5Bsearch%5D%5Bvalue%5D': '',
      // 'columns%5B6%5D%5Bsearch%5D%5Bregex%5D': 'false',
      'order%5B0%5D%5Bcolumn%5D': '0',
      'order%5B0%5D%5Bdir%5D': 'DESC',
      'start': '0',
      'length': '-1',
      'search%5Bvalue%5D': searchText,
      'search%5Bregex%5D': 'false'
    };

    isLoading.value = true;
    try {
      var response = await GetRequests.getEmployees(requestBody);
      if (response != null) {
        if (response.data != null) {
          employees.assignAll(response.data!.toList());
        }
      } else {
        Get.snackbar("error".tr, "message_server_error".tr);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void getNotificationsCount() {
    final dashboardController = Get.find<DashboardController>();
    notificationsCount = dashboardController.notificationsCount;
  }
}
