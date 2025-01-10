import 'package:get/get.dart';

import '../../consts/app_consts.dart';

class ProjectDetailController extends GetxController {
  late final int? projectId;

  @override
  void onInit() {
    // TODO: implement onInit
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

  void getProjectId() {
    Map? data = Get.arguments;
    if (data != null && data.isNotEmpty) {
      if (data.containsKey(AppConsts.keyProjectId)) {
        projectId = data[AppConsts.keyEmployeeId];
      }
    }
  }
}
