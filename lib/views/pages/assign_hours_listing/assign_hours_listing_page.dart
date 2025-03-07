import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/config/app_routes.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/consts/app_icons.dart';
import 'package:teqtop_team/controllers/assign_hours_listing/assign_hours_listing_controller.dart';
import 'package:teqtop_team/model/assign_hours_listing/assign_hours.dart';
import 'package:teqtop_team/model/global_search/project_model.dart';
import 'package:teqtop_team/views/pages/assign_hours_listing/components/assign_hour_widget.dart';
import 'package:teqtop_team/views/pages/assign_hours_listing/components/assign_hour_widget_shimmer.dart';
import 'package:teqtop_team/views/pages/dashboard/components/menu_drawer_widget.dart';
import 'package:teqtop_team/views/widgets/common/common_button_shimmer.dart';

import '../../../consts/app_images.dart';
import '../../../model/daily_reports_listing/value_time.dart';
import '../../../model/employees_listing/employee_model.dart';
import '../../widgets/common/common_button.dart';
import '../../widgets/common/common_button_outline.dart';
import '../../widgets/common/common_dropdown_button.dart';
import '../../widgets/common/common_input_field.dart';
import '../../widgets/common/common_search_field.dart';

class AssignHoursListingPage extends StatelessWidget {
  final assignHoursListingController = Get.put(AssignHoursListingController());

  AssignHoursListingPage({super.key});

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
        key: assignHoursListingController.scaffoldKey,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                color: Colors.black.withValues(alpha: 0.05),
                height: 1,
              )),
          title: Text(
            'assign_hours'.tr,
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          leading: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                assignHoursListingController.scaffoldKey.currentState
                    ?.openDrawer();
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  AppIcons.icMenu,
                  color:
                      Colors.black,
                ),
              )),
          backgroundColor: Colors.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Get.toNamed(AppRoutes.routeGlobalSearch);
                  },
                  child: Image.asset(
                    AppIcons.icSearch,
                    width: 24,
                    color:
                        Colors.black,
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
                      padding: const EdgeInsets.only(top: 4, right: 12),
                      child: Image.asset(
                        AppIcons.icBell,
                        width: 24,
                      ),
                    ),
                    Positioned(
                        left: 12,
                        top: 0,
                        child: Visibility(
                            visible: assignHoursListingController
                                    .notificationsCount.value >
                                0,
                            child: Container(
                              height: 12,
                              width: assignHoursListingController
                                          .notificationsCount.value
                                          .toString()
                                          .length >
                                      1
                                  ? (12 +
                                          ((assignHoursListingController
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
                                  assignHoursListingController
                                      .notificationsCount.value
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
                  radius: 14,
                  backgroundImage: const AssetImage(AppImages.imgPersonPlaceholder),
                  foregroundImage:
                      assignHoursListingController.profilePhoto != null
                          ? NetworkImage(AppConsts.imgInitialUrl +
                              assignHoursListingController.profilePhoto!)
                          : const AssetImage(AppImages.imgPersonPlaceholder),
                ),
              ),
            )
          ],
        ),
        backgroundColor: Colors.white,
        drawer: const MenuDrawerWidget(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Obx(
                  () => assignHoursListingController
                              .areAssignHoursLoading.value ||
                          assignHoursListingController.areUsersLoading.value ||
                          assignHoursListingController.areProjectsLoading.value
                      ? Shimmer.fromColors(
                          baseColor: AppColors.shimmerBaseColor,
                          highlightColor: AppColors.shimmerHighlightColor,
                          child: Container(
                            height: 48.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.shimmerBaseColor,
                            ),
                          ))
                      : CommonSearchField(
                          isShowLeading: true,
                          controller:
                              assignHoursListingController.searchTextController,
                          onChanged: assignHoursListingController
                              .handleSearchTextChange,
                          hint: "search",
                          isShowTrailing: assignHoursListingController
                              .showSearchFieldTrailing,
                          onTapTrailing: assignHoursListingController
                              .handleClearSearchField,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                        ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Obx(() => assignHoursListingController
                            .areAssignHoursLoading.value ||
                        assignHoursListingController.areUsersLoading.value ||
                        assignHoursListingController.areProjectsLoading.value
                    ? Shimmer.fromColors(
                        baseColor: AppColors.shimmerBaseColor,
                        highlightColor: AppColors.shimmerHighlightColor,
                        child: Container(
                          height: 48.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.shimmerBaseColor,
                          ),
                        ))
                    : CommonDropdownWidget(
                        maxDropdownHeight: 200,
                        height: 48,
                        onChanged: assignHoursListingController.onChangeProject,
                        items: assignHoursListingController.projects
                            .map((project) => DropdownMenuItem<ProjectModel>(
                                  value: project,
                                  child: Text(
                                    project != null ? project.name ?? "" : "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            fontSize:
                                                AppConsts.commonFontSizeFactor *
                                                    14),
                                  ),
                                ))
                            .toList(),
                        value: assignHoursListingController.selectedProject,
                        selectedItemBuilder: (BuildContext context) {
                          return assignHoursListingController.projects
                              .map<Widget>((project) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                project != null && project.name != null
                                    ? project.name!
                                    : "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color:
                                            Colors.black.withValues(alpha: 0.5),
                                        fontSize:
                                            AppConsts.commonFontSizeFactor *
                                                14),
                              ),
                            );
                          }).toList();
                        },
                      )),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Obx(
                        () => assignHoursListingController
                                    .areAssignHoursLoading.value ||
                                assignHoursListingController
                                    .areUsersLoading.value ||
                                assignHoursListingController
                                    .areProjectsLoading.value
                            ? Shimmer.fromColors(
                                baseColor: AppColors.shimmerBaseColor,
                                highlightColor: AppColors.shimmerHighlightColor,
                                child: Container(
                                  height: 48.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.shimmerBaseColor,
                                  ),
                                ))
                            : CommonDropdownWidget(
                                maxDropdownHeight: 200,
                                height: 48,
                                onChanged:
                                    assignHoursListingController.onChangeUser,
                                items: assignHoursListingController.users
                                    .map((user) =>
                                        DropdownMenuItem<EmployeeModel>(
                                          value: user,
                                          child: Text(
                                            user != null ? user.name ?? "" : "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontSize: AppConsts
                                                            .commonFontSizeFactor *
                                                        14),
                                          ),
                                        ))
                                    .toList(),
                                value:
                                    assignHoursListingController.selectedUser,
                                selectedItemBuilder: (BuildContext context) {
                                  return assignHoursListingController.users
                                      .map<Widget>((user) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        user != null && user.name != null
                                            ? user.name!
                                            : "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                color: Colors.black
                                                    .withValues(alpha: 0.5),
                                                fontSize: AppConsts
                                                        .commonFontSizeFactor *
                                                    14),
                                      ),
                                    );
                                  }).toList();
                                },
                              ),
                      ),
                    ),
                    const SizedBox(
                      width: 18,
                    ),
                    Expanded(
                      child: Obx(
                        () => assignHoursListingController
                                    .areAssignHoursLoading.value ||
                                assignHoursListingController
                                    .areUsersLoading.value ||
                                assignHoursListingController
                                    .areProjectsLoading.value
                            ? Shimmer.fromColors(
                                baseColor: AppColors.shimmerBaseColor,
                                highlightColor: AppColors.shimmerHighlightColor,
                                child: Container(
                                  height: 48.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.shimmerBaseColor,
                                  ),
                                ))
                            : CommonDropdownWidget(
                                maxDropdownHeight: 200,
                                height: 48,
                                onChanged:
                                    assignHoursListingController.onChangeTime,
                                items: assignHoursListingController.times
                                    .map((time) => DropdownMenuItem<ValueTime>(
                                          value: time,
                                          child: Text(
                                            time.time,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontSize: AppConsts
                                                            .commonFontSizeFactor *
                                                        14),
                                          ),
                                        ))
                                    .toList(),
                                value:
                                    assignHoursListingController.selectedTime,
                                selectedItemBuilder: (BuildContext context) {
                                  return assignHoursListingController.times
                                      .map<Widget>((time) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        time.time,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                color: Colors.black
                                                    .withValues(alpha: 0.5),
                                                fontSize: AppConsts
                                                        .commonFontSizeFactor *
                                                    14),
                                      ),
                                    );
                                  }).toList();
                                },
                              ),
                      ),
                    ),
                  ],
                ),
                Obx(
                  () => Visibility(
                    visible: assignHoursListingController.selectedTime.value !=
                            null &&
                        assignHoursListingController.selectedTime.value!.time ==
                            "select_date".tr,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CommonInputField(
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color:
                                          Colors.black.withValues(alpha: 0.5),
                                      fontSize:
                                          AppConsts.commonFontSizeFactor * 14),
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color:
                                          Colors.black.withValues(alpha: 0.1),
                                      fontSize:
                                          AppConsts.commonFontSizeFactor * 14),
                              inputVerticalPadding: 0,
                              inputHorizontalPadding: 16,
                              showLabel: false,
                              controller: assignHoursListingController
                                  .startDateController,
                              hint: "start_date",
                              label: "start_date",
                              borderWidth: 0,
                              inputType: TextInputType.datetime,
                              textInputAction: TextInputAction.done,
                              fillColor:
                                  AppColors.colorD9D9D9.withValues(alpha: 0.2),
                              borderColor: Colors.transparent,
                              isEnable: false,
                              onTap: assignHoursListingController
                                  .handleStartDateFieldOnTap,
                              onTapFirstArg: context,
                              errorMaxLines: 2,
                            ),
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          Expanded(
                            child: CommonInputField(
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color:
                                          Colors.black.withValues(alpha: 0.5),
                                      fontSize:
                                          AppConsts.commonFontSizeFactor * 14),
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color:
                                          Colors.black.withValues(alpha: 0.1),
                                      fontSize:
                                          AppConsts.commonFontSizeFactor * 14),
                              inputVerticalPadding: 0,
                              inputHorizontalPadding: 16,
                              showLabel: false,
                              controller: assignHoursListingController
                                  .endDateController,
                              hint: "end_date",
                              label: "end_date",
                              borderWidth: 0,
                              inputType: TextInputType.datetime,
                              textInputAction: TextInputAction.done,
                              fillColor:
                                  AppColors.colorD9D9D9.withValues(alpha: 0.2),
                              borderColor: Colors.transparent,
                              isEnable: false,
                              onTap: assignHoursListingController
                                  .handleEndDateFieldOnTap,
                              onTapFirstArg: context,
                              errorMaxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                        child: Obx(
                      () => assignHoursListingController
                                  .areAssignHoursLoading.value ||
                              assignHoursListingController
                                  .areUsersLoading.value ||
                              assignHoursListingController
                                  .areProjectsLoading.value
                          ? const CommonButtonShimmer(
                              borderRadius: 0,
                              height: 48,
                            )
                          : CommonButtonOutline(
                              text: "reset".tr,
                              onClick: () {
                                assignHoursListingController.resetFilters();
                              },
                              fontWeight: FontWeight.w600,
                              height: 48,
                            ),
                    )),
                    const SizedBox(
                      width: 18,
                    ),
                    Expanded(
                        child: Obx(
                      () => assignHoursListingController
                                  .areAssignHoursLoading.value ||
                              assignHoursListingController
                                  .areUsersLoading.value ||
                              assignHoursListingController
                                  .areProjectsLoading.value
                          ? const CommonButtonShimmer(
                              borderRadius: 0,
                              height: 48,
                            )
                          : CommonButton(
                              text: "filter".tr,
                              onClick: () {
                                assignHoursListingController.filterData = true;
                                assignHoursListingController.getAssignHours();
                              },
                              fontWeight: FontWeight.w600,
                              fontSize: AppConsts.commonFontSizeFactor * 16,
                              height: 48,
                            ),
                    ))
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Obx(
                  () => assignHoursListingController
                              .areAssignHoursLoading.value ||
                          assignHoursListingController.areUsersLoading.value ||
                          assignHoursListingController.areProjectsLoading.value
                      ? Shimmer.fromColors(
                          baseColor: AppColors.shimmerBaseColor,
                          highlightColor: AppColors.shimmerHighlightColor,
                          child: Container(
                            height: 94.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.shimmerBaseColor,
                            ),
                          ))
                      : GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Get.toNamed(AppRoutes
                                .routeCreateEditEmployeeAssignedProjectsHours);
                          },
                          child: DottedBorder(
                            color: Colors.black.withValues(alpha: 0.2),
                            padding: EdgeInsets.zero,
                            dashPattern: const [4],
                            strokeWidth: 1,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 34),
                              color: AppColors.colorF7F7F7,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.color7E869E
                                            .withValues(alpha: 0.25)),
                                    child: Icon(
                                      Icons.add_rounded,
                                      color: AppColors.color222222,
                                      size: 14,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 14,
                                  ),
                                  Text(
                                    "create".tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            fontSize:
                                                AppConsts.commonFontSizeFactor *
                                                    18),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
                Obx(
                  () => GridView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: assignHoursListingController
                                  .areAssignHoursLoading.value ||
                              assignHoursListingController
                                  .areUsersLoading.value ||
                              assignHoursListingController
                                  .areProjectsLoading.value
                          ? 10
                          : assignHoursListingController.assignHoursList.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return assignHoursListingController
                                    .areAssignHoursLoading.value ||
                                assignHoursListingController
                                    .areUsersLoading.value ||
                                assignHoursListingController
                                    .areProjectsLoading.value
                            ? const AssignHourWidgetShimmer()
                            : AssignHourWidget(
                                onTap: assignHoursListingController
                                    .handleAssignHourOnTap,
                                index: index,
                                assignHoursData: assignHoursListingController
                                        .assignHoursList[index] ??
                                    AssignHours(),
                              );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
