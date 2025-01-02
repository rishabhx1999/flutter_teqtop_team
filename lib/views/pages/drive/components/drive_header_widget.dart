import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/model/search/drive.dart';

import '../../../../consts/app_consts.dart';

class DriveHeaderWidget extends StatelessWidget {
  final Color? backgroundColor;
  final TextAlign? textAlignment;
  final Drive driveData;

  const DriveHeaderWidget(
      {super.key,
      this.backgroundColor,
      this.textAlignment,
      required this.driveData});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                fontWeight: FontWeight.w600),
          ),
          Text(
            "www.example.com",
            textAlign: textAlignment ?? TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            DateFormat('MMM dd, yyyy').format(DateTime.now()),
            textAlign: textAlignment ?? TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black.withValues(alpha: 0.5),
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
