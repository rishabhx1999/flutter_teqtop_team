import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as html_parser;

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teqtop_team/consts/app_images.dart';
import 'package:teqtop_team/controllers/project_detail/project_detail_controller.dart';
import 'package:teqtop_team/utils/helpers.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../consts/app_consts.dart';
import '../../../consts/app_icons.dart';

class ProjectDetailPage extends StatelessWidget {
  final projectDetailController = Get.put(ProjectDetailController());

  ProjectDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white));

    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          projectDetailController.wholePageFocus.unfocus();
        },
        child: Scaffold(
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
                  child: Image.asset(
                    AppIcons.icBack,
                    color: Colors.black,
                  ),
                )),
            leadingWidth: 40,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            elevation: 0,
            actions: [
              // Padding(
              //   padding: const EdgeInsets.only(right: 8),
              //   child: GestureDetector(
              //     behavior: HitTestBehavior.opaque,
              //     onTap: () {
              //       Get.toNamed(AppRoutes.routeProjectCreateEdit);
              //     },
              //     child: Container(
              //       width: 68,
              //       height: 28,
              //       decoration: BoxDecoration(
              //           color: AppColors.colorF9F9F9,
              //           border: Border.all(
              //               color: Colors.black.withValues(alpha: 0.1),
              //               width: 0.5)),
              //       child: Row(
              //         mainAxisSize: MainAxisSize.min,
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           Image.asset(
              //             AppIcons.icEdit,
              //             width: 24,
              //           ),
              //           const SizedBox(
              //             width: 4,
              //           ),
              //           Text(
              //             "edit".tr,
              //             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              //                 fontSize: AppConsts.commonFontSizeFactor * 14),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: projectDetailController.handleDriveOnTap,
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
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontSize:
                                      AppConsts.commonFontSizeFactor * 14),
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
                    projectDetailController.handleTaskOnTap();
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
                          AppIcons.icTask,
                          width: 24,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          "task".tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontSize:
                                      AppConsts.commonFontSizeFactor * 14),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              PopupMenuButton(
                  padding: const EdgeInsets.only(right: 16),
                  menuPadding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero),
                  style: IconButton.styleFrom(
                      splashFactory: NoSplash.splashFactory),
                  icon: Image.asset(
                    AppIcons.icMoreHorizontal,
                    width: 24,
                  ),
                  onSelected: (value) {
                    if (value == "delete".tr) {
                      projectDetailController.handleOnDelete();
                    }
                    if (value == "edit".tr) {
                      Get.toNamed(AppRoutes.routeProjectCreateEdit);
                    }
                  },
                  itemBuilder: (context) => [
                        PopupMenuItem(
                            value: "edit".tr,
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              "edit".tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontSize:
                                          AppConsts.commonFontSizeFactor * 14),
                            )),
                        PopupMenuItem(
                            value: "delete".tr,
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              "delete".tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontSize:
                                          AppConsts.commonFontSizeFactor * 14),
                            ))
                      ])
            ],
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Focus(
              focusNode: projectDetailController.wholePageFocus,
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
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    decoration: BoxDecoration(
                        color: AppColors.colorF9F9F9,
                        borderRadius: BorderRadius.zero),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(
                          () => projectDetailController.isLoading.value
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Shimmer.fromColors(
                                        baseColor: AppColors.shimmerBaseColor,
                                        highlightColor:
                                            AppColors.shimmerHighlightColor,
                                        child: Container(
                                          height: 32.0,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3.0),
                                            color: AppColors.shimmerBaseColor,
                                          ),
                                        )),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Shimmer.fromColors(
                                        baseColor: AppColors.shimmerBaseColor,
                                        highlightColor:
                                            AppColors.shimmerHighlightColor,
                                        child: Container(
                                          height: 32.0,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3.0),
                                            color: AppColors.shimmerBaseColor,
                                          ),
                                        ))
                                  ],
                                )
                              : SelectableText(
                                  projectDetailController.projectDetail.value !=
                                          null
                                      ? projectDetailController
                                              .projectDetail.value!.name ??
                                          ""
                                      : "",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontSize:
                                            AppConsts.commonFontSizeFactor * 22,
                                      ),
                                ),
                        ),
                        Obx(
                          () => projectDetailController.isLoading.value
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Shimmer.fromColors(
                                      baseColor: AppColors.shimmerBaseColor,
                                      highlightColor:
                                          AppColors.shimmerHighlightColor,
                                      child: Container(
                                        height: 24,
                                        width: 180,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3.0),
                                          color: AppColors.shimmerBaseColor,
                                        ),
                                      )),
                                )
                              : SelectableText.rich(
                                  textAlign: TextAlign.center,
                                  TextSpan(children: [
                                    TextSpan(
                                        text: projectDetailController
                                                    .projectDetail.value !=
                                                null
                                            ? projectDetailController
                                                    .projectDetail.value!.url ??
                                                ""
                                            : "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                fontSize: AppConsts
                                                        .commonFontSizeFactor *
                                                    18)),
                                    WidgetSpan(
                                        child: Visibility(
                                      visible:
                                          projectDetailController
                                                      .projectDetail.value !=
                                                  null &&
                                              projectDetailController
                                                      .projectDetail
                                                      .value!
                                                      .url !=
                                                  null &&
                                              projectDetailController
                                                  .projectDetail
                                                  .value!
                                                  .url!
                                                  .isNotEmpty,
                                      child: GestureDetector(
                                          onTap: () {
                                            // Helpers.printLog(
                                            //     description:
                                            //         'PROJECT_DETAIL_PAGE_URL_ON_TAP');
                                            if (projectDetailController.projectDetail
                                                        .value !=
                                                    null &&
                                                projectDetailController
                                                        .projectDetail
                                                        .value!
                                                        .url !=
                                                    null &&
                                                projectDetailController
                                                    .projectDetail
                                                    .value!
                                                    .url!
                                                    .isNotEmpty) {
                                              Helpers.openLink(
                                                  projectDetailController
                                                      .projectDetail
                                                      .value!
                                                      .url!);
                                            }
                                          },
                                          behavior: HitTestBehavior.opaque,
                                          child: const Icon(
                                            Icons.open_in_browser_rounded,
                                            color: Colors.black,
                                          )),
                                    ))
                                  ])),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Obx(
                          () => projectDetailController.isLoading.value
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Shimmer.fromColors(
                                      baseColor: AppColors.shimmerBaseColor,
                                      highlightColor:
                                          AppColors.shimmerHighlightColor,
                                      child: Container(
                                        height: 20,
                                        width: 88,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3.0),
                                          color: AppColors.shimmerBaseColor,
                                        ),
                                      )),
                                )
                              : Text(
                                  DateFormat('MMM dd, yyyy')
                                      .format(DateTime.now()),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: Colors.black
                                              .withValues(alpha: 0.5),
                                          fontSize:
                                              AppConsts.commonFontSizeFactor *
                                                  14),
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "access_detail".tr.toUpperCase(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Obx(
                          () => Visibility(
                            visible: projectDetailController.isLoading.value ==
                                false,
                            child: projectDetailController
                                    .isAccessDetailEditLoading.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ))
                                : GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      Get.toNamed(
                                          AppRoutes.routeEditAccessDetails);
                                    },
                                    child: Image.asset(
                                      AppIcons.icEdit,
                                      width: 20,
                                    ),
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Obx(() => projectDetailController.isLoading.value
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Shimmer.fromColors(
                              baseColor: AppColors.shimmerBaseColor,
                              highlightColor: AppColors.shimmerHighlightColor,
                              child: Container(
                                height: 100.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.shimmerBaseColor,
                                ),
                              )),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child:
                              // TextField(
                              //         controller: projectDetailController
                              //             .accessDetailController,
                              //         maxLines: 5,
                              //         style: Theme.of(context).textTheme.bodyMedium,
                              //         keyboardType: TextInputType.multiline,
                              //         cursorColor: Colors.black,
                              //         textInputAction: TextInputAction.newline,
                              //         decoration: InputDecoration(
                              //           hintText: 'enter_access_details'.tr,
                              //           enabled: true,
                              //           hintStyle: Theme.of(context)
                              //               .textTheme
                              //               .bodyMedium
                              //               ?.copyWith(
                              //                 color: Colors.black
                              //                     .withValues(alpha: 0.3),
                              //               ),
                              //           fillColor:
                              //               Colors.grey.withValues(alpha: 0.1),
                              //           filled: true,
                              //           border: inputBorder,
                              //           errorBorder: inputBorder,
                              //           enabledBorder: inputBorder,
                              //           disabledBorder: inputBorder,
                              //           focusedBorder: inputBorder,
                              //           focusedErrorBorder: inputBorder,
                              //           contentPadding: const EdgeInsets.all(10),
                              //         ),
                              //         focusNode: projectDetailController
                              //             .accessDetailFocusNode,
                              //       )
                                  SelectableText(
                                projectDetailController.projectDetail.value !=
                                            null &&
                                        projectDetailController.projectDetail.value!
                                            .accessDetail is String
                                    ? html_parser
                                            .parse(projectDetailController
                                                .projectDetail.value!.accessDetail)
                                            .body
                                            ?.children
                                            .map((e) => e.text)
                                            .join("\n") ??
                                        ""
                                    : "",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                          //     Row(
                          //   mainAxisSize: MainAxisSize.max,
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Expanded(
                          //       child: Html(
                          //         data: projectDetailController
                          //                         .projectDetail.value !=
                          //                     null &&
                          //                 projectDetailController.projectDetail
                          //                     .value!.accessDetail is String
                          //             ? projectDetailController
                          //                 .projectDetail.value!.accessDetail
                          //             : "",
                          //         onLinkTap: (url, attributes, element) {
                          //           if (url != null) {
                          //             Helpers.openLink(url);
                          //           }
                          //         },
                          //         style: {
                          //           "p": Style(fontSize: FontSize.medium),
                          //         },
                          //       ),
                          //     ),
                          //     const SizedBox(
                          //       width: 12,
                          //     ),
                          //     Visibility(
                          //       visible: projectDetailController
                          //                   .projectDetail.value !=
                          //               null &&
                          //           projectDetailController.projectDetail.value!
                          //               .accessDetail is String &&
                          //           projectDetailController.projectDetail.value!
                          //               .accessDetail.isNotEmpty,
                          //       child: GestureDetector(
                          //         behavior: HitTestBehavior.opaque,
                          //         onTap: () {
                          //           String plainText = html_parser
                          //                   .parse(projectDetailController
                          //                       .projectDetail
                          //                       .value!
                          //                       .accessDetail)
                          //                   .body
                          //                   ?.children
                          //                   .map((e) => e.text)
                          //                   .join("\n") ??
                          //               "";
                          //           Clipboard.setData(
                          //               ClipboardData(text: plainText));
                          //           Get.snackbar("success".tr,
                          //               "message_copied_to_clipboard".tr);
                          //         },
                          //         child: const Icon(
                          //           Icons.copy_rounded,
                          //           color: Colors.black,
                          //           size: 24,
                          //         ),
                          //       ),
                          //     )
                          //   ],
                          // ),
                        )),
                  const SizedBox(
                    height: 16,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
