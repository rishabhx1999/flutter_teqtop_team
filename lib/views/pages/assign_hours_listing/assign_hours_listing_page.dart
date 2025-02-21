import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/config/app_routes.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/consts/app_icons.dart';
import 'package:teqtop_team/controllers/assign_hours_listing/assign_hours_listing_controller.dart';
import 'package:teqtop_team/model/global_search/project_model.dart';
import 'package:teqtop_team/views/pages/dashboard/components/menu_drawer_widget.dart';
import 'package:teqtop_team/views/pages/projects_listing/components/project_widget.dart';
import 'package:teqtop_team/views/pages/projects_listing/components/project_widget_shimmer.dart';

import '../../../consts/app_images.dart';
import '../../widgets/common/common_dropdown_button.dart';
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
              padding: const EdgeInsets.only(right: 4),
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
                      padding: const EdgeInsets.only(top: 4, right: 12),
                      child: Image.asset(
                        AppIcons.icBell,
                        width: 24,
                      ),
                    ),
                    Positioned(
                        left: 12,
                        top: 0,
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
                                          AppConsts.commonFontSizeFactor * 8),
                            ),
                          ),
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
                  radius: 14,
                  backgroundImage: AssetImage(AppImages.imgPersonPlaceholder),
                  foregroundImage:
                      assignHoursListingController.profilePhoto != null
                          ? NetworkImage(AppConsts.imgInitialUrl +
                              assignHoursListingController.profilePhoto!)
                          : AssetImage(AppImages.imgPersonPlaceholder),
                ),
              ),
            )
          ],
        ),
        backgroundColor: Colors.white,
        drawer: MenuDrawerWidget(),
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
                CommonSearchField(
                  isShowLeading: true,
                  controller: assignHoursListingController.searchTextController,
                  onChanged:
                      assignHoursListingController.handleSearchTextChange,
                  hint: "search",
                  isShowTrailing:
                      assignHoursListingController.showSearchFieldTrailing,
                  onTapTrailing:
                      assignHoursListingController.handleClearSearchField,
                ),
                const SizedBox(
                  height: 16,
                ),
                // Row(
                //   mainAxisSize: MainAxisSize.max,
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Expanded(
                //       child: Obx(
                //             () => CommonDropdownWidget(
                //           maxDropdownHeight: 200,
                //           onChanged:
                //           dailyReportsListingController.onChangeUser,
                //           items: dailyReportsListingController.users
                //               .map((user) =>
                //               DropdownMenuItem<EmployeeModel>(
                //                 value: user,
                //                 child: Text(
                //                   user != null ? user.name ?? "" : "",
                //                   style: Theme.of(context)
                //                       .textTheme
                //                       .bodyMedium
                //                       ?.copyWith(
                //                       fontSize: AppConsts
                //                           .commonFontSizeFactor *
                //                           14),
                //                 ),
                //               ))
                //               .toList(),
                //           value:
                //           dailyReportsListingController.selectedUser,
                //           selectedItemBuilder: (BuildContext context) {
                //             return dailyReportsListingController.users
                //                 .map<Widget>((user) {
                //               return Align(
                //                 alignment: Alignment.centerLeft,
                //                 child: Text(
                //                   user != null && user.name != null
                //                       ? dailyReportsListingController
                //                       .truncateDropdownSelectedValue(
                //                       user.name!)
                //                       : "",
                //                   style: Theme.of(context)
                //                       .textTheme
                //                       .bodyMedium
                //                       ?.copyWith(
                //                       color: Colors.black
                //                           .withValues(alpha: 0.5),
                //                       fontSize: AppConsts
                //                           .commonFontSizeFactor *
                //                           14),
                //                 ),
                //               );
                //             }).toList();
                //           },
                //         ),
                //       ),
                //     ),
                //     const SizedBox(
                //       width: 18,
                //     ),
                //     Expanded(
                //       child: Obx(
                //             () => dailyReportsListingController
                //             .areDailyReportsLoading.value ||
                //             dailyReportsListingController
                //                 .areUsersLoading.value
                //             ? Shimmer.fromColors(
                //             baseColor: AppColors.shimmerBaseColor,
                //             highlightColor: AppColors.shimmerHighlightColor,
                //             child: Container(
                //               height: 40.0,
                //               width: double.infinity,
                //               decoration: BoxDecoration(
                //                 color: AppColors.shimmerBaseColor,
                //               ),
                //             ))
                //             : CommonDropdownWidget(
                //           maxDropdownHeight: 200,
                //           onChanged:
                //           dailyReportsListingController.onChangeTime,
                //           items: dailyReportsListingController.times
                //               .map((time) => DropdownMenuItem<ValueTime>(
                //             value: time,
                //             child: Text(
                //               time.time,
                //               style: Theme.of(context)
                //                   .textTheme
                //                   .bodyMedium
                //                   ?.copyWith(
                //                   fontSize: AppConsts
                //                       .commonFontSizeFactor *
                //                       14),
                //             ),
                //           ))
                //               .toList(),
                //           value:
                //           dailyReportsListingController.selectedTime,
                //           selectedItemBuilder: (BuildContext context) {
                //             return dailyReportsListingController.times
                //                 .map<Widget>((time) {
                //               return Align(
                //                 alignment: Alignment.centerLeft,
                //                 child: Text(
                //                   dailyReportsListingController
                //                       .truncateDropdownSelectedValue(
                //                       time.time),
                //                   style: Theme.of(context)
                //                       .textTheme
                //                       .bodyMedium
                //                       ?.copyWith(
                //                       color: Colors.black
                //                           .withValues(alpha: 0.5),
                //                       fontSize: AppConsts
                //                           .commonFontSizeFactor *
                //                           14),
                //                 ),
                //               );
                //             }).toList();
                //           },
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                // Obx(
                //       () => dailyReportsListingController
                //       .areDailyReportsLoading.value ||
                //       dailyReportsListingController.areUsersLoading.value
                //       ? Shimmer.fromColors(
                //       baseColor: AppColors.shimmerBaseColor,
                //       highlightColor: AppColors.shimmerHighlightColor,
                //       child: Container(
                //         height: 40.0,
                //         width: double.infinity,
                //         decoration: BoxDecoration(
                //           color: AppColors.shimmerBaseColor,
                //         ),
                //       ))
                //       : CommonButton(
                //     text: "search",
                //     onClick:
                //     dailyReportsListingController.getDailyReports,
                //     height: 40,
                //   ),
                // ),
                // Obx(
                //       () => GridView.builder(
                //       padding: EdgeInsets.symmetric(vertical: 20),
                //       shrinkWrap: true,
                //       physics: const NeverScrollableScrollPhysics(),
                //       itemCount: dailyReportsListingController
                //           .areUsersLoading.value ||
                //           dailyReportsListingController
                //               .areDailyReportsLoading.value
                //           ? 10
                //           : dailyReportsListingController.dailyReports.length,
                //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //           mainAxisSpacing: 20,
                //           crossAxisSpacing: 20,
                //           crossAxisCount: 2),
                //       itemBuilder: (context, index) {
                //         return dailyReportsListingController
                //             .areUsersLoading.value ||
                //             dailyReportsListingController
                //                 .areDailyReportsLoading.value
                //             ? DailyReportWidgetShimmer()
                //             : DailyReportWidget(
                //           dailyReportData: dailyReportsListingController
                //               .dailyReports[index] ??
                //               DailyReport(),
                //           onTap: dailyReportsListingController
                //               .handleDailyReportOnTap,
                //           index: index,
                //         );
                //       }),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
