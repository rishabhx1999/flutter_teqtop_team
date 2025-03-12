import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teqtop_team/model/dashboard/comment_count.dart';
import 'package:teqtop_team/model/dashboard/comment_list.dart';
import 'package:teqtop_team/model/dashboard/like_user.dart';
import 'package:teqtop_team/model/dashboard/notification_model.dart';
import 'package:teqtop_team/model/dashboard/user_model.dart';
import 'package:teqtop_team/network/get_requests.dart';
import 'package:teqtop_team/network/post_requests.dart';
import 'package:teqtop_team/utils/helpers.dart';
import 'package:teqtop_team/utils/permission_handler.dart';
import 'package:teqtop_team/views/dialogs/employees_dialog.dart';

import '../../config/app_routes.dart';
import '../../consts/app_consts.dart';
import '../../model/dashboard/feed_model.dart';
import '../../model/employees_listing/employee_model.dart';
import '../../model/media_content_model.dart';
import '../../utils/preference_manager.dart';
import '../../views/dialogs/common/common_alert_dialog.dart';

class DashboardController extends GetxController
    with GetTickerProviderStateMixin {
  FocusNode? commentFieldTextFocusNode;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late HtmlEditorController createPostHtmlEditorController;
  late HtmlEditorController commentFieldHtmlEditorController;
  RxString createPostHtmlEditorContent = "<p></p>".obs;
  RxList<String> createPostAttachedImages = <String>[].obs;
  RxList<String> createPostAttachedDocuments = <String>[].obs;
  RxList<String> commentFieldAttachedImages = <String>[].obs;
  RxList<String> commentFieldAttachedDocuments = <String>[].obs;
  RxString commentFieldHtmlEditorHtmlContent = "<p></p>".obs;
  RxBool isCommentFieldTextEmpty = true.obs;
  RxBool isPostFieldTextEmpty = true.obs;
  RxBool isPostButtonEnable = false.obs;
  late ImagePicker _imagePicker;
  late ImagePicker _commentImagePicker;
  late FilePicker _filePicker;
  late FilePicker _commentFilePicker;
  RxBool arePostsLoading = false.obs;
  RxBool areMorePostsLoading = false.obs;
  RxBool areCommentsLoading = false.obs;
  RxList<FeedModel?> posts = <FeedModel>[].obs;
  FeedModel? editPostPreviousValue;
  int? editPostIndex;
  Rx<UserModel?> loggedInUser = Rx<UserModel?>(null);
  final ScrollController scrollController = ScrollController();
  final ScrollController commentsSheetScrollController = ScrollController();
  int feedPage = 1;
  RxBool isPostCreateEditLoading = false.obs;
  RxBool isCommentCreateLoading = false.obs;
  RxBool areCreateEditPostFilesLoading = false.obs;
  RxBool areCommentFieldFilesLoading = false.obs;

  // RxList<EmployeeModel?> employees = <EmployeeModel>[].obs;
  RxInt notificationsCount = 0.obs;
  List<NotificationModel?> notifications = <NotificationModel>[];
  RxBool isEditPost = false.obs;
  int? editPostId;
  RxList<CommentList?> singlePostComments = <CommentList>[].obs;

  // int singlePostCommentsPage = 1;
  int? currentCommentsPostID;
  RxInt currentCommentsLength = 0.obs;
  bool currentCommentsRefreshNeeded = false;
  RxList<MediaContentModel> commentFieldContent = <MediaContentModel>[].obs;
  RxList<MediaContentModel> postFieldContent = <MediaContentModel>[].obs;
  int? commentFieldContentItemsInsertAfterIndex;
  int? postFieldContentItemsInsertAfterIndex;
  int? commentFieldContentEditIndex;
  int? postFieldContentEditIndex;
  RxBool showCreateCommentWidget = false.obs;
  RxBool showCreateEditPostWidget = false.obs;
  bool shouldCommentsSheetScrollerJumpToPrevious = true;
  Timer? createPostContentTimer;
  Timer? commentFieldContentTimer;
  double commentsListPreviousOffset = 0;
  final TextEditingController employeesSearchTextController =
      TextEditingController();
  RxBool showEmployeesSearchFieldTrailing = false.obs;
  late Worker employeesSearchTextChangeListenerWorker;
  RxBool areEmployeesLoading = false.obs;
  RxList<EmployeeModel?> employees = <EmployeeModel>[].obs;
  FocusNode? searchEmployeesFieldFocusNode;

  @override
  void onInit() {
    initializeCommentFieldTextFocusNode();
    initializeHtmlEditorControllers();
    initializeImagePicker();
    initializeCommentImagePicker();
    initializeFilePicker();
    getLoggedInUser();
    getPosts();
    addListenerToScrollControllers();
    getNotifications();
    initializeCommentFilePicker();
    setupEmployeesSearchTextChangeListener();
    getEmployees('');

    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    disposeCommentFieldTextFocusNode();
    disposeTextEditingControllers();
    disposeScrollControllers();
    if (createPostContentTimer != null) {
      createPostContentTimer!.cancel();
    }
    if (commentFieldContentTimer != null) {
      commentFieldContentTimer!.cancel();
    }
    employeesSearchTextChangeListenerWorker.dispose();
    employeesSearchTextController.dispose();
    super.onClose();
  }

  void setupEmployeesSearchTextChangeListener() {
    RxString searchText = ''.obs;
    employeesSearchTextChangeListenerWorker =
        debounce(searchText, (callback) => getEmployees(searchText.value));

    employeesSearchTextController.addListener(() {
      searchText.value = employeesSearchTextController.text.toString().trim();
    });
  }

  void handleEmployeesSearchTextChange(String text) {
    showEmployeesSearchFieldTrailing.value = text.isNotEmpty;
  }

  void handleClearEmployeesSearchField() {
    employeesSearchTextController.clear();
    showEmployeesSearchFieldTrailing.value = false;
  }

  void handleCreateEditPostEmployeeOnTap(int? id) {
    if (id == null) return;
    var requiredEmployee = employees
        .firstWhereOrNull((employee) => employee != null && employee.id == id);
    if (requiredEmployee == null ||
        requiredEmployee.name == null ||
        requiredEmployee.name!.isEmpty) {
      return;
    }

    requiredEmployee.multiUse.value = true;
    showCreateEditPostWidget.value = false;
    createPostHtmlEditorContent.value = Helpers.mentionPersonInHTML(
        createPostHtmlEditorContent.value,
        requiredEmployee.name!,
        requiredEmployee.id.toString());

    Future.delayed(const Duration(milliseconds: 500), () {
      showCreateEditPostWidget.value = true;
      requiredEmployee.multiUse.value = false;
      Get.back();
    });
  }

  void handleCommentFieldEmployeeOnTap(int? id) {
    if (id == null) return;
    var requiredEmployee = employees
        .firstWhereOrNull((employee) => employee != null && employee.id == id);
    if (requiredEmployee == null ||
        requiredEmployee.name == null ||
        requiredEmployee.name!.isEmpty) {
      return;
    }

    requiredEmployee.multiUse.value = true;
    showCreateCommentWidget.value = false;
    commentFieldHtmlEditorHtmlContent.value = Helpers.mentionPersonInHTML(
        commentFieldHtmlEditorHtmlContent.value,
        requiredEmployee.name!,
        requiredEmployee.id.toString());

    Future.delayed(const Duration(milliseconds: 500), () {
      showCreateCommentWidget.value = true;
      requiredEmployee.multiUse.value = false;
      Get.back();
    });
  }

  Future<void> getEmployees(String searchText) async {
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
      'search%5Bvalue%5D': searchText,
      'search%5Bregex%5D': 'false'
    };

    areEmployeesLoading.value = true;
    try {
      var response = await GetRequests.getEmployees(requestBody);
      if (response != null) {
        if (response.data != null) {
          employees.assignAll(response.data!.toList());
        }
      }
    } finally {
      areEmployeesLoading.value = false;
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

  void onCommentFieldTextChange(String value) {
    if (value.isEmpty) {
      isCommentFieldTextEmpty.value = true;
    } else {
      isCommentFieldTextEmpty.value = false;
    }
  }

  void addListenerToScrollControllers() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        areMorePostsLoading.value = true;
        getMorePosts();
      }
    });
    commentsSheetScrollController.addListener(() {
      if (commentsSheetScrollController.position.pixels ==
          commentsSheetScrollController.position.maxScrollExtent) {
        getComments();
      }
    });
  }

  Future<void> refreshPage() async {
    isEditPost.value = false;
    editPostId = null;
    editPostPreviousValue = null;
    editPostIndex = null;
    postFieldContent.clear();
    createPostHtmlEditorContent.value = "<p></p>";
    createPostAttachedImages.clear();
    createPostAttachedDocuments.clear();
    showCreateEditPostWidget.value = false;
    if (createPostContentTimer != null) {
      createPostContentTimer!.cancel();
    }
    isPostFieldTextEmpty.value = true;
    handlePostButtonEnable();
    postFieldContentItemsInsertAfterIndex = null;
    postFieldContentEditIndex = null;
    posts.clear();
    feedPage = 1;
    getPosts();
    notificationsCount.value = 0;
    getNotifications();
  }

  Future<void> getPosts() async {
    arePostsLoading.value = true;
    arePostsLoading.refresh();
    try {
      Map<String, String> requestBody = {};
      var response = await GetRequests.getPosts(requestBody);
      if (response != null) {
        if (response.feeds != null) {
          posts.assignAll(response.feeds!.toList());
          // for (var post in posts) {
          //   if (post != null && post.feedItems.isEmpty) {
          //     String? html = post.description;
          //     if (html != null && html.isNotEmpty) {
          //       var items = await Helpers.convertHTMLToMultimediaContent(html);
          //       post.feedItems.assignAll(items);
          //       for (var item in post.feedItems) {
          //         if (item.imageString != null &&
          //             item.imageString!.isNotEmpty) {
          //           item.downloadedImage = await Helpers.downloadFile(
          //               AppConsts.imgInitialUrl + item.imageString!,
          //               item.imageString!.split("/").last);
          //         }
          //         // Helpers.printLog(
          //         //     description: "COMMENT_WIDGET_GET_COMMENT_ITEMS",
          //         //     message: "ITEM = ${item.toString()}");
          //       }
          //     }
          //   }
          // }
          if (editPostPreviousValue != null &&
              editPostPreviousValue!.id != null) {
            posts.removeWhere(
                (post) => post != null && post.id == editPostPreviousValue!.id);
          }

          feedPage++;
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } else {
        Get.snackbar("error".tr, "message_server_error".tr);
      }
    } finally {
      arePostsLoading.value = false;
      arePostsLoading.refresh();
    }
  }

  void removeCreatePostAttachedImage(String image) {
    createPostAttachedImages.remove(image);
    createPostAttachedImages.refresh();
  }

  void removeCreatePostAttachedDocument(String document) {
    createPostAttachedDocuments.remove(document);
    createPostAttachedDocuments.refresh();
  }

  void removeCommentFieldAttachedDocument(String document) {
    commentFieldAttachedDocuments.remove(document);
    commentFieldAttachedDocuments.refresh();
  }

  void removeCommentFieldAttachedImage(String image) {
    commentFieldAttachedImages.remove(image);
    commentFieldAttachedImages.refresh();
  }

  Future<void> getMorePosts() async {
    areMorePostsLoading.value = true;
    try {
      Map<String, dynamic> requestBody = {
        'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
            as String?,
        'search': '',
        'page': feedPage.toString(),
      };

      var response = await PostRequests.getMorePosts(requestBody);
      if (response != null) {
        if (response.feeds != null) {
          Set<int?> existingPostIds = posts.map((c) => c?.id).toSet();

          List newPosts = response.feeds!
              .where((c) => !existingPostIds.contains(c?.id))
              .toList();

          posts.addAll(newPosts as Iterable<FeedModel?>);
          // for (var post in posts) {
          //   if (post != null && post.feedItems.isEmpty) {
          //     String? html = post.description;
          //     if (html != null && html.isNotEmpty) {
          //       var items = await Helpers.convertHTMLToMultimediaContent(html);
          //       post.feedItems.assignAll(items);
          //       for (var item in post.feedItems) {
          //         if (item.imageString != null &&
          //             item.imageString!.isNotEmpty) {
          //           item.downloadedImage = await Helpers.downloadFile(
          //               AppConsts.imgInitialUrl + item.imageString!,
          //               item.imageString!.split("/").last);
          //         }
          //         // Helpers.printLog(
          //         //     description: "COMMENT_WIDGET_GET_COMMENT_ITEMS",
          //         //     message: "ITEM = ${item.toString()}");
          //       }
          //     }
          //   }
          // }
          if (editPostPreviousValue != null &&
              editPostPreviousValue!.id != null) {
            posts.removeWhere(
                (post) => post != null && post.id == editPostPreviousValue!.id);
          }
          feedPage++;
        } else {
          // Get.snackbar("error".tr, "message_server_error".tr);
        }
      } else {
        // Get.snackbar("error".tr, "message_server_error".tr);
      }
    } finally {
      areMorePostsLoading.value = false;
      posts.refresh();
    }
  }

  Future<void> getComments() async {
    Helpers.printLog(description: "DASHBOARD_CONTROLLER_GET_COMMENTS");
    int commentsPerPage = 10;
    int maxPage = (currentCommentsLength.value / commentsPerPage).ceil();
    int singlePostCommentsPage =
        (singlePostComments.length / commentsPerPage).ceil() + 1;
    if (currentCommentsRefreshNeeded == true) {
      singlePostCommentsPage = 1;
    }
    // Helpers.printLog(
    //     description: "DASHBOARD_CONTROLLER_GET_COMMENTS",
    //     message:
    //         "COMMENTS_PAGE = $singlePostCommentsPage ===== MAX_PAGE = $maxPage");

    if (singlePostCommentsPage <= maxPage ||
        currentCommentsRefreshNeeded == true) {
      if (commentsSheetScrollController.hasClients &&
          commentsListPreviousOffset == 0) {
        commentsListPreviousOffset = commentsSheetScrollController.offset;
        Helpers.printLog(
            description: "DASHBOARD_CONTROLLER_GET_COMMENTS",
            message:
                "PREVIOUS_OFFSET = ${commentsListPreviousOffset.toString()}");
      }
      areCommentsLoading.value = true;
      try {
        Map<String, dynamic> requestBody = {
          'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
              as String?,
          'component_id': currentCommentsPostID,
          'component': 'feed',
          'pager': singlePostCommentsPage,
        };

        var response = await PostRequests.getComments(requestBody);
        if (response != null) {
          if (response.status == "success") {
            if (response.comments != null) {
              Set<int?> existingCommentIds =
                  singlePostComments.map((c) => c?.id).toSet();

              List newComments = response.comments!
                  .where((c) => !existingCommentIds.contains(c?.id))
                  .toList();

              singlePostComments.addAll(newComments as Iterable<CommentList?>);
              // for (var comment in singlePostComments) {
              //   if (comment != null && comment.commentItems.isEmpty) {
              //     String? html = comment.comment;
              //     if (html != null && html.isNotEmpty) {
              //       var items =
              //           await Helpers.convertHTMLToMultimediaContent(html);
              //       comment.commentItems.assignAll(items);
              //       for (var item in comment.commentItems) {
              //         if (item.imageString != null &&
              //             item.imageString!.isNotEmpty) {
              //           item.downloadedImage = await Helpers.downloadFile(
              //               AppConsts.imgInitialUrl + item.imageString!,
              //               item.imageString!.split("/").last);
              //         }
              //         // Helpers.printLog(
              //         //     description: "COMMENT_WIDGET_GET_COMMENT_ITEMS",
              //         //     message: "ITEM = ${item.toString()}");
              //       }
              //     }
              //   }
              // }

              // for (var comment in newComments) {
              //   comment.editController = TextEditingController();
              // }
              singlePostComments.refresh();
              if (commentsListPreviousOffset != 0 &&
                  shouldCommentsSheetScrollerJumpToPrevious == true) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  commentsSheetScrollController
                      .jumpTo(commentsListPreviousOffset);
                  commentsListPreviousOffset = 0;
                });
              }
            }
          } else {
            Get.snackbar("error".tr, "message_server_error".tr);
          }
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } finally {
        areCommentsLoading.value = false;
        currentCommentsRefreshNeeded = false;
      }
    }
  }

  Future<void> getLoggedInUser() async {
    // Helpers.printLog(description: 'DASHBOARD_CONTROLLER_GET_LOGGED_IN_USER');
    var response = await GetRequests.getLoggedInUserData();
    if (response != null) {
      if (response.user != null) {
        loggedInUser.value = response.user;
        saveProfileDataToPref(response.user!);
      } else {
        Get.snackbar("error".tr, "message_server_error".tr);
      }
    } else {
      Get.snackbar("error".tr, "message_server_error".tr);
    }
  }

  void initializeFilePicker() {
    _filePicker = FilePicker.platform;
  }

  void initializeCommentFilePicker() {
    _commentFilePicker = FilePicker.platform;
  }

  void initializeHtmlEditorControllers() {
    createPostHtmlEditorController = HtmlEditorController();
    commentFieldHtmlEditorController = HtmlEditorController();
  }

  void disposeTextEditingControllers() {
    // createPostTextController.dispose();
    // commentFieldTextController.dispose();
  }

  void disposeScrollControllers() {
    scrollController.dispose();
    commentsSheetScrollController.dispose();
  }

  void handleCreatePostTextChange(String value) {
    handlePostButtonEnable();
  }

  void handlePostButtonEnable() {
    if (postFieldContent.isNotEmpty) {
      isPostButtonEnable.value = true;
    } else {
      isPostButtonEnable.value = false;
    }
  }

  void clickImage() async {
    var havePermission = await PermissionHandler.requestCameraPermission();
    if (havePermission) {
      var image = await _imagePicker.pickImage(source: ImageSource.camera);
      // Helpers.printLog(
      //     description: "DASHBOARD_CONTROLLER_CLICK_IMAGE",
      //     message: "IMAGE_CLICKED = ${image.toString()}");
      areCreateEditPostFilesLoading.value = true;
      if (image != null) {
        String? imageUrl = await Helpers.uploadFile(image.path, null);
        if (imageUrl != null && imageUrl.isNotEmpty) {
          createPostAttachedImages.add(imageUrl);
          createPostAttachedImages.refresh();
        }
        if (postFieldContentItemsInsertAfterIndex == null) {
          postFieldContent.add(MediaContentModel(image: image));
        } else {
          postFieldContent.insert(postFieldContentItemsInsertAfterIndex! + 1,
              MediaContentModel(image: image));
        }
        postFieldContentItemsInsertAfterIndex = null;
      }
      areCreateEditPostFilesLoading.value = false;
      handlePostButtonEnable();
    }
  }

  void pickImages() async {
    var images = await _imagePicker.pickMultiImage();
    areCreateEditPostFilesLoading.value = true;
    if (images.isNotEmpty) {
      for (var image in images) {
        String? imageUrl = await Helpers.uploadFile(image.path, null);
        if (imageUrl != null && imageUrl.isNotEmpty) {
          createPostAttachedImages.add(imageUrl);
          createPostAttachedImages.refresh();
        }
        if (postFieldContentItemsInsertAfterIndex == null) {
          postFieldContent.add(MediaContentModel(image: image));
        } else {
          postFieldContent.insert(postFieldContentItemsInsertAfterIndex! + 1,
              MediaContentModel(image: image));
          postFieldContentItemsInsertAfterIndex =
              postFieldContentItemsInsertAfterIndex! + 1;
        }
      }
      postFieldContentItemsInsertAfterIndex = null;
    }
    areCreateEditPostFilesLoading.value = false;
    handlePostButtonEnable();
  }

  void pickVideos() async {
    var video = await _imagePicker.pickVideo(source: ImageSource.gallery);

    areCreateEditPostFilesLoading.value = true;
    if (video != null) {
      String? videoUrl = await Helpers.uploadFile(video.path, null);
      if (videoUrl != null && videoUrl.isNotEmpty) {
        createPostAttachedDocuments.add(videoUrl);
        createPostAttachedDocuments.refresh();
      }
    }
    areCreateEditPostFilesLoading.value = false;
    handlePostButtonEnable();
  }

  void removePostContentItem(MediaContentModel item) {
    postFieldContent.remove(item);
  }

  void pickDocuments() async {
    var files = await _filePicker.pickFiles(allowMultiple: true);
    if (files == null) return;

    areCreateEditPostFilesLoading.value = true;
    for (var file in files.files) {
      if (file.path == null) continue;
      String? fileUrl = await Helpers.uploadFile(file.path!, file.extension);
      if (fileUrl != null && fileUrl.isNotEmpty) {
        if (Helpers.isImage(fileUrl)) {
          createPostAttachedImages.add(fileUrl);
        } else {
          createPostAttachedDocuments.add(fileUrl);
        }
        createPostAttachedImages.refresh();
        createPostAttachedDocuments.refresh();
      }
    }
    areCreateEditPostFilesLoading.value = false;
    areCreateEditPostFilesLoading.refresh();
    handlePostButtonEnable();
  }

  void editPostContentText(int index) {
    // if (postFieldContent[index].text != null &&
    //     postFieldContent[index].text!.isNotEmpty) {
    //   createPostTextController.clear();
    //   createPostTextController.text = postFieldContent[index].text!;
    //   postFieldContent.removeAt(index);
    //   postFieldContentEditIndex = index;
    // }
  }

  void addTextInPostContent() {
    // if (createPostTextController.text.isEmpty) return;
    //
    // final newItem = MediaContentModel(text: createPostTextController.text);
    //
    // if (postFieldContentEditIndex != null) {
    //   postFieldContent.insert(postFieldContentEditIndex!, newItem);
    // } else {
    //   final insertIndex = (postFieldContentItemsInsertAfterIndex != null)
    //       ? postFieldContentItemsInsertAfterIndex! + 1
    //       : postFieldContent.length;
    //   postFieldContent.insert(insertIndex, newItem);
    // }
    // postFieldContentEditIndex = null;
    // postFieldContentItemsInsertAfterIndex = null;
    // createPostTextController.clear();
    // isPostFieldTextEmpty.value = true;
  }

  void pickCommentDocuments() async {
    var files = await _commentFilePicker.pickFiles(allowMultiple: true);
    if (files == null) return;

    areCommentFieldFilesLoading.value = true;
    for (var file in files.files) {
      if (file.path == null) continue;
      String? fileUrl = await Helpers.uploadFile(file.path!, file.extension);
      if (fileUrl != null && fileUrl.isNotEmpty) {
        if (Helpers.isImage(fileUrl)) {
          commentFieldAttachedImages.add(fileUrl);
        } else {
          commentFieldAttachedDocuments.add(fileUrl);
        }
        commentFieldAttachedImages.refresh();
        commentFieldAttachedDocuments.refresh();
      }

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
    areCommentFieldFilesLoading.value = false;
    commentFieldContentItemsInsertAfterIndex = null;
  }

  void initializeImagePicker() {
    _imagePicker = ImagePicker();
  }

  void saveProfileDataToPref(UserModel loggedInUser) {
    PreferenceManager.saveToPref(
        PreferenceManager.prefUserId, loggedInUser.userId);
    PreferenceManager.saveToPref(
        PreferenceManager.prefUserProfilePhoto, loggedInUser.profile ?? "");
    PreferenceManager.saveToPref(
        PreferenceManager.prefUserName, loggedInUser.name ?? "");
    PreferenceManager.saveToPref(
        PreferenceManager.prefUserEmail, loggedInUser.email ?? "");
    PreferenceManager.saveToPref(
        PreferenceManager.prefUserContactNumber, loggedInUser.contactNo ?? "");
    // Helpers.printLog(
    //     description: "DASHBOARD_CONTROLLER_SAVE_PROFILE_DATA_TO_PREF",
    //     message: "ALTERNATE_NO = ${loggedInUser.alternateNo}");
    PreferenceManager.saveToPref(PreferenceManager.prefUserAlternateNumber,
        loggedInUser.alternateNo ?? "");
    PreferenceManager.saveToPref(PreferenceManager.prefUserCurrentAddress,
        loggedInUser.currentAddress ?? "");
    PreferenceManager.saveToPref(PreferenceManager.prefUserAdditionalInfo,
        loggedInUser.additionalInfo ?? "");
    PreferenceManager.saveToPref(PreferenceManager.prefUserPermanentAddress,
        loggedInUser.permanentAddress ?? "");
    PreferenceManager.saveToPref(
        PreferenceManager.prefUserDateOfBirth, loggedInUser.birthDate ?? "");
    // Helpers.printLog(
    //     description: "DASHBOARD_CONTROLLER_SAVE_PROFILE_DATA_TO_PREF",
    //     message: "DATE_OF_BIRTH = ${loggedInUser.birthDate}");
  }

  void logOut() {
    PreferenceManager.clean();
    PreferenceManager.saveToPref(PreferenceManager.prefIsLogin, false);
    Get.offAllNamed(AppRoutes.routeLogin);
    Get.delete<DashboardController>(force: true);
  }

  void emptyUserPrefData() {
    PreferenceManager.saveToPref(PreferenceManager.prefUserToken, "");
    PreferenceManager.saveToPref(PreferenceManager.prefLoginDate, "");
    PreferenceManager.saveToPref(PreferenceManager.prefUserProfilePhoto, "");
    PreferenceManager.saveToPref(PreferenceManager.prefUserName, "");
    PreferenceManager.saveToPref(PreferenceManager.prefUserEmail, "");
    PreferenceManager.saveToPref(PreferenceManager.prefUserContactNumber, "");
    PreferenceManager.saveToPref(PreferenceManager.prefUserAlternateNumber, "");
    PreferenceManager.saveToPref(PreferenceManager.prefUserCurrentAddress, "");
    PreferenceManager.saveToPref(PreferenceManager.prefUserAdditionalInfo, "");
  }

  void createPost() async {
    // Helpers.printLog(description: "DASHBOARD_CONTROLLER_CREATE_POST");
    FocusManager.instance.primaryFocus?.unfocus();
    isPostCreateEditLoading.value = true;
    isPostCreateEditLoading.refresh();
    try {
      Map<String, dynamic> requestBody = {
        'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
            as String?,
        'feed': await createPostHtmlEditorController.getText(),
        'files': [...createPostAttachedImages, ...createPostAttachedDocuments]
      };
      var response = await PostRequests.createPost(requestBody);
      if (response != null && response.status == "success") {
        createPostHtmlEditorContent.value = "<p></p>";
        createPostAttachedImages.clear();
        createPostAttachedDocuments.clear();
        postFieldContent.clear();
        isPostFieldTextEmpty.value = true;
        showCreateEditPostWidget.value = false;

        handlePostButtonEnable();
        posts.clear();
        feedPage = 1;
        getPosts();
      } else {
        Get.snackbar('error'.tr, 'message_server_error'.tr);
      }
    } finally {
      isPostCreateEditLoading.value = false;
      isPostCreateEditLoading.refresh();
    }
  }

  void onPostFieldTextChange(String value) {
    if (value.isEmpty) {
      isPostFieldTextEmpty.value = true;
    } else {
      isPostFieldTextEmpty.value = false;
    }
  }

  Future<void> editPost() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (editPostId != null &&
        editPostPreviousValue != null &&
        editPostPreviousValue!.id != null &&
        editPostIndex != null) {
      isPostCreateEditLoading.value = true;
      try {
        Map<String, dynamic> requestBody = {
          'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
              as String?,
          'feed': await createPostHtmlEditorController.getText(),
          'files': [...createPostAttachedImages, ...createPostAttachedDocuments]
        };
        var response = await PostRequests.editPost(requestBody, editPostId!);
        if (response != null && response.status == "success") {
          editPostPreviousValue!.description =
              await createPostHtmlEditorController.getText();
          editPostPreviousValue!.files = json.encode(
              [...createPostAttachedImages, ...createPostAttachedDocuments]);
          String? html = editPostPreviousValue!.description;
          if (html != null && html.isNotEmpty) {
            var items = await Helpers.convertHTMLToMultimediaContent(html);
            editPostPreviousValue!.feedItems.assignAll(items);
            for (var item in editPostPreviousValue!.feedItems) {
              if (item.imageString != null && item.imageString!.isNotEmpty) {
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
          Get.snackbar('error'.tr, 'message_server_error'.tr);
        }
      } finally {
        posts.insert(editPostIndex!, editPostPreviousValue);
        editPostPreviousValue = null;
        postFieldContent.clear();
        isEditPost.value = false;
        isPostCreateEditLoading.value = false;
        editPostIndex = null;
        editPostId = null;
        posts.refresh();
        createPostHtmlEditorContent.value = "<p></p>";
        createPostAttachedImages.clear();
        createPostAttachedDocuments.clear();
        showCreateEditPostWidget.value = false;
        isPostFieldTextEmpty.value = true;
        handlePostButtonEnable();
      }
    }
  }

  Future<void> createComment() async {
    FocusManager.instance.primaryFocus?.unfocus();
    // for (var comment in singlePostComments) {
    //   if (comment != null) {
    //     comment.isEditing.value = false;
    //   }
    // }

    isCommentCreateLoading.value = true;

    try {
      String? comment = await commentFieldHtmlEditorController.getText();
      comment = comment.replaceAll('"', r'\"');
      // Helpers.printLog(
      //     description: "DASHBOARD_CONTROLLER_CREATE_COMMENT",
      //     message: "COMMENT = $comment");
      if (comment.isNotEmpty) {
        String quotedComment = '"$comment"';
        // Helpers.printLog(
        //     description: "DASHBOARD_CONTROLLER_CREATE_COMMENT",
        //     message: "COMMENT = $comment");
        Map<String, dynamic> requestBody = {
          'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
              as String?,
          'component_id': currentCommentsPostID,
          'component': 'feed',
          'comment': quotedComment,
          'files': [
            ...commentFieldAttachedImages,
            ...commentFieldAttachedDocuments
          ]
        };
        var response = await PostRequests.createComment(requestBody);
        if (response != null) {
          commentFieldHtmlEditorHtmlContent.value = "<p></p>";
          commentFieldAttachedImages.clear();
          commentFieldAttachedDocuments.clear();
          commentFieldContent.clear();
          isCommentFieldTextEmpty.value = true;
          showCreateCommentWidget.value = false;

          var post = posts.firstWhereOrNull(
              (post) => post != null && post.id == currentCommentsPostID);
          if (post != null) {
            if (post.commentCount == null) {
              post.commentCount = [
                CommentCount(componentId: currentCommentsPostID)
              ];
            } else {
              post.commentCount!
                  .add(CommentCount(componentId: currentCommentsPostID));
            }
            posts.refresh();

            currentCommentsLength.value += 1;
            currentCommentsLength.refresh();
          }
          currentCommentsRefreshNeeded = true;
          singlePostComments.clear();

          shouldCommentsSheetScrollerJumpToPrevious = false;
          await getComments();
          commentsSheetScrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          Get.snackbar('error'.tr, 'message_server_error'.tr);
        }
      }
    } finally {
      isCommentCreateLoading.value = false;
      shouldCommentsSheetScrollerJumpToPrevious = true;
    }
  }

  void toggleLike(int postId) async {
    FocusManager.instance.primaryFocus?.unfocus();
    toggleLikeLocally(postId);
    Map<String, dynamic> requestBody = {
      'token':
          PreferenceManager.getPref(PreferenceManager.prefUserToken) as String?,
      'component_id': postId,
      'component': 'feed',
    };
    var response = await PostRequests.toggleLike(requestBody);
    if ((response != null &&
            (response.status == "success" || response.status == "removed")) ==
        false) {
      Get.snackbar('error'.tr, 'message_server_error'.tr);
      toggleLikeLocally(postId);
    }
  }

  void toggleLikeLocally(int postId) {
    var post =
        posts.firstWhereOrNull((post) => post != null && post.id == postId);
    if (loggedInUser.value != null && loggedInUser.value!.userId != null) {
      // Helpers.printLog(
      //     description: "DASHBOARD_CONTROLLER_TOGGLE_LIKE_LOCALLY",
      //     message: "LIKE_BY_ID = ${loggedInUser.value!.userId}");
    }
    if (post != null &&
        loggedInUser.value != null &&
        loggedInUser.value!.userId != null) {
      if (post.likedBy == 1) {
        // Helpers.printLog(
        //     description: "DASHBOARD_CONTROLLER_TOGGLE_LIKE_LOCALLY",
        //     message: "DISLIKING");
        post.likedBy = 0;
        if (post.likeUsers != null) {
          // Helpers.printLog(
          //     description: "DASHBOARD_CONTROLLER_TOGGLE_LIKE_LOCALLY",
          //     message: "DISLIKING = POST_LIKE_USERS_NOT_NULL");
          post.likeUsers!.removeWhere((user) =>
              user != null && user.userId == loggedInUser.value!.userId);
        }
      } else {
        post.likedBy = 1;
        if (post.likeUsers == null) {
          post.likeUsers = [LikeUser(userId: loggedInUser.value!.userId)];
        } else {
          post.likeUsers!.add(LikeUser(userId: loggedInUser.value!.userId));
        }
      }
    }
    posts.refresh();
  }

  Future<void> getNotifications() async {
    var response = await GetRequests.getNotifications();
    if (response != null) {
      if (response.userNotification != null) {
        notifications.assignAll(response.userNotification!.toList());
        response.userNotification!.removeWhere(
            (notification) => notification != null && notification.read == 'Y');
        notificationsCount.value = response.userNotification!.length;
      }
    }
  }

  void onTapPostDelete(int postId) {
    CommonAlertDialog.showDialog(
      message: "message_delete_post_take_confirmation",
      positiveText: "delete",
      positiveBtnCallback: () async {
        Get.back();
        await deletePost(postId);
      },
      negativeText: "cancel",
      isShowNegativeBtn: true,
    );
  }

  Future<void> onTapPostImage(int postId, String? tappedImage) async {
    // Helpers.printLog(
    //   description: "DASHBOARD_CONTROLLER_ON_TAP_POST_IMAGE_STARTED",
    // );
    var post =
        posts.firstWhereOrNull((post) => post != null && post.id == postId);
    if (post == null) return;
    List<String> images = [];
    if (post.files is String && post.files.isNotEmpty) {
      var decode = json.decode(post.files);
      if (decode != null) {
        var files = List<String>.from(decode);
        for (var file in files) {
          if (Helpers.isImage(file)) {
            images.add(file);
          }
        }
      }
    }
    int? imageIndex;
    if (tappedImage != null) {
      imageIndex = images.indexOf(tappedImage);
    }
    images = images.map((image) => AppConsts.imgInitialUrl + image).toList();

    Get.toNamed(AppRoutes.routeGallery, arguments: {
      AppConsts.keyImagesURLS: images,
      AppConsts.keyIndex: imageIndex,
    });
  }

  Future<void> onTapCommentImage(int commentId, String? tappedImage) async {
    var comment = singlePostComments.firstWhereOrNull(
        (comment) => comment != null && comment.id == commentId);
    if (comment == null) return;
    List<String> images = [];
    if (comment.files is String && comment.files.isNotEmpty) {
      var decode = json.decode(comment.files);
      if (decode != null) {
        var files = List<String>.from(decode);
        for (var file in files) {
          if (Helpers.isImage(file)) {
            images.add(file);
          }
        }
      }
    } else if (comment.files is List && comment.files.isNotEmpty) {
      var files = comment.files;
      for (var file in files) {
        if (Helpers.isImage(file)) {
          images.add(file);
        }
      }
    }
    int? imageIndex;
    if (tappedImage != null) {
      imageIndex = images.indexOf(tappedImage);
    }
    images = images.map((image) => AppConsts.imgInitialUrl + image).toList();

    Get.toNamed(AppRoutes.routeGallery, arguments: {
      AppConsts.keyImagesURLS: images,
      AppConsts.keyIndex: imageIndex,
    });
  }

  void cancelPostEditing() {
    if (editPostPreviousValue != null && editPostIndex != null) {
      posts.insert(editPostIndex!, editPostPreviousValue);
      posts.refresh();
    }
    createPostHtmlEditorContent.value = "<p></p>";
    createPostAttachedImages.clear();
    createPostAttachedDocuments.clear();
    showCreateEditPostWidget.value = false;
    isEditPost.value = false;
    if (createPostContentTimer != null) {
      createPostContentTimer!.cancel();
    }
  }

  void cancelCommentEditing() {
    commentFieldHtmlEditorHtmlContent.value = "<p></p>";
    commentFieldAttachedImages.clear();
    commentFieldAttachedDocuments.clear();
    showCreateCommentWidget.value = false;
    if (commentFieldContentTimer != null) {
      commentFieldContentTimer!.cancel();
    }
  }

  Future<void> onTapPostEdit(int postId) async {
    if (isEditPost.value == false &&
        createPostHtmlEditorContent.value == "<p></p>" &&
        createPostAttachedImages.isEmpty &&
        createPostAttachedDocuments.isEmpty) {
      showCreateEditPostWidget.value = false;
      var post =
          posts.firstWhereOrNull((post) => post != null && post.id == postId);
      editPostPreviousValue = post;
      isEditPost.value = true;
      editPostIndex = posts.indexOf(post);
      posts.remove(post);
      posts.refresh();
      editPostId = postId;
      if (post != null) {
        postFieldContent.clear();
        createPostHtmlEditorContent.value = "<p></p>";
        createPostAttachedImages.clear();
        createPostAttachedDocuments.clear();
        isPostFieldTextEmpty.value = true;
        postFieldContentItemsInsertAfterIndex = null;
        postFieldContentEditIndex = null;

        Get.back();
        if (post.description != null) {
          // Helpers.printLog(
          //     description: "DASHBOARD_CONTROLLER_ON_TAP_POST_EDIT",
          //     message: "DESCRIPTION_NOT_EMPTY");
          createPostHtmlEditorContent.value = post.description!;
          if (post.files is String && post.files.isNotEmpty) {
            var decode = json.decode(post.files);
            if (decode != null) {
              var files = List<String>.from(decode);
              for (var file in files) {
                if (Helpers.isImage(file)) {
                  createPostAttachedImages.add(file);
                } else {
                  createPostAttachedDocuments.add(file);
                }
              }
            }
          }
          createPostHtmlEditorContent.refresh();
          Future.delayed(const Duration(milliseconds: 500), () {
            showCreateEditPostWidget.value = true;
          });

          // Helpers.printLog(
          //     description: "DASHBOARD_CONTROLLER_ON_TAP_POST_EDIT",
          //     message:
          //         "POST_HTML_EDITOR = ${await createPostHtmlEditorController.getText()}");
          var editPostItems =
              await Helpers.convertHTMLToMultimediaContent(post.description!);
          postFieldContent.assignAll(editPostItems);
        }
        handlePostButtonEnable();
        scrollController.jumpTo(scrollController.position.minScrollExtent);
      }
    }
  }

  Future<void> deletePost(int postId) async {
    FocusManager.instance.primaryFocus?.unfocus();
    arePostsLoading.value = true;
    arePostsLoading.refresh();
    bool refreshPosts = false;
    try {
      Map<String, dynamic> requestBody = {
        'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
            as String?,
        'id': postId,
      };
      // Helpers.printLog(
      //     description: "DASHBOARD_CONTROLLER_DELETE_POST", message: "");
      var response = await PostRequests.deletePost(requestBody);
      if (response != null) {
        refreshPosts = true;
      } else {
        Get.snackbar('error'.tr, 'message_server_error'.tr);
      }
    } finally {
      arePostsLoading.value = false;
      arePostsLoading.refresh();
      if (refreshPosts) {
        posts.clear();
        posts.refresh();
        feedPage = 1;
        getPosts();
      }
    }
  }

  void handleCommentOnDelete(int commentId) {
    FocusManager.instance.primaryFocus?.unfocus();
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

  Future<void> deleteComment(int commentId) async {
    Get.back();
    Map<String, dynamic> requestBody = {
      'component_id': currentCommentsPostID,
      'component': 'feed',
      'id': commentId
    };
    areCommentsLoading.value = true;
    try {
      var response = await PostRequests.deletePostComment(requestBody);
      if (response != null) {
        if (response.status == "success") {
          var deleteComment = singlePostComments.firstWhereOrNull(
              (comment) => comment != null && comment.id == commentId);
          var post = posts.firstWhereOrNull(
              (post) => post != null && post.id == currentCommentsPostID);
          if (post != null && post.commentCount!.isNotEmpty) {
            post.commentCount!.removeLast();
            posts.refresh();

            currentCommentsLength.value -= 1;
            currentCommentsLength.refresh();
          }
          currentCommentsRefreshNeeded = true;
          singlePostComments.clear();
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

  void initializeCommentImagePicker() {
    _commentImagePicker = ImagePicker();
  }

  void clickCommentImage() async {
    var havePermission = await PermissionHandler.requestCameraPermission();
    if (havePermission) {
      var image =
          await _commentImagePicker.pickImage(source: ImageSource.camera);
      areCommentFieldFilesLoading.value = true;
      if (image != null) {
        String? imageUrl = await Helpers.uploadFile(image.path, null);
        if (imageUrl != null && imageUrl.isNotEmpty) {
          commentFieldAttachedImages.add(imageUrl);
          commentFieldAttachedImages.refresh();
        }
        if (commentFieldContentItemsInsertAfterIndex == null) {
          commentFieldContent.add(MediaContentModel(image: image));
        } else {
          commentFieldContent.insert(
              commentFieldContentItemsInsertAfterIndex! + 1,
              MediaContentModel(image: image));
        }
        commentFieldContentItemsInsertAfterIndex = null;
      }
      areCommentFieldFilesLoading.value = false;
      // handlePostButtonEnable();
    }
  }

  void pickCommentImages() async {
    var images = await _commentImagePicker.pickMultiImage();
    areCommentFieldFilesLoading.value = true;
    if (images.isNotEmpty) {
      for (var image in images) {
        String? imageUrl = await Helpers.uploadFile(image.path, null);
        if (imageUrl != null && imageUrl.isNotEmpty) {
          commentFieldAttachedImages.add(imageUrl);
          commentFieldAttachedImages.refresh();
        }
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
    areCommentFieldFilesLoading.value = false;
    // handlePostButtonEnable();
  }

  void pickCommentVideos() async {
    var video =
        await _commentImagePicker.pickVideo(source: ImageSource.gallery);

    areCommentFieldFilesLoading.value = true;
    if (video != null) {
      String? videoUrl = await Helpers.uploadFile(video.path, null);
      if (videoUrl != null && videoUrl.isNotEmpty) {
        commentFieldAttachedDocuments.add(videoUrl);
        commentFieldAttachedDocuments.refresh();
      }
    }
    areCommentFieldFilesLoading.value = false;
    handlePostButtonEnable();
  }

  void addTextInCommentContent() {
    // if (commentFieldTextController.text.isEmpty) return;
    //
    // final newItem = MediaContentModel(text: commentFieldTextController.text);
    //
    // if (commentFieldContentEditIndex != null) {
    //   commentFieldContent.insert(commentFieldContentEditIndex!, newItem);
    // } else {
    //   final insertIndex = (commentFieldContentItemsInsertAfterIndex != null)
    //       ? commentFieldContentItemsInsertAfterIndex! + 1
    //       : commentFieldContent.length;
    //   commentFieldContent.insert(insertIndex, newItem);
    // }
    // commentFieldContentEditIndex = null;
    // commentFieldContentItemsInsertAfterIndex = null;
    // commentFieldTextController.clear();
    // isCommentFieldTextEmpty.value = true;
  }

  void createPostHtmlEditorOnInit() {
    Helpers.printLog(
        description: "DASHBOARD_CONTROLLER_CREATE_POST_HTML_EDITOR_ON_INIT");
    createPostHtmlEditorController
        .insertHtml(createPostHtmlEditorContent.value);
    // createPostContentTimer = Timer.periodic(
    //     const Duration(milliseconds: 500),
    //     (Timer t) async => createPostHtmlEditorContent.value =
    //         await createPostHtmlEditorController.getText());
  }

  void createPostHtmlEditorControllerOnChange(String? value) {
    if (value != null) {
      createPostHtmlEditorContent.value = value;
      Helpers.printLog(
          description:
              "DASHBOARD_CONTROLLER_CREATE_POST_HTML_EDITOR_CONTROLLER_ON_CHANGE",
          message: "TEXT = $value");

      // RegExp standaloneAtRegex = RegExp(
      //   r'(?<!<span[^>]*?>)@#(?!(?:[^<]*?>))',
      //   multiLine: true,
      // );

      if (value.contains("@#")) {
        if (searchEmployeesFieldFocusNode != null) {
          searchEmployeesFieldFocusNode!.dispose();
          searchEmployeesFieldFocusNode = null;
        }
        searchEmployeesFieldFocusNode = FocusNode();
        employeesSearchTextController.clear();
        EmployeesDialog.show(
            searchController: employeesSearchTextController,
            handleSearchTextChange: handleEmployeesSearchTextChange,
            showSearchFieldTrailing: showEmployeesSearchFieldTrailing,
            onTapSearchFieldTrailing: handleClearEmployeesSearchField,
            employees: employees,
            areEmployeesLoading: areEmployeesLoading,
            employeeOnTap: handleCreateEditPostEmployeeOnTap,
            searchFieldFocusNode: searchEmployeesFieldFocusNode!);
        searchEmployeesFieldFocusNode!.requestFocus();
        Helpers.printLog(
            description:
                "DASHBOARD_CONTROLLER_CREATE_POST_HTML_EDITOR_CONTROLLER_ON_CHANGE",
            message: "CURRENT_ROUTE = ${Get.isDialogOpen}");
      } else {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      }
    }
  }

  void commentFieldHtmlEditorControllerOnChange(String? value) {
    if (value != null) {
      commentFieldHtmlEditorHtmlContent.value = value;
      Helpers.printLog(
          description:
              "DASHBOARD_CONTROLLER_COMMENT_FIELD_HTML_EDITOR_CONTROLLER_ON_CHANGE",
          message: "TEXT = $value");

      // if (value.endsWith("</span></span></p><p></p>")) {
      //   showCreateEditPostWidget.value = false;
      //   Helpers.printLog(
      //       description:
      //           "DASHBOARD_CONTROLLER_CREATE_POST_HTML_EDITOR_CONTROLLER_ON_CHANGE",
      //       message: "NEW_VALUE_ENDS_WITH = </span></span></p><p></p>");
      //   int lastReplacementIndex = value.lastIndexOf(
      //       '<span class="dx-mention" spellcheck="false" data-marker="@"');
      //   if (lastReplacementIndex != -1) {
      //     int endIndex =
      //         value.indexOf('</span></span>', lastReplacementIndex) + 14;
      //     value = value.substring(0, lastReplacementIndex) +
      //         value.substring(endIndex);
      //     createPostHtmlEditorContent.value = value;
      //   }
      //   Future.delayed(const Duration(milliseconds: 200), () {
      //     showCreateEditPostWidget.value = true;
      //   });
      // }
      RegExp standaloneAtRegex = RegExp(
        r'(?<!<span[^>]*?>)@(?!(?:[^<]*?>))',
        multiLine: true,
      );

      if (value.contains("@#")) {
        if (searchEmployeesFieldFocusNode != null) {
          searchEmployeesFieldFocusNode!.dispose();
          searchEmployeesFieldFocusNode = null;
        }
        searchEmployeesFieldFocusNode = FocusNode();
        employeesSearchTextController.clear();
        EmployeesDialog.show(
            searchController: employeesSearchTextController,
            handleSearchTextChange: handleEmployeesSearchTextChange,
            showSearchFieldTrailing: showEmployeesSearchFieldTrailing,
            onTapSearchFieldTrailing: handleClearEmployeesSearchField,
            employees: employees,
            areEmployeesLoading: areEmployeesLoading,
            employeeOnTap: handleCommentFieldEmployeeOnTap,
            searchFieldFocusNode: searchEmployeesFieldFocusNode!);
        searchEmployeesFieldFocusNode!.requestFocus();
      } else {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      }
    }
  }

  void commentFieldHtmlEditorOnInit() {
    commentFieldHtmlEditorController
        .insertHtml(commentFieldHtmlEditorHtmlContent.value);
    // commentFieldContentTimer = Timer.periodic(
    //     const Duration(milliseconds: 500),
    //     (Timer t) async => commentFieldHtmlEditorHtmlContent.value =
    //         await commentFieldHtmlEditorController.getText());
  }

  void removeCommentContentItem(MediaContentModel item) {
    commentFieldContent.remove(item);
  }

  void initializeAddingInBetweenCommentContent(int index) {
    commentFieldContentItemsInsertAfterIndex = index;
    Get.snackbar("Success", "Adding in between");
  }

  void initializeAddingInBetweenPostContent(int index) {
    postFieldContentItemsInsertAfterIndex = index;
    Get.snackbar("Success", "Adding in between");
  }

  void editCommentContentText(int index) {
    // if (commentFieldContent[index].text != null &&
    //     commentFieldContent[index].text!.isNotEmpty) {
    //   commentFieldTextController.clear();
    //   commentFieldTextController.text = commentFieldContent[index].text!;
    //   commentFieldContent.removeAt(index);
    //   commentFieldContentEditIndex = index;
    // }
  }
}
