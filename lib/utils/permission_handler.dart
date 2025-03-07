import 'package:permission_handler/permission_handler.dart';
import 'package:teqtop_team/views/dialogs/common/common_alert_dialog.dart';

class PermissionHandler {
  static Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.status;
    // Helpers.printLog(
    //     description: "PERMISSION_HANDLER_REQUEST_CAMERA_PERMISSION",
    //     message: status.toString());
    if (status.isGranted) {
      // Helpers.printLog(
      //     description: "PERMISSION_HANDLER_REQUEST_CAMERA_PERMISSION",
      //     message: status.toString());
      return true;
    } else if (status.isPermanentlyDenied) {
      // Helpers.printLog(
      //     description: "PERMISSION_HANDLER_REQUEST_CAMERA_PERMISSION",
      //     message: status.toString());
      CommonAlertDialog.showDialog(
          message: "go_to_settings",
          positiveText: "open_settings",
          positiveBtnCallback: () async {
            await openAppSettings();
          });
    } else {
      status = await Permission.camera.request();
      // Helpers.printLog(
      //     description: "PERMISSION_HANDLER_REQUEST_CAMERA_PERMISSION",
      //     message: status.toString());
    }

    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> requestStoragePermission() async {
    var statusPhotos = await Permission.photos.status;
    var statusVideos = await Permission.videos.status;
    var statusAudio = await Permission.audio.status;
    var statusAccessMediaLocation = await Permission.accessMediaLocation.status;
    var statusManageExternalStorage =
        await Permission.manageExternalStorage.status;
    // Helpers.printLog(
    //     description: "PERMISSION_HANDLER_REQUEST_STORAGE_PERMISSION",
    //     message:
    //         "STATUS_PHOTOS = ${statusPhotos.toString()} ===== STATUS_VIDEOS = ${statusVideos.toString()} ===== STATUS_AUDIO = ${statusAudio.toString()} ===== STATUS_ACCESS_MEDIA_LOCATION = ${statusAccessMediaLocation.toString()} ===== STATUS_MANAGE_EXTERNAL_STORAGE = ${statusManageExternalStorage.toString()}");
    if (statusPhotos.isGranted &&
        statusVideos.isGranted &&
        statusAudio.isGranted &&
        statusAccessMediaLocation.isGranted &&
        statusManageExternalStorage.isGranted) {
      // Helpers.printLog(
      //     description: "PERMISSION_HANDLER_REQUEST_STORAGE_PERMISSION",
      //     message:
      //         "STATUS_PHOTOS = ${statusPhotos.toString()} ===== STATUS_VIDEOS = ${statusVideos.toString()} ===== STATUS_AUDIO = ${statusAudio.toString()} ===== STATUS_ACCESS_MEDIA_LOCATION = ${statusAccessMediaLocation.toString()} ===== STATUS_MANAGE_EXTERNAL_STORAGE = ${statusManageExternalStorage.toString()}");
      return true;
    } else if (statusPhotos.isPermanentlyDenied ||
        statusVideos.isPermanentlyDenied ||
        statusAudio.isPermanentlyDenied ||
        statusAccessMediaLocation.isPermanentlyDenied ||
        statusManageExternalStorage.isPermanentlyDenied) {
      // Helpers.printLog(
      //     description: "PERMISSION_HANDLER_REQUEST_STORAGE_PERMISSION",
      //     message:
      //         "STATUS_PHOTOS = ${statusPhotos.toString()} ===== STATUS_VIDEOS = ${statusVideos.toString()} ===== STATUS_AUDIO = ${statusAudio.toString()} ===== STATUS_ACCESS_MEDIA_LOCATION = ${statusAccessMediaLocation.toString()} ===== STATUS_MANAGE_EXTERNAL_STORAGE = ${statusManageExternalStorage.toString()}");
      CommonAlertDialog.showDialog(
          message: "go_to_settings",
          positiveText: "open_settings",
          positiveBtnCallback: () async {
            await openAppSettings();
          });
    } else {
      statusPhotos = await Permission.photos.request();
      statusVideos = await Permission.videos.request();
      statusAudio = await Permission.audio.request();
      statusAccessMediaLocation =
          await Permission.accessMediaLocation.request();
      statusManageExternalStorage =
          await Permission.manageExternalStorage.request();
      // Helpers.printLog(
      //     description: "PERMISSION_HANDLER_REQUEST_STORAGE_PERMISSION",
      //     message:
      //         "STATUS_PHOTOS = ${statusPhotos.toString()} ===== STATUS_VIDEOS = ${statusVideos.toString()} ===== STATUS_AUDIO = ${statusAudio.toString()} ===== STATUS_ACCESS_MEDIA_LOCATION = ${statusAccessMediaLocation.toString()} ===== STATUS_MANAGE_EXTERNAL_STORAGE = ${statusManageExternalStorage.toString()}");
    }

    if (statusPhotos.isGranted &&
        statusVideos.isGranted &&
        statusAudio.isGranted &&
        statusAccessMediaLocation.isGranted &&
        statusManageExternalStorage.isGranted) {
      return true;
    } else {
      return false;
    }
  }
}
