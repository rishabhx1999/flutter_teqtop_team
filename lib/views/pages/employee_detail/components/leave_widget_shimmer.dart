import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teqtop_team/config/app_colors.dart';

class LeaveWidgetShimmer extends StatelessWidget {
  final bool? showUserShimmer;

  const LeaveWidgetShimmer({super.key, this.showUserShimmer});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
          decoration: BoxDecoration(
              border: Border.all(
                  width: 0.5, color: Colors.black.withValues(alpha: 0.1))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: showUserShimmer ?? true,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10, right: 100),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Shimmer.fromColors(
                          baseColor: AppColors.shimmerBaseColor,
                          highlightColor: AppColors.shimmerHighlightColor,
                          child: Container(
                            height: 24,
                            width: 24.0,
                            decoration: BoxDecoration(
                                color: AppColors.shimmerBaseColor,
                                shape: BoxShape.circle),
                          )),
                      const SizedBox(
                        width: 12,
                      ),
                      Shimmer.fromColors(
                          baseColor: AppColors.shimmerBaseColor,
                          highlightColor: AppColors.shimmerHighlightColor,
                          child: Container(
                            height: 24.0,
                            width: 120.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3.0),
                              color: AppColors.shimmerBaseColor,
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              Shimmer.fromColors(
                  baseColor: AppColors.shimmerBaseColor,
                  highlightColor: AppColors.shimmerHighlightColor,
                  child: Container(
                    height: 20.0,
                    width: 150.0,
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
                    height: 20.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: AppColors.shimmerBaseColor,
                    ),
                  )),
              const SizedBox(
                height: 14,
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
                height: 4,
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
            ],
          ),
        ),
        Positioned(
          top: 8,
          right: 10,
          child: Shimmer.fromColors(
              baseColor: AppColors.shimmerBaseColor,
              highlightColor: AppColors.shimmerHighlightColor,
              child: Container(
                height: 20.0,
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
