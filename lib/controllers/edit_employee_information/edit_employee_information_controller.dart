import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teqtop_team/controllers/employee_detail/employee_detail_controller.dart';

import '../../model/employees_listing/employee_model.dart';
import '../../network/put_requests.dart';

class EditEmployeeInformationController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey();
  late TextEditingController roleController;
  late TextEditingController contactNoController;
  late TextEditingController positionController;
  late TextEditingController DOBController;
  late TextEditingController employeeIDController;
  DateTime? selectedDOB;
  RxBool isLoading = false.obs;
  int? userId;
  String? userEmail;
  EmployeeModel? employeeDetail;

  @override
  void onInit() {
    initializeTextEditingControllers();
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
    super.onClose();
  }

  void initializeTextEditingControllers() {
    roleController = TextEditingController();
    contactNoController = TextEditingController();
    positionController = TextEditingController();
    DOBController = TextEditingController();
    employeeIDController = TextEditingController();

    getLoggedInUserData();
  }

  void getLoggedInUserData() {
    final employeeDetailController = Get.find<EmployeeDetailController>();
    employeeDetail = employeeDetailController.employeeDetail.value;
    if (employeeDetail != null) {
      contactNoController.text =
          employeeDetail!.contactNo is String ? employeeDetail!.contactNo : "";
      selectedDOB = employeeDetail!.birthDate is String
          ? DateTime.parse(employeeDetail!.birthDate)
          : null;
      DOBController.text = selectedDOB == null
          ? ""
          : DateFormat("dd/MM/yyyy").format(selectedDOB!);
      roleController.text = employeeDetail!.roles ?? "";
      positionController.text = employeeDetail!.userPosition is String
          ? employeeDetail!.userPosition
          : "";
      employeeIDController.text = employeeDetail!.employeeId ?? "";
    }
  }

  void disposeTextEditingControllers() {
    contactNoController.dispose();
    DOBController.dispose();
    roleController.dispose();
    positionController.dispose();
    employeeIDController.dispose();
  }

  Future<void> saveInfo() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState!.validate() &&
        employeeDetail != null &&
        employeeDetail!.userId != null) {
      Map<String, dynamic> requestBody = {
        'contact_no': contactNoController.text,
        'birth_date': selectedDOB != null
            ? DateFormat('yyyy-MM-dd').format(selectedDOB!)
            : '',
        'role': roleController.text,
        'employee_id': employeeIDController.text,
        'name': employeeDetail!.name,
        'email': employeeDetail!.email,
        'position': employeeDetail!.position
      };

      isLoading.value = true;
      try {
        var response = await PutRequests.editEmployeeInfo(
            requestBody, employeeDetail!.userId!);
        if (response != null) {
          if (response.status == "success") {
            final employeeDetailController =
                Get.find<EmployeeDetailController>();
            employeeDetailController.getEmployeeDetails();
            Get.back();
          } else {
            Get.snackbar("error".tr, "message_server_error".tr);
          }
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } finally {
        // isLoading.value = false;
      }
    }
  }

  Future<void> handleDOBFieldOnTap(dynamic context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    selectedDOB = await showDatePicker(
      initialDate: selectedDOB,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
      context: context,
    );
    if (selectedDOB != null) {
      DOBController.text = DateFormat("dd/MM/yyyy").format(selectedDOB!);
    }
  }
}
