import 'dart:convert';

import 'package:get/get.dart';
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

  //
  //
  //
  static String? getToken() {
    return PreferenceManager.getPref(PreferenceManager.prefUserToken)
        as String?;
  }

  //
  //
  //
  static bool isTokenExpired() {
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
    if (isTokenExpired() == false || isLogin == true) {
      var isConnected = await InternetConnection.isConnected();
      if (!isConnected) {
        // Helpers.printLog(
        //     description: "REMOTE_SERVICE_SIMPLE_POST", message: "NO_INTERNET");
        return null;
      }

      var body = json.encode(requestBody);
      final http.Response response;

      // Helpers.printLog(
      //     description: 'REMOTE_SERVICE_SIMPLE_POST',
      //     message:
      //         "REQUEST_URL = ${_baseUrl + endUrl} ===== REQUEST_BODY = $body ===== REQUEST_HEADERS = $headers");
      if (requestBody != null) {
        response = await http.post(Uri.parse(_baseUrl + endUrl),
            headers: headers, body: body);
      } else {
        response =
            await http.post(Uri.parse(_baseUrl + endUrl), headers: headers);
      }

      // Helpers.printLog(
      //     description: 'REMOTE_SERVICE_SIMPLE_POST',
      //     message:
      //         "RESPONSE = ${response.body} ===== REQUEST_URL = ${_baseUrl + endUrl} ===== REQUEST_BODY = $body ===== REQUEST_HEADERS = $headers");

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
    if (isTokenExpired() == false) {
      var isConnected = await InternetConnection.isConnected();
      if (!isConnected) {
        // Helpers.printLog(
        //     description: "REMOTE_SERVICE_SIMPLE_GET", message: "NO_INTERNET");
        return null;
      }

      var url = "$_baseUrl$endUrl?token=${getToken()}";
      Helpers.printLog(
          description: 'REMOTE_SERVICE_SIMPLE_GET',
          message:
              "REQUEST_URL = $url ===== REQUEST_HEADERS = ${json.encode(headers)}");

      final response = await http.get(Uri.parse(url), headers: headers);

      // Helpers.printLog(
      //     description: 'REMOTE_SERVICE_SIMPLE_GET',
      //     message:
      //         "RESPONSE = ${response.body} ===== REQUEST_URL = $url");

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
    if (isTokenExpired() == false) {
      var isConnected = await InternetConnection.isConnected();
      if (!isConnected) {
        // Helpers.printLog(
        //     description: "REMOTE_SERVICE_GET_WITH_QUERIES",
        //     message: "NO_INTERNET");
        return null;
      }

      var url = "$_baseUrl$endUrl?token=${getToken()}";
      if (requestBody != null) {
        requestBody.forEach((key, value) {
          url += "&$key=$value";
        });
      }
      Helpers.printLog(
          description: 'REMOTE_SERVICE_GET_WITH_QUERIES',
          message:
              "REQUEST_URL = $url ===== REQUEST_HEADERS = $headers ===== REQUEST_BODY = $requestBody");

      final response = await http.get(Uri.parse(url), headers: headers);

      // Helpers.printLog(
      //     description: 'REMOTE_SERVICE_GET_WITH_QUERIES',
      //     message:
      //         "RESPONSE = ${response.body} ===== REQUEST_URL = $url ===== REQUEST_HEADERS = $headers");

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
  static Future<CommonResModel?> simplePostWithSingleMedia(
    String endUrl, {
    required Map<String, String> headers,
    Map<String, dynamic>? requestBody,
    bool? isLogin,
    http.MultipartFile? uploadMedia,
  }) async {
    if (isTokenExpired() == false || isLogin == true) {
      var isConnected = await InternetConnection.isConnected();
      if (!isConnected) {
        // Helpers.printLog(
        //     description: "REMOTE_SERVICE_SIMPLE_POST_WITH_SINGLE_MEDIA",
        //     message: "NO_INTERNET");
        return null;
      }

      // Helpers.printLog(
      //     description: "REMOTE_SERVICE_SIMPLE_POST_WITH_SINGLE_MEDIA",
      //     message:
      //         "REQUEST_DATA = $requestBody ===== REQUEST_URL = ${_baseUrl + endUrl} ===== REQUEST_HEADERS = ${json.encode(headers)}");

      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(_baseUrl + endUrl));
      if (requestBody != null) {
        requestBody.forEach((key, value) {
          request.fields[key] = value;
        });
      }
      request.headers.addAll(headers);
      if (uploadMedia != null) {
        request.files.add(uploadMedia);
      }

      http.StreamedResponse streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);

      // Helpers.printLog(
      //     description: 'REMOTE_SERVICE_SIMPLE_POST_WITH_SINGLE_MEDIA',
      //     message:
      //         "RESPONSE = ${response.body} ===== REQUEST_URL = ${_baseUrl + endUrl} ===== REQUEST_HEADERS = ${json.encode(headers)}");

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
  static Future<CommonResModel?> simplePut(String endUrl,
      {required Map<String, String> headers,
      Map<String, dynamic>? requestBody}) async {
    if (isTokenExpired() == false) {
      var isConnected = await InternetConnection.isConnected();
      if (!isConnected) {
        // Helpers.printLog(
        //     description: "REMOTE_SERVICE_SIMPLE_PUT", message: "NO_INTERNET");
        return null;
      }

      // Helpers.printLog(
      //     description: 'REMOTE_SERVICE_SIMPLE_PUT',
      //     message:
      //         "REQUEST_DATA = $requestBody ===== REQUEST_URL = ${_baseUrl + endUrl} ===== REQUEST_HEADERS = $headers");

      var body = json.encode(requestBody);
      final http.Response response;

      if (requestBody != null) {
        response = await http.put(Uri.parse(_baseUrl + endUrl),
            headers: headers, body: body);
      } else {
        response =
            await http.put(Uri.parse(_baseUrl + endUrl), headers: headers);
      }

      // Helpers.printLog(
      //     description: 'REMOTE_SERVICE_SIMPLE_PUT',
      //     message:
      //         "RESPONSE = ${response.body} ===== REQUEST_URL = ${_baseUrl + endUrl} ===== REQUEST_HEADERS = ${json.encode(headers)}");

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
  static Future<CommonResModel?> addDriveFiles({
    required List<String> paths,
    required String endUrl,
    required String parentURL,
    required Map<String, String> headers,
  }) async {
    if (isTokenExpired() == false) {
      var isConnected = await InternetConnection.isConnected();

      if (!isConnected) {
        return null;
      }

      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(_baseUrl + endUrl));
      request.fields['isFile'] = 'true';
      request.fields['parent'] = parentURL;
      request.fields['token'] = getToken()!;
      request.headers.addAll(headers);
      for (int x = 0; x < paths.length; x++) {
        request.files
            .add(await http.MultipartFile.fromPath('files[$x]', paths[x]));
      }

      // Helpers.printLog(
      //     description: 'REMOTE_SERVICE_ADD_DRIVE_FILES',
      //     message:
      //         "URL = ${_baseUrl + endUrl} ===== REQUEST_FIELDS = ${request.fields} ===== REQUEST_FILES = ${request.files}");

      http.StreamedResponse streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);
      // Helpers.printLog(
      //     description: 'REMOTE_SERVICE_ADD_DRIVE_FILES',
      //     message:
      //         "URL = ${_baseUrl + endUrl} ===== RESPONSE = ${response.body}");
      var responseCode = response.statusCode;
      if (Helpers.isResponseSuccessful(responseCode)) {
        return CommonResModel(
            statusCode: responseCode, response: response.body);
      } else {
        Get.snackbar('error'.tr, 'message_server_error'.tr);
      }
    } else {
      showLoginDialog();
    }
    return null;
  }

  //
  //
  //
  static Future<CommonResModel?> simplePostWithSingleMediaAndQueries(
    String endUrl, {
    required Map<String, String> headers,
    Map<String, dynamic>? requestBody,
    bool? isLogin,
    http.MultipartFile? uploadMedia,
  }) async {
    if (isTokenExpired() == false || isLogin == true) {
      var isConnected = await InternetConnection.isConnected();
      if (!isConnected) {
        // Helpers.printLog(
        //     description:
        //         "REMOTE_SERVICE_SIMPLE_POST_WITH_SINGLE_MEDIA_AND_QUERIES",
        //     message: "NO_INTERNET");
        return null;
      }

      var url = "$_baseUrl$endUrl?token=${getToken()}";
      if (requestBody != null) {
        requestBody.forEach((key, value) {
          url += "&$key=$value";
        });
      }
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);
      if (uploadMedia != null) {
        request.files.add(uploadMedia);
      }

      // Helpers.printLog(
      //     description:
      //         'REMOTE_SERVICE_SIMPLE_POST_WITH_SINGLE_MEDIA_AND_QUERIES',
      //     message:
      //         "REQUEST_URL = $url ===== UPLOAD_MEDIA = ${uploadMedia.toString()} ===== REQUEST_HEADERS = ${json.encode(headers)}");

      http.StreamedResponse streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);

      // Helpers.printLog(
      //     description:
      //         'REMOTE_SERVICE_SIMPLE_POST_WITH_SINGLE_MEDIA_AND_QUERIES',
      //     message:
      //         "RESPONSE = ${response.body} ===== REQUEST_URL = $url ===== REQUEST_HEADERS = ${json.encode(headers)}");

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
  static Future<CommonResModel?> simplePostWithQueries(
    String endUrl, {
    required Map<String, String> headers,
    Map<String, dynamic>? requestBody,
    bool? isLogin,
  }) async {
    if (isTokenExpired() == false || isLogin == true) {
      var isConnected = await InternetConnection.isConnected();
      if (!isConnected) {
        // Helpers.printLog(
        //     description:
        //         "REMOTE_SERVICE_SIMPLE_POST_WITH_SINGLE_MEDIA_AND_QUERIES",
        //     message: "NO_INTERNET");
        return null;
      }

      var url = "$_baseUrl$endUrl?token=${getToken()}";
      if (requestBody != null) {
        requestBody.forEach((key, value) {
          url += "&$key=$value";
        });
      }

      final http.Response response;

      response = await http.post(
        Uri.parse(url),
        headers: headers,
      );

      // Helpers.printLog(
      //     description:
      //         'REMOTE_SERVICE_SIMPLE_POST_WITH_SINGLE_MEDIA_AND_QUERIES',
      //     message:
      //         "REQUEST_URL = $url ===== REQUEST_HEADERS = ${json.encode(headers)}");

      // Helpers.printLog(
      //     description:
      //         'REMOTE_SERVICE_SIMPLE_POST_WITH_SINGLE_MEDIA_AND_QUERIES',
      //     message:
      //         "RESPONSE = ${response.body} ===== REQUEST_URL = $url ===== REQUEST_HEADERS = ${json.encode(headers)}");

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
  static Future<CommonResModel?> simplePutWithoutQueries(String endUrl,
      {required Map<String, String> headers,
      Map<String, dynamic>? requestBody}) async {
    if (isTokenExpired() == false) {
      var isConnected = await InternetConnection.isConnected();
      if (!isConnected) {
        // Helpers.printLog(
        //     description: "REMOTE_SERVICE_SIMPLE_PUT_WITHOUT_QUERIES",
        //     message: "NO_INTERNET");
        return null;
      }

      var body = json.encode(requestBody);
      final http.Response response;
      var url = "$_baseUrl$endUrl?token=${getToken()}";

      // Helpers.printLog(
      //     description: 'REMOTE_SERVICE_SIMPLE_PUT_WITHOUT_QUERIES',
      //     message:
      //         "REQUEST_DATA = $requestBody ===== REQUEST_URL = $url ===== REQUEST_HEADERS = ${json.encode(headers)}");

      if (requestBody != null) {
        response = await http.put(Uri.parse(url), headers: headers, body: body);
      } else {
        response = await http.put(Uri.parse(url), headers: headers);
      }

      // Helpers.printLog(
      //     description: 'REMOTE_SERVICE_SIMPLE_PUT_WITHOUT_QUERIES',
      //     message:
      //         "RESPONSE = ${response.body} ===== REQUEST_URL = $url ===== REQUEST_HEADERS = ${json.encode(headers)}");

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
