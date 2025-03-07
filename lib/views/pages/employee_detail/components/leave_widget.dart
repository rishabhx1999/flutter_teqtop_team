import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/model/employee_detail/leave_model.dart';

import '../../../../consts/app_images.dart';

class LeaveWidget extends StatelessWidget {
  final LeaveModel leaveData;
  final bool? showEmployeeDetail;

  const LeaveWidget(
      {super.key, required this.leaveData, this.showEmployeeDetail});

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
              Visibility(
                visible: showEmployeeDetail ?? true,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10, right: 100),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage:
                            const AssetImage(AppImages.imgPersonPlaceholder),
                        foregroundImage: leaveData.profile != null &&
                                leaveData.profile!.isNotEmpty &&
                                leaveData.profile!.first != null &&
                                leaveData.profile!.first!.profile != null &&
                                leaveData.profile!.first!.profile!.isNotEmpty
                            ? NetworkImage(AppConsts.imgInitialUrl +
                                leaveData.profile!.first!.profile!)
                            : const AssetImage(AppImages.imgPersonPlaceholder),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Text(
                          leaveData.name ?? "",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Text(
                leaveData.subject ?? "",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: AppConsts.commonFontSizeFactor * 14),
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
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.colorFFB400,
                    fontSize: AppConsts.commonFontSizeFactor * 14),
              ),
              const SizedBox(
                height: 14,
              ),
              ReadMoreText(
                leaveData.description ?? "",
                style: Theme.of(context).textTheme.bodyLarge,
                trimMode: TrimMode.Line,
                trimLines: 1,
                colorClickableText: AppColors.colorFFB400,
                trimCollapsedText: "see_more".tr,
                trimExpandedText: " ${"see_less".tr}",
                moreStyle: Theme.of(context)
                    .textTheme
                    .bodyLarge
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
