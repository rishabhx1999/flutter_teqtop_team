import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teqtop_team/consts/app_consts.dart';

import '../../../../model/global_search/project_model.dart';

class ProjectWidget extends StatelessWidget {
  final ProjectModel projectData;
  final Function(int?) onTap;

  const ProjectWidget(
      {super.key, required this.projectData, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap(projectData.id);
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
                  projectData.name ?? "",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: AppConsts.commonFontSizeFactor * 22,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 26,
                ),
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
                ]))
              ],
            ),
          ),
          Positioned(
            right: 14,
            bottom: 16,
            child: Text(
              projectData.createdAt != null
                  ? DateFormat('MMM dd, yyyy').format(projectData.createdAt!)
                  : "",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.black.withValues(alpha: 0.5)),
            ),
          )
        ],
      ),
    );
  }
}
