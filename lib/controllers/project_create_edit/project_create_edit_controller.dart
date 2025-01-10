import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProjectCreateEditController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey();
  late TextEditingController nameController;
  late TextEditingController clientController;
  late TextEditingController urlController;
  late TextEditingController portalController;
  late TextEditingController profileController;
  late TextEditingController descriptionController;

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
    nameController = TextEditingController();
    clientController = TextEditingController();
    urlController = TextEditingController();
    portalController = TextEditingController();
    profileController = TextEditingController();
    descriptionController = TextEditingController();
  }

  void disposeTextEditingControllers() {
    nameController.dispose();
    clientController.dispose();
    urlController.dispose();
    portalController.dispose();
    profileController.dispose();
    descriptionController.dispose();
  }

  Future<void> createProject() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState!.validate()) {}
  }
}
