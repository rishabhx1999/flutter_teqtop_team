import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/config/app_routes.dart';
import 'package:teqtop_team/config/size_config.dart';
import 'package:teqtop_team/consts/app_images.dart';
import 'package:teqtop_team/controllers/splash/splash_controller.dart';
import 'package:teqtop_team/utils/preference_manager.dart';

class SplashPage extends StatelessWidget {
  final splashController = Get.put(SplashController());

  SplashPage({super.key});

  void _moveToNextScreen() {
    var nextScreen =
        PreferenceManager.isUserLoggedIn() && isTokenExpired() == false
            ? AppRoutes.routeDashboard
            : AppRoutes.routeLogin;
    Get.offNamed(nextScreen);
    // Helpers.printLog(
    //     description: "SPLASH_PAGE_MOVE_TO_NEXT_SCREEN",
    //     message:
    //         "ROUTE_STACK_LIST :- ${AppRouteObserver.routeStack}\nROUTE_STACK_LIST :- ${AppRouteObserver.routeStack.length}");
  }

  bool isTokenExpired() {
    String? loginDateTimeString =
        PreferenceManager.getPref(PreferenceManager.prefLoginDate) as String?;
    int? loginExpireSeconds =
        PreferenceManager.getPref(PreferenceManager.prefLoginExpireSeconds)
            as int?;
    if (loginDateTimeString != null &&
        loginDateTimeString.isNotEmpty &&
        loginExpireSeconds != null) {
      DateTime loginDateTime = DateTime.parse(loginDateTimeString);
      DateTime currentDateTime = DateTime.now();

      int secondsDifference =
          currentDateTime.difference(loginDateTime).inSeconds;
      if (secondsDifference < loginExpireSeconds) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      _moveToNextScreen();
    });

    return Stack(
      children: [
        Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight,
          color: Colors.white,
          child: Center(child: Image.asset(AppImages.imgLogo)),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Obx(() => Image.asset(splashController
                .loadingImages[splashController.currentImgIndex.value])),
          ),
        ),
      ],
    );
  }
}
