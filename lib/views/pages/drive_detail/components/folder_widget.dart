import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/consts/app_icons.dart';
import 'package:teqtop_team/model/drive_detail/file_or_folder_model.dart';

class FolderWidget extends StatelessWidget {
  final Function(int) openFolder;
  final FileOrFolderModel folderData;
  final int index;
  final Function(BuildContext) downloadFolder;
  final Function(int?) onTapCross;

  const FolderWidget(
      {super.key,
      required this.openFolder,
      required this.folderData,
      required this.index,
      required this.downloadFolder,
      required this.onTapCross});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          color: AppColors.colorFFD674,
          padding: const EdgeInsets.only(top: 22, bottom: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AppIcons.icFolder,
                width: 36,
              ),
              Text(
                folderData.name ?? "",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: AppConsts.commonFontSizeFactor * 18),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      openFolder(index);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      color: Colors.white.withValues(alpha: 0.2),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      child: Text(
                        "open".tr,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: AppConsts.commonFontSizeFactor * 14),
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   width: 8,
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     downloadFolder(context);
                  //   },
                  //   behavior: HitTestBehavior.opaque,
                  //   child: Container(
                  //     color: Colors.white.withValues(alpha: 0.2),
                  //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  //     child: Text(
                  //       "download".tr,
                  //       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  //           fontSize: AppConsts.commonFontSizeFactor * 14),
                  //     ),
                  //   ),
                  // ),
                ],
              )
            ],
          ),
        ),
        Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
                onTap: () {
                  onTapCross(folderData.id);
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        color: AppColors.kPrimaryColor, shape: BoxShape.circle),
                    child: const Center(
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                )))
      ],
    );
  }
}
