import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teqtop_team/config/app_routes.dart';
import 'package:teqtop_team/model/drive_detail/drive_detail_res_model.dart';
import 'package:teqtop_team/model/drive_detail/file_or_folder_model.dart';
import 'package:teqtop_team/model/global_search/drive_model.dart';
import 'package:teqtop_team/utils/helpers.dart';

import '../../consts/app_consts.dart';
import '../../model/drive_detail/file_model.dart';
import '../../network/get_requests.dart';
import '../../network/post_requests.dart';
import '../../utils/permission_handler.dart';
import '../../utils/preference_manager.dart';
import '../../views/dialogs/common/common_alert_dialog.dart';

class DriveDetailController extends GetxController {
  final GlobalKey<FormState> folderNameFormKey = GlobalKey();
  late TextEditingController newFolderNameController;
  late FilePicker _filePicker;
  RxList<PlatformFile?> selectedFiles = <PlatformFile?>[].obs;
  String driveURL = "";
  RxBool isLoading = false.obs;
  DriveDetailResModel? driveDetail;
  RxList<FileModel> files = <FileModel>[].obs;
  RxList<FileOrFolderModel> folders = <FileOrFolderModel>[].obs;
  Rx<DriveModel?> basicDriveDetails = Rx<DriveModel?>(null);
  RxBool isFolderCreating = false.obs;

  @override
  void onInit() {
    initializeFilePicker();
    initializeTextEditingControllers();
    getDriveURL();

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

  void getDriveURL() {
    Map? data = Get.arguments;
    if (data != null && data.isNotEmpty) {
      // Helpers.printLog(
      //     description: "DRIVE_DETAIL_CONTROLLER_GET_DRIVE_URL",
      //     message: "DATA_NOT_NULL");
      if (data.containsKey(AppConsts.keyDriveURL)) {
        driveURL = data[AppConsts.keyDriveURL];
      }
    }
    getDriveDetail();
  }

  void onTapFileCross(int itemIndex) {
    CommonAlertDialog.showDialog(
      message: "message_file_delete_confirmation",
      positiveText: "yes",
      positiveBtnCallback: () async {
        Get.back();
        deleteFolderOrFile(files[itemIndex].id);
      },
      isShowNegativeBtn: true,
      negativeText: 'no',
    );
  }

  Future<void> deleteFolderOrFile(int? id) async {
    if (id != null) {
      isLoading.value = true;
      try {
        Map<String, dynamic> requestBody = {
          'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
              as String?,
          'id': id,
          'parent': driveURL.split('/').last
        };
        var response = await PostRequests.deleteDriveFolder(requestBody);
        if (response != null) {
          driveDetail = response;
          getDataFromDriveDetail();
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } finally {
        isLoading.value = false;
      }
    }
  }

  void onTapFolderCross(int? folderId) {
    CommonAlertDialog.showDialog(
      message: "message_folder_delete_confirmation",
      positiveText: "yes",
      positiveBtnCallback: () async {
        Get.back();
        deleteFolderOrFile(folderId);
      },
      isShowNegativeBtn: true,
      negativeText: 'no',
    );
  }

  void initializeTextEditingControllers() {
    newFolderNameController = TextEditingController();
  }

  void disposeTextEditingControllers() {
    newFolderNameController.dispose();
  }

  void initializeFilePicker() {
    _filePicker = FilePicker.platform;
  }

  void pickFiles() async {
    Get.back();
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

  Future<void> createFolder() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (folderNameFormKey.currentState!.validate()) {
      if (driveURL.isNotEmpty) {
        Map<String, dynamic> requestBody = {
          'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
              as String?,
          '_folder': newFolderNameController.text,
          'is_folder': 'true',
          'current_path': '/$driveURL',
          'parent': driveURL.split("/").last
        };

        isFolderCreating.value = true;
        try {
          var response = await PostRequests.createDriveFolder(requestBody);
          if (response != null) {
            newFolderNameController.clear();
            Get.back();
            getDriveDetail();
          } else {
            Get.snackbar("error".tr, "message_server_error".tr);
          }
        } finally {
          isFolderCreating.value = false;
        }
      }
    }
  }

  Future<void> getDriveDetail() async {
    if (driveURL.isNotEmpty) {
      isLoading.value = true;
      try {
        var response = await GetRequests.getDriveDetail(driveURL);
        if (response != null) {
          driveDetail = response;
          getDataFromDriveDetail();
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } finally {
        isLoading.value = false;
      }
    }
  }

  void getDataFromDriveDetail() {
    files.clear();
    folders.clear();
    if (driveDetail != null) {
      if (driveDetail!.driveFolders != null) {
        for (var item in driveDetail!.driveFolders!) {
          if (item != null) {
            if (item.isFile == "true" && item.path != null) {
              // Helpers.printLog(
              //     description:
              //         "DRIVE_DETAIL_CONTROLLER_SEPARATE_FILES_AND_FOLDERS",
              //     message: "FILES = ${item.path}");
              files.add(FileModel(id: item.id, file: item.path!));
            }
            if (item.isFolder == "true") {
              folders.add(item);
            }
          }
        }
      }
      if (driveDetail!.parentFolder != null) {
        basicDriveDetails.value = DriveModel(
            name: driveDetail!.parentFolder!.name,
            createdAt: driveDetail!.parentFolder!.createdAt,
            siteUrl: driveDetail!.parentFolder!.projectUrl);
      }
    }
  }

  void openFolder(int index) {
    Get.toNamed(AppRoutes.routeFolderDetail, arguments: {
      AppConsts.keyDriveFolderDetail: folders[index],
    });
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
            files: files, parentURL: driveURL.split("/").last);
        if (response != null) {
          getDriveDetail();
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> downloadFolder(BuildContext context) async {
    var havePermission = await PermissionHandler.requestStoragePermission();
    if (havePermission) {
      // Get the Downloads directory path
      Directory? downloadsDirectory;
      if (Platform.isAndroid) {
        downloadsDirectory = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        downloadsDirectory =
            await getApplicationDocumentsDirectory(); // On iOS, use the app's documents directory
      }

      if (downloadsDirectory == null || !downloadsDirectory.existsSync()) {
        throw Exception("Downloads directory not found");
      }

      // Define paths
      String zipPath = path.join(downloadsDirectory.path, 'jay.zip');
      String tempFilePath = path.join(downloadsDirectory.path, 'temp.jpg');

      // File download URL
      var url =
          "https://dev.team.teqtop.com/img/avatars/86720962-860f-4e0c-b5d6-3a7541b199b183052872749630332701737968346.jpg";
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Save the downloaded file locally
        File tempFile = File(tempFilePath);
        await tempFile.writeAsBytes(response.bodyBytes);

        // Create an Archive instance
        final archive = Archive();
        archive.addFile(ArchiveFile(
            'temp.jpg', tempFile.lengthSync(), await tempFile.readAsBytes()));

        // Encode the archive to a zip file
        final zipFile = File(zipPath);
        await zipFile.writeAsBytes(ZipEncoder().encode(archive));

        // Clean up the temporary file
        await tempFile.delete();

        print("Zip file created successfully at: $zipPath");
      } else {
        throw Exception("Failed to download file: ${response.statusCode}");
      }
    }
  }

  // void downloadFolder() async {
  //   var time = DateTime.now().millisecondsSinceEpoch;
  //   var path = "/storage/emulated/0/Download/$time";
  //   var file = File(path);
  //   var res = await http.get(Uri.parse(
  //       "https://dev.team.teqtop.com/img/avatars/86720962-860f-4e0c-b5d6-3a7541b199b183052872749630332701737968346.jpg"));
  //   file.writeAsBytes(res.bodyBytes);
  // }

  // void downloadFolder(BuildContext context) async {
  //   final flutterDownload = MediaDownload();
  //   flutterDownload.downloadMedia(context,
  //       "https://nta.ac.in/Download/Notice/Notice_20241230193629.pdf");
  // }

  // void downloadFolder(BuildContext context) async {
  //   Helpers.printLog(
  //       description: "DRIVE_DETAIL_CONTROLLER_DOWNLOAD_FOLDER_STARTED");
  //   Dio dio = Dio();
  //   const String url =
  //       "https://dev.team.teqtop.com/img/avatars/86720962-860f-4e0c-b5d6-3a7541b199b183052872749630332701737968346.jpg";
  //   const String fileName = "TV.jpg";
  //
  //   String path = await _getFilePath(fileName);
  //
  //   var response = await dio
  //       .download(
  //     url,
  //     path,
  //     // onReceiveProgress: (recivedBytes, totalBytes) {
  //     //   setState(() {
  //     //     progress = recivedBytes / totalBytes;
  //     //   });
  //     //
  //     //   print(progress);
  //     // },
  //     // deleteOnError: true,
  //   )
  //       .then((_) {
  //     // Navigator.pop(context);
  //   });
  //
  //   Helpers.printLog(
  //       description: "DRIVE_DETAIL_CONTROLLER_DOWNLOAD_FOLDER", message: "RESPONSE = $response");
  // }

  // Future<void> downloadFolder(BuildContext context) async {
  //   var storePath = await getPath();
  //   var filePath = '$storePath/$fileName';
  //
  //   try {
  //     await Dio().download(widget.fileUrl, filePath,
  //         onReceiveProgress: (count, total) {
  //           setState(() {
  //             progress = (count / total);
  //           });
  //         }, cancelToken: cancelToken);
  //     setState(() {
  //       dowloading = false;
  //       fileExists = true;
  //     });
  //   } catch (e) {
  //     print(e);
  //     setState(() {
  //       dowloading = false;
  //     });
  //   }
  // }

  getPath() async {
    final Directory? tempDir = await getExternalStorageDirectory();
    final filePath = Directory("${tempDir!.path}/files");
    if (await filePath.exists()) {
      return filePath.path;
    } else {
      await filePath.create(recursive: true);
      return filePath.path;
    }
  }
}
