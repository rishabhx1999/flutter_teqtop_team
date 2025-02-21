import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/consts/app_consts.dart';

class DrawerMenuListTile extends StatelessWidget {
  final Function() onTap;
  final String leading;
  final String title;

  const DrawerMenuListTile(
      {super.key,
      required this.onTap,
      required this.leading,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 16,
              ),
              leading.toLowerCase().endsWith('.svg')
                  ? SvgPicture.asset(
                      leading,
                      width: 18,
                    )
                  : Image.asset(
                      leading,
                      width: 18,
                    ),
              const SizedBox(
                width: 12,
              ),
              Text(
                title.tr,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: AppConsts.commonFontSizeFactor * 18),
              )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 46,
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.black.withValues(alpha: 0.05),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
