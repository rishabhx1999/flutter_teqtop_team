import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teqtop_team/controllers/tasks_listing/tasks_listing_controller.dart';
import 'package:teqtop_team/model/employees_listing/employee_model.dart';
import 'package:teqtop_team/model/global_search/task_model.dart';
import 'package:teqtop_team/model/media_content_model.dart';
import 'package:teqtop_team/utils/helpers.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

import '../../config/app_routes.dart';
import '../../consts/app_consts.dart';
import '../../model/dashboard/comment_list.dart';
import '../../network/get_requests.dart';
import '../../network/post_requests.dart';
import '../../utils/permission_handler.dart';
import '../../utils/preference_manager.dart';
import '../../views/bottom_sheets/task_comments_bottom_sheet.dart';
import '../../views/dialogs/common/common_alert_dialog.dart';
import '../../views/widgets/common/common_multimedia_content_create_widget.dart';
import '../global_search/global_search_controller.dart';

class TaskDetailController extends GetxController {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int? taskId;
  late TextEditingController commentFieldTextController;
  RxBool areCommentsLoading = false.obs;
  RxBool isCommentCreateEditLoading = false.obs;
  RxBool isLoading = false.obs;
  Rx<TaskModel?> taskDetail = Rx<TaskModel?>(null);
  RxList<CommentList?> comments = <CommentList>[].obs;
  CommentList? editCommentPreviousValue;
  int? editCommentIndex;
  List<EmployeeModel> employees = <EmployeeModel>[];
  Rx<EmployeeModel?> responsiblePerson = Rx<EmployeeModel?>(null);
  RxList<EmployeeModel?> participants = <EmployeeModel?>[].obs;
  RxList<EmployeeModel?> observers = <EmployeeModel?>[].obs;
  RxInt commentsLength = 0.obs;

  // int commentsPage = 1;
  final ScrollController commentsSheetScrollController = ScrollController();
  RxBool isEditingComment = false.obs;
  bool commentsRefreshNeeded = false;
  FocusNode? commentFieldTextFocusNode;
  late ImagePicker _imagePicker;
  RxList<MediaContentModel> commentFieldContent = <MediaContentModel>[].obs;
  RxBool isCommentFieldTextEmpty = true.obs;
  int? commentFieldContentItemsInsertAfterIndex;
  int? commentFieldContentEditIndex;
  late FilePicker _filePicker;
  RxList<MediaContentModel> descriptionItems = <MediaContentModel>[].obs;
  BuildContext? taskDetailPageContext;
  RxBool showCreateCommentWidget = false.obs;
  bool shouldCommentsSheetScrollerJumpToPrevious = true;
  FocusNode wholePageFocus = FocusNode();

  @override
  void onInit() {
    initializeTextEditingController();
    initializeCommentFieldTextFocusNode();
    getTaskId();
    addListenerToScrollController();
    initializeImagePicker();
    initializeFilePicker();

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
    disposeCommentFieldTextFocusNode();
    wholePageFocus.dispose();
    super.onClose();
  }

  Future<void> onTapDescriptionImage(int itemIndex) async {
    List<String> images = [];
    for (var item in descriptionItems) {
      if (item.imageString != null && item.downloadedImage != null) {
        images.add(item.imageString!);
      }
    }
    String? tappedImageString = descriptionItems[itemIndex].imageString;
    int? imageIndex;
    if (tappedImageString != null) {
      imageIndex = images.indexOf(tappedImageString);
    }
    Get.toNamed(AppRoutes.routeGallery, arguments: {
      AppConsts.keyImagesURLS: images,
      AppConsts.keyIndex: imageIndex,
    });
  }

  void initializeFilePicker() {
    _filePicker = FilePicker.platform;
  }

  void initializeImagePicker() {
    _imagePicker = ImagePicker();
  }

  void onCommentFieldTextChange(String value) {
    if (value.isEmpty) {
      isCommentFieldTextEmpty.value = true;
    } else {
      isCommentFieldTextEmpty.value = false;
    }
  }

  void initializeCommentFieldTextFocusNode() {
    commentFieldTextFocusNode = FocusNode();
  }

  void disposeCommentFieldTextFocusNode() {
    if (commentFieldTextFocusNode != null) {
      commentFieldTextFocusNode!.dispose();
    }
  }

  void addListenerToScrollController() {
    commentsSheetScrollController.addListener(() {
      if (commentsSheetScrollController.position.pixels ==
          commentsSheetScrollController.position.maxScrollExtent) {
        getComments();
      }
      showCreateCommentWidget.value = false;
    });
  }

  void clickImage() async {
    var havePermission = await PermissionHandler.requestCameraPermission();
    if (havePermission) {
      // Helpers.printLog(description: "TASK_DETAIL_CONTROLLER_CLICK_IMAGE");
      var image = await _imagePicker.pickImage(source: ImageSource.camera);
      if (image != null) {
        // Helpers.printLog(
        //     description: "TASK_DETAIL_CONTROLLER_CLICK_IMAGE",
        //     message: "IMAGE_NOT_NULL");
        if (commentFieldContentItemsInsertAfterIndex == null) {
          commentFieldContent.add(MediaContentModel(image: image));
        } else {
          commentFieldContent.insert(
              commentFieldContentItemsInsertAfterIndex! + 1,
              MediaContentModel(image: image));
        }
        commentFieldContentItemsInsertAfterIndex = null;
      }
      // handlePostButtonEnable();
    }
  }

  void pickImages() async {
    var images = await _imagePicker.pickMultiImage();
    if (images.isNotEmpty) {
      for (var image in images) {
        if (commentFieldContentItemsInsertAfterIndex == null) {
          commentFieldContent.add(MediaContentModel(image: image));
        } else {
          commentFieldContent.insert(
              commentFieldContentItemsInsertAfterIndex! + 1,
              MediaContentModel(image: image));
          commentFieldContentItemsInsertAfterIndex =
              commentFieldContentItemsInsertAfterIndex! + 1;
        }
      }
      commentFieldContentItemsInsertAfterIndex = null;
    }
    // handlePostButtonEnable();
  }

  void pickDocuments() async {
    var files = await _filePicker.pickFiles(allowMultiple: true);
    if (files == null) return;

    for (var file in files.files) {
      if (file.path == null) continue;

      var mediaContent = (file.extension != null &&
              ['jpg', 'jpeg', 'png'].contains(file.extension!.toLowerCase()))
          ? MediaContentModel(image: XFile(file.path!))
          : MediaContentModel(file: file);

      if (commentFieldContentItemsInsertAfterIndex == null) {
        commentFieldContent.add(mediaContent);
      } else {
        commentFieldContentItemsInsertAfterIndex =
            commentFieldContentItemsInsertAfterIndex! + 1;
        commentFieldContent.insert(
            commentFieldContentItemsInsertAfterIndex!, mediaContent);
      }
    }
    commentFieldContentItemsInsertAfterIndex = null;
  }

  void disposeScrollController() {
    commentsSheetScrollController.dispose();
  }

  void initializeTextEditingController() {
    commentFieldTextController = TextEditingController();
  }

  void disposeTextEditingController() {
    commentFieldTextController.dispose();
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
            String? html = response.task!.description;
            if (html != null && html.isNotEmpty) {
              var items = await Helpers.convertHTMLToMultimediaContent(html);
              descriptionItems.assignAll(items);
              for (var item in descriptionItems) {
                if (item.imageString != null && item.imageString!.isNotEmpty) {
                  // Helpers.printLog(
                  //     description: "TASK_DETAIL_CONTROLLER_GET_TASK_DETAIL",
                  //     message: "IMAGE_STRING = ${item.imageString}");
                  if (Helpers.isBase64DataUrl(item.imageString!)) {
                    item.downloadedImage =
                        await Helpers.convertDataUrlToFile(item.imageString!);
                  } else {
                    item.downloadedImage = await Helpers.downloadFile(
                        AppConsts.imgInitialUrl + item.imageString!,
                        item.imageString!.split("/").last);
                  }
                }
                // Helpers.printLog(
                //     description: "COMMENT_WIDGET_GET_COMMENT_ITEMS",
                //     message: "ITEM = ${item.toString()}");
              }
            }
            getEmployees();
            commentsLength.value = taskDetail.value!.commentsCount ?? 0;
            openComments();
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
    double? previousOffset;
    int commentsPerPage = 10;
    int maxPage = (commentsLength.value / commentsPerPage).ceil();
    int commentsPage = (comments.length / commentsPerPage).ceil() + 1;
    if (commentsRefreshNeeded == true) {
      commentsPage = 1;
    }
    // Helpers.printLog(
    //     description: "TASK_DETAIL_CONTROLLER_GET_COMMENTS",
    //     message: "COMMENTS_PAGE = $commentsPage ===== MAX_PAGE = $maxPage");

    if (taskId != null &&
        (commentsPage <= maxPage || commentsRefreshNeeded == true)) {
      if (commentsSheetScrollController.hasClients) {
        previousOffset = commentsSheetScrollController.offset;
      }
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

            Set<int?> existingCommentIds = comments.map((c) => c?.id).toSet();

            List newComments = response.comments!
                .where((c) => !existingCommentIds.contains(c?.id))
                .toList();

            comments.addAll(newComments as Iterable<CommentList?>);
            for (var comment in comments) {
              if (comment != null && comment.commentItems.isEmpty) {
                String? html = comment.comment;
                if (html != null && html.isNotEmpty) {
                  var items =
                      await Helpers.convertHTMLToMultimediaContent(html);
                  comment.commentItems.assignAll(items);
                  for (var item in comment.commentItems) {
                    if (item.imageString != null &&
                        item.imageString!.isNotEmpty) {
                      item.downloadedImage = await Helpers.downloadFile(
                          AppConsts.imgInitialUrl + item.imageString!,
                          item.imageString!.split("/").last);
                    }
                    // Helpers.printLog(
                    //     description: "COMMENT_WIDGET_GET_COMMENT_ITEMS",
                    //     message: "ITEM = ${item.toString()}");
                  }
                }
              }
            }

            if (editCommentPreviousValue != null && editCommentIndex != null) {
              comments.removeAt(editCommentIndex!);
            }

            for (var comment in newComments) {
              comment.editController = TextEditingController();
            }
            if (previousOffset != null &&
                shouldCommentsSheetScrollerJumpToPrevious == true) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                commentsSheetScrollController.jumpTo(previousOffset!);
              });
            }

            comments.refresh();
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
    // for (var comment in comments) {
    //   if (comment != null) {
    //     comment.isEditing.value = false;
    //   }
    // }
    if (commentFieldContent.isNotEmpty) {
      isCommentCreateEditLoading.value = true;
      String htmlComment =
          await Helpers.convertMultimediaContentToHTML(commentFieldContent);
      // Helpers.printLog(
      //     description: "TASK_DETAIL_CONTROLLER_CREATE_COMMENT",
      //     message: "CONVERTED_COMMENT = $htmlComment");
      try {
        if (htmlComment.isNotEmpty && taskId != null) {
          Map<String, dynamic> requestBody = {
            'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
                as String?,
            'component_id': taskId,
            'component': 'task',
            'comment': '"$htmlComment"'
          };
          var response = await PostRequests.createTaskComment(requestBody);
          if (response != null) {
            if (response.latestComment != null) {
              response.latestComment!.editController = TextEditingController();
              comments.add(response.latestComment);
              commentFieldTextController.clear();
              commentFieldContent.clear();
              isCommentFieldTextEmpty.value = true;
              commentsLength.value += 1;
              commentsLength.refresh();
              commentsRefreshNeeded = true;
              comments.clear();

              shouldCommentsSheetScrollerJumpToPrevious = false;
              await getComments();
              commentsSheetScrollController.animateTo(
                0.0,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            } else {
              Get.snackbar("error".tr, "message_server_error".tr);
            }
          } else {
            Get.snackbar("error".tr, "message_server_error".tr);
          }
        }
      } finally {
        isCommentCreateEditLoading.value = false;
        shouldCommentsSheetScrollerJumpToPrevious = true;
      }
    }
  }

  Future<void> onTapCommentImage(int commentId, int itemIndex) async {
    var comment = comments.firstWhereOrNull(
        (comment) => comment != null && comment.id == commentId);
    if (comment == null) return;
    List<String> images = [];
    for (var item in comment.commentItems) {
      if (item.imageString != null && item.downloadedImage != null) {
        images.add(item.imageString!);
      }
    }
    String? tappedImageString = comment.commentItems[itemIndex].imageString;
    int? imageIndex;
    if (tappedImageString != null) {
      imageIndex = images.indexOf(tappedImageString);
    }
    Get.toNamed(AppRoutes.routeGallery, arguments: {
      AppConsts.keyImagesURLS: images,
      AppConsts.keyIndex: imageIndex,
    });
  }

  Future<void> editComment() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (taskId != null &&
        editCommentPreviousValue != null &&
        editCommentPreviousValue!.id != null &&
        editCommentIndex != null &&
        commentFieldContent.isNotEmpty) {
      isCommentCreateEditLoading.value = true;
      try {
        String htmlComment =
            await Helpers.convertMultimediaContentToHTML(commentFieldContent);
        if (htmlComment.isNotEmpty) {
          Map<String, dynamic> requestBody = {
            'component_id': taskId,
            'component': 'task',
            'comment': htmlComment,
            'id': editCommentPreviousValue!.id
          };
          var response = await PostRequests.editTaskComment(requestBody);
          if (response != null) {
            if (response.status == "true") {
              editCommentPreviousValue!.comment = htmlComment;
              String? html = editCommentPreviousValue!.comment;
              if (html != null && html.isNotEmpty) {
                var items = await Helpers.convertHTMLToMultimediaContent(html);
                editCommentPreviousValue!.commentItems.assignAll(items);
                for (var item in editCommentPreviousValue!.commentItems) {
                  if (item.imageString != null &&
                      item.imageString!.isNotEmpty) {
                    item.downloadedImage = await Helpers.downloadFile(
                        AppConsts.imgInitialUrl + item.imageString!,
                        item.imageString!.split("/").last);
                  }
                  // Helpers.printLog(
                  //     description: "COMMENT_WIDGET_GET_COMMENT_ITEMS",
                  //     message: "ITEM = ${item.toString()}");
                }
              }
            } else {
              Get.snackbar("error".tr, "message_server_error".tr);
            }
          } else {
            Get.snackbar("error".tr, "message_server_error".tr);
          }
        }
      } finally {
        comments.insert(editCommentIndex!, editCommentPreviousValue);
        editCommentPreviousValue = null;
        commentFieldContent.clear();
        isEditingComment.value = false;
        isCommentCreateEditLoading.value = false;
        editCommentIndex = null;
        // editComment.isEditing.value = false;
        comments.refresh();
        commentFieldTextController.clear();
        isCommentFieldTextEmpty.value = true;
      }
    }
  }

  Future<String?> uploadFile(String filePath, String? fileType) async {
    var uploadMedia = await http.MultipartFile.fromPath('data_file', filePath);
    Map<String, dynamic> requestBody = {
      'token':
          PreferenceManager.getPref(PreferenceManager.prefUserToken) as String?,
      'extension': fileType ?? '',
      'data_file': '(binary)',
      '_comp': 'feed',
      'format': 'application'
    };
    var response = await PostRequests.uploadFile(uploadMedia, requestBody);
    if (response != null) {
      return response.src;
    } else {
      Get.snackbar('error'.tr, 'message_server_error'.tr);
    }
    return null;
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

  void handleKeyOnTap() {
    if (taskDetail.value != null) {
      int? projectId;
      if (taskDetail.value!.project is int?) {
        projectId = taskDetail.value!.project;
      }
      if (taskDetail.value!.project is String?) {
        projectId = int.parse(taskDetail.value!.project);
      }
      Get.toNamed(AppRoutes.routeProjectDetail, arguments: {
        AppConsts.keyProjectId: projectId,
      });
    }
  }

  Future<void> handleCommentOnEdit(int commentId) async {
    // for (var comment in comments) {
    //   if (comment != null) {
    //     comment.isEditing.value = false;
    //   }
    // }
    if (editCommentPreviousValue != null && editCommentIndex != null) {
      comments.insert(editCommentIndex!, editCommentPreviousValue);
      comments.refresh();
    }
    var editComment = comments.firstWhereOrNull(
        (comment) => comment != null && comment.id == commentId);
    editCommentPreviousValue = editComment;
    isEditingComment.value = true;
    editCommentIndex = comments.indexOf(editComment);
    comments.remove(editComment);
    if (editComment != null) {
      // editComment.isEditing.value = true;
      commentFieldContent.clear();
      commentFieldTextController.clear();
      isCommentFieldTextEmpty.value = true;
      commentFieldContentItemsInsertAfterIndex = null;
      commentFieldContentEditIndex = null;
      if (editComment.comment != null) {
        // Helpers.printLog(
        //     description: "TASK_DETAIL_CONTROLLER_HANDLE_COMMENT_ON_EDIT",
        //     message: "CURRENT_COMMENT = ${editComment.comment}");
        var editCommentItems =
            await Helpers.convertHTMLToMultimediaContent(editComment.comment!);
        commentFieldContent.assignAll(editCommentItems);
        showCreateCommentWidget.value = true;
        // commentFieldTextController.text =
        //     Helpers.cleanHtml(editComment.comment ?? "").substring(
        //         1, Helpers.cleanHtml(editComment.comment ?? "").length - 1);
        // if (editComment.editController!.text.isNotEmpty) {
        //   editComment.showTextFieldSuffix.value = true;
        // } else {
        //   editComment.showTextFieldSuffix.value = false;
        // }
        // editComment.focusNode.requestFocus();
        commentFieldTextFocusNode!.requestFocus();
      }
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
            commentsRefreshNeeded = true;
            comments.clear();
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
      // Helpers.printLog(
      //     description: "TASK_DETAIL_CONTROLLER_REFRESH_PREVIOUS_PAGE_DATA",
      //     message: "COULD_NOT_FIND_TASKS_LISTING_CONTROLLER");
    }
    if (tasksListingController != null) {
      tasksListingController.getTasks();
    }

    GlobalSearchController? globalSearchController;
    try {
      globalSearchController = Get.find<GlobalSearchController>();
    } catch (e) {
      // Helpers.printLog(
      //     description: "TASK_DETAIL_CONTROLLER_REFRESH_PREVIOUS_PAGE_DATA",
      //     message: "COULD_NOT_FIND_GLOBAL_SEARCH_CONTROLLER");
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
            // Helpers.printLog(
            //   description: "TASK_DETAIL_CONTROLLER_DELETE_TASK",
            //   message: "PREVIOUS_ROUTE = ${Get.previousRoute}",
            // );
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

  void addTextInCommentContent() {
    if (commentFieldTextController.text.isEmpty) return;

    final newItem = MediaContentModel(text: commentFieldTextController.text);

    if (commentFieldContentEditIndex != null) {
      commentFieldContent.insert(commentFieldContentEditIndex!, newItem);
    } else {
      final insertIndex = (commentFieldContentItemsInsertAfterIndex != null)
          ? commentFieldContentItemsInsertAfterIndex! + 1
          : commentFieldContent.length;
      commentFieldContent.insert(insertIndex, newItem);
    }
    commentFieldContentEditIndex = null;
    commentFieldContentItemsInsertAfterIndex = null;
    commentFieldTextController.clear();
    isCommentFieldTextEmpty.value = true;
  }

  void removeCommentContentItem(MediaContentModel item) {
    commentFieldContent.remove(item);
  }

  void initializeAddingInBetweenCommentContent(int index) {
    commentFieldContentItemsInsertAfterIndex = index;
    Get.snackbar("Success", "Adding in between");
  }

  void editCommentContentText(int index) {
    if (commentFieldContent[index].text != null &&
        commentFieldContent[index].text!.isNotEmpty) {
      commentFieldTextController.clear();
      commentFieldTextController.text = commentFieldContent[index].text!;
      commentFieldContent.removeAt(index);
      commentFieldContentEditIndex = index;
    }
  }

  void openComments() async {
    if (taskDetailPageContext != null) {
      editCommentPreviousValue = null;
      isEditingComment.value = false;
      editCommentIndex = null;
      commentFieldTextController.clear();
      isCommentFieldTextEmpty.value = true;
      commentFieldContentItemsInsertAfterIndex = null;
      commentFieldContentEditIndex = null;
      commentFieldContent.clear();
      if (commentFieldTextFocusNode != null) {
        commentFieldTextFocusNode!.dispose();
        commentFieldTextFocusNode = null;
      }
      commentFieldTextFocusNode = FocusNode();
      showCreateCommentWidget.value = false;
      await getComments();
      TaskCommentsBottomSheet.show(
        context: taskDetailPageContext!,
        createCommentWidget: CommonMultimediaContentCreateWidget(
          textController: commentFieldTextController,
          hint: 'enter_text'.tr,
          createComment: createComment,
          isEditingComment: isEditingComment,
          editComment: editComment,
          isTextFieldEmpty: isCommentFieldTextEmpty,
          onTextChanged: onCommentFieldTextChange,
          contentItems: commentFieldContent,
          clickImage: clickImage,
          pickImages: pickImages,
          addText: addTextInCommentContent,
          removeContentItem: removeCommentContentItem,
          addContentAfter: initializeAddingInBetweenCommentContent,
          pickFiles: pickDocuments,
          editText: editCommentContentText,
          showCreateEditButton: true,
          showShadow: true,
          borderRadius: BorderRadius.circular(10),
          backgroundColor: Colors.white,
          textFieldBackgroundColor: Colors.grey.withValues(alpha: 0.1),
          isCreateOrEditLoading: isCommentCreateEditLoading,
          focusNode: commentFieldTextFocusNode,
        ),
        comments: comments,
        commentCount: commentsLength,
        areCommentsLoading: areCommentsLoading,
        scrollController: commentsSheetScrollController,
        handleCommentOnEdit: handleCommentOnEdit,
        handleCommentOnDelete: handleCommentOnDelete,
        createCommentTextFieldFocusNode: commentFieldTextFocusNode!,
        showCreateCommentWidget: showCreateCommentWidget,
        handleCommentImageOnTap: onTapCommentImage,
      );
    }
  }
}
