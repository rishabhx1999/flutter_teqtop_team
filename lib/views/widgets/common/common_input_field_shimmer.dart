import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teqtop_team/config/app_colors.dart';

class CommonInputFieldShimmer extends StatelessWidget {
  final double? labelShimmerBorderRadius;
  final double? textFieldShimmerHeight;

  const CommonInputFieldShimmer({
    super.key,
    this.labelShimmerBorderRadius,
    this.textFieldShimmerHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
            baseColor: AppColors.shimmerBaseColor,
            highlightColor: AppColors.shimmerHighlightColor,
            child: Container(
              height: 20,
              width: 60,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(labelShimmerBorderRadius ?? 3),
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
              height: textFieldShimmerHeight ?? 55,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.shimmerBaseColor,
              ),
            )),
      ],
    );
  }
}
