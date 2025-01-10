import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teqtop_team/config/app_routes.dart';
import 'package:teqtop_team/model/daily_reports_listing/daily_report.dart';
import 'package:teqtop_team/utils/helpers.dart';

import '../../consts/app_consts.dart';
import '../../model/daily_reports_listing/value_time.dart';
import '../../model/employees_listing/employee_model.dart';
import '../../network/get_requests.dart';
import '../../utils/preference_manager.dart';

class DailyReportsListingController extends GetxController {
  late final scaffoldKey = GlobalKey<ScaffoldState>();
  late final String? profilePhoto;
  RxList<EmployeeModel?> users = <EmployeeModel>[].obs;
  Rx<EmployeeModel?> selectedUser = Rx<EmployeeModel?>(null);
  List<ValueTime> times = [
    ValueTime(time: "value_time".tr),
    ValueTime(time: "yesterday".tr),
    ValueTime(time: "today".tr),
    ValueTime(time: "current_week".tr),
    ValueTime(time: "current_month".tr),
    ValueTime(time: "last_month".tr),
  ];
  Rx<ValueTime?> selectedTime = Rx<ValueTime?>(null);
  RxBool areUsersLoading = false.obs;
  RxBool areDailyReportsLoading = false.obs;
  RxList<DailyReport?> dailyReports = <DailyReport>[].obs;

  @override
  void onInit() {
    getProfilePhoto();
    getEmployees();
    initializeSelectedTime();
    getDailyReports();

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

  void initializeSelectedTime() {
    selectedTime.value = times.first;
  }

  void getProfilePhoto() {
    profilePhoto =
        (PreferenceManager.getPref(PreferenceManager.prefUserProfilePhoto)
                as String?) ??
            '';
  }

  Future<void> getEmployees() async {
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
      'search%5Bvalue%5D': '',
      'search%5Bregex%5D': 'false'
    };

    areUsersLoading.value = true;
    try {
      var response = await GetRequests.getEmployees(requestBody);
      if (response != null) {
        if (response.data != null) {
          users.assignAll(response.data!.toList());
          users.insert(0, EmployeeModel(name: "select_user".tr));
          selectedUser.value = users[0];
        }
      } else {
        Get.snackbar("error".tr, "message_server_error".tr);
      }
    } finally {
      areUsersLoading.value = false;
    }
  }

  void onChangeService(var newUser) {
    selectedUser.value = newUser as EmployeeModel;
  }

  void onChangeTime(var newTime) {
    selectedTime.value = newTime as ValueTime;
  }

  String truncateDropdownSelectedValue(String text) {
    if (text == "select_user".tr || text == "value_time".tr) {
      return text;
    }
    if (text.length > 5) {
      return '${text.substring(0, 5)}...';
    }
    return text;
  }

  Future<void> getDailyReports() async {
    dailyReports.value = <DailyReport>[];
    Map<String, String> requestBody = {
      'order%5B0%5D%5Bcolumn%5D': '0',
      'order%5B0%5D%5Bdir%5D': 'DESC',
      'start': '0',
      'length': '-1',
      'search%5Bvalue%5D': '',
      'search%5Bregex%5D': 'false'
    };

    if (selectedUser.value != null &&
        selectedUser.value!.name != "select_user".tr) {
      requestBody.addIf(
          selectedUser.value != null &&
              selectedUser.value!.name != "select_user".tr,
          'user',
          users
              .firstWhere(
                  (user) => user != null && user.id == selectedUser.value!.id)!
              .id
              .toString());
    }

    if (selectedTime.value != null &&
        selectedTime.value!.time != "value_time".tr) {
      if (selectedTime.value!.time == "today".tr) {
        requestBody.addIf(selectedTime.value!.time == "today".tr, 'date',
            DateFormat('y-M-d').format(DateTime.now()));
      }

      if (selectedTime.value!.time == "yesterday".tr) {
        requestBody.addIf(
            selectedTime.value!.time == "yesterday".tr,
            'date',
            DateFormat('y-M-d')
                .format(DateTime.now().subtract(Duration(days: 1))));
      }

      if (selectedTime.value!.time == "current_week".tr) {
        requestBody.addIf(selectedTime.value!.time == "current_week".tr,
            '_begin', DateFormat('y-M-d').format(Helpers.getLastSundayDate()));
        requestBody.addIf(selectedTime.value!.time == "current_week".tr, '_end',
            DateFormat('y-M-d').format(Helpers.getNextSaturday()));
      }

      if (selectedTime.value!.time == "current_month".tr) {
        requestBody.addIf(
            selectedTime.value!.time == "current_month".tr,
            '_begin',
            DateFormat('y-M-d').format(Helpers.getFirstDayOfCurrentMonth()));
        requestBody.addIf(
            selectedTime.value!.time == "current_month".tr,
            '_end',
            DateFormat('y-M-d').format(Helpers.getLastDayOfCurrentMonth()));
      }

      if (selectedTime.value!.time == "last_month".tr) {
        requestBody.addIf(selectedTime.value!.time == "last_month".tr, '_begin',
            DateFormat('y-M-d').format(Helpers.getFirstDayOfLastMonth()));
        requestBody.addIf(selectedTime.value!.time == "last_month".tr, '_end',
            DateFormat('y-M-d').format(Helpers.getLastDayOfLastMonth()));
      }
    }

    areDailyReportsLoading.value = true;
    try {
      var response = await GetRequests.getDailyReports(requestBody);
      if (response != null) {
        if (response.data != null) {
          dailyReports.assignAll(response.data as Iterable<DailyReport?>);
        }
      } else {
        Get.snackbar("error".tr, "message_server_error".tr);
      }
    } finally {
      areDailyReportsLoading.value = false;
    }
  }

  void handleDailyReportOnTap(int dailyReportIndex) {
    Get.toNamed(AppRoutes.routeEmployeeDailyReports, arguments: {
      AppConsts.keyEmployeeId: dailyReports[dailyReportIndex]?.userId,
      AppConsts.keyEmployeeProfilePhoto:
          dailyReports[dailyReportIndex]?.profile,
      AppConsts.keyEmployeeName: dailyReports[dailyReportIndex]?.name,
      AppConsts.keyDailyReportDate: dailyReports[dailyReportIndex]?.createdAt,
    });
  }
}
