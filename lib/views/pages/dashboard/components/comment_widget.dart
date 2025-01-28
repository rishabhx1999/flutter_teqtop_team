import 'package:flutter/material.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/utils/helpers.dart';

import '../../../../consts/app_images.dart';
import '../../../../model/dashboard/comment_list.dart';

class CommentWidget extends StatelessWidget {
  final CommentList commentData;

  const CommentWidget({super.key, required this.commentData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
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
              CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage(AppImages.imgPersonPlaceholder),
                foregroundImage: commentData.profile != null
                    ? NetworkImage(
                        AppConsts.imgInitialUrl + commentData.profile!)
                    : AssetImage(AppImages.imgPersonPlaceholder),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: commentData.userName ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  WidgetSpan(
                      child: const SizedBox(
                    width: 4,
                  )),
                  TextSpan(
                      text: commentData.createdAt != null
                          ? Helpers.formatTimeAgo(commentData.createdAt!)
                          : "",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black.withValues(alpha: 0.5),
                          fontSize: AppConsts.commonFontSizeFactor * 14))
                ])),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                width: 38,
              ),
              Expanded(
                child: Text(
                  Helpers.cleanHtml(commentData.comment ?? "").substring(1,
                      Helpers.cleanHtml(commentData.comment ?? "").length - 1),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: AppConsts.commonFontSizeFactor * 14),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
