import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/consts/app_consts.dart';

class CommonButtonOutline extends StatelessWidget {
  final String text;
  final Color? borderColor;
  final Color? textColor;
  final VoidCallback onClick;
  final RxBool? isEnable;
  final double? borderRadius;
  final double? height;
  final double? width;
  final TextStyle? textStyle;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CommonButtonOutline(
      {super.key,
      required this.text,
      this.textColor,
      this.borderColor,
      required this.onClick,
      this.isEnable,
      this.borderRadius,
      this.height,
      this.width,
      this.textStyle,
      this.fontSize,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 52,
      width: width ?? double.infinity,
      child: Obx(() => ElevatedButton(
          onPressed: isEnable?.value ?? RxBool(true).value ? onClick : null,
          style: ButtonStyle(
              elevation: WidgetStateProperty.all(0),
              padding: WidgetStateProperty.all(EdgeInsets.zero),
              backgroundColor: WidgetStateProperty.all(Colors.white),
              side: WidgetStateProperty.all(BorderSide(
                  color: isEnable?.value ?? RxBool(true).value
                      ? borderColor ?? AppColors.kPrimaryColor
                      : borderColor?.withValues(alpha: 0.2) ??
                          AppColors.kPrimaryColor.withValues(alpha: 0.2))),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 0),
                ),
              )),
          child: Text(
            text.tr,
            textAlign: TextAlign.center,
            style: textStyle ??
                GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        color: isEnable?.value ?? RxBool(true).value
                            ? borderColor ?? AppColors.kPrimaryColor
                            : borderColor?.withValues(alpha: 0.2) ??
                                AppColors.kPrimaryColor.withValues(alpha: 0.2),
                        fontSize:
                            fontSize ?? AppConsts.commonFontSizeFactor * 18,
                        fontWeight: fontWeight ?? FontWeight.w700)),
          ))),
    );
  }
}
