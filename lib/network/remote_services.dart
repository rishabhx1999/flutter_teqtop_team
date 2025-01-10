import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:teqtop_team/model/common_res_model.dart';
import 'package:teqtop_team/utils/helpers.dart';
import 'package:teqtop_team/utils/internet_connection.dart';
import 'package:teqtop_team/utils/preference_manager.dart';

import '../config/app_routes.dart';
import '../views/dialogs/common/common_alert_dialog.dart';

class RemoteService {
  static var client = http.Client();
  static const String _baseUrl = "https://dev.team.teqtop.com/api/";
  static String? token =
      PreferenceManager.getPref(PreferenceManager.prefUserToken) as String?;

  //
  //
  //
  static bool isLoginDay() {
    String? loginDateTimeString =
        PreferenceManager.getPref(PreferenceManager.prefLoginDate) as String?;
    if (loginDateTimeString != null && loginDateTimeString.isNotEmpty) {
      DateTime loginDateTime = DateTime.parse(loginDateTimeString);
      DateTime currentDateTime = DateTime.now();

      if (loginDateTime.year == currentDateTime.year &&
          loginDateTime.month == currentDateTime.month &&
          loginDateTime.day == currentDateTime.day) {
        return true;
      }
    }
    return false;
  }

  //
  //
  //
  static void showLoginDialog() {
    Future.delayed(const Duration(milliseconds: 500), () {
      CommonAlertDialog.showDialog(
          message: "message_login_again",
          positiveText: "ok",
          positiveBtnCallback: () async {
            PreferenceManager.clean();
            PreferenceManager.saveToPref(PreferenceManager.prefIsLogin, false);
            Get.offAllNamed(AppRoutes.routeLogin);
          });
    });
  }

  //
  //
  //
  static Future<CommonResModel?> simplePost(String endUrl,
      {required Map<String, String> headers,
      Map<String, dynamic>? requestBody,
      bool? isLogin}) async {
    if (isLoginDay() || isLogin == true) {
      var isConnected = await InternetConnection.isConnected();
      if (!isConnected) {
        Helpers.printLog(
            description: "REMOTE_SERVICE_SIMPLE_POST", message: "NO_INTERNET");
        return null;
      }

      Helpers.printLog(
          description: 'REMOTE_SERVICE_SIMPLE_POST',
          message:
              "REQUEST_DATA = $requestBody ===== REQUEST_URL = ${_baseUrl + endUrl} ===== REQUEST_HEADERS = ${json.encode(headers)}");

      var body = json.encode(requestBody);
      final http.Response response;

      if (requestBody != null) {
        response = await http.post(Uri.parse(_baseUrl + endUrl),
            headers: headers, body: body);
      } else {
        response =
            await http.post(Uri.parse(_baseUrl + endUrl), headers: headers);
      }

      Helpers.printLog(
          description: 'REMOTE_SERVICE_SIMPLE_POST',
          message:
              "RESPONSE = ${response.body} ===== REQUEST_URL = ${_baseUrl + endUrl} ===== REQUEST_HEADERS = ${json.encode(headers)}");

      var responseCode = response.statusCode;
      if (Helpers.isResponseSuccessful(responseCode)) {
        return CommonResModel(
            statusCode: responseCode, response: response.body);
      }
    } else {
      showLoginDialog();
    }
    return null;
  }

  //
  //
  //
  static Future<CommonResModel?> simpleGet(String endUrl,
      {required Map<String, String> headers}) async {
    if (isLoginDay()) {
      var isConnected = await InternetConnection.isConnected();
      if (!isConnected) {
        Helpers.printLog(
            description: "REMOTE_SERVICE_SIMPLE_GET", message: "NO_INTERNET");
        return null;
      }

      var url = "$_baseUrl$endUrl?token=$token";
      Helpers.printLog(
          description: 'REMOTE_SERVICE_SIMPLE_GET',
          message:
              "REQUEST_URL = $url ===== REQUEST_HEADERS = ${json.encode(headers)}");

      final response = await http.get(Uri.parse(url), headers: headers);

      Helpers.printLog(
          description: 'REMOTE_SERVICE_SIMPLE_GET',
          message:
              "RESPONSE = ${response.body} ===== REQUEST_URL = ${_baseUrl + endUrl} ===== REQUEST_HEADERS = ${json.encode(headers)}");

      var responseCode = response.statusCode;
      if (Helpers.isResponseSuccessful(responseCode)) {
        return CommonResModel(
            statusCode: responseCode, response: response.body);
      }
    } else {
      showLoginDialog();
    }
    return null;
  }

  //
  //
  //
  static Future<CommonResModel?> getWithQueries(String endUrl,
      {required Map<String, String> headers,
      Map<String, String>? requestBody}) async {
    if (isLoginDay()) {
      var isConnected = await InternetConnection.isConnected();
      if (!isConnected) {
        Helpers.printLog(
            description: "REMOTE_SERVICE_GET_WITH_QUERIES",
            message: "NO_INTERNET");
        return null;
      }

      var url = "$_baseUrl$endUrl?token=$token";
      if (requestBody != null) {
        requestBody.forEach((key, value) {
          url += "&$key=$value";
        });
      }
      Helpers.printLog(
          description: 'REMOTE_SERVICE_GET_WITH_QUERIES',
          message:
              "REQUEST_URL = $url ===== REQUEST_HEADERS = ${json.encode(headers)}");

      final response = await http.get(Uri.parse(url), headers: headers);

      Helpers.printLog(
          description: 'REMOTE_SERVICE_GET_WITH_QUERIES',
          message:
              "RESPONSE = ${response.body} ===== REQUEST_URL = $url ===== REQUEST_HEADERS = ${json.encode(headers)}");

      var responseCode = response.statusCode;
      if (Helpers.isResponseSuccessful(responseCode)) {
        return CommonResModel(
            statusCode: responseCode, response: response.body);
      }
    } else {
      showLoginDialog();
    }
    return null;
  }
}
