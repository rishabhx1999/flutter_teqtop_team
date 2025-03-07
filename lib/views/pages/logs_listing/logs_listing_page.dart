import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/config/app_routes.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/consts/app_icons.dart';
import 'package:teqtop_team/controllers/logs_listing/logs_listing_controller.dart';
import 'package:teqtop_team/model/logs_listing/log_model.dart';
import 'package:teqtop_team/views/pages/dashboard/components/menu_drawer_widget.dart';
import 'package:teqtop_team/views/pages/logs_listing/components/log_widget_shimmer.dart';

import '../../../consts/app_images.dart';
import 'components/log_widget.dart';

class LogsListingPage extends StatelessWidget {
  final logsListingController = Get.put(LogsListingController());

  LogsListingPage({super.key});

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
        key: logsListingController.scaffoldKey,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                color: Colors.black.withValues(alpha: 0.05),
                height: 1,
              )),
          title: Text(
            'logs'.tr,
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          leading: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                logsListingController.scaffoldKey.currentState?.openDrawer();
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  AppIcons.icMenu,
                  color: Colors.black,
                ),
              )),
          backgroundColor: Colors.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
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
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Get.toNamed(AppRoutes.routeNotifications);
              },
              child: Obx(
                () => Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4, right: 16),
                      child: Image.asset(
                        AppIcons.icBell,
                        width: 24,
                      ),
                    ),
                    Positioned(
                        left: 12,
                        top: 0,
                        child: Visibility(
                            visible:
                                logsListingController.notificationsCount.value >
                                    0,
                            child: Container(
                              height: 12,
                              width: logsListingController
                                          .notificationsCount.value
                                          .toString()
                                          .length >
                                      1
                                  ? (12 +
                                          ((logsListingController
                                                      .notificationsCount.value
                                                      .toString()
                                                      .length -
                                                  1) *
                                              4))
                                      .toDouble()
                                  : 12,
                              decoration: BoxDecoration(
                                  color: AppColors.colorFFB400,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Center(
                                child: Text(
                                  logsListingController.notificationsCount.value
                                      .toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          fontSize:
                                              AppConsts.commonFontSizeFactor *
                                                  8),
                                ),
                              ),
                            )))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Get.toNamed(AppRoutes.routeProfileDetail);
                },
                child: CircleAvatar(
                  radius: 17,
                  backgroundImage: const AssetImage(AppImages.imgPersonPlaceholder),
                  foregroundImage: logsListingController.profilePhoto != null
                      ? NetworkImage(AppConsts.imgInitialUrl +
                          logsListingController.profilePhoto!)
                      : const AssetImage(AppImages.imgPersonPlaceholder),
                ),
              ),
            )
          ],
        ),
        backgroundColor: Colors.white,
        drawer: const MenuDrawerWidget(),
        body: Obx(
          () => ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              itemBuilder: (context, index) {
                return logsListingController.isLoading.value
                    ? const LogWidgetShimmer()
                    : LogWidget(
                        logData:
                            logsListingController.logs[index] ?? LogModel(),
                        index: index,
                        onTap: logsListingController.handleLogOnTap,
                      );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 16,
                );
              },
              itemCount: logsListingController.isLoading.value
                  ? 5
                  : logsListingController.logs.length),
        ),
      ),
    );
  }
}
