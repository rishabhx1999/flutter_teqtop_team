import 'package:get/get.dart';
import 'package:teqtop_team/utils/helpers.dart';
import 'package:teqtop_team/utils/in_app_notification_type.dart';

import '../../config/app_routes.dart';
import '../../consts/app_consts.dart';
import '../../model/dashboard/notification_model.dart';
import '../dashboard/dashboard_controller.dart';

class NotificationsController extends GetxController {
  List<NotificationModel?> notifications = <NotificationModel>[];

  @override
  void onInit() {
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
    // TODO: implement onClose
    super.onClose();
  }

  void getNotifications() {
    final dashboardController = Get.find<DashboardController>();
    notifications.assignAll(dashboardController.notifications);
    extractAndPrintClasses();
  }

  void extractAndPrintClasses() {
    final Set<String> uniqueClasses = {};

    for (var notification in notifications) {
      if (notification != null) {
        final text = notification.text;

        if (text != null) {
          final regex = RegExp(r"class='(notification-[^']+)'");
          final matches = regex.allMatches(text);

          for (var match in matches) {
            uniqueClasses.add(match.group(1)!);
          }
        }
      }
    }

    for (var className in uniqueClasses) {
      Helpers.printLog(
          description: "NOTIFICATION_CONTROLLER_EXTRACT_AND_PRINT_CLASSES",
          message: "DATA = $className");
    }
  }

  void handleNotificationOnTap(int index) {
    if (notifications[index] != null &&
        notifications[index]!.notificationType != null) {
      var notificationType = notifications[index]!.notificationType!;
      if (notificationType == InAppNotificationType.task) {
        moveToTaskDetailPage(notifications[index]!.taskId);
      }
      if (notificationType == InAppNotificationType.project) {
        moveToProjectDetailPage(notifications[index]!.projectId);
      }
      if (notificationType == InAppNotificationType.hiring) {
        moveToLeavesListingPage();
      }
    }
  }

  void moveToTaskDetailPage(String? taskId) {
    if (taskId != null) {
      var id = int.parse(taskId);
      Get.toNamed(AppRoutes.routeTaskDetail, arguments: {
        AppConsts.keyTaskId: id,
      });
    }
  }

  void moveToProjectDetailPage(String? projectId) {
    if (projectId != null) {
      var id = int.parse(projectId);
      Get.toNamed(AppRoutes.routeProjectDetail, arguments: {
        AppConsts.keyProjectId: id,
      });
    }
  }

  void moveToLeavesListingPage() {
    Get.offNamedUntil(
      AppRoutes.routeLeavesListing,
      (route) => route.settings.name == AppRoutes.routeDashboard,
    );
  }
}
