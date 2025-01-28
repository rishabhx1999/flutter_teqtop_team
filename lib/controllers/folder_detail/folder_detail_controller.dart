import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

import '../../consts/app_consts.dart';
import '../../model/drive_detail/drive_detail_res_model.dart';
import '../../model/drive_detail/file_or_folder_model.dart';
import '../../network/get_requests.dart';
import '../../network/post_requests.dart';

class FolderDetailController extends GetxController {
  late FilePicker _filePicker;
  RxList<PlatformFile?> selectedFiles = <PlatformFile?>[].obs;
  FileOrFolderModel? folderBasicDetail;
  RxBool isLoading = false.obs;
  DriveDetailResModel? folderData;
  RxList<String> files = <String>[].obs;

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

  @override
  void onClose() {
    super.onClose();
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
        var response = await GetRequests.getDriveDetail(
            folderBasicDetail!.link!.replaceFirst('/', ''));
        if (response != null) {
          folderData = response;
          getFilesFromFolderData();
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } finally {
        isLoading.value = false;
      }
    }
  }

  void getFilesFromFolderData() {
    files.clear();
    if (folderData != null) {
      if (folderData!.driveFolders != null) {
        for (var item in folderData!.driveFolders!) {
          if (item != null) {
            if (item.isFile == "true" && item.path != null) {
              files.add(item.path!);
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
        var response = await PostRequests.addDriveFiles(
            files: files, parentURL: folderBasicDetail!.link!.split("/").last);
        if (response != null) {
          getFolderData();
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } finally {
        isLoading.value = false;
      }
    }
  }
}
