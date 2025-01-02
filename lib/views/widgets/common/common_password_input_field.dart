import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/consts/app_consts.dart';

class CommonPasswordInputField extends StatelessWidget {
  final String hint;
  final String label;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatter;
  final RxBool isObscure = true.obs;
  final bool? isShowHelperText;
  final bool isShowSuffix;
  final double? inputHorizontalPadding;
  final double? inputVerticalPadding;
  final double? bottomScrollPadding;

  final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.1)));
  final errorInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(color: Colors.red.withValues(alpha: 0.1)));

  CommonPasswordInputField(
      {super.key,
      required this.controller,
      required this.hint,
      required this.label,
      required this.isShowSuffix,
      this.onChanged,
      this.validator,
      this.inputType,
      this.inputFormatter,
      this.isShowHelperText,
      this.inputHorizontalPadding,
      this.inputVerticalPadding,
      this.bottomScrollPadding});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.tr.toUpperCase(),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(
          height: 8,
        ),
        Obx(() => TextFormField(
              controller: controller,
              style: Theme.of(context).textTheme.bodyMedium,
              keyboardType: TextInputType.visiblePassword,
              cursorColor: Colors.black,
              obscureText: isObscure.value,
              obscuringCharacter: '*',
              decoration: InputDecoration(
                  hintText: hint.tr,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.colorA9A9A9),
                  suffixIcon: isShowSuffix
                      ? IconButton(
                          onPressed: () {
                            isObscure.value = !isObscure.value;
                          },
                          style: IconButton.styleFrom(
                              splashFactory: NoSplash.splashFactory),
                          icon: Icon(
                            isObscure.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black,
                          ))
                      : const SizedBox(),
                  filled: true,
                  fillColor: Colors.white,
                  errorMaxLines: 3,
                  errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.red,
                      fontSize: AppConsts.commonFontSizeFactor * 12,
                      fontWeight: FontWeight.w400),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: inputHorizontalPadding ?? 14,
                      vertical: inputVerticalPadding ?? 16),
                  border: inputBorder,
                  errorBorder: errorInputBorder,
                  enabledBorder: inputBorder,
                  disabledBorder: inputBorder,
                  focusedBorder: inputBorder,
                  focusedErrorBorder: errorInputBorder),
              inputFormatters: inputFormatter,
              validator: validator,
              onChanged: onChanged,
              scrollPadding: EdgeInsets.only(bottom: bottomScrollPadding ?? 40),
            ))
      ],
    );
  }
}
