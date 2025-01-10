import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/views/widgets/common/common_button.dart';
import 'package:teqtop_team/views/widgets/common/common_button_outline.dart';

class CommonAlertDialog {
  CommonAlertDialog._();

  static showDialog(
      {String? title,
      required String message,
      String? negativeText,
      required String positiveText,
      bool? isShowNegativeBtn,
      VoidCallback? negativeBtnCallback,
      required VoidCallback positiveBtnCallback,
      bool? isPositiveBtnOutlined,
      Color? positiveBtnColor}) {
    Get.dialog(Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: CommonDialogContent(
        title: title,
        message: message,
        negativeText: negativeText,
        positiveText: positiveText,
        isShowNegativeBtn: isShowNegativeBtn,
        positiveBtnCallback: positiveBtnCallback,
        negativeBtnCallback: negativeBtnCallback,
        isPositiveBtnOutlined: isPositiveBtnOutlined,
        positiveBtnColor: positiveBtnColor,
      ),
    ));
  }
}

class CommonDialogContent extends StatelessWidget {
  final String? title;
  final String message;
  final String? negativeText;
  final String positiveText;
  final bool? isShowNegativeBtn;
  final VoidCallback positiveBtnCallback;
  final VoidCallback? negativeBtnCallback;
  final bool? isPositiveBtnOutlined;
  final Color? positiveBtnColor;

  const CommonDialogContent(
      {super.key,
      this.title,
      required this.message,
      this.negativeText,
      required this.positiveText,
      this.isShowNegativeBtn,
      required this.positiveBtnCallback,
      this.negativeBtnCallback,
      this.isPositiveBtnOutlined,
      this.positiveBtnColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
              visible: title != null && title!.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  title ?? "".tr,
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: AppConsts.commonFontSizeFactor * 20,
                          fontWeight: FontWeight.w600)),
                ),
              )),
          const SizedBox(
            height: 6,
          ),
          Text(message.tr,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: AppConsts.commonFontSizeFactor * 18,
                      fontWeight: FontWeight.w500))),
          const SizedBox(
            height: 28,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                  visible: isShowNegativeBtn ?? false,
                  child: Expanded(
                      child: CommonButtonOutline(
                    text: negativeText ?? "".tr,
                    onClick: negativeBtnCallback ??
                        () {
                          Get.back();
                        },
                    fontWeight: FontWeight.w600,
                    fontSize: AppConsts.commonFontSizeFactor * 16,
                  ))),
              Visibility(
                  visible: isShowNegativeBtn ?? false,
                  child: const SizedBox(
                    width: 12,
                  )),
              Expanded(
                  child: isPositiveBtnOutlined ?? false
                      ? CommonButtonOutline(
                          borderColor: positiveBtnColor,
                          text: positiveText.tr,
                          onClick: positiveBtnCallback,
                          fontWeight: FontWeight.w600,
                          fontSize: AppConsts.commonFontSizeFactor * 16,
                        )
                      : CommonButton(
                          text: positiveText.tr,
                          onClick: positiveBtnCallback,
                          fontWeight: FontWeight.w600,
                          fontSize: AppConsts.commonFontSizeFactor * 16,
                        ))
            ],
          )
        ],
      ),
    );
  }
}
