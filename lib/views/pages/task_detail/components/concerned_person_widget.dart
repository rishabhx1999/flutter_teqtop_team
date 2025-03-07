import 'package:flutter/material.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/model/employees_listing/employee_model.dart';

import '../../../../consts/app_images.dart';

class ConcernedPersonWidget extends StatelessWidget {
  final EmployeeModel personData;

  const ConcernedPersonWidget({super.key, required this.personData});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: const AssetImage(AppImages.imgPersonPlaceholder),
          foregroundImage: personData.profile is String
              ? NetworkImage(AppConsts.imgInitialUrl + personData.profile)
              : const AssetImage(AppImages.imgPersonPlaceholder),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                personData.name ?? "",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: AppConsts.commonFontSizeFactor * 14),
              ),
              Text(
                personData.roles ?? personData.positionName ?? "",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black.withValues(alpha: 0.7),
                    fontSize: AppConsts.commonFontSizeFactor * 14),
              )
            ],
          ),
        )
      ],
    );
  }
}
