import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teqtop_team/controllers/employee_assigned_projects_hours/employee_assigned_projects_hours_controller.dart';
import 'package:teqtop_team/views/pages/employee_assigned_projects_hours/components/employee_assigned_project_widget.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../consts/app_consts.dart';
import '../../../consts/app_icons.dart';
import '../../../consts/app_images.dart';
import '../../widgets/common/common_button.dart';

class EmployeeAssignedProjectsHoursPage extends StatelessWidget {
  final employeeAssignedProjectsHoursController =
      Get.put(EmployeeAssignedProjectsHoursController());

  EmployeeAssignedProjectsHoursPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'assigned_detail'.tr,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
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
            padding: const EdgeInsets.only(right: 10),
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
                          visible: employeeAssignedProjectsHoursController
                                  .notificationsCount.value >
                              0,
                          child: Container(
                            height: 12,
                            width: employeeAssignedProjectsHoursController
                                        .notificationsCount.value
                                        .toString()
                                        .length >
                                    1
                                ? (12 +
                                        ((employeeAssignedProjectsHoursController
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
                                employeeAssignedProjectsHoursController
                                    .notificationsCount.value
                                    .toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        fontSize:
                                            AppConsts.commonFontSizeFactor * 8),
                              ),
                            ),
                          )))
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Obx(
        () => IgnorePointer(
          ignoring:
              employeeAssignedProjectsHoursController.isDeleteLoading.value,
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 34,
                          backgroundImage:
                              AssetImage(AppImages.imgPersonPlaceholder),
                          foregroundImage:
                              employeeAssignedProjectsHoursController
                                          .employeeProfilePhoto !=
                                      null
                                  ? NetworkImage(AppConsts.imgInitialUrl +
                                      employeeAssignedProjectsHoursController
                                          .employeeProfilePhoto!)
                                  : AssetImage(AppImages.imgPersonPlaceholder),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Text(
                            employeeAssignedProjectsHoursController
                                    .employeeName ??
                                "",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontSize:
                                        AppConsts.commonFontSizeFactor * 18),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                text: "${"created".tr}: ",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        fontSize:
                                            AppConsts.commonFontSizeFactor *
                                                12),
                              ),
                              TextSpan(
                                  text: employeeAssignedProjectsHoursController
                                              .createdDateTime ==
                                          null
                                      ? ""
                                      : DateFormat("MMM dd, yyyy hh:mm a").format(
                                          employeeAssignedProjectsHoursController
                                              .createdDateTime!),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontSize:
                                              AppConsts.commonFontSizeFactor *
                                                  12))
                            ])),
                            Obx(
                              () => RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                  text: "${"modified".tr}: ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          fontSize:
                                              AppConsts.commonFontSizeFactor *
                                                  12),
                                ),
                                TextSpan(
                                    text: employeeAssignedProjectsHoursController
                                                .modifiedDateTime.value ==
                                            null
                                        ? ""
                                        : DateFormat("MMM dd, yyyy hh:mm a").format(
                                            employeeAssignedProjectsHoursController
                                                .modifiedDateTime.value!),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontSize:
                                                AppConsts.commonFontSizeFactor *
                                                    12))
                              ])),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CommonButton(
                              text: 'edit'.tr,
                              onClick: employeeAssignedProjectsHoursController
                                  .onEditTap,
                              width: 72,
                              height: 30,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.colorF5F5F7,
                                  ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Obx(
                              () => employeeAssignedProjectsHoursController
                                      .isDeleteLoading.value
                                  ? Container(
                                      height: 30,
                                      width: 72,
                                      padding: EdgeInsets.all(8),
                                      child: Center(
                                        child: SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.kPrimaryColor,
                                          ),
                                        ),
                                      ),
                                    )
                                  : CommonButton(
                                      text: 'delete'.tr,
                                      onClick:
                                          employeeAssignedProjectsHoursController
                                              .onDeleteTap,
                                      width: 72,
                                      height: 30,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColors.colorF5F5F7,
                                          ),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Obx(
                      () => ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 26),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return EmployeeAssignedProjectWidget(
                              employeeAssignedProjectData:
                                  employeeAssignedProjectsHoursController
                                      .employeeAssignedProjectsHours[index],
                              playPauseProject:
                                  employeeAssignedProjectsHoursController
                                      .playPauseProject,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 16,
                            );
                          },
                          itemCount: employeeAssignedProjectsHoursController
                              .employeeAssignedProjectsHours.length),
                    )
                  ],
                ),
              ),
              Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  right: 0,
                  child: Visibility(
                    visible: employeeAssignedProjectsHoursController
                        .isDeleteLoading.value,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.zero,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
