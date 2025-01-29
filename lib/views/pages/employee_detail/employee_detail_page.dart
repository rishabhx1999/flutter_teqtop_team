import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/config/app_routes.dart';
import 'package:teqtop_team/controllers/employee_detail/employee_detail_controller.dart';
import 'package:teqtop_team/utils/employee_doc_type.dart';
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
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontSize:
                                          AppConsts.commonFontSizeFactor * 18),
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
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall,
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
                                                  .employeeDetail
                                                  .value!
                                                  .isActive ==
                                              "1"
                                      ? AppColors.color54B435
                                      : AppColors.colorF18585),
                              child: Text(
                                employeeDetailController.employeeDetail.value !=
                                            null &&
                                        employeeDetailController.employeeDetail
                                                .value!.isActive ==
                                            "1"
                                    ? "active".tr
                                    : "inactive".tr,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontSize:
                                            AppConsts.commonFontSizeFactor *
                                                14),
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
                    labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: AppConsts.commonFontSizeFactor * 14),
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
                        Expanded(
                          child: Text(
                            "${Helpers.capitalizeFirstLetter("contact_number".tr)}:",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize:
                                        AppConsts.commonFontSizeFactor * 14),
                          ),
                        ),
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
                                    height: 24.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.0),
                                      color: AppColors.shimmerBaseColor,
                                    ),
                                  ))
                              : Expanded(
                                  child: Text(
                                    employeeDetailController
                                                    .employeeDetail.value !=
                                                null &&
                                            employeeDetailController
                                                .employeeDetail
                                                .value!
                                                .contactNo is String
                                        ? "+91 ${employeeDetailController.employeeDetail.value!.contactNo}"
                                        : "",
                                    textAlign: TextAlign.end,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
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
                        Expanded(
                          child: Text(
                            "${"date_of_birth".tr}:",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize:
                                        AppConsts.commonFontSizeFactor * 14),
                          ),
                        ),
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
                                    height: 24.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.0),
                                      color: AppColors.shimmerBaseColor,
                                    ),
                                  ))
                              : Expanded(
                                  child: Text(
                                    employeeDetailController
                                                    .employeeDetail.value !=
                                                null &&
                                            employeeDetailController
                                                .employeeDetail
                                                .value!
                                                .birthDate is String
                                        ? DateFormat("dd/MM/yyyy").format(
                                            DateTime.parse(
                                                employeeDetailController
                                                    .employeeDetail
                                                    .value!
                                                    .birthDate))
                                        : "",
                                    textAlign: TextAlign.end,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
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
                        Expanded(
                          child: Text(
                            "${"role".tr}:",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize:
                                        AppConsts.commonFontSizeFactor * 14),
                          ),
                        ),
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
                                    height: 24.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.0),
                                      color: AppColors.shimmerBaseColor,
                                    ),
                                  ))
                              : Expanded(
                                  child: Text(
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
                                    textAlign: TextAlign.end,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
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
                        Expanded(
                          child: Text(
                            "${"position".tr}:",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize:
                                        AppConsts.commonFontSizeFactor * 14),
                          ),
                        ),
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
                                    height: 24.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.0),
                                      color: AppColors.shimmerBaseColor,
                                    ),
                                  ))
                              : Expanded(
                                  child: Text(
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
                                    textAlign: TextAlign.end,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
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
                        Expanded(
                          child: Text(
                            "${"employee_id".tr}:",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize:
                                        AppConsts.commonFontSizeFactor * 14),
                          ),
                        ),
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
                                    height: 24.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.0),
                                      color: AppColors.shimmerBaseColor,
                                    ),
                                  ))
                              : Expanded(
                                  child: Text(
                                    employeeDetailController
                                                    .employeeDetail.value !=
                                                null &&
                                            employeeDetailController
                                                    .employeeDetail
                                                    .value!
                                                    .employeeId !=
                                                null
                                        ? employeeDetailController
                                                .employeeDetail
                                                .value!
                                                .employeeId ??
                                            ""
                                        : "",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    textAlign: TextAlign.end,
                                  ),
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
                        Expanded(
                          child: Text(
                            "${"registered_on".tr}:",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize:
                                        AppConsts.commonFontSizeFactor * 14),
                          ),
                        ),
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
                                    height: 24.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.0),
                                      color: AppColors.shimmerBaseColor,
                                    ),
                                  ))
                              : Expanded(
                                  child: Text(
                                    employeeDetailController
                                                    .employeeDetail.value !=
                                                null &&
                                            employeeDetailController
                                                    .employeeDetail
                                                    .value!
                                                    .createdAt !=
                                                null
                                        ? DateFormat("MMM dd, yyyy HH:mm")
                                            .format(employeeDetailController
                                                .employeeDetail
                                                .value!
                                                .createdAt!)
                                        : "",
                                    textAlign: TextAlign.end,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
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
                        Expanded(
                          child: Text(
                            "${"joining_date".tr}:",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize:
                                        AppConsts.commonFontSizeFactor * 14),
                          ),
                        ),
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
                                    height: 24.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.0),
                                      color: AppColors.shimmerBaseColor,
                                    ),
                                  ))
                              : Expanded(
                                  child: Text(
                                    employeeDetailController
                                                    .employeeDetail.value !=
                                                null &&
                                            employeeDetailController
                                                .employeeDetail
                                                .value!
                                                .joiningDate is DateTime
                                        ? DateFormat("MMM dd, yyyy HH:mm")
                                            .format(employeeDetailController
                                                .employeeDetail
                                                .value!
                                                .joiningDate)
                                        : "",
                                    textAlign: TextAlign.end,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 88,
                    ),
                    CommonButton(
                        text: "edit_information",
                        onClick: () {
                          Get.toNamed(AppRoutes.routeEditEmployeeInformation);
                        })
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
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: AppConsts.commonFontSizeFactor * 14),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(
                      () => SizedBox(
                        height: 98,
                        child: ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return employeeDetailController
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
                                  : GestureDetector(
                                      onTap: () {
                                        employeeDetailController.openFile(
                                            EmployeeDocType.aadhaarCard, index);
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: Helpers.isImage(
                                              employeeDetailController
                                                  .aadharCardDocs[index])
                                          ? FadeInImage.assetNetwork(
                                              width: 152,
                                              height: 98,
                                              placeholder:
                                                  AppImages.imgPlaceholder,
                                              // Placeholder image
                                              image: AppConsts.imgInitialUrl +
                                                  employeeDetailController
                                                      .aadharCardDocs[index],
                                              imageErrorBuilder:
                                                  (BuildContext context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                return Image.asset(
                                                  AppImages.imgPlaceholder,
                                                  width: 152,
                                                  height: 98,
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                              fit: BoxFit.cover,
                                            )
                                          : employeeDetailController
                                                  .aadharCardDocs[index]
                                                  .isNotEmpty
                                              ? Container(
                                                  width: 152,
                                                  height: 98,
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  color:
                                                      AppColors.kPrimaryColor,
                                                  child: Center(
                                                    child: Text(
                                                      employeeDetailController
                                                          .aadharCardDocs[index]
                                                          .split("/")
                                                          .last,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                    );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                width: 10,
                              );
                            },
                            itemCount: employeeDetailController
                                        .isEmployeeDetailLoading.value ||
                                    employeeDetailController
                                        .areEmployeeLeavesLoading.value
                                ? 2
                                : employeeDetailController
                                    .aadharCardDocs.length),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "pan_card".tr.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: AppConsts.commonFontSizeFactor * 14),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(
                      () => SizedBox(
                        height: 98,
                        child: ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return employeeDetailController
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
                                  : GestureDetector(
                                      onTap: () {
                                        employeeDetailController.openFile(
                                            EmployeeDocType.panCard, index);
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: Helpers.isImage(
                                              employeeDetailController
                                                  .panCardDocs[index])
                                          ? FadeInImage.assetNetwork(
                                              width: 152,
                                              height: 98,
                                              placeholder:
                                                  AppImages.imgPlaceholder,
                                              // Placeholder image
                                              image: AppConsts.imgInitialUrl +
                                                  employeeDetailController
                                                      .panCardDocs[index],
                                              imageErrorBuilder:
                                                  (BuildContext context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                return Image.asset(
                                                  AppImages.imgPlaceholder,
                                                  width: 152,
                                                  height: 98,
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                              fit: BoxFit.cover,
                                            )
                                          : employeeDetailController
                                                  .panCardDocs[index].isNotEmpty
                                              ? Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  width: 152,
                                                  height: 98,
                                                  color:
                                                      AppColors.kPrimaryColor,
                                                  child: Center(
                                                    child: Text(
                                                      employeeDetailController
                                                          .panCardDocs[index]
                                                          .split("/")
                                                          .last,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                    );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                width: 10,
                              );
                            },
                            itemCount: employeeDetailController
                                        .isEmployeeDetailLoading.value ||
                                    employeeDetailController
                                        .areEmployeeLeavesLoading.value
                                ? 2
                                : employeeDetailController.panCardDocs.length),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "official_document".tr.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: AppConsts.commonFontSizeFactor * 14),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(
                      () => SizedBox(
                        height: 98,
                        child: ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return employeeDetailController
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
                                  : GestureDetector(
                                      onTap: () {
                                        employeeDetailController.openFile(
                                            EmployeeDocType.officialDoc, index);
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: Helpers.isImage(
                                              employeeDetailController
                                                  .officialDocs[index])
                                          ? FadeInImage.assetNetwork(
                                              width: 152,
                                              height: 98,
                                              placeholder:
                                                  AppImages.imgPlaceholder,
                                              // Placeholder image
                                              image: AppConsts.imgInitialUrl +
                                                  employeeDetailController
                                                      .officialDocs[index],
                                              imageErrorBuilder:
                                                  (BuildContext context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                return Image.asset(
                                                  AppImages.imgPlaceholder,
                                                  width: 152,
                                                  height: 98,
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                              fit: BoxFit.cover,
                                            )
                                          : employeeDetailController
                                                  .officialDocs[index]
                                                  .isNotEmpty
                                              ? Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  width: 152,
                                                  height: 98,
                                                  color:
                                                      AppColors.kPrimaryColor,
                                                  child: Center(
                                                    child: Text(
                                                      employeeDetailController
                                                          .officialDocs[index]
                                                          .split("/")
                                                          .last,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                    );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                width: 10,
                              );
                            },
                            itemCount: employeeDetailController
                                        .isEmployeeDetailLoading.value ||
                                    employeeDetailController
                                        .areEmployeeLeavesLoading.value
                                ? 2
                                : employeeDetailController.officialDocs.length),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "qualification_experience_document".tr.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: AppConsts.commonFontSizeFactor * 14),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(
                      () => SizedBox(
                        height: 98,
                        child: ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return employeeDetailController
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
                                  : GestureDetector(
                                      onTap: () {
                                        employeeDetailController.openFile(
                                            EmployeeDocType
                                                .qualificationOrExperienceDoc,
                                            index);
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: Helpers.isImage(
                                              employeeDetailController
                                                      .qualificationAndExperienceDocs[
                                                  index])
                                          ? FadeInImage.assetNetwork(
                                              width: 152,
                                              height: 98,
                                              placeholder:
                                                  AppImages.imgPlaceholder,
                                              image: AppConsts.imgInitialUrl +
                                                  employeeDetailController
                                                          .qualificationAndExperienceDocs[
                                                      index],
                                              imageErrorBuilder:
                                                  (BuildContext context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                return Image.asset(
                                                  AppImages.imgPlaceholder,
                                                  width: 152,
                                                  height: 98,
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                              fit: BoxFit.cover,
                                            )
                                          : employeeDetailController
                                                  .qualificationAndExperienceDocs[
                                                      index]
                                                  .isNotEmpty
                                              ? Container(
                                                  width: 152,
                                                  height: 98,
                                                  padding: EdgeInsets.all(8),
                                                  color:
                                                      AppColors.kPrimaryColor,
                                                  child: Center(
                                                    child: Text(
                                                      employeeDetailController
                                                          .qualificationAndExperienceDocs[
                                                              index]
                                                          .split("/")
                                                          .last,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                    );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                width: 10,
                              );
                            },
                            itemCount: employeeDetailController
                                        .isEmployeeDetailLoading.value ||
                                    employeeDetailController
                                        .areEmployeeLeavesLoading.value
                                ? 2
                                : employeeDetailController
                                    .qualificationAndExperienceDocs.length),
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
                                  return LeaveWidgetShimmer(
                                    showUserShimmer: false,
                                  );
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontSize: AppConsts
                                                      .commonFontSizeFactor *
                                                  14),
                                    ),
                                    ListView.separated(
                                        padding: const EdgeInsets.only(
                                            top: 4, bottom: 14),
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return LeaveWidget(
                                            showEmployeeDetail: false,
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
