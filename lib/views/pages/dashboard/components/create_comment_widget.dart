import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/consts/app_icons.dart';

class CreateCommentWidget extends StatelessWidget {
  final String hint;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatter;
  final int? maxLines;
  final bool? isEnable;
  final bool? showFloatingLabel;
  final TextCapitalization? textCapitalization;

  final inputBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(4), bottomRight: Radius.circular(4)),
      borderSide:
          BorderSide(color: Colors.black.withValues(alpha: 0.2), width: 0.5));

  CreateCommentWidget(
      {super.key,
      required this.controller,
      required this.hint,
      this.onChanged,
      this.validator,
      this.inputType,
      this.inputFormatter,
      this.maxLines,
      this.isEnable,
      this.showFloatingLabel,
      this.textCapitalization});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          offset: const Offset(0, 0),
          blurRadius: 14,
          spreadRadius: 0,
        ),
      ]),
      child: Stack(
        children: [
          TextField(
            controller: controller,
            maxLines: maxLines ?? 1,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500),
            keyboardType: inputType ?? TextInputType.name,
            cursorColor: Colors.black,
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            decoration: InputDecoration(
                hintText: (showFloatingLabel ?? false) ? '' : hint.tr,
                enabled: isEnable ?? true,
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black.withValues(alpha: 0.3),
                    fontWeight: FontWeight.w500),
                fillColor: Colors.white,
                filled: true,
                border: inputBorder,
                errorBorder: inputBorder,
                enabledBorder: inputBorder,
                disabledBorder: inputBorder,
                focusedBorder: inputBorder,
                focusedErrorBorder: inputBorder,
                contentPadding: const EdgeInsets.fromLTRB(16, 14, 70, 14)),
            inputFormatters: inputFormatter,
            onChanged: onChanged,
          ),
          Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 54,
                  height: 52,
                  decoration: BoxDecoration(
                      color: AppColors.kPrimaryColor,
                      borderRadius: BorderRadius.circular(4)),
                  child: Center(
                    child: SvgPicture.asset(
                      AppIcons.icSend,
                      width: 36,
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
