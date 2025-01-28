import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/controllers/drive_detail/drive_detail_controller.dart';
import 'package:teqtop_team/model/global_search/drive_model.dart';
import 'package:teqtop_team/views/pages/drive_detail/components/drive_header_widget.dart';
import 'package:teqtop_team/views/pages/drive_detail/components/drive_header_widget_shimmer.dart';
import 'package:teqtop_team/views/pages/drive_detail/components/file_or_folder_widget_shimmer.dart';
import 'package:teqtop_team/views/pages/drive_detail/components/folder_widget.dart';

import '../../../config/app_colors.dart';
import '../../../consts/app_icons.dart';
import '../../../consts/app_images.dart';
import '../../../utils/helpers.dart';
import '../../bottom_sheets/add_to_drive_bottom_sheet.dart';
import '../../dialogs/create_drive_folder_dialog.dart';

class DriveDetailPage extends StatelessWidget {
  final driveDetailController = Get.put(DriveDetailController());

  DriveDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white));

    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.05),
                    height: 1,
                  )),
              title: Text(
                'drive'.tr,
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
              leading: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: SvgPicture.asset(
                      AppIcons.icBack,
                      colorFilter:
                          const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    ),
                  )),
              leadingWidth: 40,
              backgroundColor: Colors.white,
              centerTitle: true,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              elevation: 0,
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 18,
                  ),
                  Obx(
                    () => driveDetailController.isLoading.value
                        ? DriveHeaderWidgetShimmer()
                        : DriveHeaderWidget(
                            driveData:
                                driveDetailController.basicDriveDetails.value ??
                                    DriveModel()),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: () {
                        AddToDriveBottomSheet.show(
                            context: context,
                            pickFiles: driveDetailController.pickFiles,
                            createFolder: () {
                              Get.back();
                              CreateDriveFolderDialog.showDialog(
                                  createFolder:
                                      driveDetailController.createFolder,
                                  nameController: driveDetailController
                                      .newFolderNameController,
                                  formKey:
                                      driveDetailController.folderNameFormKey,
                                  isFolderCreating:
                                      driveDetailController.isFolderCreating);
                            });
                      },
                      behavior: HitTestBehavior.opaque,
                      child: DottedBorder(
                        color: Colors.black.withValues(alpha: 0.2),
                        padding: EdgeInsets.zero,
                        dashPattern: [4],
                        strokeWidth: 1,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 34),
                          color: AppColors.colorF7F7F7,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.color7E869E
                                        .withValues(alpha: 0.25)),
                                child: Icon(
                                  Icons.add_rounded,
                                  color: AppColors.color222222,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(
                                width: 14,
                              ),
                              Text(
                                "add".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        fontSize:
                                            AppConsts.commonFontSizeFactor *
                                                18),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.only(left: 16, right: 16, top: 22),
                        itemBuilder: (context, index) {
                          return driveDetailController.isLoading.value
                              ? FileOrFolderWidgetShimmer()
                              : GestureDetector(
                                  onTap: () {
                                    Helpers.openFile(
                                        path:
                                            driveDetailController.files[index],
                                        fileName: driveDetailController
                                            .files[index]
                                            .split("/")
                                            .last);
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Helpers.isImage(
                                          driveDetailController.files[index])
                                      ? FadeInImage.assetNetwork(
                                          width: double.infinity,
                                          height: 144,
                                          placeholder: AppImages.imgPlaceholder,
                                          image: AppConsts.imgInitialUrl +
                                              driveDetailController
                                                  .files[index],
                                          imageErrorBuilder:
                                              (BuildContext context,
                                                  Object error,
                                                  StackTrace? stackTrace) {
                                            return Image.asset(
                                              AppImages.imgPlaceholder,
                                              width: double.infinity,
                                              height: 144,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                          fit: BoxFit.cover,
                                        )
                                      : driveDetailController
                                              .files[index].isNotEmpty
                                          ? Container(
                                              width: double.infinity,
                                              height: 144,
                                              padding: const EdgeInsets.all(16),
                                              color: AppColors.kPrimaryColor,
                                              child: Center(
                                                child: Text(
                                                  driveDetailController
                                                      .files[index]
                                                      .split("/")
                                                      .last,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          color: Colors.white),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 16,
                          );
                        },
                        itemCount: driveDetailController.isLoading.value
                            ? 5
                            : driveDetailController.files.length),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Obx(
                    () => ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 22),
                        itemBuilder: (context, index) {
                          return driveDetailController.isLoading.value
                              ? FileOrFolderWidgetShimmer()
                              : FolderWidget(
                                  openFolder: driveDetailController.openFolder,
                                  folderData:
                                      driveDetailController.folders[index],
                                  index: index,
                                  downloadFolder:
                                      driveDetailController.downloadFolder,
                                );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 16,
                          );
                        },
                        itemCount: driveDetailController.isLoading.value
                            ? 5
                            : driveDetailController.folders.length),
                  )
                ],
              ),
            )));
  }
}
