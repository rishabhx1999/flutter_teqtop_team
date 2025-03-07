import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/model/dashboard/notification_model.dart';
import 'package:teqtop_team/utils/helpers.dart';

import '../../../../consts/app_images.dart';

class NotificationWidget extends StatelessWidget {
  final NotificationModel notificationData;
  final Function(int) onTap;
  final int index;

  const NotificationWidget(
      {super.key,
      required this.notificationData,
      required this.onTap,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(index);
      },
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.zero,
                border: Border.all(
                    color: Colors.black.withValues(alpha: 0.1), width: 0.5)),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundImage: const AssetImage(AppImages.imgPersonPlaceholder),
                  foregroundImage: notificationData.profile != null &&
                          notificationData.profile!.isNotEmpty
                      ? NetworkImage(
                          AppConsts.imgInitialUrl + notificationData.profile!)
                      : const AssetImage(AppImages.imgPersonPlaceholder),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Helpers.cleanHtml(notificationData.text ?? ""),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        notificationData.createdAt != null
                            ? DateFormat('MMM dd, yyyy HH:mm')
                                .format(notificationData.createdAt!)
                            : "",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.black.withValues(alpha: 0.5),
                              fontSize: AppConsts.commonFontSizeFactor * 12,
                            ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: false,
            child: Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          )
        ],
      ),
    );
  }
}
