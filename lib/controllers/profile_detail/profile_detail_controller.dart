import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utils/preference_manager.dart';
import '../dashboard/dashboard_controller.dart';

class ProfileDetailController extends GetxController {
  RxString profilePhoto = "".obs;
  RxString personName = "".obs;
  RxString personEmail = "".obs;
  RxString personContactNo = "".obs;
  RxString personAlternatedNo = "".obs;
  RxString personDOB = "".obs;
  RxString personCurrentAddress = "".obs;
  RxString personAdditionalInfo = "".obs;
  RxInt notificationsCount = 0.obs;

  @override
  void onInit() {
    getLoggedInUserData();
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
    // TODO: implement onClose
    super.onClose();
  }

  void getLoggedInUserData() {
    profilePhoto.value =
        (PreferenceManager.getPref(PreferenceManager.prefUserProfilePhoto)
                as String?) ??
            '';
    personName.value =
        (PreferenceManager.getPref(PreferenceManager.prefUserName)
                as String?) ??
            '';
    personEmail.value =
        (PreferenceManager.getPref(PreferenceManager.prefUserEmail)
                as String?) ??
            '';
    personContactNo.value =
        (PreferenceManager.getPref(PreferenceManager.prefUserContactNumber)
                as String?) ??
            '';
    personAlternatedNo.value =
        (PreferenceManager.getPref(PreferenceManager.prefUserAlternateNumber)
                as String?) ??
            '';
    personDOB.value =
        (PreferenceManager.getPref(PreferenceManager.prefUserDateOfBirth)
                as String?) ??
            '';
    if (personDOB.value.isNotEmpty) {
      personDOB.value =
          DateFormat('dd/MM/yyyy').format(DateTime.parse(personDOB.value));
    }
    personCurrentAddress.value =
        (PreferenceManager.getPref(PreferenceManager.prefUserCurrentAddress)
                as String?) ??
            '';
    personAdditionalInfo.value =
        (PreferenceManager.getPref(PreferenceManager.prefUserAdditionalInfo)
                as String?) ??
            '';
  }

  void getNotificationsCount() {
    final dashboardController = Get.find<DashboardController>();
    notificationsCount = dashboardController.notificationsCount;
  }
}
