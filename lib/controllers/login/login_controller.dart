import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/network/post_requests.dart';
import 'package:teqtop_team/utils/preference_manager.dart';

import '../../config/app_route_observer.dart';
import '../../config/app_routes.dart';
import '../../utils/helpers.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  RxBool isLoading = false.obs;

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
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  void disposeTextEditingControllers() {
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> signIn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState!.validate()) {
      Map<String, dynamic> requestBody = {
        'email': emailController.text.toString().trim(),
        'password': passwordController.text.toString().trim()
      };

      isLoading.value = true;
      try {
        var response = await PostRequests.loginUser(requestBody);
        if (response != null) {
          if (response.accessToken != null &&
              response.accessToken!.isNotEmpty) {
            saveDataToPref(response);
          } else {
            Get.snackbar(
                "error".tr, response.error ?? "message_server_error".tr);
          }
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } finally {
        isLoading.value = false;
      }
    }
  }

  void saveDataToPref(dynamic loginData) {
    PreferenceManager.saveToPref(PreferenceManager.prefIsLogin, true);
    PreferenceManager.saveToPref(
        PreferenceManager.prefUserToken, loginData.accessToken);
    PreferenceManager.saveToPref(
        PreferenceManager.prefLoginDate, DateTime.now().toString());
    PreferenceManager.saveToPref(
        PreferenceManager.prefLoginExpireSeconds, loginData.expiresIn);

    moveToDashboard();
  }

  void moveToDashboard() {
    Get.offNamed(AppRoutes.routeDashboard);
    Helpers.printLog(
        description: "LOGIN_CONTROLLER_MOVE_TO_DASHBOARD",
        message:
            "ROUTE_STACK_LIST :- ${AppRouteObserver.routeStack}\nROUTE_STACK_LIST :- ${AppRouteObserver.routeStack.length}");
  }
}
