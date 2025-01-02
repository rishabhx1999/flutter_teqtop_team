import 'package:permission_handler/permission_handler.dart';
import 'package:teqtop_team/utils/helpers.dart';
import 'package:teqtop_team/views/dialogs/common/common_alert_dialog.dart';

class PermissionHandler {
  static Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.status;
    Helpers.printLog(
        description: "PERMISSION_HANDLER_REQUEST_CAMERA_PERMISSION",
        message: status.toString());
    if (status.isGranted) {
      Helpers.printLog(
          description: "PERMISSION_HANDLER_REQUEST_CAMERA_PERMISSION",
          message: status.toString());
      return true;
    } else if (status.isPermanentlyDenied) {
      Helpers.printLog(
          description: "PERMISSION_HANDLER_REQUEST_CAMERA_PERMISSION",
          message: status.toString());
      CommonAlertDialog.showDialog(
          message: "go_to_settings",
          positiveText: "open_settings",
          positiveBtnCallback: () async {
            await openAppSettings();
          });
    } else {
      status = await Permission.camera.request();
      Helpers.printLog(
          description: "PERMISSION_HANDLER_REQUEST_CAMERA_PERMISSION",
          message: status.toString());
    }

    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }
}
