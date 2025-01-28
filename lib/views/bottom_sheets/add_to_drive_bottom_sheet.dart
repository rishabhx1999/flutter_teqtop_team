import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/common/common_button.dart';
import '../widgets/common/common_button_outline.dart';

class AddToDriveBottomSheet {
  static show({
    required BuildContext context,
    required void Function() pickFiles,
    required void Function() createFolder,
  }) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return AddToDriveBottomSheetContent(
            pickFiles: pickFiles,
            createFolder: createFolder,
          );
        },
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22), topRight: Radius.circular(22))));
  }
}

class AddToDriveBottomSheetContent extends StatelessWidget {
  final void Function() pickFiles;
  final void Function() createFolder;

  const AddToDriveBottomSheetContent(
      {super.key, required this.pickFiles, required this.createFolder});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22), topRight: Radius.circular(22))),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 32,
          ),
          CommonButton(text: 'add_files'.tr, onClick: pickFiles),
          const SizedBox(
            height: 8,
          ),
          CommonButton(text: 'create_folder'.tr, onClick: createFolder),
          const SizedBox(
            height: 24,
          ),
          CommonButtonOutline(
            text: 'cancel'.tr,
            onClick: () {
              Get.back();
            },
          ),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}
