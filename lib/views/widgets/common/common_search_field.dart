import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:teqtop_team/consts/app_consts.dart';

import '../../../config/app_colors.dart';
import '../../../consts/app_icons.dart';

class CommonSearchField extends StatelessWidget {
  TextEditingController controller;
  final Function(String) onChanged;
  final String hint;
  final RxBool? isShowTrailing;
  final Function()? onTapTrailing;
  final bool? isShowLeading;
  static const inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.zero, borderSide: BorderSide.none);
  final EdgeInsetsGeometry? contentPadding;

  CommonSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.hint,
    this.isShowTrailing,
    this.onTapTrailing,
    this.isShowLeading,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextField(
        controller: controller,
        decoration: InputDecoration(
            fillColor: AppColors.colorD9D9D9.withValues(alpha: 0.2),
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            floatingLabelAlignment: FloatingLabelAlignment.center,
            isDense: true,
            alignLabelWithHint: true,
            hintText: hint.tr,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.colorAEAEAE,
                fontSize: AppConsts.commonFontSizeFactor * 14),
            prefixIcon: isShowLeading ?? true
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(10, 4, 8, 4),
                    child: Image.asset(
                      AppIcons.icSearch,
                      color: Colors.black,
                    ),
                  )
                : const SizedBox(),
            prefixIconConstraints: BoxConstraints(
                minHeight: isShowLeading ?? true ? 32 : 8,
                minWidth: isShowLeading ?? true ? 42 : 10,
                maxHeight: isShowLeading ?? true ? 32 : 8,
                maxWidth: isShowLeading ?? true ? 42 : 10),
            suffixIcon: isShowTrailing?.value ?? false
                ? GestureDetector(
                    onTap: onTapTrailing,
                    child: Container(
                      width: 16,
                      height: 16,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.kPrimaryColor),
                      child: const Icon(
                        Icons.clear_rounded,
                        color: Colors.white,
                        size: 12,
                      ),
                    ))
                : null,
            suffixIconConstraints: const BoxConstraints(
                minHeight: 32, minWidth: 32, maxHeight: 32, maxWidth: 32),
            border: inputBorder,
            focusedBorder: inputBorder,
            enabledBorder: inputBorder,
            focusedErrorBorder: inputBorder,
            errorBorder: inputBorder,
            disabledBorder: inputBorder,
            contentPadding: contentPadding ?? const EdgeInsets.all(8)),
        cursorColor: AppColors.kPrimaryColor,
        keyboardType: TextInputType.text,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontSize: AppConsts.commonFontSizeFactor * 14),
        onChanged: onChanged,
      ),
    );
  }
}
