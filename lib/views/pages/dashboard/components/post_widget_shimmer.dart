import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teqtop_team/config/app_colors.dart';

class PostWidgetShimmer extends StatelessWidget {
  const PostWidgetShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0),
          border:
              Border.all(color: Colors.black.withValues(alpha: 0.05), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              offset: const Offset(0, 0),
              blurRadius: 7,
              spreadRadius: 0,
            ),
          ]),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
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
                        width: 28,
                        height: 28,
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
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                width: 36,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                      height: 6,
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
                    const SizedBox(
                      height: 6,
                    ),
                    Shimmer.fromColors(
                        baseColor: AppColors.shimmerBaseColor,
                        highlightColor: AppColors.shimmerHighlightColor,
                        child: Container(
                          height: 150.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            color: AppColors.shimmerBaseColor,
                          ),
                        )),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      height: 1,
                      width: 238,
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Shimmer.fromColors(
                            baseColor: AppColors.shimmerBaseColor,
                            highlightColor: AppColors.shimmerHighlightColor,
                            child: Container(
                              height: 24,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.0),
                                color: AppColors.shimmerBaseColor,
                              ),
                            )),
                        const SizedBox(
                          width: 44,
                        ),
                        Shimmer.fromColors(
                            baseColor: AppColors.shimmerBaseColor,
                            highlightColor: AppColors.shimmerHighlightColor,
                            child: Container(
                              height: 24,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.0),
                                color: AppColors.shimmerBaseColor,
                              ),
                            )),
                      ],
                    )
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
