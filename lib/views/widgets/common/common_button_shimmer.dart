import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teqtop_team/config/app_colors.dart';

class CommonButtonShimmer extends StatelessWidget {
  final double? borderRadius;
  final double? height;
  final double? width;

  const CommonButtonShimmer({
    super.key,
    this.borderRadius,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: AppColors.shimmerBaseColor,
        highlightColor: AppColors.shimmerHighlightColor,
        child: Container(
          height: height ?? 52,
          width: width ?? double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 3),
            color: AppColors.shimmerBaseColor,
          ),
        ));
  }
}
