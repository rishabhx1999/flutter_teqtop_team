import 'package:teqtop_team/model/assign_hours_listing/assign_hours_list_res_model.dart';
import 'package:teqtop_team/model/daily_reports_listing/daily_reports_res_model.dart';
import 'package:teqtop_team/model/dashboard/feed_res_model.dart';
import 'package:teqtop_team/model/dashboard/notifications_res_model.dart';
import 'package:teqtop_team/model/dashboard/user_res_model.dart';
import 'package:teqtop_team/model/drive_detail/drive_detail_res_model.dart';
import 'package:teqtop_team/model/employee_assigned_projects_hours/delete_employee_assigned_projects_hours_res_model.dart';
import 'package:teqtop_team/model/employee_detail/leaves_res_model.dart';
import 'package:teqtop_team/model/employees_listing/employee_model.dart';
import 'package:teqtop_team/model/employees_listing/employees_res_model.dart';
import 'package:teqtop_team/model/logs_listing/logs_res_model.dart';
import 'package:teqtop_team/model/notifications/read_notifications_res_model.dart';
import 'package:teqtop_team/model/project_create_edit/project_categories_and_proposals_res_model.dart';
import 'package:teqtop_team/model/project_detail/project_detail_res_model.dart';
import 'package:teqtop_team/model/projects_listing/projects_res_model.dart';
import 'package:teqtop_team/model/task_detail/delete_task_res_model.dart';
import 'package:teqtop_team/model/task_detail/task_detail_res_model.dart';
import 'package:teqtop_team/model/tasks_listing/tasks_res_model.dart';
import 'package:teqtop_team/network/remote_services.dart';

import '../utils/helpers.dart';
import 'api_urls.dart';

class GetRequests {
  GetRequests._();

  static Future<FeedResModel?> getPosts() async {
    // Helpers.printLog(description: "GET_REQUESTS_GET_POSTS_REACHED");
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
    // Helpers.printLog(
    //     description: "GET_REQUESTS_GET_LOGGED_IN_USER_DATA_REACHED");
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
    // Helpers.printLog(description: "GET_REQUESTS_GET_EMPLOYEES_REACHED");
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

  static Future<EmployeeModel?> getEmployeeDetails(int id) async {
    // Helpers.printLog(description: "GET_REQUESTS_GET_EMPLOYEE_DETAILS_REACHED");
    var apiResponse = await RemoteService.simpleGet("${ApiUrls.users}/$id/edit",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json;charset=utf-8"
        });

    if (apiResponse != null) {
      return employeeFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<DeleteEmployeeAssignedProjectsHoursResModel?>
      deleteEmployeeAssignedProjectsHours(int id) async {
    var apiResponse = await RemoteService.simpleGet(
        "${ApiUrls.weeklyHoursDelete}/$id",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json;charset=utf-8"
        });

    if (apiResponse != null) {
      return deleteEmployeeAssignedProjectsHoursResModelFromJson(
          apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<ReadNotificationsResModel?> readNotifications() async {
    var apiResponse = await RemoteService.simpleGet(
        ApiUrls.notificationsUpdateUncheck,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json;charset=utf-8"
        });

    if (apiResponse != null) {
      return readNotificationsResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<LeavesResModel?> getLeaves(
      Map<String, String> requestBody) async {
    // Helpers.printLog(description: "GET_REQUESTS_GET_EMPLOYEE_LEAVES_REACHED");
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

  static Future<AssignHoursListResModel?> getAssignHoursList(
      Map<String, String> requestBody) async {
    var apiResponse = await RemoteService.getWithQueries(ApiUrls.weeklyHours,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json;charset=utf-8"
        },
        requestBody: requestBody);

    if (apiResponse != null) {
      return assignHoursListResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<ProjectsResModel?> getProjects(
      Map<String, String> requestBody) async {
    // Helpers.printLog(description: "GET_REQUESTS_GET_PROJECTS_REACHED");
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

  static Future<TasksResModel?> getTasks(
      Map<String, String> requestBody) async {
    // Helpers.printLog(description: "GET_REQUESTS_GET_TASKS_REACHED");
    var apiResponse = await RemoteService.getWithQueries(ApiUrls.tasks,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json;charset=utf-8"
        },
        requestBody: requestBody);

    if (apiResponse != null) {
      return tasksResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<NotificationsResModel?> getNotifications() async {
    // Helpers.printLog(description: "GET_REQUESTS_GET_NOTIFICATIONS_REACHED");
    var apiResponse = await RemoteService.getWithQueries(
      ApiUrls.notifications,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json;charset=utf-8"
      },
    );

    if (apiResponse != null) {
      return notificationsResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<ProjectDetailResModel?> getProjectDetail(int projectId) async {
    // Helpers.printLog(description: "GET_REQUESTS_GET_PROJECT_DETAIL_REACHED");
    var apiResponse = await RemoteService.getWithQueries(
      "${ApiUrls.projects}/$projectId",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json;charset=utf-8"
      },
    );

    if (apiResponse != null) {
      return projectDetailResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<TaskDetailResModel?> getTaskDetail(int taskId) async {
    // Helpers.printLog(description: "GET_REQUESTS_GET_TASK_DETAIL_REACHED");
    var apiResponse = await RemoteService.getWithQueries(
      "${ApiUrls.tasksView}/$taskId",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json;charset=utf-8"
      },
    );

    if (apiResponse != null) {
      return taskDetailResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<ProjectCategoriesAndProposalsResModel?>
      getProjectCategoriesAndProposals() async {
    // Helpers.printLog(
    //     description:
    //         "GET_REQUESTS_GET_PROJECT_CATEGORIES_AND_PROPOSALS_REACHED");
    var apiResponse =
        await RemoteService.simpleGet(ApiUrls.projectsSalesProposals, headers: {
      "Accept": "application/json",
      "Content-Type": "application/json;charset=utf-8"
    });

    if (apiResponse != null) {
      return projectCategoriesAndProposalsResModelFromJson(
          apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<LogsResModel?> getLogs(Map<String, String> requestBody) async {
    // Helpers.printLog(description: "GET_REQUESTS_GET_LOGS_REACHED");
    var apiResponse = await RemoteService.getWithQueries(ApiUrls.logs,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json;charset=utf-8"
        },
        requestBody: requestBody);

    if (apiResponse != null) {
      return logsResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<DriveDetailResModel?> getDriveDetail(String driveURL) async {
    // Helpers.printLog(description: "GET_REQUESTS_GET_DRIVE_DETAIL_REACHED");
    var apiResponse = await RemoteService.simpleGet(driveURL, headers: {
      "Accept": "application/json",
      "Content-Type": "application/json;charset=utf-8"
    });

    if (apiResponse != null) {
      return driveDetailResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<DeleteTaskResModel?> deleteTask(int id) async {
    var apiResponse =
        await RemoteService.simpleGet("${ApiUrls.tasks}/delete/$id", headers: {
      "Accept": "application/json",
      "Content-Type": "application/json;charset=utf-8"
    });

    if (apiResponse != null) {
      return deleteTaskResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }
}
