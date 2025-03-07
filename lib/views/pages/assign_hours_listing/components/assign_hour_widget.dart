import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/model/assign_hours_listing/assign_hours.dart';

import '../../../../consts/app_images.dart';

class AssignHourWidget extends StatelessWidget {
  final AssignHours assignHoursData;
  final Function onTap;
  final int index;

  const AssignHourWidget(
      {super.key,
      required this.onTap,
      required this.index,
      required this.assignHoursData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (assignHoursData.action == null ||
            (assignHoursData.action != null &&
                assignHoursData.action!.toLowerCase().contains("trash") ==
                    false)) {
          onTap(index);
        }
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 0.5, color: Colors.black.withValues(alpha: 0.1))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(width: 1, color: AppColors.colorFFB400)),
                  child: Center(
                    child: CircleAvatar(
                      radius: 36,
                      backgroundImage:
                          const AssetImage(AppImages.imgPersonPlaceholder),
                      foregroundImage: assignHoursData.userProfile != null
                          ? NetworkImage(AppConsts.imgInitialUrl +
                              assignHoursData.userProfile!)
                          : const AssetImage(AppImages.imgPersonPlaceholder),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  assignHoursData.userName ?? "",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  assignHoursData.addedDate == null
                      ? ""
                      : "C: ${DateFormat('MMM d, y').format(assignHoursData.addedDate!)}",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black.withValues(
                          alpha: 0.7,
                        ),
                        fontSize: AppConsts.commonFontSizeFactor * 12,
                      ),
                ),
                Text(
                  assignHoursData.updatededDate == null
                      ? ""
                      : "M: ${DateFormat('MMM d, y').format(assignHoursData.updatededDate!)}",
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
          Visibility(
            visible: assignHoursData.action != null &&
                assignHoursData.action!.toLowerCase().contains("trash"),
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
