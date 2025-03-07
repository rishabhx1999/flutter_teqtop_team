import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/config/app_routes.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/consts/app_icons.dart';
import 'package:teqtop_team/controllers/daily_reports_listing/daily_reports_listing_controller.dart';
import 'package:teqtop_team/model/daily_reports_listing/daily_report.dart';
import 'package:teqtop_team/model/daily_reports_listing/value_time.dart';
import 'package:teqtop_team/model/employees_listing/employee_model.dart';
import 'package:teqtop_team/views/pages/daily_reports_listing/components/daily_report_widget.dart';
import 'package:teqtop_team/views/pages/daily_reports_listing/components/daily_report_widget_shimmer.dart';
import 'package:teqtop_team/views/pages/dashboard/components/menu_drawer_widget.dart';
import 'package:teqtop_team/views/widgets/common/common_button.dart';

import '../../../consts/app_images.dart';
import '../../widgets/common/common_dropdown_button.dart';
import '../../widgets/common/common_input_field.dart';

class DailyReportsListingPage extends StatelessWidget {
  final dailyReportsListingController =
      Get.put(DailyReportsListingController());

  DailyReportsListingPage({super.key});

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
        key: dailyReportsListingController.scaffoldKey,
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
                dailyReportsListingController.scaffoldKey.currentState
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
                            visible: dailyReportsListingController
                                    .notificationsCount.value >
                                0,
                            child: Container(
                              height: 12,
                              width: dailyReportsListingController
                                          .notificationsCount.value
                                          .toString()
                                          .length >
                                      1
                                  ? (12 +
                                          ((dailyReportsListingController
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
                                  dailyReportsListingController
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
                      dailyReportsListingController.profilePhoto != null
                          ? NetworkImage(AppConsts.imgInitialUrl +
                              dailyReportsListingController.profilePhoto!)
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
          controller: dailyReportsListingController.scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Obx(
                        () => dailyReportsListingController
                                    .areDailyReportsLoading.value ||
                                dailyReportsListingController
                                    .areUsersLoading.value
                            ? Shimmer.fromColors(
                                baseColor: AppColors.shimmerBaseColor,
                                highlightColor: AppColors.shimmerHighlightColor,
                                child: Container(
                                  height: 40.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.shimmerBaseColor,
                                  ),
                                ))
                            : CommonDropdownWidget(
                                maxDropdownHeight: 200,
                                onChanged:
                                    dailyReportsListingController.onChangeUser,
                                items: dailyReportsListingController.users
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
                                    dailyReportsListingController.selectedUser,
                                selectedItemBuilder: (BuildContext context) {
                                  return dailyReportsListingController.users
                                      .map<Widget>((user) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        user != null && user.name != null
                                            ? dailyReportsListingController
                                                .truncateDropdownSelectedValue(
                                                    user.name!)
                                            : "",
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
                        () => dailyReportsListingController
                                    .areDailyReportsLoading.value ||
                                dailyReportsListingController
                                    .areUsersLoading.value
                            ? Shimmer.fromColors(
                                baseColor: AppColors.shimmerBaseColor,
                                highlightColor: AppColors.shimmerHighlightColor,
                                child: Container(
                                  height: 40.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.shimmerBaseColor,
                                  ),
                                ))
                            : CommonDropdownWidget(
                                maxDropdownHeight: 200,
                                onChanged:
                                    dailyReportsListingController.onChangeTime,
                                items: dailyReportsListingController.times
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
                                    dailyReportsListingController.selectedTime,
                                selectedItemBuilder: (BuildContext context) {
                                  return dailyReportsListingController.times
                                      .map<Widget>((time) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        dailyReportsListingController
                                            .truncateDropdownSelectedValue(
                                                time.time),
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
                    visible: dailyReportsListingController.selectedTime.value !=
                            null &&
                        dailyReportsListingController
                                .selectedTime.value!.time ==
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
                              controller: dailyReportsListingController
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
                              onTap: dailyReportsListingController
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
                              controller: dailyReportsListingController
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
                              onTap: dailyReportsListingController
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
                Obx(
                  () => dailyReportsListingController
                              .areDailyReportsLoading.value ||
                          dailyReportsListingController.areUsersLoading.value
                      ? Shimmer.fromColors(
                          baseColor: AppColors.shimmerBaseColor,
                          highlightColor: AppColors.shimmerHighlightColor,
                          child: Container(
                            height: 40.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.shimmerBaseColor,
                            ),
                          ))
                      : CommonButton(
                          text: "search",
                          onClick: () {
                            dailyReportsListingController.dailyReports.clear();
                            dailyReportsListingController.getDailyReports();
                          },
                          height: 40,
                        ),
                ),
                Obx(
                  () => GridView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dailyReportsListingController
                                  .areUsersLoading.value ||
                              (dailyReportsListingController
                                      .areDailyReportsLoading.value &&
                                  dailyReportsListingController
                                      .dailyReports.isEmpty)
                          ? 10
                          : dailyReportsListingController.dailyReports.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return dailyReportsListingController
                                    .areUsersLoading.value ||
                                (dailyReportsListingController
                                        .areDailyReportsLoading.value &&
                                    dailyReportsListingController
                                        .dailyReports.isEmpty)
                            ? const DailyReportWidgetShimmer()
                            : DailyReportWidget(
                                dailyReportData: dailyReportsListingController
                                        .dailyReports[index] ??
                                    DailyReport(),
                                onTap: dailyReportsListingController
                                    .handleDailyReportOnTap,
                                index: index,
                              );
                      }),
                ),
                Obx(
                  () => Visibility(
                    visible: dailyReportsListingController
                            .areDailyReportsLoading.value &&
                        dailyReportsListingController.dailyReports.isNotEmpty,
                    child: GridView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 10,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          return const DailyReportWidgetShimmer();
                        }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
