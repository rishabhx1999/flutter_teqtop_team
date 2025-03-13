import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/model/drive_detail/file_model.dart';

import '../../config/app_routes.dart';
import '../../consts/app_consts.dart';
import '../../model/drive_detail/drive_detail_res_model.dart';
import '../../model/drive_detail/file_or_folder_model.dart';
import '../../network/get_requests.dart';
import '../../network/post_requests.dart';
import '../../utils/helpers.dart';
import '../../utils/preference_manager.dart';
import '../../views/dialogs/common/common_alert_dialog.dart';

class FolderDetailController extends GetxController {
  late FilePicker _filePicker;
  RxList<PlatformFile?> selectedFiles = <PlatformFile?>[].obs;
  FileOrFolderModel? folderBasicDetail;
  RxBool isLoading = false.obs;
  DriveDetailResModel? folderData;
  RxList<FileModel> files = <FileModel>[].obs;

  @override
  void onInit() {
    initializeFilePicker();
    getFolderBasicDetails();

    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  void initializeFilePicker() {
    _filePicker = FilePicker.platform;
  }

  void pickFiles() async {
    var files = await _filePicker.pickFiles(allowMultiple: true);
    if (files != null) {
      for (var file in files.files) {
        if (file.path != null) {
          selectedFiles.add(file);
        }
      }
    }
    uploadFiles();
  }

  Future<void> onTapImage(int itemIndex) async {
    List<String> images = [];
    for (var file in files) {
      if (Helpers.isImage(file.file)) {
        images.add(file.file);
      }
    }
    String tappedImageString = files[itemIndex].file;
    int? imageIndex;
    imageIndex = images.indexOf(tappedImageString);
    images = images.map((image) => AppConsts.imgInitialUrl + image).toList();
    Get.toNamed(AppRoutes.routeGallery, arguments: {
      AppConsts.keyImagesURLS: images,
      AppConsts.keyIndex: imageIndex,
    });
  }

  void getFolderBasicDetails() {
    Map? data = Get.arguments;
    if (data != null && data.isNotEmpty) {
      if (data.containsKey(AppConsts.keyDriveFolderDetail)) {
        folderBasicDetail = data[AppConsts.keyDriveFolderDetail];
      }
    }
    getFolderData();
  }

  Future<void> getFolderData() async {
    if (folderBasicDetail != null &&
        folderBasicDetail!.link != null &&
        folderBasicDetail!.link!.isNotEmpty) {
      isLoading.value = true;
      try {
        if (await Helpers.isInternetWorking()) {
          var response = await GetRequests.getDriveDetail(
              folderBasicDetail!.link!.replaceFirst('/', ''));
          if (response != null) {
            folderData = response;
            getFilesFromFolderData();
          } else {
            Get.snackbar("error".tr, "message_server_error".tr);
          }
        } else {
          Get.snackbar("error".tr, "message_check_internet".tr);
        }
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> deleteFile(int? fileId) async {
    if (fileId != null &&
        folderBasicDetail != null &&
        folderBasicDetail!.link != null) {
      isLoading.value = true;
      try {
        if (await Helpers.isInternetWorking()) {
          Map<String, dynamic> requestBody = {
            'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
                as String?,
            'id': fileId,
            'parent': folderBasicDetail!.link!.split('/').last
          };
          var response = await PostRequests.deleteDriveFolder(requestBody);
          if (response != null) {
            folderData = response;
            getFilesFromFolderData();
          } else {
            Get.snackbar("error".tr, "message_server_error".tr);
          }
        } else {
          Get.snackbar("error".tr, "message_check_internet".tr);
        }
      } finally {
        isLoading.value = false;
      }
    }
  }

  void onTapFileCross(int itemIndex) {
    CommonAlertDialog.showDialog(
      message: "message_file_delete_confirmation",
      positiveText: "yes",
      positiveBtnCallback: () async {
        Get.back();
        deleteFile(files[itemIndex].id);
      },
      isShowNegativeBtn: true,
      negativeText: 'no',
    );
  }

  void getFilesFromFolderData() {
    files.clear();
    if (folderData != null) {
      if (folderData!.driveFolders != null) {
        for (var item in folderData!.driveFolders!) {
          if (item != null) {
            if (item.isFile == "true" && item.path != null) {
              files.add(FileModel(id: item.id, file: item.path!));
            }
          }
        }
      }
    }
  }

  Future<void> uploadFiles() async {
    List<String> files = [];
    for (var file in selectedFiles) {
      if (file != null && file.path != null) {
        files.add(file.path!);
      }
    }
    if (files.isNotEmpty) {
      isLoading.value = true;
      try {
        if (await Helpers.isInternetWorking()) {
          var response = await PostRequests.addDriveFiles(
              files: files,
              parentURL: folderBasicDetail!.link!.split("/").last);
          if (response != null) {
            getFolderData();
          } else {
            Get.snackbar("error".tr, "message_server_error".tr);
          }
        } else {
          Get.snackbar("error".tr, "message_check_internet".tr);
        }
      } finally {
        isLoading.value = false;
      }
    }
  }
}
