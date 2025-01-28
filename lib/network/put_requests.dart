import 'package:teqtop_team/model/edit_employee_information/edit_employee_info_res_model.dart';
import 'package:teqtop_team/model/project_create_edit/edit_project_res_model.dart';
import 'package:teqtop_team/network/remote_services.dart';

import '../utils/helpers.dart';
import 'api_urls.dart';

class PutRequests {
  PutRequests._();

  static Future<EditProjectResModel?> editProject(
      Map<String, dynamic> requestBody, int projectId) async {
    Helpers.printLog(description: "PUT_REQUESTS_EDIT_PROJECT_REACHED");
    var apiResponse = await RemoteService.simplePut(
      "${ApiUrls.projects}/$projectId",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json;charset=utf-8"
      },
      requestBody: requestBody,
    );

    if (apiResponse != null) {
      return editProjectResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<EditEmployeeInfoResModel?> editEmployeeInfo(
      Map<String, dynamic> requestBody, int id) async {
    Helpers.printLog(description: "PUT_REQUESTS_EDIT_EMPLOYEE_INFO_REACHED");
    var apiResponse = await RemoteService.simplePutWithoutQueries(
      "${ApiUrls.users}/$id",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json;charset=utf-8"
      },
      requestBody: requestBody,
    );

    if (apiResponse != null) {
      return editEmployeeInfoResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }
}
