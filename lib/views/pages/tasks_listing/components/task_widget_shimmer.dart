import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teqtop_team/config/app_colors.dart';

class TaskWidgetShimmer extends StatelessWidget {
  const TaskWidgetShimmer({
    super.key,
  });

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
          Shimmer.fromColors(
              baseColor: AppColors.shimmerBaseColor,
              highlightColor: AppColors.shimmerHighlightColor,
              child: Container(
                height: 32.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0),
                  color: AppColors.shimmerBaseColor,
                ),
              )),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Shimmer.fromColors(
                  baseColor: AppColors.shimmerBaseColor,
                  highlightColor: AppColors.shimmerHighlightColor,
                  child: Container(
                    height: 24,
                    width: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: AppColors.shimmerBaseColor,
                    ),
                  )),
              const SizedBox(
                width: 16,
              ),
              Shimmer.fromColors(
                  baseColor: AppColors.shimmerBaseColor,
                  highlightColor: AppColors.shimmerHighlightColor,
                  child: Container(
                    height: 20.0,
                    width: 88,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: AppColors.shimmerBaseColor,
                    ),
                  )),
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
              Shimmer.fromColors(
                  baseColor: AppColors.shimmerBaseColor,
                  highlightColor: AppColors.shimmerHighlightColor,
                  child: Container(
                    height: 24,
                    width: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: AppColors.shimmerBaseColor,
                    ),
                  )),
              const SizedBox(
                width: 16,
              ),
              Shimmer.fromColors(
                  baseColor: AppColors.shimmerBaseColor,
                  highlightColor: AppColors.shimmerHighlightColor,
                  child: Container(
                    height: 22,
                    width: 56,
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBaseColor,
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
