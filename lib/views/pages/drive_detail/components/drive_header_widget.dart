import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teqtop_team/config/app_colors.dart';

import '../../../../consts/app_consts.dart';
import '../../../../model/global_search/drive_model.dart';

class DriveHeaderWidget extends StatelessWidget {
  final Color? backgroundColor;
  final TextAlign? textAlignment;
  final DriveModel driveData;
  final Function(String?)? onTap;

  const DriveHeaderWidget(
      {super.key,
      this.backgroundColor,
      this.textAlignment,
      required this.driveData,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (onTap != null) {
          onTap!(driveData.link);
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
        decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.colorF9F9F9,
            borderRadius: BorderRadius.zero),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: textAlignment == TextAlign.start
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Text(
              driveData.name ?? "",
              textAlign: textAlignment ?? TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: AppConsts.commonFontSizeFactor * 22,
                  ),
            ),
            Text(
              driveData.siteUrl ?? "",
              textAlign: textAlignment ?? TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: AppConsts.commonFontSizeFactor * 18),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              driveData.createdAt != null
                  ? DateFormat('MMM dd, yyyy').format(driveData.createdAt!)
                  : "",
              textAlign: textAlignment ?? TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black.withValues(alpha: 0.5),
                  fontSize: AppConsts.commonFontSizeFactor * 14),
            ),
          ],
        ),
      ),
    );
  }
}
