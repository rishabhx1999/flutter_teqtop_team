import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teqtop_team/config/app_route_observer.dart';
import 'package:teqtop_team/config/app_routes.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/consts/app_icons.dart';
import 'package:teqtop_team/consts/app_images.dart';
import 'package:teqtop_team/controllers/dashboard/dashboard_controller.dart';
import 'package:teqtop_team/views/dialogs/common/common_alert_dialog.dart';
import 'package:teqtop_team/views/pages/dashboard/components/drawer_menu_list_tile.dart';

import '../../../../config/app_colors.dart';
import '../../../../utils/helpers.dart';
import '../../../dialogs/common/common_dialog.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: 284,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Stack(
        children: [
          ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(
                height: 56,
              ),
              DrawerMenuListTile(
                  onTap: () {
                    final dashboardController = Get.find<DashboardController>();
                    dashboardController.scaffoldKey.currentState?.closeDrawer();
                    if (Get.currentRoute == AppRoutes.routeDashboard) {
                      dashboardController.refreshPage();
                    } else {
                      Get.offAllNamed(AppRoutes.routeDashboard);
                      Helpers.printLog(
                          description: "DRAWER_WIDGET_ITEM_ON_TAP",
                          message:
                              "ROUTE_STACK_LIST :- ${AppRouteObserver.routeStack}\nROUTE_STACK_LIST :- ${AppRouteObserver.routeStack.length}");
                    }
                  },
                  leading: AppIcons.icFeeds,
                  title: "feeds"),
              DrawerMenuListTile(
                  onTap: () {
                    if (Get.currentRoute == AppRoutes.routeDashboard) {
                      final dashboardController =
                          Get.find<DashboardController>();
                      dashboardController.scaffoldKey.currentState
                          ?.closeDrawer();
                      Get.toNamed(AppRoutes.routeEmployeesListing);
                    } else {
                      Get.offNamed(AppRoutes.routeEmployeesListing);
                    }
                    Helpers.printLog(
                        description: "DRAWER_WIDGET_ITEM_ON_TAP",
                        message:
                            "ROUTE_STACK_LIST :- ${AppRouteObserver.routeStack}\nROUTE_STACK_LIST :- ${AppRouteObserver.routeStack.length}");
                  },
                  leading: AppIcons.icEmployees,
                  title: "employees"),
              DrawerMenuListTile(
                  onTap: () {
                    if (Get.currentRoute == AppRoutes.routeDashboard) {
                      final dashboardController =
                          Get.find<DashboardController>();
                      dashboardController.scaffoldKey.currentState
                          ?.closeDrawer();
                      Get.toNamed(AppRoutes.routeDailyReportsListing);
                    } else {
                      Get.offNamed(AppRoutes.routeDailyReportsListing);
                    }
                    Helpers.printLog(
                        description: "DRAWER_WIDGET_ITEM_ON_TAP",
                        message:
                            "ROUTE_STACK_LIST :- ${AppRouteObserver.routeStack}\nROUTE_STACK_LIST :- ${AppRouteObserver.routeStack.length}");
                  },
                  leading: AppIcons.icDailyReport,
                  title: "daily_report"),
              DrawerMenuListTile(
                  onTap: () {
                    if (Get.currentRoute == AppRoutes.routeDashboard) {
                      final dashboardController =
                          Get.find<DashboardController>();
                      dashboardController.scaffoldKey.currentState
                          ?.closeDrawer();
                      Get.toNamed(AppRoutes.routeProjectsListing);
                    } else {
                      Get.offNamed(AppRoutes.routeProjectsListing);
                    }
                    Helpers.printLog(
                        description: "DRAWER_WIDGET_ITEM_ON_TAP",
                        message:
                            "ROUTE_STACK_LIST :- ${AppRouteObserver.routeStack}\nROUTE_STACK_LIST :- ${AppRouteObserver.routeStack.length}");
                  },
                  leading: AppIcons.icProjects,
                  title: "projects"),
              DrawerMenuListTile(
                  onTap: () {
                    if (Get.currentRoute == AppRoutes.routeDashboard) {
                      final dashboardController =
                          Get.find<DashboardController>();
                      dashboardController.scaffoldKey.currentState
                          ?.closeDrawer();
                      Get.toNamed(AppRoutes.routeTasksListing);
                    } else {
                      Get.offNamed(AppRoutes.routeTasksListing);
                    }
                    Helpers.printLog(
                        description: "DRAWER_WIDGET_ITEM_ON_TAP",
                        message:
                            "ROUTE_STACK_LIST :- ${AppRouteObserver.routeStack}\nROUTE_STACK_LIST :- ${AppRouteObserver.routeStack.length}");
                  },
                  leading: AppIcons.icTasks,
                  title: "tasks"),
              DrawerMenuListTile(
                  onTap: () {}, leading: AppIcons.icLogs, title: "logs"),
              DrawerMenuListTile(
                  onTap: () {}, leading: AppIcons.icLeaves, title: "leaves"),
              DrawerMenuListTile(
                  onTap: () {
                    Get.back();
                    final dashboardController = Get.find<DashboardController>();
                    CommonAlertDialog.showDialog(
                        isShowNegativeBtn: true,
                        isPositiveBtnOutlined: true,
                        message: "message_logout",
                        positiveText: "logout",
                        positiveBtnCallback: dashboardController.logOut,
                        negativeText: 'no',
                        positiveBtnColor: AppColors.colorFE7A7A);
                  },
                  leading: AppIcons.icLogOut,
                  title: "log_out"),
              const SizedBox(
                height: 56,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AppImages.imgLogo2,
                  width: 75,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "${'version'.tr} 1.0.0",
                  style: GoogleFonts.notoSans(
                      textStyle: TextStyle(
                          color: Colors.black.withValues(alpha: 0.5),
                          fontSize: AppConsts.commonFontSizeFactor * 12,
                          fontWeight: FontWeight.w400)),
                ),
                const SizedBox(
                  height: 76,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
