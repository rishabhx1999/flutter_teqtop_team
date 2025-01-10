import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/views/widgets/common/common_button.dart';

class CommonDialog {
  static show(
      {required BuildContext context,
      required String middleText,
      required Function onConfirmPress,
      Function? onCancelPress,
      String? confirmText,
      String? cancelText}) {
    Get.defaultDialog(
      radius: 0,
      title: "",
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.fromLTRB(44.0, 8, 44.0, 28),
      barrierDismissible: true,
      middleText: middleText.tr,
      middleTextStyle: Theme.of(context).textTheme.bodyLarge,
      confirm: CommonButton(
          text: confirmText ?? 'ok'.tr, onClick: () => onConfirmPress()),
      cancel: CommonButton(
          text: cancelText ?? 'cancel'.tr,
          onClick:
              onCancelPress != null ? () => onCancelPress() : () => Get.back()),
    );
  }
}
