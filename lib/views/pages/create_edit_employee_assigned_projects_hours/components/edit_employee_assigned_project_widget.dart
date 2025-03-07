import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/model/employee_assigned_projects_hours/person_projects_assign_hours.dart';
import 'package:teqtop_team/utils/validations.dart';

class EditEmployeeAssignedProjectWidget extends StatelessWidget {
  final PersonProjectsAssignHours employeeAssignedProjectData;
  final void Function(bool, int) playPauseProject;
  final int index;

  const EditEmployeeAssignedProjectWidget(
      {super.key,
      required this.employeeAssignedProjectData,
      required this.playPauseProject, required this.index});

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.transparent, width: 0));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          border: Border.all(
              width: 0.5, color: Colors.black.withValues(alpha: 0.1))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            employeeAssignedProjectData.projectName ?? "",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontSize: AppConsts.commonFontSizeFactor * 20),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextFormField(
                  controller:
                      employeeAssignedProjectData.assignHoursEditingController,
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: AppConsts.commonFontSizeFactor * 18),
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      hintText: 'assign_hours'.tr,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(
                              color: Colors.black.withValues(alpha: 0.2),
                              fontSize: AppConsts.commonFontSizeFactor * 18),
                      fillColor: AppColors.colorFFD674.withValues(alpha: 0.34),
                      filled: true,
                      border: inputBorder,
                      errorMaxLines: 1,
                      errorBorder: inputBorder,
                      enabledBorder: inputBorder,
                      disabledBorder: inputBorder,
                      focusedBorder: inputBorder,
                      focusedErrorBorder: inputBorder,
                      errorStyle:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.red,
                                fontSize: AppConsts.commonFontSizeFactor * 12,
                              ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      isDense: true),
                  validator: Validations.checkAssignHoursValidations,
                  textInputAction: TextInputAction.done,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Transform.scale(
                scale: 0.8,
                child: Obx(() => Switch(
                      padding: EdgeInsets.zero,
                      trackOutlineColor:
                          WidgetStateProperty.all(Colors.transparent),
                      trackOutlineWidth: WidgetStateProperty.all(0),
                      value: employeeAssignedProjectData.isPaused.value,
                      onChanged: (value) {
                        playPauseProject(value, index);
                      },
                      activeColor: Colors.white,
                      activeTrackColor: AppColors.colorFFD674,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: AppColors.colorFFD674,
                    )),
              )
            ],
          )
        ],
      ),
    );
  }
}
