import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

import '../../../../config/app_colors.dart';

class LogWidgetShimmer extends StatelessWidget {
  const LogWidgetShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                Shimmer.fromColors(
                    baseColor: AppColors.shimmerBaseColor,
                    highlightColor: AppColors.shimmerHighlightColor,
                    child: Container(
                      height: 28.0,
                      width: 120.0,
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
                      height: 20.0,
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
                      height: 20.0,
                      width: double.infinity,
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
                      height: 20.0,
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.0),
                        color: AppColors.shimmerBaseColor,
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Shimmer.fromColors(
              baseColor: AppColors.shimmerBaseColor,
              highlightColor: AppColors.shimmerHighlightColor,
              child: Container(
                height: 14,
                width: 14,
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
