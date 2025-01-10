import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/controllers/employee_detail/employee_detail_controller.dart';
import 'package:teqtop_team/utils/helpers.dart';
import 'package:teqtop_team/views/pages/employee_detail/components/leave_widget.dart';
import 'package:teqtop_team/views/pages/employee_detail/components/leave_widget_shimmer.dart';
import 'package:teqtop_team/views/widgets/common/common_button.dart';

import '../../../consts/app_consts.dart';
import '../../../consts/app_icons.dart';
import '../../../consts/app_images.dart';

class EmployeeDetailPage extends StatelessWidget {
  final employeeDetailController = Get.put(EmployeeDetailController());

  EmployeeDetailPage({super.key});

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
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: NestedScrollView(
          controller: employeeDetailController.scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Obx(
                        () => employeeDetailController
                                    .isEmployeeDetailLoading.value ||
                                employeeDetailController
                                    .areEmployeeLeavesLoading.value
                            ? Shimmer.fromColors(
                                baseColor: AppColors.shimmerBaseColor,
                                highlightColor: AppColors.shimmerHighlightColor,
                                child: Container(
                                  width: 116,
                                  height: 116,
                                  decoration: BoxDecoration(
                                      color: AppColors.shimmerBaseColor,
                                      shape: BoxShape.circle),
                                ))
                            : CircleAvatar(
                                radius: 58,
                                backgroundImage:
                                    AssetImage(AppImages.imgPersonPlaceholder),
                                foregroundImage: employeeDetailController
                                                .employeeDetail.value !=
                                            null &&
                                        employeeDetailController.employeeDetail
                                            .value!.profile is String
                                    ? NetworkImage(AppConsts.imgInitialUrl +
                                        employeeDetailController
                                            .employeeDetail.value!.profile!)
                                    : AssetImage(
                                        AppImages.imgPersonPlaceholder),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Obx(
                      () => employeeDetailController
                                  .isEmployeeDetailLoading.value ||
                              employeeDetailController
                                  .areEmployeeLeavesLoading.value
                          ? Shimmer.fromColors(
                              baseColor: AppColors.shimmerBaseColor,
                              highlightColor: AppColors.shimmerHighlightColor,
                              child: Container(
                                height: 24.0,
                                width: 80.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.0),
                                  color: AppColors.shimmerBaseColor,
                                ),
                              ))
                          : Text(
                              employeeDetailController.employeeDetail.value !=
                                      null
                                  ? employeeDetailController
                                          .employeeDetail.value!.name ??
                                      ""
                                  : "",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                    ),
                    Obx(() => Visibility(
                        visible: employeeDetailController
                                .isEmployeeDetailLoading.value ||
                            employeeDetailController
                                .areEmployeeLeavesLoading.value,
                        child: const SizedBox(
                          height: 4,
                        ))),
                    Obx(
                      () => employeeDetailController
                                  .isEmployeeDetailLoading.value ||
                              employeeDetailController
                                  .areEmployeeLeavesLoading.value
                          ? Shimmer.fromColors(
                              baseColor: AppColors.shimmerBaseColor,
                              highlightColor: AppColors.shimmerHighlightColor,
                              child: Container(
                                height: 24.0,
                                width: 150.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.0),
                                  color: AppColors.shimmerBaseColor,
                                ),
                              ))
                          : Text(
                              employeeDetailController.employeeDetail.value !=
                                      null
                                  ? employeeDetailController
                                          .employeeDetail.value!.email ??
                                      ""
                                  : "",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.normal),
                            ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Obx(
                      () => employeeDetailController
                                  .isEmployeeDetailLoading.value ||
                              employeeDetailController
                                  .areEmployeeLeavesLoading.value
                          ? Shimmer.fromColors(
                              baseColor: AppColors.shimmerBaseColor,
                              highlightColor: AppColors.shimmerHighlightColor,
                              child: Container(
                                height: 28.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.0),
                                  color: AppColors.shimmerBaseColor,
                                ),
                              ))
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 4),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.zero,
                                  color: employeeDetailController
                                                  .employeeDetail.value !=
                                              null &&
                                          employeeDetailController
                                                  .employeeDetail.value!.status
                                                  .toString()
                                                  .toLowerCase() ==
                                              "active"
                                      ? AppColors.color54B435
                                      : Colors.transparent),
                              child: Text(
                                employeeDetailController.employeeDetail.value !=
                                            null &&
                                        employeeDetailController.employeeDetail
                                            .value!.status is String
                                    ? employeeDetailController
                                        .employeeDetail.value!.status
                                    : "active",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: employeeDetailController.tabController,
                    indicatorColor: AppColors.kPrimaryColor,
                    tabs: [
                      Tab(
                        text: "information".tr,
                      ),
                      Tab(
                        text: "document".tr,
                      ),
                      Tab(
                        text: "leaves".tr,
                      )
                    ],
                    labelColor: AppColors.kPrimaryColor,
                    unselectedLabelColor: Colors.black,
                    labelStyle: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                    labelPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: employeeDetailController.tabController,
            children: [
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 28,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${Helpers.capitalizeFirstLetter("contact_number".tr)}:",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Obx(
                          () => employeeDetailController
                                      .isEmployeeDetailLoading.value ||
                                  employeeDetailController
                                      .areEmployeeLeavesLoading.value
                              ? Shimmer.fromColors(
                                  baseColor: AppColors.shimmerBaseColor,
                                  highlightColor:
                                      AppColors.shimmerHighlightColor,
                                  child: Container(
                                    height: 24.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.0),
                                      color: AppColors.shimmerBaseColor,
                                    ),
                                  ))
                              : Text(
                                  employeeDetailController
                                                  .employeeDetail.value !=
                                              null &&
                                          employeeDetailController
                                              .employeeDetail
                                              .value!
                                              .contactNo is String
                                      ? "+91 ${employeeDetailController.employeeDetail.value!.contactNo}"
                                      : "",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Divider(
                      thickness: 0.5,
                      height: 0.5,
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${"date_of_birth".tr}:",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Obx(
                          () => employeeDetailController
                                      .isEmployeeDetailLoading.value ||
                                  employeeDetailController
                                      .areEmployeeLeavesLoading.value
                              ? Shimmer.fromColors(
                                  baseColor: AppColors.shimmerBaseColor,
                                  highlightColor:
                                      AppColors.shimmerHighlightColor,
                                  child: Container(
                                    height: 24.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.0),
                                      color: AppColors.shimmerBaseColor,
                                    ),
                                  ))
                              : Text(
                                  employeeDetailController
                                                  .employeeDetail.value !=
                                              null &&
                                          employeeDetailController
                                              .employeeDetail
                                              .value!
                                              .birthDate is DateTime
                                      ? DateFormat("dd/MM/yyyy").format(
                                          employeeDetailController
                                              .employeeDetail.value!.birthDate)
                                      : "",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Divider(
                      thickness: 0.5,
                      height: 0.5,
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${"role".tr}:",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Obx(
                          () => employeeDetailController
                                      .isEmployeeDetailLoading.value ||
                                  employeeDetailController
                                      .areEmployeeLeavesLoading.value
                              ? Shimmer.fromColors(
                                  baseColor: AppColors.shimmerBaseColor,
                                  highlightColor:
                                      AppColors.shimmerHighlightColor,
                                  child: Container(
                                    height: 24.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.0),
                                      color: AppColors.shimmerBaseColor,
                                    ),
                                  ))
                              : Text(
                                  employeeDetailController
                                                  .employeeDetail.value !=
                                              null &&
                                          employeeDetailController
                                                  .employeeDetail
                                                  .value!
                                                  .roles !=
                                              null
                                      ? employeeDetailController
                                              .employeeDetail.value!.roles ??
                                          ""
                                      : "",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Divider(
                      thickness: 0.5,
                      height: 0.5,
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${"position".tr}:",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Obx(
                          () => employeeDetailController
                                      .isEmployeeDetailLoading.value ||
                                  employeeDetailController
                                      .areEmployeeLeavesLoading.value
                              ? Shimmer.fromColors(
                                  baseColor: AppColors.shimmerBaseColor,
                                  highlightColor:
                                      AppColors.shimmerHighlightColor,
                                  child: Container(
                                    height: 24.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.0),
                                      color: AppColors.shimmerBaseColor,
                                    ),
                                  ))
                              : Text(
                                  employeeDetailController
                                                  .employeeDetail.value !=
                                              null &&
                                          employeeDetailController
                                              .employeeDetail
                                              .value!
                                              .userPosition is String
                                      ? employeeDetailController
                                          .employeeDetail.value!.userPosition
                                      : "",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Divider(
                      thickness: 0.5,
                      height: 0.5,
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${"employee_id".tr}:",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Obx(
                          () => employeeDetailController
                                      .isEmployeeDetailLoading.value ||
                                  employeeDetailController
                                      .areEmployeeLeavesLoading.value
                              ? Shimmer.fromColors(
                                  baseColor: AppColors.shimmerBaseColor,
                                  highlightColor:
                                      AppColors.shimmerHighlightColor,
                                  child: Container(
                                    height: 24.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.0),
                                      color: AppColors.shimmerBaseColor,
                                    ),
                                  ))
                              : Text(
                                  employeeDetailController
                                                  .employeeDetail.value !=
                                              null &&
                                          employeeDetailController
                                                  .employeeDetail
                                                  .value!
                                                  .employeeId !=
                                              null
                                      ? employeeDetailController.employeeDetail
                                              .value!.employeeId ??
                                          ""
                                      : "",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Divider(
                      thickness: 0.5,
                      height: 0.5,
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${"registered_on".tr}:",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Obx(
                          () => employeeDetailController
                                      .isEmployeeDetailLoading.value ||
                                  employeeDetailController
                                      .areEmployeeLeavesLoading.value
                              ? Shimmer.fromColors(
                                  baseColor: AppColors.shimmerBaseColor,
                                  highlightColor:
                                      AppColors.shimmerHighlightColor,
                                  child: Container(
                                    height: 24.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.0),
                                      color: AppColors.shimmerBaseColor,
                                    ),
                                  ))
                              : Text(
                                  employeeDetailController
                                                  .employeeDetail.value !=
                                              null &&
                                          employeeDetailController
                                                  .employeeDetail
                                                  .value!
                                                  .createdAt !=
                                              null
                                      ? DateFormat("MMM dd, yyyy HH:mm").format(
                                          employeeDetailController
                                              .employeeDetail.value!.createdAt!)
                                      : "",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Divider(
                      thickness: 0.5,
                      height: 0.5,
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${"joining_date".tr}:",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Obx(
                          () => employeeDetailController
                                      .isEmployeeDetailLoading.value ||
                                  employeeDetailController
                                      .areEmployeeLeavesLoading.value
                              ? Shimmer.fromColors(
                                  baseColor: AppColors.shimmerBaseColor,
                                  highlightColor:
                                      AppColors.shimmerHighlightColor,
                                  child: Container(
                                    height: 24.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.0),
                                      color: AppColors.shimmerBaseColor,
                                    ),
                                  ))
                              : Text(
                                  employeeDetailController
                                                  .employeeDetail.value !=
                                              null &&
                                          employeeDetailController
                                              .employeeDetail
                                              .value!
                                              .joiningDate is DateTime
                                      ? DateFormat("MMM dd, yyyy HH:mm").format(
                                          employeeDetailController
                                              .employeeDetail
                                              .value!
                                              .joiningDate)
                                      : "",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 88,
                    ),
                    CommonButton(text: "edit_information", onClick: () {})
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 32,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "aadhar_card".tr.toUpperCase(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 98,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 16,
                            ),
                            Obx(
                              () => employeeDetailController
                                          .isEmployeeDetailLoading.value ||
                                      employeeDetailController
                                          .areEmployeeLeavesLoading.value
                                  ? Shimmer.fromColors(
                                      baseColor: AppColors.shimmerBaseColor,
                                      highlightColor:
                                          AppColors.shimmerHighlightColor,
                                      child: Container(
                                        height: 98,
                                        width: 152,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3.0),
                                          color: AppColors.shimmerBaseColor,
                                        ),
                                      ))
                                  : Image.asset(
                                      AppImages.imgPlaceholder,
                                      width: 152,
                                      height: 98,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Obx(
                              () => employeeDetailController
                                          .isEmployeeDetailLoading.value ||
                                      employeeDetailController
                                          .areEmployeeLeavesLoading.value
                                  ? Shimmer.fromColors(
                                      baseColor: AppColors.shimmerBaseColor,
                                      highlightColor:
                                          AppColors.shimmerHighlightColor,
                                      child: Container(
                                        height: 98,
                                        width: 152,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3.0),
                                          color: AppColors.shimmerBaseColor,
                                        ),
                                      ))
                                  : Image.asset(
                                      AppImages.imgPlaceholder,
                                      width: 152,
                                      height: 98,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 52,
                              height: 98,
                              decoration:
                                  BoxDecoration(color: AppColors.kPrimaryColor),
                              child: Center(
                                child: SvgPicture.asset(
                                  AppIcons.icDownload,
                                  width: 24,
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "pan_card".tr.toUpperCase(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 98,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 16,
                            ),
                            Obx(
                              () => employeeDetailController
                                          .isEmployeeDetailLoading.value ||
                                      employeeDetailController
                                          .areEmployeeLeavesLoading.value
                                  ? Shimmer.fromColors(
                                      baseColor: AppColors.shimmerBaseColor,
                                      highlightColor:
                                          AppColors.shimmerHighlightColor,
                                      child: Container(
                                        height: 98,
                                        width: 152,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3.0),
                                          color: AppColors.shimmerBaseColor,
                                        ),
                                      ))
                                  : Image.asset(
                                      AppImages.imgPlaceholder,
                                      width: 152,
                                      height: 98,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Obx(
                              () => employeeDetailController
                                          .isEmployeeDetailLoading.value ||
                                      employeeDetailController
                                          .areEmployeeLeavesLoading.value
                                  ? Shimmer.fromColors(
                                      baseColor: AppColors.shimmerBaseColor,
                                      highlightColor:
                                          AppColors.shimmerHighlightColor,
                                      child: Container(
                                        height: 98,
                                        width: 152,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3.0),
                                          color: AppColors.shimmerBaseColor,
                                        ),
                                      ))
                                  : Image.asset(
                                      AppImages.imgPlaceholder,
                                      width: 152,
                                      height: 98,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 52,
                              height: 98,
                              decoration:
                                  BoxDecoration(color: AppColors.kPrimaryColor),
                              child: Center(
                                child: SvgPicture.asset(
                                  AppIcons.icDownload,
                                  width: 24,
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "official_document".tr.toUpperCase(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 98,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 16,
                            ),
                            Obx(
                              () => employeeDetailController
                                          .isEmployeeDetailLoading.value ||
                                      employeeDetailController
                                          .areEmployeeLeavesLoading.value
                                  ? Shimmer.fromColors(
                                      baseColor: AppColors.shimmerBaseColor,
                                      highlightColor:
                                          AppColors.shimmerHighlightColor,
                                      child: Container(
                                        height: 98,
                                        width: 152,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3.0),
                                          color: AppColors.shimmerBaseColor,
                                        ),
                                      ))
                                  : Image.asset(
                                      AppImages.imgPlaceholder,
                                      width: 152,
                                      height: 98,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Obx(
                              () => employeeDetailController
                                          .isEmployeeDetailLoading.value ||
                                      employeeDetailController
                                          .areEmployeeLeavesLoading.value
                                  ? Shimmer.fromColors(
                                      baseColor: AppColors.shimmerBaseColor,
                                      highlightColor:
                                          AppColors.shimmerHighlightColor,
                                      child: Container(
                                        height: 98,
                                        width: 152,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3.0),
                                          color: AppColors.shimmerBaseColor,
                                        ),
                                      ))
                                  : Image.asset(
                                      AppImages.imgPlaceholder,
                                      width: 152,
                                      height: 98,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 52,
                              height: 98,
                              decoration:
                                  BoxDecoration(color: AppColors.kPrimaryColor),
                              child: Center(
                                child: SvgPicture.asset(
                                  AppIcons.icDownload,
                                  width: 24,
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "qualification_experience_document".tr.toUpperCase(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 98,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 16,
                            ),
                            Obx(
                              () => employeeDetailController
                                          .isEmployeeDetailLoading.value ||
                                      employeeDetailController
                                          .areEmployeeLeavesLoading.value
                                  ? Shimmer.fromColors(
                                      baseColor: AppColors.shimmerBaseColor,
                                      highlightColor:
                                          AppColors.shimmerHighlightColor,
                                      child: Container(
                                        height: 98,
                                        width: 152,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3.0),
                                          color: AppColors.shimmerBaseColor,
                                        ),
                                      ))
                                  : Image.asset(
                                      AppImages.imgPlaceholder,
                                      width: 152,
                                      height: 98,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Obx(
                              () => employeeDetailController
                                          .isEmployeeDetailLoading.value ||
                                      employeeDetailController
                                          .areEmployeeLeavesLoading.value
                                  ? Shimmer.fromColors(
                                      baseColor: AppColors.shimmerBaseColor,
                                      highlightColor:
                                          AppColors.shimmerHighlightColor,
                                      child: Container(
                                        height: 98,
                                        width: 152,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3.0),
                                          color: AppColors.shimmerBaseColor,
                                        ),
                                      ))
                                  : Image.asset(
                                      AppImages.imgPlaceholder,
                                      width: 152,
                                      height: 98,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 52,
                              height: 98,
                              decoration:
                                  BoxDecoration(color: AppColors.kPrimaryColor),
                              child: Center(
                                child: SvgPicture.asset(
                                  AppIcons.icDownload,
                                  width: 24,
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(
                  () => employeeDetailController
                              .isEmployeeDetailLoading.value ||
                          employeeDetailController
                              .areEmployeeLeavesLoading.value
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Shimmer.fromColors(
                                baseColor: AppColors.shimmerBaseColor,
                                highlightColor: AppColors.shimmerHighlightColor,
                                child: Container(
                                  height: 20.0,
                                  width: 100.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3.0),
                                    color: AppColors.shimmerBaseColor,
                                  ),
                                )),
                            ListView.separated(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 14),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return LeaveWidgetShimmer();
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 12,
                                  );
                                },
                                itemCount: 5)
                          ],
                        )
                      : employeeDetailController.filteredLeaves.value != null
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: employeeDetailController
                                  .filteredLeaves.value!.entries
                                  .map((entry) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      entry.key,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    ListView.separated(
                                        padding: const EdgeInsets.only(
                                            top: 4, bottom: 14),
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return LeaveWidget(
                                            leaveData: entry.value[index],
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(
                                            height: 12,
                                          );
                                        },
                                        itemCount: entry.value.length)
                                  ],
                                );
                              }).toList(),
                            )
                          : const SizedBox(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.colorF7F7F7,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
