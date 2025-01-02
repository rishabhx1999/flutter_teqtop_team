import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../utils/permission_handler.dart';
import '../../utils/preference_manager.dart';

class EditProfileController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey();
  late final TextEditingController nameController;
  late final TextEditingController contactNoController;
  late final TextEditingController alternateNoController;
  late final TextEditingController DOBController;
  late final TextEditingController currentAddressController;
  late final TextEditingController additionalInfoController;
  late final String? profilePhoto;
  DateTime? selectedDOB;
  late ImagePicker _imagePicker;
  Rx<XFile?> selectedImage = Rx<XFile?>(null);

  @override
  void onInit() {
    initializeTextEditingControllers();
    initializeImagePicker();

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
    if (formKey.currentState!.validate()) {}
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
}
