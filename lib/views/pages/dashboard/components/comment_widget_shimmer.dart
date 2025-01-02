import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/app_colors.dart';

class CommentWidgetShimmer extends StatelessWidget {
  const CommentWidgetShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Shimmer.fromColors(
                  baseColor: AppColors.shimmerBaseColor,
                  highlightColor: AppColors.shimmerHighlightColor,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        color: AppColors.shimmerBaseColor,
                        shape: BoxShape.circle),
                  )),
              const SizedBox(
                width: 8,
              ),
              Shimmer.fromColors(
                  baseColor: AppColors.shimmerBaseColor,
                  highlightColor: AppColors.shimmerHighlightColor,
                  child: Container(
                    height: 26.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: AppColors.shimmerBaseColor,
                    ),
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                width: 38,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                        baseColor: AppColors.shimmerBaseColor,
                        highlightColor: AppColors.shimmerHighlightColor,
                        child: Container(
                          height: 23.0,
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
                          height: 23.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            color: AppColors.shimmerBaseColor,
                          ),
                        )),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
