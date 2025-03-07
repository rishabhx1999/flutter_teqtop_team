import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/consts/app_icons.dart';
import 'package:teqtop_team/model/logs_listing/log_model.dart';

class LogWidget extends StatelessWidget {
  final LogModel logData;
  final int index;
  final Function(int) onTap;

  const LogWidget(
      {super.key,
      required this.logData,
      required this.index,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(index);
      },
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 14, 22, 14),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 0.5, color: Colors.black.withValues(alpha: 0.1))),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        logData.user ?? "",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: AppConsts.commonFontSizeFactor * 18),
                      ),
                      Text(
                        logData.projectName ?? "",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.black.withValues(alpha: 0.7)),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        logData.createdAt == null
                            ? ""
                            : DateFormat('MMM dd, yyyy HH:mm')
                                .format(logData.createdAt!),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Image.asset(AppIcons.icNavigateNext,
                    width: 8,
                    color: Colors.black,),
              ],
            ),
          ),
          Visibility(
            visible: false,
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
