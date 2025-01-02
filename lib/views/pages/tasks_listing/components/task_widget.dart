import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/model/search/task.dart';

class TaskWidget extends StatelessWidget {
  final Task taskData;

  const TaskWidget({super.key, required this.taskData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 12, 14, 16),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.zero,
          border: Border.all(
              color: Colors.black.withValues(alpha: 0.1), width: 0.5)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            taskData.name ?? "",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontSize: AppConsts.commonFontSizeFactor * 22),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "${"created".tr}: ",
                    style: Theme.of(context).textTheme.bodySmall),
                TextSpan(
                    text: "Sushil Kumar",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500))
              ])),
              Text(
                DateFormat('MMM dd, yyyy').format(DateTime.now()),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.black.withValues(alpha: 0.5)),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "${"responsible".tr}: ",
                    style: Theme.of(context).textTheme.bodySmall),
                TextSpan(
                    text: "Sunil Dhadwal",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500))
              ])),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                    color: AppColors.colorCF0A0A.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.zero),
                child: Text(
                  "High",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.colorCF0A0A,
                      fontSize: AppConsts.commonFontSizeFactor * 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
