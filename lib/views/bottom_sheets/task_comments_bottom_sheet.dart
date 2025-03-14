import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/model/dashboard/comment_list.dart';
import 'package:teqtop_team/views/pages/dashboard/components/comment_widget.dart';

import '../pages/dashboard/components/comment_widget_shimmer.dart';

class TaskCommentsBottomSheet {
  static show({
    required BuildContext context,
    required Widget createCommentWidget,
    required RxInt commentCount,
    required RxBool areCommentsLoading,
    required final RxList<CommentList?> comments,
    required ScrollController scrollController,
    required Function(int) handleCommentOnEdit,
    required Function(int) handleCommentOnDelete,
    required FocusNode createCommentTextFieldFocusNode,
    required RxBool showCreateCommentWidget,
    required Function(int, String?) handleCommentImageOnTap,
  }) {
    // Helpers.printLog(description: "COMMENT_BOTTOM_SHEET_SHOW_REACHED");
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.95),
        builder: (context) {
          // Helpers.printLog(
          //     description: "TASK_COMMENTS_BOTTOM_SHEET_SHOW_MODAL_BOTTOM_SHEET",
          //     message: "CURRENT_ROUTE = ${Get.currentRoute}");
          return TaskCommentsBottomSheetContent(
            createCommentWidget: createCommentWidget,
            comments: comments,
            commentCount: commentCount,
            areCommentsLoading: areCommentsLoading,
            scrollController: scrollController,
            handleCommentOnEdit: handleCommentOnEdit,
            handleCommentOnDelete: handleCommentOnDelete,
            createCommentTextFieldFocusNode: createCommentTextFieldFocusNode,
            showCreateCommentWidget: showCreateCommentWidget,
            handleCommentImageOnTap: handleCommentImageOnTap,
          );
        },
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22), topRight: Radius.circular(22))));
  }
}

class TaskCommentsBottomSheetContent extends StatelessWidget {
  final Widget createCommentWidget;
  final RxInt commentCount;
  final RxBool areCommentsLoading;
  final RxList<CommentList?> comments;
  final ScrollController scrollController;
  final Function(int) handleCommentOnEdit;
  final Function(int) handleCommentOnDelete;
  final RxBool showCreateCommentWidget;
  final FocusNode createCommentTextFieldFocusNode;
  final Function(int, String?) handleCommentImageOnTap;

  const TaskCommentsBottomSheetContent({
    super.key,
    required this.createCommentWidget,
    required this.comments,
    required this.commentCount,
    required this.areCommentsLoading,
    required this.scrollController,
    required this.handleCommentOnEdit,
    required this.handleCommentOnDelete,
    required this.createCommentTextFieldFocusNode,
    required this.showCreateCommentWidget,
    required this.handleCommentImageOnTap,
  });

  @override
  Widget build(BuildContext context) {
    // Helpers.printLog(
    //     description: "TASK_COMMENTS_BOTTOM_SHEET_BUILD",
    //     message: "CURRENT_ROUTE = ${Get.currentRoute}");
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        showCreateCommentWidget.value = false;
      },
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(22), topLeft: Radius.circular(22))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "comments".tr.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: AppConsts.commonFontSizeFactor * 14),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Obx(
                    () => Text(
                      commentCount.value.toString(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black.withValues(alpha: 0.5),
                          fontSize: AppConsts.commonFontSizeFactor * 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Expanded(
                child: Obx(
                  () => ListView.separated(
                      addAutomaticKeepAlives: true,
                      controller: scrollController,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return areCommentsLoading.value
                            ? const CommentWidgetShimmer()
                            : CommentWidget(
                                commentData: comments[index] ?? CommentList(),
                                onTapEdit: handleCommentOnEdit,
                                onTapDelete: handleCommentOnDelete,
                                // commentItems: comments[index] == null
                                //     ? []
                                //     : comments[index]!.commentItems,
                                handleImageOnTap: handleCommentImageOnTap,
                              );
                      },
                      separatorBuilder: (context, index) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const SizedBox(
                                width: 38,
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.black.withValues(alpha: 0.1),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      itemCount:
                          areCommentsLoading.value ? 5 : comments.length),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Obx(() => showCreateCommentWidget.value
                  ? createCommentWidget
                  : GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        showCreateCommentWidget.value = true;
                        createCommentTextFieldFocusNode.requestFocus();
                      },
                      child: Container(
                        height: 48,
                        width: double.infinity,
                        color: Colors.grey.withValues(alpha: 0.1),
                        padding: const EdgeInsets.all(10),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "create_comment".tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.black.withValues(alpha: 0.3),
                                  ),
                            )),
                      ),
                    ))
            ],
          ),
        ),
      ),
    );
  }
}
