import 'package:get/get.dart';
import 'package:teqtop_team/config/app_routes.dart';
import 'package:teqtop_team/controllers/assign_hours_listing/assign_hours_listing_controller.dart';
import 'package:teqtop_team/model/employee_assigned_projects_hours/person_projects_assign_hours.dart';
import 'package:html/parser.dart' as html;
import 'package:html/dom.dart';
import 'package:teqtop_team/utils/helpers.dart';

import '../../consts/app_consts.dart';
import '../../network/get_requests.dart';
import '../../network/post_requests.dart';
import '../../views/dialogs/common/common_alert_dialog.dart';
import '../dashboard/dashboard_controller.dart';

class EmployeeAssignedProjectsHoursController extends GetxController {
  late final int? employeeId;
  late final String? employeeProfilePhoto;
  late final String? employeeName;
  late final DateTime? createdDateTime;
  late final int? employeeAssignedProjectsHoursId;
  String? employeeAssignedProjectsHoursString;
  Rx<DateTime?> modifiedDateTime = Rx<DateTime?>(null);
  RxList<PersonProjectsAssignHours> employeeAssignedProjectsHours =
      <PersonProjectsAssignHours>[].obs;
  RxInt notificationsCount = 0.obs;
  RxBool isDeleteLoading = false.obs;

  @override
  void onInit() {
    getEmployeeDetails();
    getNotificationsCount();

    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  void getNotificationsCount() {
    final dashboardController = Get.find<DashboardController>();
    notificationsCount = dashboardController.notificationsCount;
  }

  void getEmployeeDetails() {
    Map? data = Get.arguments;
    if (data != null && data.isNotEmpty) {
      if (data.containsKey(AppConsts.keyEmployeeAssignedProjectsHoursId)) {
        employeeAssignedProjectsHoursId =
            data[AppConsts.keyEmployeeAssignedProjectsHoursId];
      }
      if (data.containsKey(AppConsts.keyEmployeeId)) {
        employeeId = data[AppConsts.keyEmployeeId];
      }
      if (data.containsKey(AppConsts.keyEmployeeProfilePhoto)) {
        employeeProfilePhoto = data[AppConsts.keyEmployeeProfilePhoto];
      }
      if (data.containsKey(AppConsts.keyEmployeeName)) {
        employeeName = data[AppConsts.keyEmployeeName];
      }
      if (data.containsKey(AppConsts.keyEmployeeAssignedProjectsHours)) {
        employeeAssignedProjectsHoursString =
            data[AppConsts.keyEmployeeAssignedProjectsHours];
      }
      if (data.containsKey(AppConsts.keyCreatedDateTime)) {
        createdDateTime = data[AppConsts.keyCreatedDateTime];
      }
      if (data.containsKey(AppConsts.keyModifiedDateTime)) {
        modifiedDateTime.value = data[AppConsts.keyModifiedDateTime];
      }
      convertHTMLTableToEmployeeAssignedProjectsHoursList();
    }
  }

  void convertHTMLTableToEmployeeAssignedProjectsHoursList() {
    if (employeeAssignedProjectsHoursString != null &&
        employeeAssignedProjectsHoursString!.isNotEmpty) {
      Document document = html.parse(employeeAssignedProjectsHoursString);
      List<PersonProjectsAssignHours> projectList = [];

      var rows = document.querySelectorAll('table tbody tr');

      for (var row in rows) {
        if (row.classes.contains('trashed-row')) continue;

        var cells = row.querySelectorAll('td');
        if (cells.length < 7) continue;

        String projectName = cells[1].text.trim().replaceAll('&quot;', '"');
        int projectId = int.tryParse(cells[2].text.trim()) ?? 0;
        double assignedHours = double.tryParse(cells[3].text.trim()) ?? 0.0;
        double totalHours = double.tryParse(cells[4].text.trim()) ?? 0.0;
        double weeklyHours = double.tryParse(cells[5].text.trim()) ?? 0.0;

        Element? checkbox = cells[6].querySelector('input[type="checkbox"]');
        bool isPaused = checkbox?.attributes.containsKey('checked') ?? false;
        int id = int.tryParse(checkbox?.attributes['data-hour'] ?? '0') ?? 0;

        projectList.add(PersonProjectsAssignHours(
          id: id,
          projectId: projectId,
          projectName: projectName,
          assignedHours: assignedHours,
          totalHours: totalHours,
          weeklyHours: weeklyHours,
          isPaused: isPaused.obs,
        ));
      }
      employeeAssignedProjectsHours.assignAll(projectList);
    }
  }

  Future<void> playPauseProject(bool value, int? id) async {
    // Helpers.printLog(
    //     description:
    //         "EMPLOYEE_ASSIGNED_PROJECTS_HOURS_CONTROLLER_PLAY_PAUSE_PROJECT",
    //     message: "ID = $id");
    if (id == null) return;
    var project = employeeAssignedProjectsHours
        .firstWhereOrNull((project) => project.id == id);
    if (project == null) return;
    project.isPaused.value = value;

    Map<String, dynamic> requestBody = {
      'hour': id,
      'value': value ? '1' : '0',
    };
    var response = await PostRequests.playPauseProject(requestBody);
    if (response != null) {
      if (response.status == "success") {
        refreshPreviousPageData();
      } else {
        project.isPaused.value = !value;
        Get.snackbar("error".tr, "message_server_error".tr);
      }
    } else {
      project.isPaused.value = !value;
      Get.snackbar("error".tr, "message_server_error".tr);
    }
  }

  void onDeleteTap() {
    CommonAlertDialog.showDialog(
      message: "message_delete_confirmation",
      positiveText: "yes",
      positiveBtnCallback: () async {
        Get.back();
        deleteEmployeeAssignedProjectsHours();
      },
      isShowNegativeBtn: true,
      negativeText: 'no',
    );
  }

  Future<void> deleteEmployeeAssignedProjectsHours() async {
    if (employeeAssignedProjectsHoursId != null) {
      isDeleteLoading.value = true;
      try {
        var response = await GetRequests.deleteEmployeeAssignedProjectsHours(
            employeeAssignedProjectsHoursId!);
        if (response != null) {
          if (response.status == "success") {
            refreshPreviousPageData();
            Get.back();
          } else {
            Get.snackbar("error".tr, "message_server_error".tr);
          }
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } finally {
        isDeleteLoading.value = false;
      }
    }
  }

  void onEditTap() {
    Get.toNamed(AppRoutes.routeCreateEditEmployeeAssignedProjectsHours);
  }

  void refreshPreviousPageData() {
    AssignHoursListingController? assignHoursListingController;
    try {
      assignHoursListingController = Get.find<AssignHoursListingController>();
    } catch (e) {
      // Helpers.printLog(
      //     description:
      //         "EMPLOYEE_ASSIGNED_PROJECTS_HOURS_CONTROLLER_REFRESH_PREVIOUS_PAGE_DATA",
      //     message:
      //         "COULDN'T_FIND_ASSIGN_HOURS_LISTING_CONTROLLER = ${e.toString()}");
    }
    if (assignHoursListingController != null) {
      assignHoursListingController.getAssignHours();
    }
  }
}
