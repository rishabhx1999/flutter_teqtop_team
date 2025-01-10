import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teqtop_team/consts/app_images.dart';
import 'package:teqtop_team/controllers/project_detail/project_detail_controller.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../consts/app_consts.dart';
import '../../../consts/app_icons.dart';

class ProjectDetailPage extends StatelessWidget {
  final employeeDailyReportsController = Get.put(ProjectDetailController());

  ProjectDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white));

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: Colors.black.withValues(alpha: 0.05),
              height: 1,
            )),
        leading: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: SvgPicture.asset(
                AppIcons.icBack,
                colorFilter:
                    const ColorFilter.mode(Colors.black, BlendMode.srcIn),
              ),
            )),
        leadingWidth: 40,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: Container(
                width: 68,
                height: 28,
                decoration: BoxDecoration(
                    color: AppColors.colorF9F9F9,
                    border: Border.all(
                        color: Colors.black.withValues(alpha: 0.1),
                        width: 0.5)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppIcons.icEdit,
                      width: 24,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      "edit".tr,
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Get.toNamed(AppRoutes.routeDriveDetail);
              },
              child: Container(
                width: 68,
                height: 28,
                decoration: BoxDecoration(
                    color: AppColors.colorF9F9F9,
                    border: Border.all(
                        color: Colors.black.withValues(alpha: 0.1),
                        width: 0.5)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.imgDrive,
                      width: 18,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      "drive".tr,
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: Container(
                width: 68,
                height: 28,
                decoration: BoxDecoration(
                    color: AppColors.colorF9F9F9,
                    border: Border.all(
                        color: Colors.black.withValues(alpha: 0.1),
                        width: 0.5)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppIcons.icTask,
                      width: 24,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      "task".tr,
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 18,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
              decoration: BoxDecoration(
                  color: AppColors.colorF9F9F9,
                  borderRadius: BorderRadius.zero),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Jared Frost-Redesign some pages layouts for Joomla site-Upwork",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: AppConsts.commonFontSizeFactor * 22,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "www.example.com",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    DateFormat('MMM dd, yyyy').format(DateTime.now()),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 28,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "access_detail".tr.toUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
