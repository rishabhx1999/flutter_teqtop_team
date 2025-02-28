import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/utils/helpers.dart';

import '../../consts/app_consts.dart';

class GalleryController extends GetxController {
  late final PageController pageController;
  List<String> images = [];
  RxInt? index;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void initializePageController() {
    if (index != null) {
      pageController = PageController(initialPage: index!.value);
    }
  }

  void getData() {
    Map? data = Get.arguments;
    if (data != null && data.isNotEmpty) {
      if (data.containsKey(AppConsts.keyImagesURLS)) {
        images = data[AppConsts.keyImagesURLS];
      }
      if (data.containsKey(AppConsts.keyIndex)) {
        int? value = data[AppConsts.keyIndex];
        Helpers.printLog(
            description: "GALLERY_CONTROLLER_GET_DATA",
            message: "INDEX = $value");
        if (value != null) {
          index = value.obs;
        }
      }
    }
    initializePageController();
  }
}
