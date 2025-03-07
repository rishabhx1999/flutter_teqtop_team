import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/config/app_routes.dart';
import 'package:teqtop_team/controllers/assign_hours_listing/assign_hours_listing_controller.dart';
import 'package:teqtop_team/controllers/employee_assigned_projects_hours/employee_assigned_projects_hours_controller.dart';
import 'package:teqtop_team/model/employee_assigned_projects_hours/person_projects_assign_hours.dart';
import 'package:teqtop_team/network/post_requests.dart';

import '../../model/assign_hours_listing/assign_hours.dart';
import '../../model/employees_listing/employee_model.dart';
import '../../model/global_search/project_model.dart';
import '../../network/get_requests.dart';
import '../../network/put_requests.dart';
import '../../utils/preference_manager.dart';
import '../dashboard/dashboard_controller.dart';

class CreateEditEmployeeAssignedProjectsHoursController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey();
  int? employeeId;
  String? employeeProfilePhoto;
  String? employeeName;
  int? employeeAssignedProjectsHoursId;
  String? previousRoute;
  late TextEditingController projectSearchTextController;
  late Worker projectSearchTextChangeListenerWorker;
  RxList<PersonProjectsAssignHours> employeeAssignedProjectsHours =
      <PersonProjectsAssignHours>[].obs;
  RxList<EmployeeModel?> users = <EmployeeModel>[].obs;
  RxInt notificationsCount = 0.obs;
  RxBool showProjectSearchFieldTrailing = false.obs;
  RxString projectSearchText = ''.obs;
  RxList<ProjectModel?> projects = <ProjectModel>[].obs;
  RxBool areProjectsLoading = false.obs;
  List<int> removeEmployeeAssignedProjectsHours = [];
  RxBool isCreateUpdateLoading = false.obs;
  RxBool areUsersLoading = false.obs;
  RxBool showSelectUserMessage = false.obs;
  bool fromAssignHoursListing = false;
  Rx<EmployeeModel?> selectedUser = Rx<EmployeeModel?>(null);

  @override
  void onInit() {
    getPreviousRoute();
    getNotificationsCount();
    initializeProjectSearchTextController();
    setupProjectSearchTextChangeListener();

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
    disposeProjectSearchTextChangeListenerWorker();
    super.onClose();
  }

  void onChangeUser(var newUser) {
    selectedUser.value = newUser as EmployeeModel;
  }

  Future<void> getEmployees() async {
    if (fromAssignHoursListing) {
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
  }

  void getPreviousRoute() {
    previousRoute = Get.previousRoute;
    if (previousRoute == AppRoutes.routeAssignHoursListing) {
      fromAssignHoursListing = true;
    }
    getData();
    getEmployees();
  }

  void setupProjectSearchTextChangeListener() {
    projectSearchTextChangeListenerWorker =
        debounce(projectSearchText, (callback) => getProjects());

    projectSearchTextController.addListener(() {
      projectSearchText.value =
          projectSearchTextController.text.toString().trim();
    });
  }

  void addRemoveProject(int? projectId) {
    if (projectId == null) return;
    var project = projects.firstWhereOrNull(
        (project) => project != null && project.id == projectId);
    if (project == null) return;
    if (project.multiUse.value) {
      var employeeAssignedProject = employeeAssignedProjectsHours
          .firstWhereOrNull((employeeAssignedProject) =>
              employeeAssignedProject.projectId != null &&
              employeeAssignedProject.projectId == project.id);
      if (employeeAssignedProject != null) {
        if (employeeAssignedProject.assignHoursEditingController != null) {
          employeeAssignedProject.assignHoursEditingController!.dispose();
          employeeAssignedProject.assignHoursEditingController = null;
        }
        if (employeeAssignedProject.id != null) {
          removeEmployeeAssignedProjectsHours.add(employeeAssignedProject.id!);
        }
        employeeAssignedProjectsHours.remove(employeeAssignedProject);
      }
    } else {
      var newItem = PersonProjectsAssignHours(
        isPaused: false.obs,
        projectId: project.id,
        projectName: project.name,
      );
      newItem.assignHoursEditingController = TextEditingController();
      employeeAssignedProjectsHours.add(newItem);
    }
    project.multiUse.value = !project.multiUse.value;
    projects.refresh();
    employeeAssignedProjectsHours.refresh();
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
      'search%5Bvalue%5D': projectSearchText.value,
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
          for (var employeeAssignedProject in employeeAssignedProjectsHours) {
            var project = response.data!.firstWhereOrNull((project) =>
                project != null &&
                project.id != null &&
                project.id == employeeAssignedProject.projectId);
            if (project != null) {
              project.multiUse.value = true;
            }
          }
          projects.assignAll(response.data!.toList());
        }
      } else {
        Get.snackbar("error".tr, "message_server_error".tr);
      }
    } finally {
      areProjectsLoading.value = false;
    }
  }

  void disposeProjectSearchTextChangeListenerWorker() {
    projectSearchTextChangeListenerWorker.dispose();
  }

  void initializeProjectSearchTextController() {
    projectSearchTextController = TextEditingController();
  }

  void getNotificationsCount() {
    final dashboardController = Get.find<DashboardController>();
    notificationsCount = dashboardController.notificationsCount;
  }

  void disposeTextEditingControllers() {
    projectSearchTextController.dispose();
    for (var project in employeeAssignedProjectsHours) {
      if (project.assignHoursEditingController != null) {
        project.assignHoursEditingController!.dispose();
        project.assignHoursEditingController = null;
      }
    }
  }

  void handleClearProjectSearchField() {
    projectSearchTextController.clear();
    showProjectSearchFieldTrailing.value = false;
  }

  void handleProjectSearchTextChange(String text) {
    showProjectSearchFieldTrailing.value = text.isNotEmpty;
  }

  void getData() {
    if (previousRoute == AppRoutes.routeEmployeeAssignedProjectsHours) {
      final employeeAssignedProjectsHoursController =
          Get.find<EmployeeAssignedProjectsHoursController>();
      employeeId = employeeAssignedProjectsHoursController.employeeId;
      employeeProfilePhoto =
          employeeAssignedProjectsHoursController.employeeProfilePhoto;
      employeeName = employeeAssignedProjectsHoursController.employeeName;
      employeeAssignedProjectsHoursId = employeeAssignedProjectsHoursController
          .employeeAssignedProjectsHoursId;
      employeeAssignedProjectsHours.assignAll(
        employeeAssignedProjectsHoursController.employeeAssignedProjectsHours
            .map((project) => PersonProjectsAssignHours(
                  id: project.id,
                  projectId: project.projectId,
                  projectName: project.projectName,
                  assignedHours: project.assignedHours,
                  weeklyHours: project.weeklyHours,
                  totalHours: project.totalHours,
                  isPaused: project.isPaused.value.obs,
                ))
            .toList(),
      );
      for (var project in employeeAssignedProjectsHours) {
        project.assignHoursEditingController = TextEditingController();
        project.assignHoursEditingController!.text =
            project.assignedHours.toString();
      }
    }
  }

  Future<void> refreshPreviousPageData() async {
    AssignHours? assignHours;
    AssignHoursListingController? assignHoursListingController;
    try {
      assignHoursListingController = Get.find<AssignHoursListingController>();
    } catch (e) {
      // Helpers.printLog(
      //     description:
      //         "EDIT_EMPLOYEE_ASSIGNED_PROJECTS_HOURS_CONTROLLER_REFRESH_PREVIOUS_PAGE_DATA",
      //     message:
      //         "COULDN'T_FIND_ASSIGN_HOURS_LISTING_CONTROLLER = ${e.toString()}");
    }
    if (assignHoursListingController != null) {
      await assignHoursListingController.getAssignHours();
      assignHours = assignHoursListingController.assignHoursList
          .firstWhereOrNull((item) =>
              item != null &&
              item.id != null &&
              item.id == employeeAssignedProjectsHoursId);
    }

    EmployeeAssignedProjectsHoursController?
        employeeAssignedProjectsHoursController;
    try {
      employeeAssignedProjectsHoursController =
          Get.find<EmployeeAssignedProjectsHoursController>();
    } catch (e) {
      // Helpers.printLog(
      //     description:
      //         "EDIT_EMPLOYEE_ASSIGNED_PROJECTS_HOURS_CONTROLLER_REFRESH_PREVIOUS_PAGE_DATA",
      //     message:
      //         "COULDN'T_FIND_EMPLOYEE_ASSIGNED_PROJECTS_HOURS_CONTROLLER = ${e.toString()}");
    }
    if (employeeAssignedProjectsHoursController != null &&
        assignHours != null) {
      employeeAssignedProjectsHoursController
          .employeeAssignedProjectsHoursString = assignHours.projects;
      employeeAssignedProjectsHoursController.modifiedDateTime.value =
          assignHours.updatededDate;
      employeeAssignedProjectsHoursController
          .convertHTMLTableToEmployeeAssignedProjectsHoursList();
    }
  }

  Future<void> playPauseProject(
      bool value, int employeeAssignedProjectIndex) async {
    employeeAssignedProjectsHours[employeeAssignedProjectIndex].isPaused.value =
        value;
  }

  Future<void> updateData() async {
    FocusManager.instance.primaryFocus?.unfocus();
    var json = convertEmployeeAssignedProjectsHoursToEditString();
    if (employeeAssignedProjectsHours.isEmpty) {
      Get.snackbar("error".tr, "message_assign_project".tr);
    }
    if (formKey.currentState!.validate() &&
        employeeAssignedProjectsHoursId != null &&
        json.isNotEmpty &&
        employeeAssignedProjectsHours.isNotEmpty) {
      isCreateUpdateLoading.value = true;
      try {
        Map<String, dynamic> requestBody = {
          'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
              as String?,
          'check': 'true',
          'details': json,
          'removed': removeEmployeeAssignedProjectsHours,
          '_method': '"PUT"',
        };
        var response = await PutRequests.editEmployeeAssignedProjectsHours(
            requestBody, employeeAssignedProjectsHoursId!);
        if (response != null) {
          if (response.status == "success") {
            await refreshPreviousPageData();
            Get.back();
          } else {
            Get.snackbar("error".tr, "message_server_error".tr);
          }
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } finally {
        isCreateUpdateLoading.value = false;
      }
    }
  }

  Future<void> createEmployeeAssignedProjectsHours() async {
    FocusManager.instance.primaryFocus?.unfocus();
    var json = convertEmployeeAssignedProjectsHoursToCreateString();
    if (employeeAssignedProjectsHours.isEmpty) {
      Get.snackbar("error".tr, "message_assign_project".tr);
    }
    if (selectedUser.value != null &&
        selectedUser.value!.name == "select_user".tr) {
      showSelectUserMessage.value = true;
    }
    if (formKey.currentState!.validate() &&
        json.isNotEmpty &&
        employeeAssignedProjectsHours.isNotEmpty &&
        selectedUser.value != null &&
        selectedUser.value!.name != "select_user".tr &&
        selectedUser.value!.id != null) {
      isCreateUpdateLoading.value = true;
      try {
        Map<String, dynamic> requestBody = {
          'project': json,
          'user': selectedUser.value!.id.toString()
        };
        var response =
            await PostRequests.createEmployeeAssignedProjectsHours(requestBody);
        if (response != null) {
          if (response.status == "success") {
            await refreshPreviousPageData();
            Get.back();
          } else {
            Get.snackbar("error".tr, "message_server_error".tr);
          }
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } finally {
        isCreateUpdateLoading.value = false;
      }
    }
  }

  String convertEmployeeAssignedProjectsHoursToEditString() {
    List<Map<String, dynamic>> jsonList = employeeAssignedProjectsHours
        .where((item) => item.projectId != null)
        .map((item) {
      return {
        "id": item.projectId,
        "hourId": item.id,
        "assignedHours": item.assignHoursEditingController?.text ?? "",
        "paused": item.isPaused.value ? "1" : "0",
        "timeout": "0"
      };
    }).toList();

    return jsonEncode(jsonList);
  }

  String convertEmployeeAssignedProjectsHoursToCreateString() {
    List<Map<String, dynamic>> jsonList = employeeAssignedProjectsHours
        .where((item) => item.projectId != null)
        .map((item) {
      return {
        "id": item.projectId,
        "assignedHours": item.assignHoursEditingController?.text ?? "",
      };
    }).toList();

    return jsonEncode(jsonList);
  }
}
