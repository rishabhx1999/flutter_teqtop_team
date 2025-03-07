import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/config/app_routes.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/consts/app_icons.dart';
import 'package:teqtop_team/controllers/dashboard/dashboard_controller.dart';
import 'package:teqtop_team/model/dashboard/comment_list.dart';
import 'package:teqtop_team/views/bottom_sheets/post_comments_bottom_sheet.dart';
import 'package:teqtop_team/views/widgets/common/common_multimedia_content_create_widget.dart';
import 'package:teqtop_team/views/pages/dashboard/components/menu_drawer_widget.dart';
import 'package:teqtop_team/views/pages/dashboard/components/post_widget.dart';
import 'package:teqtop_team/views/pages/dashboard/components/post_widget_shimmer.dart';

import '../../../consts/app_images.dart';
import '../../../model/dashboard/feed_model.dart';

class DashboardPage extends StatelessWidget {
  final dashboardController = Get.put(DashboardController(), permanent: true);

  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white));

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        dashboardController.showCreateEditPostWidget.value = false;
      },
      child: Scaffold(
          key: dashboardController.scaffoldKey,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.05),
                  height: 1,
                )),
            title: Text(
              'feeds'.tr,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            leading: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  dashboardController.scaffoldKey.currentState?.openDrawer();
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Image.asset(
                    AppIcons.icMenu,
                    color: Colors.black,
                  ),
                )),
            backgroundColor: Colors.white,
            centerTitle: true,
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
                            visible:
                                dashboardController.notificationsCount.value >
                                    0,
                            child: Container(
                              height: 12,
                              width: dashboardController
                                          .notificationsCount.value
                                          .toString()
                                          .length >
                                      1
                                  ? (12 +
                                          ((dashboardController
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
                                  dashboardController.notificationsCount.value
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
                  child: Obx(
                    () => CircleAvatar(
                      radius: 17,
                      backgroundImage:
                          const AssetImage(AppImages.imgPersonPlaceholder),
                      foregroundImage: dashboardController.loggedInUser.value !=
                                  null &&
                              dashboardController.loggedInUser.value!.profile !=
                                  null
                          ? NetworkImage(AppConsts.imgInitialUrl +
                              dashboardController.loggedInUser.value!.profile!)
                          : const AssetImage(AppImages.imgPersonPlaceholder),
                    ),
                  ),
                ),
              )
            ],
          ),
          backgroundColor: Colors.white,
          drawer: const MenuDrawerWidget(),
          body: RefreshIndicator(
            color: AppColors.kPrimaryColor,
            backgroundColor: Colors.white,
            onRefresh: dashboardController.refreshPage,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              controller: dashboardController.scrollController,
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
                      () => dashboardController.showCreateEditPostWidget.value
                          ? CommonMultimediaContentCreateWidget(
                              removeAttachedDocument: dashboardController
                                  .removeCreatePostAttachedDocument,
                              removeAttachedImage: dashboardController
                                  .removeCreatePostAttachedImage,
                              htmlEditorOnChange: dashboardController
                                  .createPostHtmlEditorControllerOnChange,
                              cancelEditing:
                                  dashboardController.cancelPostEditing,
                              htmlEditorController: dashboardController
                                  .createPostHtmlEditorController,
                              hint: 'enter_text'.tr,
                              createComment: dashboardController.createPost,
                              isEditingComment: dashboardController.isEditPost,
                              editComment: dashboardController.editPost,
                              isTextFieldEmpty:
                                  dashboardController.isPostFieldTextEmpty,
                              onTextChanged:
                                  dashboardController.onPostFieldTextChange,
                              contentItems:
                                  dashboardController.postFieldContent,
                              clickImage: dashboardController.clickImage,
                              pickImages: dashboardController.pickImages,
                              addText: dashboardController.addTextInPostContent,
                              removeContentItem:
                                  dashboardController.removePostContentItem,
                              addContentAfter: dashboardController
                                  .initializeAddingInBetweenPostContent,
                              pickFiles: dashboardController.pickDocuments,
                              expandEditor: true,
                              editText: dashboardController.editPostContentText,
                              showCreateEditButton: true,
                              showShadow: true,
                              borderRadius: BorderRadius.circular(10),
                              backgroundColor: Colors.white,
                              textFieldBackgroundColor:
                                  Colors.grey.withValues(alpha: 0.1),
                              isCreateOrEditLoading:
                                  dashboardController.isPostCreateEditLoading,
                              htmlEditorOnInit: dashboardController
                                  .createPostHtmlEditorOnInit,
                              attachedImages:
                                  dashboardController.createPostAttachedImages,
                              attachedDocuments: dashboardController
                                  .createPostAttachedDocuments,
                              areAttachedFilesLoading: dashboardController
                                  .areCreateEditPostFilesLoading,
                            )
                          : GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                dashboardController
                                    .showCreateEditPostWidget.value = true;
                              },
                              child: Container(
                                height: 48,
                                width: double.infinity,
                                color: Colors.grey.withValues(alpha: 0.1),
                                padding: const EdgeInsets.all(10),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "create_feed".tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Colors.black
                                                .withValues(alpha: 0.3),
                                          ),
                                    )),
                              ),
                            ),
                    ),
                    Obx(
                      () => ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return dashboardController.arePostsLoading.value
                                ? const PostWidgetShimmer()
                                : PostWidget(
                                    handleImageOnTap:
                                        dashboardController.onTapPostImage,
                                    commentOnTap: () {
                                      dashboardController
                                          .currentCommentsPostID = null;
                                      dashboardController
                                          .currentCommentsLength.value = 0;
                                      dashboardController.singlePostComments
                                          .value = <CommentList>[];
                                      if (dashboardController.posts[index] !=
                                          null) {
                                        dashboardController
                                                .currentCommentsPostID =
                                            dashboardController
                                                .posts[index]!.id;
                                        dashboardController
                                            .currentCommentsLength
                                            .value = dashboardController
                                                    .posts[index]!
                                                    .commentCount !=
                                                null
                                            ? dashboardController.posts[index]!
                                                .commentCount!.length
                                            : 0;
                                      }
                                      dashboardController
                                              .commentFieldContentItemsInsertAfterIndex =
                                          null;
                                      dashboardController
                                          .commentFieldContentEditIndex = null;
                                      dashboardController.commentFieldContent
                                          .clear();
                                      dashboardController
                                          .commentFieldHtmlEditorHtmlContent
                                          .value = "<p></p>";
                                      dashboardController
                                          .commentFieldAttachedDocuments
                                          .clear();
                                      dashboardController
                                          .commentFieldAttachedImages
                                          .clear();
                                      if (dashboardController
                                              .commentFieldTextFocusNode !=
                                          null) {
                                        dashboardController
                                            .commentFieldTextFocusNode!
                                            .dispose();
                                        dashboardController
                                            .commentFieldTextFocusNode = null;
                                      }
                                      dashboardController
                                              .commentFieldTextFocusNode =
                                          FocusNode();
                                      dashboardController
                                          .showCreateCommentWidget
                                          .value = false;
                                      PostCommentsBottomSheet.show(
                                        context: context,
                                        createCommentWidget:
                                            CommonMultimediaContentCreateWidget(
                                          htmlEditorOnChange: dashboardController
                                              .commentFieldHtmlEditorControllerOnChange,
                                          focusNode: dashboardController
                                              .commentFieldTextFocusNode,
                                          htmlEditorOnInit: dashboardController
                                              .commentFieldHtmlEditorOnInit,
                                          htmlEditorController: dashboardController
                                              .commentFieldHtmlEditorController,
                                          hint: 'enter_text'.tr,
                                          createComment:
                                              dashboardController.createComment,
                                          isEditingComment: false.obs,
                                          isTextFieldEmpty: dashboardController
                                              .isCommentFieldTextEmpty,
                                          onTextChanged: dashboardController
                                              .onCommentFieldTextChange,
                                          contentItems: dashboardController
                                              .commentFieldContent,
                                          clickImage: dashboardController
                                              .clickCommentImage,
                                          pickImages: dashboardController
                                              .pickCommentImages,
                                          addText: dashboardController
                                              .addTextInCommentContent,
                                          removeContentItem: dashboardController
                                              .removeCommentContentItem,
                                          addContentAfter: dashboardController
                                              .initializeAddingInBetweenCommentContent,
                                          pickFiles: dashboardController
                                              .pickCommentDocuments,
                                          editText: dashboardController
                                              .editCommentContentText,
                                          showCreateEditButton: true,
                                          showShadow: true,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          backgroundColor: Colors.white,
                                          textFieldBackgroundColor: Colors.grey
                                              .withValues(alpha: 0.1),
                                          isCreateOrEditLoading:
                                              dashboardController
                                                  .isCommentCreateLoading,
                                          cancelEditing: dashboardController
                                              .cancelCommentEditing,
                                          attachedImages: dashboardController
                                              .commentFieldAttachedImages,
                                          attachedDocuments: dashboardController
                                              .commentFieldAttachedDocuments,
                                          removeAttachedImage: dashboardController
                                              .removeCommentFieldAttachedImage,
                                          removeAttachedDocument:
                                              dashboardController
                                                  .removeCommentFieldAttachedDocument,
                                          areAttachedFilesLoading:
                                              dashboardController
                                                  .areCommentFieldFilesLoading,
                                        ),
                                        commentCount: dashboardController
                                            .currentCommentsLength,
                                        getComments:
                                            dashboardController.getComments,
                                        areCommentsLoading: dashboardController
                                            .areCommentsLoading,
                                        comments: dashboardController
                                            .singlePostComments,
                                        scrollController: dashboardController
                                            .commentsSheetScrollController,
                                        handleCommentOnDelete:
                                            dashboardController
                                                .handleCommentOnDelete,
                                        createCommentTextFieldFocusNode:
                                            dashboardController
                                                .commentFieldTextFocusNode!,
                                        showCreateCommentWidget:
                                            dashboardController
                                                .showCreateCommentWidget,
                                        handleCommentImageOnTap:
                                            dashboardController
                                                .onTapCommentImage,
                                      );
                                    },
                                    postData:
                                        dashboardController.posts[index] ??
                                            FeedModel(),
                                    toggleLike: dashboardController.toggleLike,
                                    handleOnTapDelete:
                                        dashboardController.onTapPostDelete,
                                    handleOnTapEdit:
                                        dashboardController.onTapPostEdit,
                                    postItems:
                                        dashboardController.posts[index] == null
                                            ? []
                                            : dashboardController
                                                .posts[index]!.feedItems,
                                  );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 16,
                            );
                          },
                          itemCount: dashboardController.arePostsLoading.value
                              ? 5
                              : dashboardController.posts.length),
                    ),
                    Obx(
                      () => Visibility(
                        visible: dashboardController.posts.isNotEmpty &&
                            dashboardController.areMorePostsLoading.value,
                        child: ListView.separated(
                            padding: const EdgeInsets.only(bottom: 16),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return const PostWidgetShimmer();
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 16,
                              );
                            },
                            itemCount: 5),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
