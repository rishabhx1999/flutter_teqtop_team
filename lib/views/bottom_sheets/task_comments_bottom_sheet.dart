import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/model/dashboard/comment_list.dart';
import 'package:teqtop_team/utils/helpers.dart';
import 'package:teqtop_team/views/pages/dashboard/components/comment_widget.dart';

import '../pages/dashboard/components/comment_widget_shimmer.dart';

class TaskCommentsBottomSheet {
  static show(
      {required BuildContext context,
      required Widget createCommentWidget,
      required RxInt commentCount,
      required RxBool areCommentsLoading,
      required final RxList<CommentList?> comments,
      required ScrollController scrollController}) {
    Helpers.printLog(description: "COMMENT_BOTTOM_SHEET_SHOW_REACHED");
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85),
        builder: (context) {
          return TaskCommentsBottomSheetContent(
            createCommentWidget: createCommentWidget,
            comments: comments,
            commentCount: commentCount,
            areCommentsLoading: areCommentsLoading,
            scrollController: scrollController,
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

  const TaskCommentsBottomSheetContent({
    super.key,
    required this.createCommentWidget,
    required this.comments,
    required this.commentCount,
    required this.areCommentsLoading,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 48),
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
                      controller: scrollController,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return areCommentsLoading.value
                            ? CommentWidgetShimmer()
                            : CommentWidget(
                                commentData: comments[index] ?? CommentList());
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
                height: 30,
              ),
              createCommentWidget
            ],
          ),
        ),
      ),
    );
  }
}
