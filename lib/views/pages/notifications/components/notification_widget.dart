import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teqtop_team/consts/app_consts.dart';

import '../../../../consts/app_images.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
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
            backgroundImage: AssetImage(AppImages.imgPersonPlaceholder),
            foregroundImage: AssetImage(AppImages.imgPersonPlaceholder),
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
                  "Add a comment to task Create a Website mockup",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Dec 04, 2024 16:40",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black.withValues(alpha: 0.5),
                      fontSize: AppConsts.commonFontSizeFactor * 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
