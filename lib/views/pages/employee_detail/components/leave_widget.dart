import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/model/employee_detail/leave_model.dart';

class LeaveWidget extends StatelessWidget {
  final LeaveModel leaveData;

  const LeaveWidget({super.key, required this.leaveData});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
          decoration: BoxDecoration(
              border: Border.all(
                  width: 0.5, color: Colors.black.withValues(alpha: 0.1))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                leaveData.subject ?? "",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                leaveData.from == null || leaveData.to == null
                    ? ""
                    : leaveData.from!.year == leaveData.to!.year &&
                            leaveData.from!.month == leaveData.to!.month &&
                            leaveData.from!.day == leaveData.to!.day
                        ? DateFormat("MMM dd, yyyy").format(leaveData.from!)
                        : "${DateFormat("MMM dd, yyyy").format(leaveData.from!)} - ${DateFormat("MMM dd, yyyy").format(leaveData.to!)}",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.colorFFB400, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 14,
              ),
              ReadMoreText(
                "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English.",
                style: Theme.of(context).textTheme.bodyMedium,
                trimMode: TrimMode.Line,
                trimLines: 1,
                colorClickableText: AppColors.colorFFB400,
                trimCollapsedText: "see_more".tr,
                trimExpandedText: " ${"see_less".tr}",
                moreStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.colorFFB400),
              )
            ],
          ),
        ),
        Positioned(
            top: 8,
            right: 10,
            child: Container(
              color: leaveData.status == "1"
                  ? AppColors.color54B435.withValues(alpha: 0.2)
                  : leaveData.status == "2"
                      ? AppColors.colorCF0A0A.withValues(alpha: 0.2)
                      : AppColors.colorF49D1A.withValues(alpha: 0.2),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: Text(
                leaveData.status == "1"
                    ? "approved".tr
                    : leaveData.status == "2"
                        ? "rejected".tr
                        : "pending".tr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: leaveData.status == "1"
                        ? AppColors.color54B435
                        : leaveData.status == "2"
                            ? AppColors.colorCF0A0A
                            : AppColors.colorF49D1A,
                    fontSize: AppConsts.commonFontSizeFactor * 12),
              ),
            ))
      ],
    );
  }
}
