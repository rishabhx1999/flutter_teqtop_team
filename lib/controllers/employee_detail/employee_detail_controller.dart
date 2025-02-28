import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teqtop_team/model/employee_detail/leave_model.dart';
import 'package:teqtop_team/model/employees_listing/employee_model.dart';
import 'package:teqtop_team/utils/helpers.dart';

import '../../consts/app_consts.dart';
import '../../network/get_requests.dart';
import '../../utils/employee_doc_type.dart';

class EmployeeDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final TabController tabController;
  late final ScrollController scrollController;
  late final int? employeeId;
  late final int? id;
  RxBool isEmployeeDetailLoading = false.obs;
  Rx<EmployeeModel?> employeeDetail = Rx<EmployeeModel?>(null);
  List<LeaveModel?> leaves = <LeaveModel?>[];
  RxBool areEmployeeLeavesLoading = false.obs;
  Rx<Map<String, List<LeaveModel>>?> filteredLeaves =
      Rx<Map<String, List<LeaveModel>>?>(null);
  List<String> aadharCardDocs = [];
  List<String> panCardDocs = [];
  List<String> officialDocs = [];
  List<String> qualificationAndExperienceDocs = [];

  @override
  void onInit() {
    initializeTabController();
    initializeScrollController();
    getIds();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    disposeTabController();
    disposeScrollController();

    super.onClose();
  }

  void getIds() {
    Map? data = Get.arguments;
    if (data != null && data.isNotEmpty) {
      if (data.containsKey(AppConsts.keyEmployeeId)) {
        employeeId = data[AppConsts.keyEmployeeId];
      }
      if (data.containsKey(AppConsts.keyId)) {
        id = data[AppConsts.keyId];
      }
    }
    getEmployeeDetails();
    getEmployeeLeaves();
  }

  Future<void> getEmployeeDetails() async {
    if (id != null) {
      isEmployeeDetailLoading.value = true;
      try {
        var response = await GetRequests.getEmployeeDetails(id!);
        if (response != null) {
          employeeDetail.value = response;
          await extractEmployeeDocuments();
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } finally {
        isEmployeeDetailLoading.value = false;
      }
    }
  }

  void openFile(EmployeeDocType docType, int index) {
    if (docType == EmployeeDocType.aadhaarCard) {
      Helpers.openFile(
          path: aadharCardDocs[index],
          fileName: aadharCardDocs[index].split("/").last);
    }
    if (docType == EmployeeDocType.panCard) {
      Helpers.openFile(
          path: panCardDocs[index],
          fileName: panCardDocs[index].split("/").last);
    }
    if (docType == EmployeeDocType.officialDoc) {
      Helpers.openFile(
          path: officialDocs[index],
          fileName: officialDocs[index].split("/").last);
    }
    if (docType == EmployeeDocType.qualificationOrExperienceDoc) {
      Helpers.openFile(
          path: qualificationAndExperienceDocs[index],
          fileName: qualificationAndExperienceDocs[index].split("/").last);
    }
  }

  Future<void> extractEmployeeDocuments() async {
    // Helpers.printLog(
    //     description: "EMPLOYEE_DETAIL_CONTROLLER_EXTRACT_EMPLOYEE_DOCUMENTS",
    //     message:
    //         "OTHER_DOCS = ${Helpers.extractFilesURLs(employeeDetail.value!.otherDocs ?? "")}");
    aadharCardDocs =
        Helpers.extractFilesURLs(employeeDetail.value!.adharCard ?? "");
    panCardDocs = Helpers.extractFilesURLs(employeeDetail.value!.panCard ?? "");
    officialDocs =
        Helpers.extractFilesURLs(employeeDetail.value!.officialDocs ?? "");
    qualificationAndExperienceDocs =
        Helpers.extractFilesURLs(employeeDetail.value!.otherDocs ?? "");
  }

  void initializeTabController() {
    tabController = TabController(length: 3, vsync: this);
  }

  void disposeTabController() {
    tabController.dispose();
  }

  void initializeScrollController() {
    scrollController = ScrollController();
  }

  void disposeScrollController() {
    scrollController.dispose();
  }

  Future<void> getEmployeeLeaves() async {
    if (employeeId != null) {
      Map<String, String> requestBody = {
        'users': employeeId.toString(),
        'order%5B0%5D%5Bcolumn%5D': '0',
        'order%5B0%5D%5Bdir%5D': 'DESC',
        'start': '0',
        'length': '-1',
        'search%5Bvalue%5D': '',
        'search%5Bregex%5D': 'false'
      };

      areEmployeeLeavesLoading.value = true;
      try {
        var response = await GetRequests.getLeaves(requestBody);
        if (response != null) {
          if (response.data != null) {
            leaves.assignAll(response.data as Iterable<LeaveModel?>);
            groupLeavesByMonth();
          }
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } finally {
        areEmployeeLeavesLoading.value = false;
      }
    }
  }

  void groupLeavesByMonth() {
    List<LeaveModel> validLeaves = leaves
        .where((leave) => leave != null && leave.from != null)
        .map((leave) => leave!)
        .toList();

    Map<String, List<LeaveModel>> groupedLeaves = {};
    for (var leave in validLeaves) {
      String monthKey = DateFormat('MMMM yyyy').format(leave.from!);
      if (!groupedLeaves.containsKey(monthKey)) {
        groupedLeaves[monthKey] = [];
      }
      groupedLeaves[monthKey]!.add(leave);
    }

    groupedLeaves.removeWhere((key, value) => value.isEmpty);

    final sortedEntries = groupedLeaves.entries.toList()
      ..sort((a, b) => DateFormat('MMMM yyyy')
          .parse(b.key)
          .compareTo(DateFormat('MMMM yyyy').parse(a.key)));

    filteredLeaves.value = Map.fromEntries(sortedEntries);
  }
}
