import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/consts/app_images.dart';
import 'package:teqtop_team/controllers/task_detail/task_detail_controller.dart';
import 'package:teqtop_team/utils/helpers.dart';
import 'package:teqtop_team/views/pages/task_detail/components/task_drawer_widget.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../consts/app_icons.dart';
import '../../bottom_sheets/task_comments_bottom_sheet.dart';
import '../../widgets/common/common_button.dart';
import '../../widgets/common/common_button_shimmer.dart';
import '../../widgets/common/common_multimedia_content_create_widget.dart';

class TaskDetailPage extends StatelessWidget {
  final taskDetailController = Get.put(TaskDetailController());

  TaskDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white));
    taskDetailController.taskDetailPageContext = context;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        taskDetailController.wholePageFocus.unfocus();
      },
      child: Scaffold(
        key: taskDetailController.scaffoldKey,
        endDrawer: TaskDrawerWidget(
          responsiblePerson: taskDetailController.responsiblePerson,
          participants: taskDetailController.participants,
          observers: taskDetailController.observers,
        ),
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
            // Padding(
            //   padding: const EdgeInsets.only(right: 8),
            //   child: GestureDetector(
            //     behavior: HitTestBehavior.opaque,
            //     onTap: () {
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
            //           SvgPicture.asset(
            //             AppIcons.icEdit,
            //             width: 24,
            //           ),
            //           const SizedBox(
            //             width: 4,
            //           ),
            //           Text(
            //             "delete".tr,
            //             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            //                 fontSize: AppConsts.commonFontSizeFactor * 14),
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(right: 8),
            //   child: GestureDetector(
            //     behavior: HitTestBehavior.opaque,
            //     onTap: () {
            //       Get.toNamed(AppRoutes.routeTaskCreateEdit);
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
            //           SvgPicture.asset(
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
                onTap: taskDetailController.handleDriveOnTap,
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
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: AppConsts.commonFontSizeFactor * 14),
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
                onTap: taskDetailController.handleKeyOnTap,
                child: Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                      color: AppColors.colorF9F9F9,
                      border: Border.all(
                          color: Colors.black.withValues(alpha: 0.1),
                          width: 0.5)),
                  child: Center(
                    child: Image.asset(
                      AppIcons.icKey,
                      width: 16,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  taskDetailController.scaffoldKey.currentState
                      ?.openEndDrawer();
                },
                child: Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                      color: AppColors.colorF9F9F9,
                      border: Border.all(
                          color: Colors.black.withValues(alpha: 0.1),
                          width: 0.5)),
                  child: Center(
                    child: SvgPicture.asset(
                      AppIcons.icPerson,
                      width: 24,
                    ),
                  ),
                ),
              ),
            ),
            PopupMenuButton(
                padding: EdgeInsets.only(right: 16),
                menuPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                style:
                    IconButton.styleFrom(splashFactory: NoSplash.splashFactory),
                icon: SvgPicture.asset(
                  AppIcons.icMoreHorizontal,
                  width: 24,
                ),
                onSelected: (value) {
                  if (value == "delete".tr) {
                    taskDetailController.handleOnDelete();
                  }
                  if (value == "edit".tr) {
                    Get.toNamed(AppRoutes.routeTaskCreateEdit);
                  }
                },
                itemBuilder: (context) => [
                      PopupMenuItem(
                          value: "edit".tr,
                          padding: EdgeInsets.only(left: 16),
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
                          padding: EdgeInsets.only(left: 16),
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Focus(
                  focusNode: taskDetailController.wholePageFocus,
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                            color: AppColors.colorF9F9F9,
                            borderRadius: BorderRadius.zero),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24),
                                  child: Obx(
                                    () => taskDetailController.isLoading.value
                                        ? Shimmer.fromColors(
                                            baseColor:
                                                AppColors.shimmerBaseColor,
                                            highlightColor:
                                                AppColors.shimmerHighlightColor,
                                            child: Container(
                                              height: 28,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(3.0),
                                                color:
                                                    AppColors.shimmerBaseColor,
                                              ),
                                            ))
                                        : SelectableText(
                                            taskDetailController
                                                        .taskDetail.value !=
                                                    null
                                                ? taskDetailController
                                                        .taskDetail
                                                        .value!
                                                        .name ??
                                                    ""
                                                : "",
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                    fontSize: AppConsts
                                                            .commonFontSizeFactor *
                                                        18),
                                          ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Obx(
                                  () => taskDetailController.isLoading.value
                                      ? Shimmer.fromColors(
                                          baseColor: AppColors.shimmerBaseColor,
                                          highlightColor:
                                              AppColors.shimmerHighlightColor,
                                          child: Container(
                                            height: 20,
                                            width: 86,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(3.0),
                                              color: AppColors.shimmerBaseColor,
                                            ),
                                          ))
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
                                                  fontSize: AppConsts
                                                          .commonFontSizeFactor *
                                                      14),
                                        ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Colors.black.withValues(alpha: 0.2),
                                  indent: 32,
                                  endIndent: 32,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                            Obx(
                              () => taskDetailController.isLoading.value
                                  ? Shimmer.fromColors(
                                      baseColor: AppColors.shimmerBaseColor,
                                      highlightColor:
                                          AppColors.shimmerHighlightColor,
                                      child: Container(
                                        height: 100,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3.0),
                                          color: AppColors.shimmerBaseColor,
                                        ),
                                      ))
                                  : ListView.separated(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return taskDetailController
                                                    .descriptionItems[index]
                                                    .text !=
                                                null
                                            ? SelectableText(
                                                taskDetailController
                                                    .descriptionItems[index]
                                                    .text!,
                                                textAlign: TextAlign.start,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              )
                                            : taskDetailController
                                                            .descriptionItems[
                                                                index]
                                                            .imageString !=
                                                        null &&
                                                    taskDetailController
                                                            .descriptionItems[
                                                                index]
                                                            .downloadedImage !=
                                                        null
                                                ? GestureDetector(
                                                    behavior:
                                                        HitTestBehavior.opaque,
                                                    onTap: () {
                                                      taskDetailController
                                                          .onTapDescriptionImage(
                                                              index);
                                                    },
                                                    child: Image.file(
                                                      taskDetailController
                                                          .descriptionItems[
                                                              index]
                                                          .downloadedImage!,
                                                      height: 250,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  )
                                                : taskDetailController
                                                            .descriptionItems[
                                                                index]
                                                            .fileString !=
                                                        null
                                                    ? GestureDetector(
                                                        behavior:
                                                            HitTestBehavior
                                                                .opaque,
                                                        onTap: () async {
                                                          if (taskDetailController
                                                              .descriptionItems[
                                                                  index]
                                                              .fileString!
                                                              .isNotEmpty) {
                                                            taskDetailController
                                                                .descriptionItems[
                                                                    index]
                                                                .isFileLoading
                                                                .value = true;
                                                            taskDetailController
                                                                .descriptionItems[
                                                                    index]
                                                                .isFileLoading
                                                                .refresh();
                                                            await Helpers.openFile(
                                                                path: taskDetailController
                                                                    .descriptionItems[
                                                                        index]
                                                                    .fileString!,
                                                                fileName: taskDetailController
                                                                    .descriptionItems[
                                                                        index]
                                                                    .fileString!
                                                                    .split("/")
                                                                    .last);
                                                            taskDetailController
                                                                .descriptionItems[
                                                                    index]
                                                                .isFileLoading
                                                                .value = false;
                                                            taskDetailController
                                                                .descriptionItems[
                                                                    index]
                                                                .isFileLoading
                                                                .refresh();
                                                          }
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .fromLTRB(14, 10,
                                                                  10, 10),
                                                          width:
                                                              double.infinity,
                                                          decoration: BoxDecoration(
                                                              color: AppColors
                                                                  .kPrimaryColor
                                                                  .withValues(
                                                                      alpha:
                                                                          0.1)),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  taskDetailController
                                                                      .descriptionItems[
                                                                          index]
                                                                      .fileString!
                                                                      .split(
                                                                          "/")
                                                                      .last,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall
                                                                      ?.copyWith(
                                                                        color: AppColors
                                                                            .kPrimaryColor,
                                                                      ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 12,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        4.0),
                                                                child: Obx(() => taskDetailController
                                                                        .descriptionItems[
                                                                            index]
                                                                        .isFileLoading
                                                                        .value
                                                                    ? Container(
                                                                        height:
                                                                            24,
                                                                        width:
                                                                            24,
                                                                        padding:
                                                                            EdgeInsets.all(4),
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          strokeWidth:
                                                                              2,
                                                                          color:
                                                                              AppColors.kPrimaryColor,
                                                                        ),
                                                                      )
                                                                    : SvgPicture
                                                                        .asset(
                                                                        AppIcons
                                                                            .icDownload,
                                                                        width:
                                                                            24,
                                                                        colorFilter: ColorFilter.mode(
                                                                            AppColors.kPrimaryColor,
                                                                            BlendMode.srcIn),
                                                                      )),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox();
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(
                                          height: 10,
                                        );
                                      },
                                      itemCount: taskDetailController
                                          .descriptionItems.length),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Obx(
                  () => taskDetailController.isLoading.value
                      ? CommonButtonShimmer(
                          borderRadius: 0,
                        )
                      : taskDetailController.areCommentsLoading.value
                          ? Center(
                              child: Container(
                                height: 51,
                                width: 51,
                                padding: EdgeInsets.all(8),
                                child: CircularProgressIndicator(
                                  color: AppColors.kPrimaryColor,
                                ),
                              ),
                            )
                          : CommonButton(
                              text: "comments",
                              onClick: () async {
                                taskDetailController.editCommentPreviousValue =
                                    null;
                                taskDetailController.isEditingComment.value =
                                    false;
                                taskDetailController.editCommentIndex = null;
                                taskDetailController.commentFieldTextController
                                    .clear();
                                taskDetailController
                                    .isCommentFieldTextEmpty.value = true;
                                taskDetailController
                                        .commentFieldContentItemsInsertAfterIndex =
                                    null;
                                taskDetailController
                                    .commentFieldContentEditIndex = null;
                                taskDetailController.commentFieldContent
                                    .clear();
                                taskDetailController
                                    .showCreateCommentWidget.value = false;
                                if (taskDetailController
                                        .commentFieldTextFocusNode !=
                                    null) {
                                  taskDetailController
                                      .commentFieldTextFocusNode!
                                      .dispose();
                                  taskDetailController
                                      .commentFieldTextFocusNode = null;
                                }
                                taskDetailController.commentFieldTextFocusNode =
                                    FocusNode();
                                await taskDetailController.getComments();
                                TaskCommentsBottomSheet.show(
                                  context: context,
                                  createCommentWidget:
                                      CommonMultimediaContentCreateWidget(
                                    textController: taskDetailController
                                        .commentFieldTextController,
                                    hint: 'enter_text'.tr,
                                    createComment:
                                        taskDetailController.createComment,
                                    isEditingComment:
                                        taskDetailController.isEditingComment,
                                    editComment:
                                        taskDetailController.editComment,
                                    isTextFieldEmpty: taskDetailController
                                        .isCommentFieldTextEmpty,
                                    onTextChanged: taskDetailController
                                        .onCommentFieldTextChange,
                                    contentItems: taskDetailController
                                        .commentFieldContent,
                                    clickImage: taskDetailController.clickImage,
                                    pickImages: taskDetailController.pickImages,
                                    addText: taskDetailController
                                        .addTextInCommentContent,
                                    removeContentItem: taskDetailController
                                        .removeCommentContentItem,
                                    addContentAfter: taskDetailController
                                        .initializeAddingInBetweenCommentContent,
                                    pickFiles:
                                        taskDetailController.pickDocuments,
                                    editText: taskDetailController
                                        .editCommentContentText,
                                    showCreateEditButton: true,
                                    showShadow: true,
                                    borderRadius: BorderRadius.circular(10),
                                    backgroundColor: Colors.white,
                                    textFieldBackgroundColor:
                                        Colors.grey.withValues(alpha: 0.1),
                                    isCreateOrEditLoading: taskDetailController
                                        .isCommentCreateEditLoading,
                                    focusNode: taskDetailController
                                        .commentFieldTextFocusNode,
                                  ),
                                  comments: taskDetailController.comments,
                                  commentCount:
                                      taskDetailController.commentsLength,
                                  areCommentsLoading:
                                      taskDetailController.areCommentsLoading,
                                  scrollController: taskDetailController
                                      .commentsSheetScrollController,
                                  handleCommentOnEdit:
                                      taskDetailController.handleCommentOnEdit,
                                  handleCommentOnDelete: taskDetailController
                                      .handleCommentOnDelete,
                                  createCommentTextFieldFocusNode:
                                      taskDetailController
                                          .commentFieldTextFocusNode!,
                                  showCreateCommentWidget: taskDetailController
                                      .showCreateCommentWidget,
                                  handleCommentImageOnTap:
                                      taskDetailController.onTapCommentImage,
                                );
                              }),
                ))
          ],
        ),
      ),
    );
  }
}
