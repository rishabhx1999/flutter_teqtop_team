import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/model/dashboard/comment_list.dart';
import 'package:teqtop_team/views/pages/dashboard/components/comment_widget.dart';
import 'package:teqtop_team/views/pages/dashboard/components/comment_widget_shimmer.dart';

class CommentBottomSheet {
  static show(
      {required BuildContext context,
      required Widget createCommentWidget,
      required int commentCount,
      required int componentId,
      required Future<List<CommentList?>?> Function(int, int) getComments,
      required RxBool areCommentsLoading}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85),
        builder: (context) {
          return CommentBottomSheetContent(
            createCommentWidget: createCommentWidget,
            commentCount: commentCount,
            componentId: componentId,
            getComments: getComments,
            areCommentsLoading: areCommentsLoading,
          );
        },
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22), topRight: Radius.circular(22))));
  }
}

class CommentBottomSheetContent extends StatelessWidget {
  final Widget createCommentWidget;
  final int commentCount;
  final int componentId;
  final Future<List<CommentList?>?> Function(int, int) getComments;
  final RxBool areCommentsLoading;
  late final RxList<CommentList?> comments = <CommentList?>[].obs;

  CommentBottomSheetContent(
      {super.key,
      required this.createCommentWidget,
      required this.commentCount,
      required this.componentId,
      required this.getComments,
      required this.areCommentsLoading});

  Future<void> fetchComments() async {
    comments.assignAll((await getComments(componentId, commentCount))
        as Iterable<CommentList?>);
  }

  @override
  Widget build(BuildContext context) {
    fetchComments();

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
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    commentCount.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.black.withValues(alpha: 0.5)),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Expanded(
                child: Obx(
                  () => ListView.separated(
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
