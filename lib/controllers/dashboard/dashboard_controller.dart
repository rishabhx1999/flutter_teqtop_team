import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
import 'package:http/http.dart' as http;

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
  late TextEditingController createPostTextController;
  late TextEditingController commentFieldTextController;
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
  RxList<EmployeeModel?> employees = <EmployeeModel>[].obs;
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
  bool shouldCommentsSheetScrollerJumpToPrevious = true;

  @override
  void onInit() {
    initializeCommentFieldTextFocusNode();
    initializeTextEditingControllers();
    initializeImagePicker();
    initializeCommentImagePicker();
    initializeFilePicker();
    getLoggedInUser();
    getPosts();
    addListenerToScrollControllers();
    getEmployees();
    getNotifications();
    initializeCommentFilePicker();

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
    super.onClose();
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
      showCreateCommentWidget.value = false;
    });
  }

  Future<void> refreshPage() async {
    isEditPost.value = false;
    editPostId = null;
    editPostPreviousValue = null;
    editPostIndex = null;
    postFieldContent.clear();
    createPostTextController.clear();
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
      var response = await GetRequests.getPosts();
      if (response != null) {
        if (response.feeds != null) {
          posts.assignAll(response.feeds!.toList());
          for (var post in posts) {
            if (post != null && post.feedItems.isEmpty) {
              String? html = post.description;
              if (html != null && html.isNotEmpty) {
                var items = await Helpers.convertHTMLToMultimediaContent(html);
                post.feedItems.assignAll(items);
                for (var item in post.feedItems) {
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

  Future<void> getMorePosts() async {
    areMorePostsLoading.value = true;
    try {
      Map<String, dynamic> requestBody = {
        'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
            as String?,
        'search': '',
        'page': feedPage.toString()
      };

      var response = await PostRequests.getMorePosts(requestBody);
      if (response != null) {
        if (response.feeds != null) {
          Set<int?> existingPostIds = posts.map((c) => c?.id).toSet();

          List newPosts = response.feeds!
              .where((c) => !existingPostIds.contains(c?.id))
              .toList();

          posts.addAll(newPosts as Iterable<FeedModel?>);
          for (var post in posts) {
            if (post != null && post.feedItems.isEmpty) {
              String? html = post.description;
              if (html != null && html.isNotEmpty) {
                var items = await Helpers.convertHTMLToMultimediaContent(html);
                post.feedItems.assignAll(items);
                for (var item in post.feedItems) {
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
    }
  }

  Future<void> getComments() async {
    double? previousOffset;
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
      if (commentsSheetScrollController.hasClients) {
        previousOffset = commentsSheetScrollController.offset;
      }
      areCommentsLoading.value = true;
      try {
        Map<String, dynamic> requestBody = {
          'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
              as String?,
          'component_id': currentCommentsPostID,
          'component': 'feed',
          'pager': singlePostCommentsPage
        };

        var response = await PostRequests.getComments(requestBody);
        if (response != null) {
          if (response.status == "success") {
            if (response.comments != null) {
              for (var comment in singlePostComments) {
                if (comment != null && comment.editController != null) {
                  comment.editController!.dispose();
                  comment.editController = null;
                }
              }

              Set<int?> existingCommentIds =
                  singlePostComments.map((c) => c?.id).toSet();

              List newComments = response.comments!
                  .where((c) => !existingCommentIds.contains(c?.id))
                  .toList();

              singlePostComments.addAll(newComments as Iterable<CommentList?>);
              for (var comment in singlePostComments) {
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

              for (var comment in newComments) {
                comment.editController = TextEditingController();
              }
              if (previousOffset != null &&
                  shouldCommentsSheetScrollerJumpToPrevious == true) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  commentsSheetScrollController.jumpTo(previousOffset!);
                });
              }
              singlePostComments.refresh();
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

  void initializeTextEditingControllers() {
    createPostTextController = TextEditingController();
    commentFieldTextController = TextEditingController();
  }

  void disposeTextEditingControllers() {
    createPostTextController.dispose();
    commentFieldTextController.dispose();
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
      if (image != null) {
        if (postFieldContentItemsInsertAfterIndex == null) {
          postFieldContent.add(MediaContentModel(image: image));
        } else {
          postFieldContent.insert(postFieldContentItemsInsertAfterIndex! + 1,
              MediaContentModel(image: image));
        }
        postFieldContentItemsInsertAfterIndex = null;
      }
      handlePostButtonEnable();
    }
  }

  void pickImages() async {
    var images = await _imagePicker.pickMultiImage();
    if (images.isNotEmpty) {
      for (var image in images) {
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
    handlePostButtonEnable();
  }

  void removePostContentItem(MediaContentModel item) {
    postFieldContent.remove(item);
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

      if (postFieldContentItemsInsertAfterIndex == null) {
        postFieldContent.add(mediaContent);
      } else {
        postFieldContentItemsInsertAfterIndex =
            postFieldContentItemsInsertAfterIndex! + 1;
        postFieldContent.insert(
            postFieldContentItemsInsertAfterIndex!, mediaContent);
      }
    }
    postFieldContentItemsInsertAfterIndex = null;
    handlePostButtonEnable();
  }

  void editPostContentText(int index) {
    if (postFieldContent[index].text != null &&
        postFieldContent[index].text!.isNotEmpty) {
      createPostTextController.clear();
      createPostTextController.text = postFieldContent[index].text!;
      postFieldContent.removeAt(index);
      postFieldContentEditIndex = index;
    }
  }

  void addTextInPostContent() {
    if (createPostTextController.text.isEmpty) return;

    final newItem = MediaContentModel(text: createPostTextController.text);

    if (postFieldContentEditIndex != null) {
      postFieldContent.insert(postFieldContentEditIndex!, newItem);
    } else {
      final insertIndex = (postFieldContentItemsInsertAfterIndex != null)
          ? postFieldContentItemsInsertAfterIndex! + 1
          : postFieldContent.length;
      postFieldContent.insert(insertIndex, newItem);
    }
    postFieldContentEditIndex = null;
    postFieldContentItemsInsertAfterIndex = null;
    createPostTextController.clear();
    isPostFieldTextEmpty.value = true;
  }

  void pickCommentDocuments() async {
    var files = await _commentFilePicker.pickFiles(allowMultiple: true);
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
    FocusManager.instance.primaryFocus?.unfocus();
    if (postFieldContent.isNotEmpty) {
      isPostCreateEditLoading.value = true;
      String htmlPost =
          await Helpers.convertMultimediaContentToHTML(postFieldContent);
      try {
        if (htmlPost.isNotEmpty) {
          Map<String, dynamic> requestBody = {
            'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
                as String?,
            'feed': '"$htmlPost"',
          };
          var response = await PostRequests.createPost(requestBody);
          if (response != null && response.status == "success") {
            createPostTextController.clear();
            postFieldContent.clear();
            isPostFieldTextEmpty.value = true;

            handlePostButtonEnable();
            posts.clear();
            feedPage = 1;
            getPosts();
          } else {
            Get.snackbar('error'.tr, 'message_server_error'.tr);
          }
        }
      } finally {
        isPostCreateEditLoading.value = false;
      }
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
        editPostIndex != null &&
        postFieldContent.isNotEmpty) {
      isPostCreateEditLoading.value = true;
      try {
        String htmlPost =
            await Helpers.convertMultimediaContentToHTML(postFieldContent);
        Map<String, dynamic> requestBody = {
          'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
              as String?,
          'feed': htmlPost,
        };
        var response = await PostRequests.editPost(requestBody, editPostId!);
        if (response != null && response.status == "success") {
          editPostPreviousValue!.description = htmlPost;
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
        createPostTextController.clear();
        isPostFieldTextEmpty.value = true;
        handlePostButtonEnable();
      }
    }
  }

  Future<void> createComment() async {
    // Helpers.printLog(description: "DASHBOARD_CONTROLLER_CREATE_COMMENT");
    FocusManager.instance.primaryFocus?.unfocus();
    // for (var comment in singlePostComments) {
    //   if (comment != null) {
    //     comment.isEditing.value = false;
    //   }
    // }

    if (commentFieldContent.isNotEmpty) {
      isCommentCreateLoading.value = true;
      String htmlComment =
          await Helpers.convertMultimediaContentToHTML(commentFieldContent);
      try {
        if (htmlComment.isNotEmpty) {
          Map<String, dynamic> requestBody = {
            'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
                as String?,
            'component_id': currentCommentsPostID,
            'component': 'feed',
            'comment': '"$htmlComment"',
          };
          var response = await PostRequests.createComment(requestBody);
          if (response != null) {
            commentFieldTextController.clear();
            commentFieldContent.clear();
            isCommentFieldTextEmpty.value = true;

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
              duration: Duration(milliseconds: 500),
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

    var response = await GetRequests.getEmployees(requestBody);
    if (response != null) {
      if (response.data != null) {
        employees.assignAll(response.data!.toList());
      } else {
        Get.snackbar("error".tr, "message_server_error".tr);
      }
    } else {
      Get.snackbar("error".tr, "message_server_error".tr);
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

  Future<void> onTapPostImage(int postId, int itemIndex) async {
    var post =
        posts.firstWhereOrNull((post) => post != null && post.id == postId);
    if (post == null) return;
    List<String> images = [];
    for (var item in post.feedItems) {
      if (item.imageString != null && item.downloadedImage != null) {
        images.add(item.imageString!);
      }
    }
    String? tappedImageString = post.feedItems[itemIndex].imageString;
    int? imageIndex;
    if (tappedImageString != null) {
      imageIndex = images.indexOf(tappedImageString);
    }
    Get.toNamed(AppRoutes.routeGallery, arguments: {
      AppConsts.keyImagesURLS: images,
      AppConsts.keyIndex: imageIndex,
    });
  }

  Future<void> onTapCommentImage(int commentId, int itemIndex) async {
    var comment = singlePostComments.firstWhereOrNull(
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

  Future<void> onTapPostEdit(int postId) async {
    if (editPostPreviousValue != null && editPostIndex != null) {
      posts.insert(editPostIndex!, editPostPreviousValue);
      posts.refresh();
    }
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
      createPostTextController.clear();
      isPostFieldTextEmpty.value = true;
      postFieldContentItemsInsertAfterIndex = null;
      postFieldContentEditIndex = null;

      Get.back();
      if (post.description != null) {
        var editPostItems =
            await Helpers.convertHTMLToMultimediaContent(post.description!);
        postFieldContent.assignAll(editPostItems);
      }
      handlePostButtonEnable();
      scrollController.jumpTo(scrollController.position.minScrollExtent);
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
    for (var comment in singlePostComments) {
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
          if (deleteComment != null && deleteComment.editController != null) {
            deleteComment.editController!.dispose();
            deleteComment.editController = null;
          }
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
      if (image != null) {
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

  void pickCommentImages() async {
    var images = await _commentImagePicker.pickMultiImage();
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

  void initializeAddingInBetweenPostContent(int index) {
    postFieldContentItemsInsertAfterIndex = index;
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
}
