import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/consts/app_consts.dart';

import '../../../../model/global_search/task_model.dart';

class TaskWidget extends StatelessWidget {
  final TaskModel taskData;
  final Function(int?) onTap;

  const TaskWidget({super.key, required this.taskData, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap(taskData.id);
      },
      child: Container(
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
                  .bodyMedium
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
                Expanded(
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "${"created".tr}: ",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: AppConsts.commonFontSizeFactor * 14)),
                    TextSpan(
                        text: taskData.createdBy,
                        style: Theme.of(context).textTheme.bodyMedium)
                  ])),
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  taskData.createdAt != null
                      ? DateFormat('MMM dd, yyyy').format(taskData.createdAt!)
                      : "",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black.withValues(alpha: 0.5),
                      fontSize: AppConsts.commonFontSizeFactor * 14),
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
                Expanded(
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "${"responsible".tr}: ",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: AppConsts.commonFontSizeFactor * 14)),
                    TextSpan(
                        text: taskData.responsiblePerson,
                        style: Theme.of(context).textTheme.bodyMedium)
                  ])),
                ),
                const SizedBox(
                  width: 16,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                      color: taskData.priority == "0"
                          ? Colors.grey.withValues(alpha: 0.2)
                          : taskData.priority == "1"
                              ? AppColors.colorF49D1A.withValues(alpha: 0.2)
                              : taskData.priority == "2"
                                  ? AppColors.colorCF0A0A.withValues(alpha: 0.2)
                                  : Colors.transparent,
                      borderRadius: BorderRadius.zero),
                  child: Text(
                    taskData.priority == "0"
                        ? "low".tr
                        : taskData.priority == "1"
                            ? "medium".tr
                            : taskData.priority == "2"
                                ? "high".tr
                                : "",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: taskData.priority == "0"
                              ? Colors.grey
                              : taskData.priority == "1"
                                  ? AppColors.colorF49D1A
                                  : taskData.priority == "2"
                                      ? AppColors.colorCF0A0A
                                      : Colors.transparent,
                          fontSize: AppConsts.commonFontSizeFactor * 12,
                        ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
