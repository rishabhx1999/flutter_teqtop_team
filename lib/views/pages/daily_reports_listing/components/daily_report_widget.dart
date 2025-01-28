import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/model/daily_reports_listing/daily_report.dart';

import '../../../../consts/app_images.dart';

class DailyReportWidget extends StatelessWidget {
  final DailyReport dailyReportData;
  final Function onTap;
  final int index;

  const DailyReportWidget(
      {super.key,
      required this.dailyReportData,
      required this.onTap,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap(index);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(
                width: 0.5, color: Colors.black.withValues(alpha: 0.1))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 1, color: AppColors.colorFFB400)),
              child: Center(
                child: CircleAvatar(
                  radius: 36,
                  backgroundImage: AssetImage(AppImages.imgPersonPlaceholder),
                  foregroundImage: dailyReportData.profile != null
                      ? NetworkImage(
                          AppConsts.imgInitialUrl + dailyReportData.profile!)
                      : AssetImage(AppImages.imgPersonPlaceholder),
                ),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              dailyReportData.name ?? "",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge,
            ),
            Text(
              dailyReportData.createdAt != null
                  ? DateFormat('MMM dd, yyyy')
                      .format(dailyReportData.createdAt!)
                  : "",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black.withValues(
                      alpha: 0.7,
                    ),
                    fontSize: AppConsts.commonFontSizeFactor * 12,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
