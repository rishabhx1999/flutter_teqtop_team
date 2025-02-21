import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/consts/app_consts.dart';

class CommonInputField extends StatelessWidget {
  final String label;
  final String hint;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Future<void> Function(dynamic)? onTap;
  final dynamic onTapFirstArg;
  final TextEditingController controller;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatter;
  final int? maxLines;
  final double? inputHorizontalPadding;
  final double? inputVerticalPadding;
  final int? errorMaxLines;
  final bool? isEnable;
  final bool? showFloatingLabel;
  final TextCapitalization? textCapitalization;
  final double? bottomScrollPadding;
  final TextInputAction? textInputAction;
  final Color? fillColor;
  final double? borderWidth;
  final Color? borderColor;
  final Widget? trailing;
  final bool? blurField;

  const CommonInputField({
    super.key,
    required this.controller,
    required this.hint,
    required this.label,
    this.onChanged,
    this.validator,
    this.inputType,
    this.inputFormatter,
    this.maxLines,
    this.inputHorizontalPadding,
    this.inputVerticalPadding,
    this.errorMaxLines,
    this.isEnable,
    this.showFloatingLabel,
    this.textCapitalization,
    this.bottomScrollPadding,
    this.textInputAction,
    this.fillColor,
    this.borderWidth,
    this.borderColor,
    this.onTap,
    this.trailing,
    this.onTapFirstArg,
    this.blurField,
  });

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: BorderSide(
            color: borderColor ?? Colors.black.withValues(alpha: 0.1),
            width: borderWidth ?? 0.5));
    final errorInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: BorderSide(
            color: borderColor ?? Colors.red.withValues(alpha: 0.1),
            width: borderWidth ?? 0.5));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.tr.toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: AppConsts.commonFontSizeFactor * 14),
        ),
        const SizedBox(
          height: 8,
        ),
        Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                onTap != null ? onTap!(onTapFirstArg) : () {};
              },
              child: TextFormField(
                enabled: isEnable ?? true,
                controller: controller,
                maxLines: maxLines ?? 1,
                style: Theme.of(context).textTheme.bodyLarge,
                keyboardType: inputType ?? TextInputType.name,
                cursorColor: Colors.black,
                textCapitalization:
                    textCapitalization ?? TextCapitalization.none,
                decoration: InputDecoration(
                    hintText: (showFloatingLabel ?? false) ? '' : hint.tr,
                    enabled: isEnable ?? true,
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: AppColors.colorA9A9A9),
                    suffixIcon: trailing,
                    fillColor: fillColor ?? Colors.white,
                    filled: true,
                    border: inputBorder,
                    errorMaxLines: errorMaxLines ?? 1,
                    errorBorder: errorInputBorder,
                    enabledBorder: inputBorder,
                    disabledBorder: inputBorder,
                    focusedBorder: inputBorder,
                    focusedErrorBorder: errorInputBorder,
                    errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.red,
                          fontSize: AppConsts.commonFontSizeFactor * 12,
                        ),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: inputHorizontalPadding ?? 14,
                        vertical: inputVerticalPadding ?? 16)),
                inputFormatters: inputFormatter,
                validator: validator,
                onChanged: onChanged,
                scrollPadding:
                    EdgeInsets.only(bottom: bottomScrollPadding ?? 40),
                textInputAction: textInputAction ?? TextInputAction.done,
                onFieldSubmitted: textInputAction == TextInputAction.next
                    ? (v) {
                        FocusScope.of(context).nextFocus();
                      }
                    : null,
              ),
            ),
            Visibility(
              visible: blurField ?? false,
              child: Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
