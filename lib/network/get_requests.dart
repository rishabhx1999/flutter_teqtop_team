import 'package:teqtop_team/model/daily_reports_listing/daily_reports_res_model.dart';
import 'package:teqtop_team/model/dashboard/feed_res_model.dart';
import 'package:teqtop_team/model/dashboard/user_res_model.dart';
import 'package:teqtop_team/model/employee_detail/leaves_res_model.dart';
import 'package:teqtop_team/model/employees_listing/employee_model.dart';
import 'package:teqtop_team/model/employees_listing/employees_res_model.dart';
import 'package:teqtop_team/model/projects_listing/projects_res_model.dart';
import 'package:teqtop_team/network/remote_services.dart';

import '../utils/helpers.dart';
import 'api_urls.dart';

class GetRequests {
  GetRequests._();

  static Future<FeedResModel?> getPosts() async {
    Helpers.printLog(description: "GET_REQUESTS_GET_POSTS_REACHED");
    var apiResponse = await RemoteService.simpleGet(ApiUrls.feeds, headers: {
      "Accept": "application/json",
      "Content-Type": "application/json;charset=utf-8"
    });

    if (apiResponse != null) {
      return feedResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<UserResModel?> getLoggedInUserData() async {
    Helpers.printLog(
        description: "GET_REQUESTS_GET_LOGGED_IN_USER_DATA_REACHED");
    var apiResponse = await RemoteService.simpleGet(ApiUrls.user, headers: {
      "Accept": "application/json",
      "Content-Type": "application/json;charset=utf-8"
    });

    if (apiResponse != null) {
      return userResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<EmployeesResModel?> getEmployees(
      Map<String, String> requestBody) async {
    Helpers.printLog(description: "GET_REQUESTS_GET_EMPLOYEES_REACHED");
    var apiResponse = await RemoteService.getWithQueries(ApiUrls.users,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json;charset=utf-8"
        },
        requestBody: requestBody);

    if (apiResponse != null) {
      return employeesResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<EmployeeModel?> getEmployeeDetails(int employeeId) async {
    Helpers.printLog(description: "GET_REQUESTS_GET_EMPLOYEE_DETAILS_REACHED");
    var apiResponse =
        await RemoteService.simpleGet("${ApiUrls.users}/$employeeId", headers: {
      "Accept": "application/json",
      "Content-Type": "application/json;charset=utf-8"
    });

    if (apiResponse != null) {
      return employeeFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<LeavesResModel?> getEmployeeLeaves(
      Map<String, String> requestBody) async {
    Helpers.printLog(description: "GET_REQUESTS_GET_EMPLOYEE_LEAVES_REACHED");
    var apiResponse = await RemoteService.getWithQueries(ApiUrls.leaves,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json;charset=utf-8"
        },
        requestBody: requestBody);

    if (apiResponse != null) {
      return leavesResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<DailyReportsResModel?> getDailyReports(
      Map<String, String> requestBody) async {
    var apiResponse = await RemoteService.getWithQueries(ApiUrls.dailyReport,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json;charset=utf-8"
        },
        requestBody: requestBody);

    if (apiResponse != null) {
      return dailyReportsResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<ProjectsResModel?> getProjects(
      Map<String, String> requestBody) async {
    Helpers.printLog(description: "GET_REQUESTS_GET_PROJECTS_REACHED");
    var apiResponse = await RemoteService.getWithQueries(ApiUrls.projects,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json;charset=utf-8"
        },
        requestBody: requestBody);

    if (apiResponse != null) {
      return projectsResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }
}
