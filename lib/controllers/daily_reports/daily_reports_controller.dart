import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/preference_manager.dart';

class DailyReportsController extends GetxController {
  late final scaffoldKey = GlobalKey<ScaffoldState>();
  late final String? profilePhoto;

  @override
  void onInit() {
    getProfilePhoto();
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

  void getProfilePhoto() {
    profilePhoto =
        (PreferenceManager.getPref(PreferenceManager.prefUserProfilePhoto)
                as String?) ??
            '';
  }

  Future<void> refreshPage() async {}
}
