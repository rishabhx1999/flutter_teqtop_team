import 'dart:convert';

import 'package:http/http.dart';
import 'package:teqtop_team/model/common_res_model.dart';
import 'package:teqtop_team/utils/helpers.dart';
import 'package:teqtop_team/utils/internet_connection.dart';
import 'package:teqtop_team/utils/preference_manager.dart';

class RemoteService {
  static var client = Client();
  static const String _baseUrl = "https://dev.team.teqtop.com/api/";
  static String? token =
      PreferenceManager.getPref(PreferenceManager.prefUserToken) as String?;

  //
  //
  //
  static Future<CommonResModel?> simplePost(String endUrl,
      {required Map<String, String> headers,
      Map<String, dynamic>? requestBody}) async {
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
    final Response response;

    if (requestBody != null) {
      response = await post(Uri.parse(_baseUrl + endUrl),
          headers: headers, body: body);
    } else {
      response = await post(Uri.parse(_baseUrl + endUrl), headers: headers);
    }

    Helpers.printLog(
        description: 'REMOTE_SERVICE_SIMPLE_POST',
        message:
            "RESPONSE = ${response.body} ===== REQUEST_URL = ${_baseUrl + endUrl} ===== REQUEST_HEADERS = ${json.encode(headers)}");

    var responseCode = response.statusCode;
    if (Helpers.isResponseSuccessful(responseCode)) {
      return CommonResModel(statusCode: responseCode, response: response.body);
    } else {
      return null;
    }
  }

  //
  //
  //
  static Future<CommonResModel?> simpleGet(String endUrl,
      {required Map<String, String> headers}) async {
    var isConnected = await InternetConnection.isConnected();
    if (!isConnected) {
      Helpers.printLog(
          description: "REMOTE_SERVICE_SIMPLE_GET", message: "NO_INTERNET");
      return null;
    }

    var url="$_baseUrl$endUrl?token=$token";
    Helpers.printLog(
        description: 'REMOTE_SERVICE_SIMPLE_GET',
        message:
            "REQUEST_URL = $url ===== REQUEST_HEADERS = ${json.encode(headers)}");

    final response = await get(Uri.parse(url), headers: headers);

    Helpers.printLog(
        description: 'REMOTE_SERVICE_SIMPLE_GET',
        message:
            "RESPONSE = ${response.body} ===== REQUEST_URL = ${_baseUrl + endUrl} ===== REQUEST_HEADERS = ${json.encode(headers)}");

    var responseCode = response.statusCode;
    if (Helpers.isResponseSuccessful(responseCode)) {
      return CommonResModel(statusCode: responseCode, response: response.body);
    } else {
      return null;
    }
  }
}
