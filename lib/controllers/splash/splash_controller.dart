import 'dart:async';

import 'package:get/get.dart';
import 'package:teqtop_team/consts/app_images.dart';

class SplashController extends GetxController {
  late Timer timer;
  RxInt currentImgIndex = 0.obs;
  final List<String> loadingImages = [
    AppImages.imgLoading,
    AppImages.imgLoading2,
    AppImages.imgLoading3,
    AppImages.imgLoading4
  ];

  @override
  void onInit() {
    startImageLoop();
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }

  void startImageLoop() {
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      currentImgIndex.value =
          (currentImgIndex.value + 1) % loadingImages.length;
    });
  }
}
