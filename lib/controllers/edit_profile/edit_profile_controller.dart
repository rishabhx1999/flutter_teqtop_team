import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:teqtop_team/controllers/profile_detail/profile_detail_controller.dart';
import 'package:teqtop_team/utils/helpers.dart';

import '../../network/post_requests.dart';
import '../../utils/permission_handler.dart';
import '../../utils/preference_manager.dart';
import '../dashboard/dashboard_controller.dart';

class EditProfileController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey();
  late TextEditingController nameController;
  late TextEditingController contactNoController;
  late TextEditingController alternateNoController;
  late TextEditingController DOBController;
  late TextEditingController currentAddressController;
  late TextEditingController additionalInfoController;
  late final String? profilePhoto;
  DateTime? selectedDOB;
  late ImagePicker _imagePicker;
  Rx<XFile?> selectedImage = Rx<XFile?>(null);
  RxInt notificationsCount = 0.obs;
  RxBool isLoading = false.obs;
  int? userId;
  String? userEmail;
  String? permanentAddress;

  @override
  void onInit() {
    initializeTextEditingControllers();
    initializeImagePicker();
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
    disposeTextEditingControllers();
    super.onClose();
  }

  void initializeTextEditingControllers() {
    nameController = TextEditingController();
    contactNoController = TextEditingController();
    alternateNoController = TextEditingController();
    DOBController = TextEditingController();
    currentAddressController = TextEditingController();
    additionalInfoController = TextEditingController();

    getLoggedInUserData();
  }

  void getLoggedInUserData() {
    userId = PreferenceManager.getPref(PreferenceManager.prefUserId) as int?;
    profilePhoto =
        PreferenceManager.getPref(PreferenceManager.prefUserProfilePhoto)
            as String?;
    nameController.text =
        (PreferenceManager.getPref(PreferenceManager.prefUserName)
                as String?) ??
            '';
    contactNoController.text =
        (PreferenceManager.getPref(PreferenceManager.prefUserContactNumber)
                as String?) ??
            '';
    alternateNoController.text =
        (PreferenceManager.getPref(PreferenceManager.prefUserAlternateNumber)
                as String?) ??
            '';
    currentAddressController.text =
        (PreferenceManager.getPref(PreferenceManager.prefUserCurrentAddress)
                as String?) ??
            '';
    additionalInfoController.text =
        (PreferenceManager.getPref(PreferenceManager.prefUserAdditionalInfo)
                as String?) ??
            '';
    userEmail = (PreferenceManager.getPref(PreferenceManager.prefUserEmail)
            as String?) ??
        '';
    permanentAddress =
        (PreferenceManager.getPref(PreferenceManager.prefUserPermanentAddress)
                as String?) ??
            '';
    String? date =
        PreferenceManager.getPref(PreferenceManager.prefUserDateOfBirth)
            as String?;
    if (date != null && date.isNotEmpty) {
      selectedDOB = DateTime.parse(date);
      DOBController.text = DateFormat("dd/MM/yyyy").format(selectedDOB!);
      Helpers.printLog(
          description: "EDIT_PROFILE_CONTROLLER_GET_LOGGED_IN_USER_DATA",
          message: "SELECTED_DOB = ${selectedDOB.toString()}");
    }
  }

  void disposeTextEditingControllers() {
    nameController.dispose();
    contactNoController.dispose();
    alternateNoController.dispose();
    DOBController.dispose();
    currentAddressController.dispose();
    additionalInfoController.dispose();
  }

  Future<void> saveInfo() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState!.validate() &&
        userId != null &&
        userEmail != null) {
      isLoading.value = true;
      try {
        Map<String, dynamic> requestBody = {
          'name': nameController.text,
          'contact_no': contactNoController.text,
          'alternate_no': alternateNoController.text,
          'birth_date': selectedDOB != null
              ? DateFormat('yyyy-MM-dd').format(selectedDOB!)
              : '',
          'current_address': currentAddressController.text,
          'additional_info': additionalInfoController.text,
          'email': userEmail,
          'permanent_address': permanentAddress
        };
        http.MultipartFile? uploadMedia;
        if (selectedImage.value != null) {
          uploadMedia = await http.MultipartFile.fromPath(
              'file', selectedImage.value!.path);
        }
        var response = await PostRequests.editProfile(
            requestBody: requestBody,
            profileId: userId!,
            uploadMedia: uploadMedia);
        if (response != null) {
          final dashboardController = Get.find<DashboardController>();
          await dashboardController.getLoggedInUser();
          dashboardController.refreshPage();
          final profileDetailController = Get.find<ProfileDetailController>();
          profileDetailController.getLoggedInUserData();
          Get.back();
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

  void pickImage(ImageSource source) async {
    bool isHavingPermissions = true;
    if (source == ImageSource.camera) {
      isHavingPermissions = await PermissionHandler.requestCameraPermission();
    }
    if (isHavingPermissions) {
      selectedImage.value = await _imagePicker.pickImage(source: source);
    }
  }

  void initializeImagePicker() {
    _imagePicker = ImagePicker();
  }

  void getNotificationsCount() {
    final dashboardController = Get.find<DashboardController>();
    notificationsCount = dashboardController.notificationsCount;
  }
}
