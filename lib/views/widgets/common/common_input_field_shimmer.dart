import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teqtop_team/config/app_colors.dart';

class CommonInputFieldShimmer extends StatelessWidget {
  final double? labelShimmerBorderRadius;
  final double? textFieldShimmerHeight;
  final bool? showLabelShimmer;

  const CommonInputFieldShimmer({
    super.key,
    this.labelShimmerBorderRadius,
    this.textFieldShimmerHeight,
    this.showLabelShimmer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: showLabelShimmer ?? true,
          child: Shimmer.fromColors(
              baseColor: AppColors.shimmerBaseColor,
              highlightColor: AppColors.shimmerHighlightColor,
              child: Container(
                height: 20,
                width: 60,
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(labelShimmerBorderRadius ?? 3),
                  color: AppColors.shimmerBaseColor,
                ),
              )),
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
