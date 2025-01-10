import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/consts/app_icons.dart';

import '../../../../consts/app_images.dart';
import '../../../../model/employees_listing/employee_model.dart';

class EmployeeWidget extends StatelessWidget {
  final EmployeeModel employeeData;
  final Function(int?) onTap;

  const EmployeeWidget(
      {super.key, required this.employeeData, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap(employeeData.id);
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.zero,
                color: Colors.transparent,
                border: Border.all(
                    color: Colors.black.withValues(alpha: 0.1), width: 0.5)),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage:
                          AssetImage(AppImages.imgPersonPlaceholder),
                      foregroundImage: employeeData.profile != null
                          ? NetworkImage(
                              AppConsts.imgInitialUrl + employeeData.profile!)
                          : AssetImage(AppImages.imgPersonPlaceholder),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employeeData.name ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          employeeData.roles ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.w400),
                        )
                      ],
                    )
                  ],
                ),
                SvgPicture.asset(
                  AppIcons.icNavigateNext,
                  width: 8,
                  colorFilter:
                      const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                )
              ],
            ),
          ),
          Positioned(
              right: 0,
              top: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                    color: AppColors.colorFFF7E5,
                    borderRadius: BorderRadius.zero),
                child: Text(
                  employeeData.employeeId ?? "",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.colorFFB300,
                      fontSize: AppConsts.commonFontSizeFactor * 10,
                      fontWeight: FontWeight.w600),
                ),
              ))
        ],
      ),
    );
  }
}
