import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/config/app_routes.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/consts/app_icons.dart';
import 'package:teqtop_team/views/pages/dashboard/components/drawer_widget.dart';

import '../../../consts/app_images.dart';
import '../../../controllers/daily_reports/daily_reports_controller.dart';

class DailyReportsPage extends StatelessWidget {
  final dailyReportsController = Get.put(DailyReportsController());

  DailyReportsPage({super.key});

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
          key: dailyReportsController.scaffoldKey,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.05),
                  height: 1,
                )),
            title: Text(
              'daily_reports'.tr,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            leading: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  dailyReportsController.scaffoldKey.currentState?.openDrawer();
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SvgPicture.asset(
                    AppIcons.icMenu,
                    colorFilter:
                        const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  ),
                )),
            backgroundColor: Colors.white,
            centerTitle: true,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 3),
                child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Get.toNamed(AppRoutes.routeGlobalSearch);
                    },
                    child: SvgPicture.asset(
                      AppIcons.icSearch,
                      width: 24,
                      colorFilter:
                          const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 7),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Get.toNamed(AppRoutes.routeNotifications);
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Image.asset(
                          AppIcons.icBell,
                          width: 24,
                        ),
                      ),
                      Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                                color: AppColors.colorFFB400,
                                shape: BoxShape.circle),
                            child: Center(
                                child: Text(
                              "2",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      fontSize:
                                          AppConsts.commonFontSizeFactor * 8),
                            )),
                          ))
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
                    backgroundImage: AssetImage(AppImages.imgPersonPlaceholder),
                    foregroundImage: dailyReportsController.profilePhoto != null
                        ? NetworkImage(AppConsts.imgInitialUrl +
                            dailyReportsController.profilePhoto!)
                        : AssetImage(AppImages.imgPersonPlaceholder),
                  ),
                ),
              )
            ],
          ),
          backgroundColor: Colors.white,
          drawer: DrawerWidget(),
          body: RefreshIndicator(
            color: AppColors.kPrimaryColor,
            backgroundColor: Colors.white,
            onRefresh: dailyReportsController.refreshPage,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [],
                ),
              ),
            ),
          )),
    );
  }
}
