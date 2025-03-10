import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:teqtop_team/controllers/notifications/notifications_controller.dart';
import 'package:teqtop_team/model/dashboard/notification_model.dart';
import 'package:teqtop_team/views/pages/notifications/components/notification_widget.dart';

import '../../../config/app_routes.dart';
import '../../../consts/app_icons.dart';

class NotificationsPage extends StatelessWidget {
  final notificationsController = Get.put(NotificationsController());

  NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white));

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                color: Colors.black.withValues(alpha: 0.05),
                height: 1,
              )),
          title: Text(
            'notification'.tr,
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          leading: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Image.asset(
                  AppIcons.icBack,
                  color: Colors.black,
                ),
              )),
          leadingWidth: 40,
          backgroundColor: Colors.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Get.toNamed(AppRoutes.routeGlobalSearch);
                  },
                  child: Image.asset(
                    AppIcons.icSearch,
                    width: 24,
                    color: Colors.black,
                  )),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return NotificationWidget(
                notificationData:
                    notificationsController.notifications[index] ??
                        NotificationModel(),
                onTap: notificationsController.handleNotificationOnTap,
                index: index,
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 16,
              );
            },
            itemCount: notificationsController.notifications.length),
      ),
    );
  }
}
