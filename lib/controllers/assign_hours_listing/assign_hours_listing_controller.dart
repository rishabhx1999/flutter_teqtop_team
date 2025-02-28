import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teqtop_team/config/app_routes.dart';
import 'package:teqtop_team/model/assign_hours_listing/assign_hours.dart';
import 'package:teqtop_team/model/global_search/project_model.dart';
import '../../consts/app_consts.dart';
import '../../model/daily_reports_listing/value_time.dart';
import '../../model/employees_listing/employee_model.dart';
import '../../network/get_requests.dart';
import '../../utils/helpers.dart';
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
  Rx<EmployeeModel?> selectedUser = Rx<EmployeeModel?>(null);
  RxList<EmployeeModel?> users = <EmployeeModel>[].obs;
  RxBool areUsersLoading = false.obs;
  RxBool areAssignHoursLoading = false.obs;
  RxBool areProjectsLoading = false.obs;
  Rx<ValueTime?> selectedTime = Rx<ValueTime?>(null);
  List<ValueTime> times = [
    ValueTime(time: "value_time".tr),
    ValueTime(time: "yesterday".tr),
    ValueTime(time: "today".tr),
    ValueTime(time: "current_week".tr),
    ValueTime(time: "current_month".tr),
    ValueTime(time: "last_month".tr),
    ValueTime(time: "select_date".tr),
  ];
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  Rx<ProjectModel?> selectedProject = Rx<ProjectModel?>(null);
  RxList<ProjectModel?> projects = <ProjectModel>[].obs;
  bool filterData = false;
  RxList<AssignHours?> assignHoursList = <AssignHours>[].obs;

  @override
  void onInit() {
    getProfilePhoto();
    getEmployees();
    initializeTextEditingControllers();
    setupSearchTextChangeListener();
    getNotificationsCount();
    initializeSelectedTime();
    getProjects();
    getAssignHours();

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
    disposeTextEditingControllers();

    super.onClose();
  }

  void initializeSelectedTime() {
    selectedTime.value = times.first;
  }

  Future<void> getProjects() async {
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

    areProjectsLoading.value = true;
    try {
      var response = await GetRequests.getProjects(requestBody);
      if (response != null) {
        if (response.data != null) {
          response.data!.removeWhere((element) =>
              element != null &&
              element.trash != null &&
              element.trash!.toLowerCase().contains("trash"));

          projects.assignAll(response.data!.toList());
          projects.insert(0, ProjectModel(name: "select_project".tr));
          selectedProject.value = projects[0];
        }
      } else {
        Get.snackbar("error".tr, "message_server_error".tr);
      }
    } finally {
      areProjectsLoading.value = false;
    }
  }

  void onChangeTime(var newTime) {
    selectedTime.value = newTime as ValueTime;
  }

  void onChangeProject(var newProject) {
    selectedProject.value = newProject as ProjectModel;
  }

  Future<void> handleStartDateFieldOnTap(dynamic context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    selectedStartDate = await showDatePicker(
      initialDate: selectedStartDate,
      firstDate: DateTime(2013),
      lastDate: selectedEndDate ?? DateTime.now(),
      context: context,
    );
    if (selectedStartDate != null) {
      startDateController.text =
          DateFormat('yyyy-MM-dd').format(selectedStartDate!);
    }
  }

  Future<void> handleEndDateFieldOnTap(dynamic context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    selectedEndDate = await showDatePicker(
      initialDate: selectedEndDate,
      firstDate: selectedStartDate ?? DateTime(2013),
      lastDate: DateTime.now(),
      context: context,
    );
    if (selectedEndDate != null) {
      endDateController.text =
          DateFormat('yyyy-MM-dd').format(selectedEndDate!);
    }
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

  void initializeTextEditingControllers() {
    searchTextController = TextEditingController();
    startDateController = TextEditingController();
    endDateController = TextEditingController();
  }

  void onChangeUser(var newUser) {
    selectedUser.value = newUser as EmployeeModel;
  }

  void disposeTextEditingControllers() {
    searchTextController.dispose();
    startDateController.dispose();
    endDateController.dispose();
  }

  void handleSearchTextChange(String text) {
    showSearchFieldTrailing.value = text.isNotEmpty;
  }

  void handleClearSearchField() {
    searchTextController.clear();
    showSearchFieldTrailing.value = false;
  }

  void getNotificationsCount() {
    final dashboardController = Get.find<DashboardController>();
    notificationsCount = dashboardController.notificationsCount;
  }

  void handleAssignHourOnTap(int assignHourIndex) {
    Get.toNamed(AppRoutes.routeEmployeeAssignedProjectsHours, arguments: {
      AppConsts.keyEmployeeId: assignHoursList[assignHourIndex]?.userId,
      AppConsts.keyEmployeeProfilePhoto:
          assignHoursList[assignHourIndex]?.userProfile,
      AppConsts.keyEmployeeName: assignHoursList[assignHourIndex]?.userName,
      AppConsts.keyEmployeeAssignedProjectsHours:
          assignHoursList[assignHourIndex]?.projects,
      AppConsts.keyEmployeeAssignedProjectsHoursId:
          assignHoursList[assignHourIndex]?.id,
      AppConsts.keyCreatedDateTime: assignHoursList[assignHourIndex]?.addedDate,
      AppConsts.keyModifiedDateTime:
          assignHoursList[assignHourIndex]?.updatededDate,
    });
  }

  Future<void> getAssignHours() async {
    areAssignHoursLoading.value = true;
    try {
      Map<String, String> requestBody = {
        'order%5B0%5D%5Bcolumn%5D': '0',
        'order%5B0%5D%5Bdir%5D': 'DESC',
        'start': '0',
        'length': '-1',
        'search%5Bvalue%5D': searchText.value,
        'search%5Bregex%5D': 'false'
      };

      if (filterData) {
        if (selectedUser.value != null &&
            selectedUser.value!.name != "select_user".tr) {
          var user = users.firstWhereOrNull(
              (user) => user != null && user.id == selectedUser.value!.id);
          if (user != null) {
            requestBody.addIf(true, 'user', user.id.toString());
          }
        }

        if (selectedProject.value != null &&
            selectedProject.value!.name != "select_project".tr) {
          var project = projects.firstWhereOrNull((project) =>
              project != null && project.id == selectedProject.value!.id);
          if (project != null) {
            requestBody.addIf(true, 'project', project.id.toString());
          }
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
            requestBody.addIf(
                selectedTime.value!.time == "current_week".tr,
                '_begin',
                DateFormat('y-M-d').format(Helpers.getLastSundayDate()));
            requestBody.addIf(selectedTime.value!.time == "current_week".tr,
                '_end', DateFormat('y-M-d').format(Helpers.getNextSaturday()));
          }

          if (selectedTime.value!.time == "current_month".tr) {
            requestBody.addIf(
                selectedTime.value!.time == "current_month".tr,
                '_begin',
                DateFormat('y-M-d')
                    .format(Helpers.getFirstDayOfCurrentMonth()));
            requestBody.addIf(
                selectedTime.value!.time == "current_month".tr,
                '_end',
                DateFormat('y-M-d').format(Helpers.getLastDayOfCurrentMonth()));
          }

          if (selectedTime.value!.time == "last_month".tr) {
            requestBody.addIf(
                selectedTime.value!.time == "last_month".tr,
                '_begin',
                DateFormat('y-M-d').format(Helpers.getFirstDayOfLastMonth()));
            requestBody.addIf(
                selectedTime.value!.time == "last_month".tr,
                '_end',
                DateFormat('y-M-d').format(Helpers.getLastDayOfLastMonth()));
          }

          if (selectedTime.value!.time == "select_date".tr &&
              selectedStartDate != null &&
              selectedEndDate != null) {
            requestBody.addIf(selectedTime.value!.time == "select_date".tr,
                '_begin', DateFormat('y-M-d').format(selectedStartDate!));
            requestBody.addIf(selectedTime.value!.time == "select_date".tr,
                '_end', DateFormat('y-M-d').format(selectedEndDate!));
          }
        }
      }
      var response = await GetRequests.getAssignHoursList(requestBody);
      if (response != null) {
        if (response.data != null) {
          assignHoursList.assignAll(response.data as Iterable<AssignHours?>);
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } else {
        Get.snackbar("error".tr, "message_server_error".tr);
      }
    } finally {
      areAssignHoursLoading.value = false;
    }
  }

  void resetFilters() {
    filterData = false;
    selectedProject.value = projects[0];
    selectedUser.value = users[0];
    selectedTime.value = times.first;
    selectedStartDate = null;
    startDateController.clear();
    selectedEndDate = null;
    endDateController.clear();
  }
}
