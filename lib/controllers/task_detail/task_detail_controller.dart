import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/controllers/tasks_listing/tasks_listing_controller.dart';
import 'package:teqtop_team/model/employees_listing/employee_model.dart';
import 'package:teqtop_team/model/global_search/task_model.dart';
import 'package:teqtop_team/utils/helpers.dart';

import '../../config/app_routes.dart';
import '../../consts/app_consts.dart';
import '../../model/dashboard/comment_list.dart';
import '../../network/get_requests.dart';
import '../../network/post_requests.dart';
import '../../utils/preference_manager.dart';
import '../../views/dialogs/common/common_alert_dialog.dart';
import '../global_search/global_search_controller.dart';

class TaskDetailController extends GetxController {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int? taskId;
  late TextEditingController commentFieldController;
  RxBool areCommentsLoading = false.obs;
  RxBool isLoading = false.obs;
  Rx<TaskModel?> taskDetail = Rx<TaskModel?>(null);
  RxList<CommentList?> comments = <CommentList>[].obs;
  List<EmployeeModel> employees = <EmployeeModel>[];
  Rx<EmployeeModel?> responsiblePerson = Rx<EmployeeModel?>(null);
  RxList<EmployeeModel?> participants = <EmployeeModel?>[].obs;
  RxList<EmployeeModel?> observers = <EmployeeModel?>[].obs;
  RxInt commentsLength = 0.obs;
  int commentsPage = 1;
  final ScrollController commentsSheetScrollController = ScrollController();
  RxBool isCommentEditing = false.obs;
  bool commentsRefreshNeeded = false;

  @override
  void onInit() {
    initializeTextEditingController();
    getTaskId();
    addListenerToScrollController();

    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    disposeTextEditingController();
    disposeScrollController();

    super.onClose();
  }

  void addListenerToScrollController() {
    commentsSheetScrollController.addListener(() {
      if (commentsSheetScrollController.position.pixels ==
          commentsSheetScrollController.position.maxScrollExtent) {
        getComments();
      }
    });
  }

  void disposeScrollController() {
    commentsSheetScrollController.dispose();
  }

  void initializeTextEditingController() {
    commentFieldController = TextEditingController();
  }

  void disposeTextEditingController() {
    commentFieldController.dispose();
  }

  void getTaskId() {
    Map? data = Get.arguments;
    if (data != null && data.isNotEmpty) {
      if (data.containsKey(AppConsts.keyTaskId)) {
        taskId = data[AppConsts.keyTaskId];
      }
    }
    getTaskDetail();
  }

  Future<void> getTaskDetail() async {
    if (taskId != null) {
      isLoading.value = true;
      try {
        var response = await GetRequests.getTaskDetail(taskId!);
        if (response != null) {
          if (response.task != null) {
            taskDetail.value = response.task;
            getEmployees();
            commentsLength.value = taskDetail.value!.commentsCount ?? 0;
          } else {
            Get.snackbar("error".tr, "message_server_error".tr);
          }
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> getComments() async {
    int commentsPerPage = 10;
    int maxPage = (commentsLength.value / commentsPerPage).ceil();

    if (taskId != null && commentsPage <= maxPage ||
        commentsRefreshNeeded == true) {
      Map<String, dynamic> requestBody = {
        'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
            as String?,
        'component_id': taskId,
        'component': 'task',
        'pager': commentsPage
      };

      areCommentsLoading.value = true;
      try {
        var response = await PostRequests.getTaskComments(requestBody);
        if (response != null) {
          if (response.comments != null) {
            for (var comment in comments) {
              if (comment != null && comment.editController != null) {
                comment.editController!.dispose();
                comment.editController = null;
              }
            }
            comments.assignAll(response.comments!.toList());
            for (var comment in comments) {
              if (comment != null) {
                comment.editController = TextEditingController();
              }
            }
            comments.refresh();
            commentsPage++;
          } else {
            Get.snackbar("error".tr, "message_server_error".tr);
          }
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } finally {
        areCommentsLoading.value = false;
        commentsRefreshNeeded = false;
      }
    }
  }

  Future<void> createComment() async {
    FocusManager.instance.primaryFocus?.unfocus();
    for (var comment in comments) {
      if (comment != null) {
        comment.isEditing.value = false;
      }
    }
    if (taskId != null && commentFieldController.text.isNotEmpty) {
      Map<String, dynamic> requestBody = {
        'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
            as String?,
        'component_id': taskId,
        'component': 'task',
        'comment':
            '"${Helpers.convertToHTMLParagraphs(commentFieldController.text)}"'
      };

      areCommentsLoading.value = true;
      try {
        var response = await PostRequests.createTaskComment(requestBody);
        if (response != null) {
          if (response.latestComment != null) {
            response.latestComment!.editController = TextEditingController();
            comments.add(response.latestComment);
            commentFieldController.clear();
            commentsLength.value += 1;
            commentsLength.refresh();
            commentsPage = 1;
            getComments();
          } else {
            Get.snackbar("error".tr, "message_server_error".tr);
          }
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } finally {
        areCommentsLoading.value = false;
      }
    }
  }

  Future<void> editComment(int commentId) async {
    FocusManager.instance.primaryFocus?.unfocus();
    var editComment = comments.firstWhereOrNull(
        (comment) => comment != null && comment.id == commentId);
    if (taskId != null && editComment != null) {
      Map<String, dynamic> requestBody = {
        'component_id': taskId,
        'component': 'task',
        'comment':
            '"${Helpers.convertToHTMLParagraphs(editComment.editController!.text)}"',
        'id': commentId
      };

      isCommentEditing.value = true;
      try {
        var response = await PostRequests.editTaskComment(requestBody);
        if (response != null) {
          if (response.status == "true") {
            editComment.comment =
                "\"<p>${editComment.editController!.text}</p>\"";
          } else {
            Get.snackbar("error".tr, "message_server_error".tr);
          }
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } finally {
        isCommentEditing.value = false;
        editComment.isEditing.value = false;
        comments.refresh();
      }
    }
  }

  Future<void> getEmployees() async {
    Map<String, String> requestBody = {
      // 'draw': '20',
      // 'columns%5B0%5D%5Bdata%5D': 'DT_RowIndex',
      // 'columns%5B0%5D%5Bname%5D': '',
      // 'columns%5B0%5D%5Bsearchable%5D': 'true',
      // 'columns%5B0%5D%5Borderable%5D': 'true',
      // 'columns%5B0%5D%5Bsearch%5D%5Bvalue%5D': '',
      // 'columns%5B0%5D%5Bsearch%5D%5Bregex%5D': 'false',
      // 'columns%5B1%5D%5Bdata%5D': 'employee_id',
      // 'columns%5B1%5D%5Bname%5D': '',
      // 'columns%5B1%5D%5Bsearchable%5D': 'true',
      // 'columns%5B1%5D%5Borderable%5D': 'true',
      // 'columns%5B1%5D%5Bsearch%5D%5Bvalue%5D': '',
      // 'columns%5B1%5D%5Bsearch%5D%5Bregex%5D': 'false',
      // 'columns%5B2%5D%5Bdata%5D': 'name',
      // 'columns%5B2%5D%5Bname%5D': 'name',
      // 'columns%5B2%5D%5Bsearchable%5D': 'true',
      // 'columns%5B2%5D%5Borderable%5D': 'true',
      // 'columns%5B2%5D%5Bsearch%5D%5Bvalue%5D': '',
      // 'columns%5B2%5D%5Bsearch%5D%5Bregex%5D': 'false',
      // 'columns%5B3%5D%5Bdata%5D': 'registered',
      // 'columns%5B3%5D%5Bname%5D': 'registered',
      // 'columns%5B3%5D%5Borderable%5D': 'true',
      // 'columns%5B3%5D%5Bsearch%5D%5Bvalue%5D': '',
      // 'columns%5B3%5D%5Bsearch%5D%5Bregex%5D': 'false',
      // 'columns%5B4%5D%5Bdata%5D': 'roles',
      // 'columns%5B4%5D%5Bname%5D': '',
      // 'columns%5B4%5D%5Bsearchable%5D': 'true',
      // 'columns%5B4%5D%5Borderable%5D': 'true',
      // 'columns%5B4%5D%5Bsearch%5D%5Bvalue%5D': '',
      // 'columns%5B4%5D%5Bsearch%5D%5Bregex%5D': 'false',
      // 'columns%5B5%5D%5Bdata%5D': 'status',
      // 'columns%5B5%5D%5Bname%5D': '',
      // 'columns%5B5%5D%5Bsearchable%5D': 'true',
      // 'columns%5B5%5D%5Borderable%5D': 'true',
      // 'columns%5B5%5D%5Bsearch%5D%5Bvalue%5D': '',
      // 'columns%5B5%5D%5Bsearch%5D%5Bregex%5D': 'false',
      // 'columns%5B6%5D%5Bdata%5D': 'action',
      // 'columns%5B6%5D%5Bname%5D': '',
      // 'columns%5B6%5D%5Bsearchable%5D': 'false',
      // 'columns%5B6%5D%5Borderable%5D': 'false',
      // 'columns%5B6%5D%5Bsearch%5D%5Bvalue%5D': '',
      // 'columns%5B6%5D%5Bsearch%5D%5Bregex%5D': 'false',
      'order%5B0%5D%5Bcolumn%5D': '0',
      'order%5B0%5D%5Bdir%5D': 'DESC',
      'start': '0',
      'length': '-1',
      'search%5Bvalue%5D': '',
      'search%5Bregex%5D': 'false'
    };

    isLoading.value = true;
    try {
      var response = await GetRequests.getEmployees(requestBody);
      if (response != null) {
        if (response.data != null) {
          employees.assignAll(response.data as Iterable<EmployeeModel>);
          responsiblePerson.value = null;
          participants.clear();
          observers.clear();
          setTaskConcernedPeople();
        }
      } else {
        Get.snackbar("error".tr, "message_server_error".tr);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void setTaskConcernedPeople() {
    var employee = employees.firstWhereOrNull((employee) =>
        employee.id != null && employee.id == taskDetail.value!.assignedTo);
    if (employee != null) {
      responsiblePerson.value = employee;
    }

    List<int>? participantsIds;
    if (taskDetail.value!.participants != null &&
        taskDetail.value!.participants!.isNotEmpty) {
      participantsIds = convertStringToIntList(taskDetail.value!.participants!);
    }
    if (participantsIds != null && participantsIds.isNotEmpty) {
      for (var participantId in participantsIds) {
        var employee = employees
            .firstWhereOrNull((employee) => employee.id == participantId);
        if (employee != null) {
          participants.add(employee);
        }
      }
    }

    List<int>? observersIds;
    if (taskDetail.value!.observers != null &&
        taskDetail.value!.observers!.isNotEmpty) {
      observersIds = convertStringToIntList(taskDetail.value!.observers!);
    }
    if (observersIds != null && observersIds.isNotEmpty) {
      for (var observerId in observersIds) {
        var employee =
            employees.firstWhereOrNull((employee) => employee.id == observerId);
        if (employee != null) {
          observers.add(employee);
        }
      }
    }
  }

  List<int> convertStringToIntList(String input) {
    String trimmedInput = input.replaceAll(RegExp(r'[\[\]]'), '');

    if (trimmedInput.isEmpty) {
      return [];
    }

    List<int> intList =
        trimmedInput.split(',').map((e) => int.parse(e.trim())).toList();

    return intList;
  }

  void handleDriveOnTap() {
    if (taskDetail.value != null) {
      Get.toNamed(AppRoutes.routeDriveDetail, arguments: {
        AppConsts.keyDriveURL: taskDetail.value!.drive,
      });
    }
  }

  void handleCommentOnEdit(int commentId) {
    for (var comment in comments) {
      if (comment != null) {
        comment.isEditing.value = false;
      }
    }
    var editComment = comments.firstWhereOrNull(
        (comment) => comment != null && comment.id == commentId);
    if (editComment != null) {
      editComment.isEditing.value = true;
      editComment.editController!.text =
          Helpers.cleanHtml(editComment.comment ?? "").substring(
              1, Helpers.cleanHtml(editComment.comment ?? "").length - 1);
      if (editComment.editController!.text.isNotEmpty) {
        editComment.showTextFieldSuffix.value = true;
      } else {
        editComment.showTextFieldSuffix.value = false;
      }
      editComment.focusNode.requestFocus();
    }
  }

  Future<void> deleteComment(int commentId) async {
    Get.back();
    if (taskId != null) {
      Map<String, dynamic> requestBody = {
        'component_id': taskId,
        'component': 'task',
        'id': commentId
      };
      areCommentsLoading.value = true;
      try {
        var response = await PostRequests.deleteTaskComment(requestBody);
        if (response != null) {
          if (response.status == "success") {
            var deleteComment = comments.firstWhereOrNull(
                (comment) => comment != null && comment.id == commentId);
            if (deleteComment != null && deleteComment.editController != null) {
              deleteComment.editController!.dispose();
              deleteComment.editController = null;
            }
            commentsLength.value -= 1;
            commentsLength.refresh();
            commentsPage = 1;
            commentsRefreshNeeded = true;
            getComments();
          } else {
            Get.snackbar("error".tr, "message_server_error".tr);
          }
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } finally {
        areCommentsLoading.value = false;
      }
    }
  }

  void refreshPreviousPageData() {
    TasksListingController? tasksListingController;
    try {
      tasksListingController = Get.find<TasksListingController>();
    } catch (e) {
      Helpers.printLog(
          description: "TASK_DETAIL_CONTROLLER_REFRESH_PREVIOUS_PAGE_DATA",
          message: "COULD_NOT_FIND_TASKS_LISTING_CONTROLLER");
    }
    if (tasksListingController != null) {
      tasksListingController.getTasks();
    }

    GlobalSearchController? globalSearchController;
    try {
      globalSearchController = Get.find<GlobalSearchController>();
    } catch (e) {
      Helpers.printLog(
          description: "TASK_DETAIL_CONTROLLER_REFRESH_PREVIOUS_PAGE_DATA",
          message: "COULD_NOT_FIND_GLOBAL_SEARCH_CONTROLLER");
    }
    if (globalSearchController != null) {
      globalSearchController.searchGlobally();
    }
  }

  Future<void> deleteTask() async {
    Get.back();
    if (taskId != null) {
      isLoading.value = true;
      try {
        var response = await GetRequests.deleteTask(taskId!);
        if (response != null) {
          if (response.status == "success") {
            Helpers.printLog(
              description: "TASK_DETAIL_CONTROLLER_DELETE_TASK",
              message: "PREVIOUS_ROUTE = ${Get.previousRoute}",
            );
            Get.back();
            refreshPreviousPageData();
          } else {
            Get.snackbar("error".tr, "message_server_error".tr);
          }
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } finally {
        isLoading.value = false;
      }
    }
  }

  void handleCommentOnDelete(int commentId) {
    FocusManager.instance.primaryFocus?.unfocus();
    for (var comment in comments) {
      if (comment != null) {
        comment.isEditing.value = false;
      }
    }
    CommonAlertDialog.showDialog(
      message: "message_comment_delete_confirmation",
      positiveText: "yes",
      positiveBtnCallback: () async {
        deleteComment(commentId);
      },
      isShowNegativeBtn: true,
      negativeText: 'no',
    );
  }

  void handleOnDelete() {
    CommonAlertDialog.showDialog(
      message: "message_task_delete_confirmation",
      positiveText: "yes",
      positiveBtnCallback: () async {
        deleteTask();
      },
      isShowNegativeBtn: true,
      negativeText: 'no',
    );
  }
}
