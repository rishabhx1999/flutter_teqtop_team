import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/common/common_button.dart';
import '../widgets/common/common_button_outline.dart';

enum ImageSourceOptions { camera, gallery }

class TakeImageBottomSheet {
  static show(
      {required BuildContext context,
      required Function(ImageSource) imageSource}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return TakeImageBottomSheetContent(
            imageSource: imageSource,
          );
        },
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22), topRight: Radius.circular(22))));
  }
}

class TakeImageBottomSheetContent extends StatelessWidget {
  const TakeImageBottomSheetContent({super.key, required this.imageSource});

  final void Function(ImageSource) imageSource;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22), topRight: Radius.circular(22))),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 32,
          ),
          CommonButton(
              text: 'take_a_photo'.tr,
              onClick: () {
                imageSource(ImageSource.camera);
              }),
          const SizedBox(
            height: 8,
          ),
          CommonButton(
              text: 'choose_from_gallery'.tr,
              onClick: () {
                imageSource(ImageSource.gallery);
              }),
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
