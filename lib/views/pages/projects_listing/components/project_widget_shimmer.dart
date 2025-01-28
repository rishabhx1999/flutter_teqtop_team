import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/app_colors.dart';

class ProjectWidgetShimmer extends StatelessWidget {
  const ProjectWidgetShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                height: 4,
              ),
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
                height: 26,
              ),
              Shimmer.fromColors(
                  baseColor: AppColors.shimmerBaseColor,
                  highlightColor: AppColors.shimmerHighlightColor,
                  child: Container(
                    height: 24,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: AppColors.shimmerBaseColor,
                    ),
                  )),
            ],
          ),
        ),
        Positioned(
          right: 14,
          bottom: 16,
          child: Shimmer.fromColors(
              baseColor: AppColors.shimmerBaseColor,
              highlightColor: AppColors.shimmerHighlightColor,
              child: Container(
                height: 20,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0),
                  color: AppColors.shimmerBaseColor,
                ),
              )),
        )
      ],
    );
  }
}
