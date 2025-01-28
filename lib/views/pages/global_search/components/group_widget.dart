import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teqtop_team/consts/app_consts.dart';

import '../../../../model/global_search/project_model.dart';

class GroupWidget extends StatelessWidget {
  final ProjectModel groupData;
  final Function(int?) onTap;

  const GroupWidget({super.key, required this.groupData, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap(groupData.id);
      },
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.zero,
                color: Colors.transparent,
                border: Border.all(
                    color: Colors.black.withValues(alpha: 0.1), width: 0.5)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groupData.name ?? "",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: AppConsts.commonFontSizeFactor * 22,
                      ),
                ),
                const SizedBox(
                  height: 26,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 96),
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "${"created".tr}: ",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: AppConsts.commonFontSizeFactor * 14)),
                    TextSpan(
                        text: groupData.createdBy,
                        style: Theme.of(context).textTheme.bodyMedium)
                  ])),
                )
              ],
            ),
          ),
          Positioned(
            right: 14,
            bottom: 16,
            child: Text(
              groupData.createdAt != null
                  ? DateFormat('MMM dd, yyyy').format(groupData.createdAt!)
                  : groupData.projectCreatedAt != null
                      ? DateFormat('MMM dd, yyyy')
                          .format(groupData.projectCreatedAt!)
                      : "",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black.withValues(alpha: 0.5),
                  fontSize: AppConsts.commonFontSizeFactor * 14),
            ),
          )
        ],
      ),
    );
  }
}
