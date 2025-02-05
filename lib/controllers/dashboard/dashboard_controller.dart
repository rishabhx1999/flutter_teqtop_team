import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:teqtop_team/model/dashboard/comment_count.dart';
import 'package:teqtop_team/model/dashboard/comment_list.dart';
import 'package:teqtop_team/model/dashboard/like_user.dart';
import 'package:teqtop_team/model/dashboard/notification_model.dart';
import 'package:teqtop_team/model/dashboard/post_media_model.dart';
import 'package:teqtop_team/model/dashboard/user_model.dart';
import 'package:teqtop_team/network/get_requests.dart';
import 'package:teqtop_team/network/post_requests.dart';
import 'package:teqtop_team/utils/helpers.dart';
import 'package:teqtop_team/utils/permission_handler.dart';
import 'package:http/http.dart' as http;

import '../../config/app_routes.dart';
import '../../model/dashboard/feed_model.dart';
import '../../model/dashboard/post_image_model.dart';
import '../../model/employees_listing/employee_model.dart';
import '../../utils/preference_manager.dart';
import '../../views/dialogs/common/common_alert_dialog.dart';

class DashboardController extends GetxController
    with GetTickerProviderStateMixin {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController createPostTextController;
  late TextEditingController commentFieldController;
  RxBool isPostButtonEnable = false.obs;
  late ImagePicker _imagePicker;
  RxList<XFile?> selectedImages = <XFile?>[].obs;
  late FilePicker _filePicker;
  RxList<PlatformFile?> selectedDocuments = <PlatformFile?>[].obs;
  RxBool arePostsLoading = false.obs;
  RxBool areCommentsLoading = false.obs;
  RxList<FeedModel?> posts = <FeedModel>[].obs;
  Rx<UserModel?> loggedInUser = Rx<UserModel?>(null);
  final ScrollController scrollController = ScrollController();
  final ScrollController commentsSheetScrollController = ScrollController();
  int feedPage = 1;
  RxBool isPostCreating = false.obs;
  RxBool isPostEditing = false.obs;
  RxBool isCommentCreating = false.obs;
  List<String> remoteFilePaths = [];
  RxList<EmployeeModel?> employees = <EmployeeModel>[].obs;
  List<PostMediaModel> postsMedia = [];
  RxInt notificationsCount = 0.obs;
  List<NotificationModel?> notifications = <NotificationModel>[];
  RxList<PostImageModel> editPostPreviousImages = <PostImageModel>[].obs;
  RxList<String> editPostPreviousDocuments = <String>[].obs;
  RxBool isEditPost = false.obs;
  int? editPostId;
  RxList<CommentList?> singlePostComments = <CommentList>[].obs;
  int singlePostCommentsPage = 1;
  int? currentCommentsPostID;
  RxInt currentCommentsLength = 0.obs;
  bool currentCommentsRefreshNeeded = false;

  @override
  void onInit() {
    initializeTextEditingControllers();
    initializeImagePicker();
    initializeFilePicker();
    getLoggedInUser();
    getPosts();
    addListenerToScrollControllers();
    getEmployees();
    getNotifications();

    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    disposeTextEditingControllers();
    disposeScrollControllers();
    super.onClose();
  }

  void addListenerToScrollControllers() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
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
    selectedImages.clear();
    selectedDocuments.clear();
    remoteFilePaths.clear();
    createPostTextController.clear();
    editPostPreviousDocuments.clear();
    editPostPreviousImages.clear();
    handlePostButtonEnable();
    posts.clear();
    clearPostsMedia();
    feedPage = 1;
    getPosts();
    notificationsCount.value = 0;
    getNotifications();
  }

  Future<void> getPosts() async {
    arePostsLoading.value = true;
    try {
      var response = await GetRequests.getPosts();
      if (response != null) {
        if (response.feeds != null) {
          posts.assignAll(response.feeds!.toList());
          clearPostsMedia();
          getPostsMedia();
          feedPage++;
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } else {
        Get.snackbar("error".tr, "message_server_error".tr);
      }
    } finally {
      arePostsLoading.value = false;
    }
  }

  void clearPostsMedia() {
    for (var postMedia in postsMedia) {
      postMedia.pageController.dispose();
      for (var image in postMedia.images) {
        image.animationController.dispose();
        image.transformationController.dispose();
      }
    }
    postsMedia.clear();
  }

  Future<void> getMorePosts() async {
    Map<String, dynamic> requestBody = {
      'token':
          PreferenceManager.getPref(PreferenceManager.prefUserToken) as String?,
      'search': '',
      'page': feedPage.toString()
    };

    var response = await PostRequests.getMorePosts(requestBody);
    if (response != null) {
      if (response.feeds != null) {
        var lastFiveFeeds = response.feeds!.length > 5
            ? response.feeds!.skip(response.feeds!.length - 5).toList()
            : response.feeds!.toList();
        posts.addAll(lastFiveFeeds);
        getPostsMedia();
        feedPage++;
      } else {
        // Get.snackbar("error".tr, "message_server_error".tr);
      }
    } else {
      // Get.snackbar("error".tr, "message_server_error".tr);
    }
  }

  void getPostsMedia() {
    var recentPosts = posts.isNotEmpty
        ? posts.sublist(posts.length > 5 ? posts.length - 5 : 0)
        : [];

    for (var post in recentPosts) {
      if (post != null && post.id != null) {
        var postMediaModel = PostMediaModel(
          postId: post.id!,
          images: [],
          documents: [],
          pageController: PageController(),
        );

        var extractedImages = Helpers.extractImages(post.description ?? "");
        for (var image in extractedImages) {
          if (!postMediaModel.images.any((img) => img.image == image)) {
            postMediaModel.images.add(PostImageModel(
              image: image,
              transformationController: TransformationController(),
              animationController: AnimationController(
                  vsync: this, duration: Duration(milliseconds: 200)),
            ));
          }
        }

        if (post.files != null && post.files is String) {
          // Parse the string into a list of file paths
          try {
            List<String> extractedFiles =
                List<String>.from(jsonDecode(post.files) as List<dynamic>);

            for (var file in extractedFiles) {
              Helpers.printLog(
                description: "DASHBOARD_CONTROLLER_GET_POSTS_MEDIA",
                message:
                    "DESCRIPTION = ${Helpers.cleanHtml(post.description ?? "")} ===== FILE = $file",
              );
              if (Helpers.isImage(file) &&
                  !postMediaModel.images.any((img) => img.image == file)) {
                postMediaModel.images.add(PostImageModel(
                  image: file,
                  transformationController: TransformationController(),
                  animationController: AnimationController(
                    vsync: this,
                  ),
                ));
              } else if (!postMediaModel.documents.contains(file)) {
                postMediaModel.documents.add(file);
              }
            }
          } catch (e) {
            debugPrint('Error parsing files for post ${post.id}: $e');
          }
        }

        postsMedia.add(postMediaModel);
      }
    }
  }

  Future<void> getComments() async {
    int commentsPerPage = 10;
    int maxPage = (currentCommentsLength.value / commentsPerPage).ceil();

    if (singlePostCommentsPage <= maxPage ||
        currentCommentsRefreshNeeded == true) {
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
              singlePostComments
                  .assignAll(response.comments as Iterable<CommentList?>);
              for (var comment in singlePostComments) {
                if (comment != null) {
                  comment.editController = TextEditingController();
                }
              }
              singlePostComments.refresh();
              singlePostCommentsPage++;
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

  void initializeTextEditingControllers() {
    createPostTextController = TextEditingController();
    commentFieldController = TextEditingController();
  }

  void disposeTextEditingControllers() {
    createPostTextController.dispose();
    commentFieldController.dispose();
  }

  void disposeScrollControllers() {
    scrollController.dispose();
    commentsSheetScrollController.dispose();
  }

  void handleCreatePostTextChange(String value) {
    handlePostButtonEnable();
  }

  void handlePostButtonEnable() {
    var images = selectedImages;
    var text = createPostTextController.text;
    var documents = selectedDocuments;
    var editPostDocuments = editPostPreviousDocuments;
    var editPostImages = editPostPreviousImages;
    if (images.isNotEmpty ||
        text.isNotEmpty ||
        documents.isNotEmpty ||
        editPostDocuments.isNotEmpty ||
        editPostImages.isNotEmpty) {
      isPostButtonEnable.value = true;
    } else {
      isPostButtonEnable.value = false;
    }
  }

  void clickImage() async {
    var havePermission = await PermissionHandler.requestCameraPermission();
    if (havePermission) {
      selectedImages
          .add(await _imagePicker.pickImage(source: ImageSource.camera));
      handlePostButtonEnable();
    }
  }

  void pickImages() async {
    selectedImages.addAll(await _imagePicker.pickMultiImage());
    handlePostButtonEnable();
  }

  void pickDocuments() async {
    var files = await _filePicker.pickFiles(allowMultiple: true);
    if (files != null) {
      for (var file in files.files) {
        if (file.path != null) {
          if (file.extension != null &&
              ['jpg', 'jpeg', 'png'].contains(file.extension!.toLowerCase())) {
            selectedImages.add(XFile(file.path!));
          } else {
            selectedDocuments.add(file);
          }
        }
      }
      handlePostButtonEnable();
    }
  }

  void initializeImagePicker() {
    _imagePicker = ImagePicker();
  }

  void removeSelectedImage(XFile image) {
    selectedImages.remove(image);
    handlePostButtonEnable();
  }

  void removeEditPostPreviousImage(PostImageModel image) {
    editPostPreviousImages.remove(image);
    handlePostButtonEnable();
  }

  void removeSelectedDocument(PlatformFile file) {
    selectedDocuments.remove(file);
    handlePostButtonEnable();
  }

  void removeEditPostPreviousDocument(String file) {
    editPostPreviousDocuments.remove(file);
    handlePostButtonEnable();
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
    Helpers.printLog(
        description: "DASHBOARD_CONTROLLER_SAVE_PROFILE_DATA_TO_PREF",
        message: "ALTERNATE_NO = ${loggedInUser.alternateNo}");
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
    Helpers.printLog(
        description: "DASHBOARD_CONTROLLER_SAVE_PROFILE_DATA_TO_PREF",
        message: "DATE_OF_BIRTH = ${loggedInUser.birthDate}");
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
    isPostCreating.value = true;
    await uploadImagesAndDocuments();
    try {
      Map<String, dynamic> requestBody = {
        'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
            as String?,
        'feed': Helpers.convertToHTMLParagraphs(createPostTextController.text),
      };
      if (remoteFilePaths.isNotEmpty) {
        for (int i = 0; i < remoteFilePaths.length; i++) {
          requestBody.addIf(true, 'files', remoteFilePaths);
        }
      }
      var response = await PostRequests.createPost(requestBody);
      if (response != null && response.status == "success") {
        selectedImages.clear();
        selectedDocuments.clear();
        remoteFilePaths.clear();
        createPostTextController.clear();
        handlePostButtonEnable();
        posts.clear();
        clearPostsMedia();
        feedPage = 1;
        getPosts();
      } else {
        Get.snackbar('error'.tr, 'message_server_error'.tr);
      }
    } finally {
      isPostCreating.value = false;
    }
  }

  void editPost() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (editPostId != null) {
      isPostEditing.value = true;
      await uploadImagesAndDocuments();
      try {
        Map<String, dynamic> requestBody = {
          'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
              as String?,
          'feed':
              Helpers.convertToHTMLParagraphs(createPostTextController.text),
        };
        if (remoteFilePaths.isNotEmpty) {
          for (int i = 0; i < remoteFilePaths.length; i++) {
            requestBody.addIf(true, 'files', remoteFilePaths);
          }
        }
        var response = await PostRequests.editPost(requestBody, editPostId!);
        if (response != null && response.status == "success") {
          isEditPost.value = false;
          editPostId = null;
          selectedImages.clear();
          selectedDocuments.clear();
          remoteFilePaths.clear();
          createPostTextController.clear();
          editPostPreviousDocuments.clear();
          editPostPreviousImages.clear();
          handlePostButtonEnable();
          posts.clear();
          clearPostsMedia();
          feedPage = 1;
          getPosts();
        } else {
          Get.snackbar('error'.tr, 'message_server_error'.tr);
        }
      } finally {
        isPostEditing.value = false;
      }
    }
  }

  Future<void> createComment() async {
    FocusManager.instance.primaryFocus?.unfocus();
    for (var comment in singlePostComments) {
      if (comment != null) {
        comment.isEditing.value = false;
      }
    }
    if (commentFieldController.text.isNotEmpty) {
      isCommentCreating.value = true;
      try {
        Map<String, dynamic> requestBody = {
          'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
              as String?,
          'component_id': currentCommentsPostID,
          'component': 'feed',
          'comment':
              '"${Helpers.convertToHTMLParagraphs(commentFieldController.text)}"',
        };
        var response = await PostRequests.createComment(requestBody);
        if (response != null) {
          commentFieldController.clear();

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
          singlePostCommentsPage = 1;
          getComments();
        } else {
          Get.snackbar('error'.tr, 'message_server_error'.tr);
        }
      } finally {
        isCommentCreating.value = false;
      }
    }
  }

  Future<void> uploadImagesAndDocuments() async {
    if (editPostPreviousDocuments.isNotEmpty) {
      remoteFilePaths.addAll(editPostPreviousDocuments);
    }
    if (editPostPreviousImages.isNotEmpty) {
      for (var image in editPostPreviousImages) {
        remoteFilePaths.add(image.image);
      }
    }

    if (selectedImages.isNotEmpty) {
      for (var image in selectedImages) {
        if (image != null) {
          String? remoteFilePath =
              await uploadFile(image.path, path.extension(image.path));
          if (remoteFilePath != null && remoteFilePath.isNotEmpty) {
            remoteFilePaths.add(remoteFilePath);
          }
        }
      }
    }
    if (selectedDocuments.isNotEmpty) {
      for (var document in selectedDocuments) {
        if (document != null) {
          String? filePath = document.path;
          String? fileType = document.extension;
          String? remoteFilePath;
          if (filePath != null && filePath.isNotEmpty) {
            remoteFilePath = await uploadFile(filePath, fileType);
          }
          if (remoteFilePath != null && remoteFilePath.isNotEmpty) {
            remoteFilePaths.add(remoteFilePath);
          }
        }
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
      Helpers.printLog(
          description: "DASHBOARD_CONTROLLER_TOGGLE_LIKE_LOCALLY",
          message: "LIKE_BY_ID = ${loggedInUser.value!.userId}");
    }
    if (post != null &&
        loggedInUser.value != null &&
        loggedInUser.value!.userId != null) {
      if (post.likedBy == 1) {
        post.likedBy = 0;
        if (post.likeUsers != null) {
          post.likeUsers!.removeWhere((user) =>
              user != null && user.userId == loggedInUser.value!.userId);
        }
      } else {
        post.likedBy = 1;
        if (post.likeUsers == null) {
          post.likeUsers = [LikeUser(id: loggedInUser.value!.userId)];
        } else {
          post.likeUsers!.add(LikeUser(id: loggedInUser.value!.userId));
        }
      }
    }
    posts.refresh();
  }

  List<PostImageModel>? getPostImages(int? postId) {
    if (postId != null) {
      var postMedia = postsMedia.firstWhereOrNull(
        (postMedia) => postId == postMedia.postId,
      );
      if (postMedia != null) {
        return postMedia.images;
      }
    }
    return null;
  }

  List<String>? getPostDocuments(int? postId) {
    if (postId != null) {
      var postMedia = postsMedia
          .firstWhereOrNull((postMedia) => postId == postMedia.postId);
      if (postMedia != null) {
        return postMedia.documents;
      }
    }
    return null;
  }

  Future<void> getNotifications() async {
    var response = await GetRequests.getNotifications();
    if (response != null) {
      if (response.userNotification != null) {
        notificationsCount.value = response.userNotification!.length;
        notifications.assignAll(response.userNotification!.toList());
      }
      Helpers.printLog(
          description: "DASHBOARD_CONTROLLER_GET_NOTIFICATIONS",
          message:
              "TOTAL_NOTIFICATIONS = ${response.userNotification != null ? response.userNotification!.length : 0}");
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

  void onTapPostEdit(int postId) {
    var post =
        posts.firstWhereOrNull((post) => post != null && post.id == postId);
    if (post != null) {
      isEditPost.value = true;
      editPostId = postId;

      selectedImages.clear();
      selectedDocuments.clear();
      createPostTextController.clear();
      editPostPreviousDocuments.clear();
      editPostPreviousImages.clear();

      Get.back();
      posts.remove(post);
      posts.refresh();
      createPostTextController.text = Helpers.cleanHtml(post.description ?? "");
      var documents = getPostDocuments(postId);
      if (documents != null) {
        editPostPreviousDocuments.assignAll(documents as Iterable<String>);
      }
      var images = getPostImages(postId);
      if (images != null) {
        editPostPreviousImages.assignAll(images as Iterable<PostImageModel>);
      }
      handlePostButtonEnable();
      scrollController.jumpTo(scrollController.position.minScrollExtent);
    }
  }

  Future<void> deletePost(int postId) async {
    FocusManager.instance.primaryFocus?.unfocus();
    arePostsLoading.value = true;
    try {
      Map<String, dynamic> requestBody = {
        'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
            as String?,
        'id': postId,
      };
      var response = await PostRequests.deletePost(requestBody);
      if (response != null) {
        isEditPost.value = false;
        editPostId = null;
        selectedImages.clear();
        selectedDocuments.clear();
        remoteFilePaths.clear();
        createPostTextController.clear();
        editPostPreviousDocuments.clear();
        editPostPreviousImages.clear();
        handlePostButtonEnable();
        posts.clear();
        clearPostsMedia();
        feedPage = 1;
        getPosts();
      } else {
        Get.snackbar('error'.tr, 'message_server_error'.tr);
      }
    } finally {
      arePostsLoading.value = false;
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
          singlePostCommentsPage = 1;
          currentCommentsRefreshNeeded = true;
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
