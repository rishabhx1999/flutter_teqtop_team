import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teqtop_team/config/app_colors.dart';


class DriveHeaderWidgetShimmer extends StatelessWidget {
  const DriveHeaderWidgetShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: BoxDecoration(
          color: AppColors.colorF9F9F9, borderRadius: BorderRadius.zero),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Shimmer.fromColors(
              baseColor: AppColors.shimmerBaseColor,
              highlightColor: AppColors.shimmerHighlightColor,
              child: Container(
                height: 32,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0),
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
                height: 32,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0),
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
                height: 26,
                width: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0),
                  color: AppColors.shimmerBaseColor,
                ),
              )),
          const SizedBox(
            height: 8,
          ),
          Shimmer.fromColors(
              baseColor: AppColors.shimmerBaseColor,
              highlightColor: AppColors.shimmerHighlightColor,
              child: Container(
                height: 20,
                width: 88,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0),
                  color: AppColors.shimmerBaseColor,
                ),
              )),
        ],
      ),
    );
  }
}
