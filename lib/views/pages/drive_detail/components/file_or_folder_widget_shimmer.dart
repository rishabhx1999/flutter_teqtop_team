import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/consts/app_icons.dart';

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
