import 'package:get/get.dart';

import '../../utils/preference_manager.dart';

class ProfileDetailController extends GetxController {
  late final String? profilePhoto;
  late final String? personName;
  late final String? personEmail;
  late final String? personContactNo;
  late final String? personAlternatedNo;
  late final String? personDOB;
  late final String? personCurrentAddress;
  late final String? personAdditionalInfo;

  @override
  void onInit() {
    getLoggedInUserData();
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
    profilePhoto =
        (PreferenceManager.getPref(PreferenceManager.prefUserProfilePhoto)
                as String?) ??
            '';
    personName = (PreferenceManager.getPref(PreferenceManager.prefUserName)
            as String?) ??
        '';
    personEmail = (PreferenceManager.getPref(PreferenceManager.prefUserEmail)
            as String?) ??
        '';
    personContactNo =
        (PreferenceManager.getPref(PreferenceManager.prefUserContactNumber)
                as String?) ??
            '';
    personAlternatedNo =
        (PreferenceManager.getPref(PreferenceManager.prefUserAlternateNumber)
                as String?) ??
            '';
    personDOB =
        (PreferenceManager.getPref(PreferenceManager.prefUserDateOfBirth)
                as String?) ??
            '';
    personCurrentAddress =
        (PreferenceManager.getPref(PreferenceManager.prefUserCurrentAddress)
                as String?) ??
            '';
    personAdditionalInfo =
        (PreferenceManager.getPref(PreferenceManager.prefUserAdditionalInfo)
                as String?) ??
            '';
  }
}
