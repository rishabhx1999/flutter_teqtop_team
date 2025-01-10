import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teqtop_team/model/dashboard/comment_list.dart';
import 'package:teqtop_team/model/dashboard/user_model.dart';
import 'package:teqtop_team/network/get_requests.dart';
import 'package:teqtop_team/network/post_requests.dart';
import 'package:teqtop_team/utils/permission_handler.dart';

import '../../config/app_routes.dart';
import '../../model/dashboard/feed_model.dart';
import '../../utils/preference_manager.dart';

class DashboardController extends GetxController {
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
  int feedPage = 1;

  @override
  void onInit() {
    initializeTextEditingControllers();
    initializeImagePicker();
    initializeFilePicker();
    getLoggedInUser();
    getPosts();
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
    disposeTextEditingControllers();
    super.onClose();
  }

  void addListenerToScrollController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getMorePosts();
      }
    });
  }

  Future<void> refreshPage() async {
    posts.clear();
    feedPage = 1;
    getPosts();
  }

  Future<void> getPosts() async {
    arePostsLoading.value = true;
    try {
      var response = await GetRequests.getPosts();
      if (response != null) {
        if (response.feeds != null) {
          posts.assignAll(response.feeds!.toList());
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
        posts.assignAll(response.feeds!.toList());
        feedPage++;
      } else {
        // Get.snackbar("error".tr, "message_server_error".tr);
      }
    } else {
      // Get.snackbar("error".tr, "message_server_error".tr);
    }
  }

  Future<List<CommentList?>?> getComments(
      int componentId, int commentsCount) async {
    areCommentsLoading.value = true;
    try {
      Map<String, dynamic> requestBody = {
        'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
            as String?,
        'component_id': componentId,
        'component': 'feed',
        'pager': (commentsCount / 3).ceil()
      };

      var response = await PostRequests.getComments(requestBody);
      if (response != null) {
        if (response.status == "success") {
          return response.comments;
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } else {
        Get.snackbar("error".tr, "message_server_error".tr);
      }
    } finally {
      areCommentsLoading.value = false;
    }
    return null;
  }

  Future<void> getLoggedInUser() async {
    var response = await GetRequests.getLoggedInUserData();
    if (response != null) {
      if (response.user != null) {
        loggedInUser.value = response.user;
        saveDataToPref(response.user!);
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

  void handleCreatePostTextChange(String value) {
    handlePostButtonEnable();
  }

  void handlePostButtonEnable() {
    var images = selectedImages;
    var text = createPostTextController.text;
    var documents = selectedDocuments;
    if (images.isNotEmpty || text.isNotEmpty || documents.isNotEmpty) {
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

  void removeSelectedDocument(PlatformFile file) {
    selectedDocuments.remove(file);
    handlePostButtonEnable();
  }

  void saveDataToPref(UserModel loggedInUser) {
    PreferenceManager.saveToPref(
        PreferenceManager.prefUserProfilePhoto, loggedInUser.profile ?? "");
    PreferenceManager.saveToPref(
        PreferenceManager.prefUserName, loggedInUser.name ?? "");
    PreferenceManager.saveToPref(
        PreferenceManager.prefUserEmail, loggedInUser.email ?? "");
    PreferenceManager.saveToPref(
        PreferenceManager.prefUserContactNumber, loggedInUser.contactNo ?? "");
    PreferenceManager.saveToPref(PreferenceManager.prefUserAlternateNumber,
        loggedInUser.alternateNo ?? "");
    PreferenceManager.saveToPref(PreferenceManager.prefUserCurrentAddress,
        loggedInUser.currentAddress ?? "");
    PreferenceManager.saveToPref(PreferenceManager.prefUserAdditionalInfo,
        loggedInUser.additionalInfo ?? "");
  }

  void logOut() {
    PreferenceManager.clean();
    PreferenceManager.saveToPref(PreferenceManager.prefIsLogin, false);
    Get.offAllNamed(AppRoutes.routeLogin);
  }
}
