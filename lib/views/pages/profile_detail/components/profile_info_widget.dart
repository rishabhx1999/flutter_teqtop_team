import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/consts/app_consts.dart';

class ProfileInfoWidget extends StatelessWidget {
  final String title;
  final String data;

  const ProfileInfoWidget({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 38,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 12,
            ),
            SizedBox(
              width: 50,
              child: Divider(
                color: Colors.black.withValues(alpha: 0.2),
                thickness: 1,
              ),
            ),
            Expanded(
              child: Text(
                title.tr.toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: AppConsts.commonFontSizeFactor * 12),
              ),
            ),
            SizedBox(
              width: 50,
              child: Divider(
                color: Colors.black.withValues(alpha: 0.2),
                thickness: 1,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
          ],
        ),
        Text(
          data,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        )
      ],
    );
  }
}
