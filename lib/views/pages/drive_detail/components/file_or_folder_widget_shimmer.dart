import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';
import 'package:teqtop_team/config/app_colors.dart';

class FileOrFolderWidgetShimmer extends StatelessWidget {
  const FileOrFolderWidgetShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: AppColors.shimmerBaseColor,
        highlightColor: AppColors.shimmerHighlightColor,
        child: Container(
          height: 144,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.0),
            color: AppColors.shimmerBaseColor,
          ),
        ));
  }
}
