import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teqtop_team/config/app_colors.dart';

class AssignHourWidgetShimmer extends StatelessWidget {
  const AssignHourWidgetShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              width: 0.5, color: Colors.black.withValues(alpha: 0.1))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Shimmer.fromColors(
              baseColor: AppColors.shimmerBaseColor,
              highlightColor: AppColors.shimmerHighlightColor,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                    color: AppColors.shimmerBaseColor, shape: BoxShape.circle),
              )),
          const SizedBox(
            height: 6,
          ),
          Shimmer.fromColors(
              baseColor: AppColors.shimmerBaseColor,
              highlightColor: AppColors.shimmerHighlightColor,
              child: Container(
                height: 22.0,
                width: 100.0,
                decoration: BoxDecoration(
                  color: AppColors.shimmerBaseColor,
                ),
              )),
          const SizedBox(
            height: 4,
          ),
          Shimmer.fromColors(
              baseColor: AppColors.shimmerBaseColor,
              highlightColor: AppColors.shimmerHighlightColor,
              child: Container(
                height: 14.0,
                width: 80.0,
                decoration: BoxDecoration(
                  color: AppColors.shimmerBaseColor,
                ),
              )),
          const SizedBox(
            height: 2,
          ),
          Shimmer.fromColors(
              baseColor: AppColors.shimmerBaseColor,
              highlightColor: AppColors.shimmerHighlightColor,
              child: Container(
                height: 14.0,
                width: 80.0,
                decoration: BoxDecoration(
                  color: AppColors.shimmerBaseColor,
                ),
              )),
        ],
      ),
    );
  }
}
