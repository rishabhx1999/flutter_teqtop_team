import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/model/employee_assigned_projects_hours/person_projects_assign_hours.dart';

class EmployeeAssignedProjectWidget extends StatelessWidget {
  final PersonProjectsAssignHours employeeAssignedProjectData;
  final void Function(bool, int?) playPauseProject;

  const EmployeeAssignedProjectWidget(
      {super.key,
      required this.employeeAssignedProjectData,
      required this.playPauseProject});

  @override
  Widget build(BuildContext context) {
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
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employeeAssignedProjectData.assignedHours == null
                          ? ""
                          : employeeAssignedProjectData.assignedHours!
                              .toStringAsFixed(2),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: AppConsts.commonFontSizeFactor * 18),
                    ),
                    Text(
                      "assigned_hours".tr,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: AppConsts.commonFontSizeFactor * 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employeeAssignedProjectData.totalHours == null
                          ? ""
                          : employeeAssignedProjectData.totalHours!
                              .toStringAsFixed(2),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: AppConsts.commonFontSizeFactor * 18),
                    ),
                    Text(
                      "total_hours".tr,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: AppConsts.commonFontSizeFactor * 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employeeAssignedProjectData.weeklyHours == null
                          ? ""
                          : employeeAssignedProjectData.weeklyHours!
                              .toStringAsFixed(2),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: AppConsts.commonFontSizeFactor * 18),
                    ),
                    Text(
                      "weekly_hours".tr,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: AppConsts.commonFontSizeFactor * 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            decoration: BoxDecoration(
                color: AppColors.colorFFD674.withValues(alpha: 0.34),
                borderRadius: BorderRadius.circular(4)),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'message_pause_project'.tr,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: AppConsts.commonFontSizeFactor * 14),
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
                          playPauseProject(
                              value, employeeAssignedProjectData.id);
                        },
                        activeColor: Colors.white,
                        activeTrackColor: AppColors.colorFFD674,
                        inactiveThumbColor: AppColors.colorFFD674,
                        inactiveTrackColor: Colors.white,
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
