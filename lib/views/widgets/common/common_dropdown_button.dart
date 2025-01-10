import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/consts/app_icons.dart';

import '../../../config/app_colors.dart';

class CommonDropdownWidget extends StatelessWidget {
  var value;
  final Function onChanged;
  var items;
  final List<Widget> Function(BuildContext)? selectedItemBuilder;
  final double? maxDropdownHeight;

  CommonDropdownWidget(
      {super.key,
      required this.value,
      required this.onChanged,
      required this.items,
      this.selectedItemBuilder,
      this.maxDropdownHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      color: AppColors.colorD9D9D9.withValues(alpha: 0.2),
      child: DropdownButtonHideUnderline(
        child: Obx(
          () => DropdownButton2(
            iconStyleData: IconStyleData(
                icon: Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 16, 8),
                  child: SvgPicture.asset(
                    AppIcons.icDropdown,
                    width: 16,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withValues(alpha: 0.5), BlendMode.srcIn),
                  ),
                ),
                iconSize: 40),
            value: value.value,
            onChanged: (value) {
              onChanged(value);
            },
            items: items,
            selectedItemBuilder: selectedItemBuilder,
            dropdownStyleData: DropdownStyleData(
                maxHeight: maxDropdownHeight ?? 200,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5))),
          ),
        ),
      ),
    );
  }
}
