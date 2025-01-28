import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teqtop_team/controllers/task_create_edit/task_create_edit_controller.dart';
import 'package:teqtop_team/model/employees_listing/employee_model.dart';
import 'package:teqtop_team/model/global_search/project_model.dart';
import 'package:teqtop_team/model/task_create_edit/task_priority.dart';
import 'package:teqtop_team/views/widgets/common/common_button_shimmer.dart';
import 'package:teqtop_team/views/widgets/common/common_input_field_shimmer.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../consts/app_consts.dart';
import '../../../consts/app_icons.dart';
import '../../../utils/validations.dart';
import '../../widgets/common/common_button.dart';
import '../../widgets/common/common_dropdown_button.dart';
import '../../widgets/common/common_input_field.dart';

class TaskCreateEditPage extends StatelessWidget {
  final taskCreateEditController = Get.put(TaskCreateEditController());

  TaskCreateEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white));

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                color: Colors.black.withValues(alpha: 0.05),
                height: 1,
              )),
          title: Obx(
            () => Text(
              taskCreateEditController.fromTaskDetail.value
                  ? 'edit_task'.tr
                  : 'add_new_task'.tr,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ),
          leading: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: SvgPicture.asset(
                  AppIcons.icBack,
                  colorFilter:
                      const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                ),
              )),
          leadingWidth: 40,
          backgroundColor: Colors.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: taskCreateEditController.formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => taskCreateEditController.areProjectsLoading.value ||
                            taskCreateEditController.areEmployeesLoading.value
                        ? CommonInputFieldShimmer(
                            labelShimmerBorderRadius: 0,
                          )
                        : CommonInputField(
                            fillColor: AppColors.colorF9F9F9,
                            borderColor: Colors.transparent,
                            controller: taskCreateEditController.nameController,
                            hint: 'enter_task_name',
                            label: 'name',
                            onChanged: (value) {},
                            validator: Validations.checkTaskNameValidations,
                            inputType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => taskCreateEditController.areProjectsLoading.value ||
                            taskCreateEditController.areEmployeesLoading.value
                        ? Shimmer.fromColors(
                            baseColor: AppColors.shimmerBaseColor,
                            highlightColor: AppColors.shimmerHighlightColor,
                            child: Container(
                              height: 20,
                              width: 60,
                              decoration: BoxDecoration(
                                color: AppColors.shimmerBaseColor,
                              ),
                            ))
                        : Text(
                            'project'.tr.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize:
                                        AppConsts.commonFontSizeFactor * 14),
                          ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Obx(
                    () => taskCreateEditController.areProjectsLoading.value ||
                            taskCreateEditController.areEmployeesLoading.value
                        ? Shimmer.fromColors(
                            baseColor: AppColors.shimmerBaseColor,
                            highlightColor: AppColors.shimmerHighlightColor,
                            child: Container(
                              height: 55.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.shimmerBaseColor,
                              ),
                            ))
                        : CommonDropdownWidget(
                            trailingIcon: AppIcons.icDropdown2,
                            trailingIconColor: AppColors.color040404,
                            backgroundColor: AppColors.colorF9F9F9,
                            maxDropdownHeight: 200,
                            height: 55,
                            onChanged: taskCreateEditController.onChangeProject,
                            items: taskCreateEditController.projects
                                .map(
                                    (project) => DropdownMenuItem<ProjectModel>(
                                          value: project,
                                          child: Text(
                                            project != null
                                                ? project.name ?? ""
                                                : "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontSize: AppConsts
                                                            .commonFontSizeFactor *
                                                        14),
                                          ),
                                        ))
                                .toList(),
                            value: taskCreateEditController.selectedProject,
                            selectedItemBuilder: (BuildContext context) {
                              return taskCreateEditController.projects
                                  .map<Widget>((project) {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    project != null && project.name != null
                                        ? taskCreateEditController
                                            .truncateDropdownSelectedValue(
                                                project.name!)
                                        : "",
                                    style: project != null &&
                                            project.name == "select_project".tr
                                        ? Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                color: AppColors.colorA9A9A9)
                                        : Theme.of(context).textTheme.bodyLarge,
                                  ),
                                );
                              }).toList();
                            },
                          ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: taskCreateEditController
                          .showSelectProjectMessage.value,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 4, left: 14, right: 14),
                        child: Text(
                          "message_select_project".tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Colors.red,
                                  fontSize:
                                      AppConsts.commonFontSizeFactor * 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => taskCreateEditController.areProjectsLoading.value ||
                            taskCreateEditController.areEmployeesLoading.value
                        ? Shimmer.fromColors(
                            baseColor: AppColors.shimmerBaseColor,
                            highlightColor: AppColors.shimmerHighlightColor,
                            child: Container(
                              height: 20,
                              width: 60,
                              decoration: BoxDecoration(
                                color: AppColors.shimmerBaseColor,
                              ),
                            ))
                        : Text(
                            'person'.tr.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize:
                                        AppConsts.commonFontSizeFactor * 14),
                          ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Obx(
                    () => taskCreateEditController.areProjectsLoading.value ||
                            taskCreateEditController.areEmployeesLoading.value
                        ? Shimmer.fromColors(
                            baseColor: AppColors.shimmerBaseColor,
                            highlightColor: AppColors.shimmerHighlightColor,
                            child: Container(
                              height: 55.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.shimmerBaseColor,
                              ),
                            ))
                        : CommonDropdownWidget(
                            trailingIcon: AppIcons.icDropdown2,
                            trailingIconColor: AppColors.color040404,
                            backgroundColor: AppColors.colorF9F9F9,
                            maxDropdownHeight: 200,
                            height: 55,
                            onChanged: taskCreateEditController
                                .onChangeResponsiblePerson,
                            items: taskCreateEditController.persons
                                .map((person) =>
                                    DropdownMenuItem<EmployeeModel>(
                                      value: person,
                                      child: Text(
                                        person != null ? person.name ?? "" : "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                fontSize: AppConsts
                                                        .commonFontSizeFactor *
                                                    14),
                                      ),
                                    ))
                                .toList(),
                            value: taskCreateEditController
                                .selectedResponsiblePerson,
                            selectedItemBuilder: (BuildContext context) {
                              return taskCreateEditController.persons
                                  .map<Widget>((person) {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    person != null && person.name != null
                                        ? taskCreateEditController
                                            .truncateDropdownSelectedValue(
                                                person.name!)
                                        : "",
                                    style: person != null &&
                                            person.name == "select_person".tr
                                        ? Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                color: AppColors.colorA9A9A9)
                                        : Theme.of(context).textTheme.bodyLarge,
                                  ),
                                );
                              }).toList();
                            },
                          ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: taskCreateEditController
                          .showSelectResponsiblePersonMessage.value,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 4, left: 14, right: 14),
                        child: Text(
                          "message_select_person".tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Colors.red,
                                  fontSize:
                                      AppConsts.commonFontSizeFactor * 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => taskCreateEditController.areProjectsLoading.value ||
                            taskCreateEditController.areEmployeesLoading.value
                        ? Shimmer.fromColors(
                            baseColor: AppColors.shimmerBaseColor,
                            highlightColor: AppColors.shimmerHighlightColor,
                            child: Container(
                              height: 20,
                              width: 60,
                              decoration: BoxDecoration(
                                color: AppColors.shimmerBaseColor,
                              ),
                            ))
                        : Text(
                            'priority'.tr.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize:
                                        AppConsts.commonFontSizeFactor * 14),
                          ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Obx(
                    () => taskCreateEditController.areProjectsLoading.value ||
                            taskCreateEditController.areEmployeesLoading.value
                        ? Shimmer.fromColors(
                            baseColor: AppColors.shimmerBaseColor,
                            highlightColor: AppColors.shimmerHighlightColor,
                            child: Container(
                              height: 55.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.shimmerBaseColor,
                              ),
                            ))
                        : CommonDropdownWidget(
                            trailingIcon: AppIcons.icDropdown2,
                            trailingIconColor: AppColors.color040404,
                            backgroundColor: AppColors.colorF9F9F9,
                            maxDropdownHeight: 200,
                            height: 55,
                            onChanged:
                                taskCreateEditController.onChangeTaskPriority,
                            items: taskCreateEditController.taskPriorities
                                .map((priority) =>
                                    DropdownMenuItem<TaskPriority>(
                                      value: priority,
                                      child: Text(
                                        priority.priorityText,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                fontSize: AppConsts
                                                        .commonFontSizeFactor *
                                                    14),
                                      ),
                                    ))
                                .toList(),
                            value: taskCreateEditController.selectedPriority,
                            selectedItemBuilder: (BuildContext context) {
                              return taskCreateEditController.taskPriorities
                                  .map<Widget>((priority) {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    priority.priorityText,
                                    style: priority.priorityText ==
                                            "select_priority".tr
                                        ? Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                color: AppColors.colorA9A9A9)
                                        : Theme.of(context).textTheme.bodyLarge,
                                  ),
                                );
                              }).toList();
                            },
                          ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: taskCreateEditController
                          .showSelectPriorityMessage.value,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 4, left: 14, right: 14),
                        child: Text(
                          "message_select_priority".tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Colors.red,
                                fontSize: AppConsts.commonFontSizeFactor * 12,
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => taskCreateEditController.areProjectsLoading.value ||
                            taskCreateEditController.areEmployeesLoading.value
                        ? Shimmer.fromColors(
                            baseColor: AppColors.shimmerBaseColor,
                            highlightColor: AppColors.shimmerHighlightColor,
                            child: Container(
                              height: 20,
                              width: 60,
                              decoration: BoxDecoration(
                                color: AppColors.shimmerBaseColor,
                              ),
                            ))
                        : Text(
                            'participants'.tr.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize:
                                        AppConsts.commonFontSizeFactor * 14),
                          ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Obx(
                    () => taskCreateEditController.areProjectsLoading.value ||
                            taskCreateEditController.areEmployeesLoading.value
                        ? Shimmer.fromColors(
                            baseColor: AppColors.shimmerBaseColor,
                            highlightColor: AppColors.shimmerHighlightColor,
                            child: Container(
                              height: 55.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.shimmerBaseColor,
                              ),
                            ))
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonDropdownWidget(
                                trailingIcon: AppIcons.icDropdown2,
                                trailingIconColor: AppColors.color040404,
                                backgroundColor: AppColors.colorF9F9F9,
                                maxDropdownHeight: 200,
                                height: 55,
                                items: taskCreateEditController.participants
                                    .map((participant) =>
                                        DropdownMenuItem<EmployeeModel>(
                                          value: participant,
                                          child: Text(
                                            participant != null
                                                ? participant.name ?? ""
                                                : "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontSize: AppConsts
                                                            .commonFontSizeFactor *
                                                        14),
                                          ),
                                        ))
                                    .toList(),
                                value: taskCreateEditController
                                    .selectedDropdownParticipant,
                                onChanged: taskCreateEditController
                                    .onParticipantSelect,
                                selectedItemBuilder: (BuildContext context) {
                                  return taskCreateEditController.participants
                                      .map<Widget>((participant) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          participant != null
                                              ? participant.name ?? ""
                                              : "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  color:
                                                      AppColors.colorA9A9A9)),
                                    );
                                  }).toList();
                                },
                              ),
                              Visibility(
                                visible: taskCreateEditController
                                    .showSelectParticipantsMessage.value,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4, left: 14, right: 14),
                                  child: Text(
                                    "message_select_participants".tr,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.red,
                                          fontSize:
                                              AppConsts.commonFontSizeFactor *
                                                  12,
                                        ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: taskCreateEditController
                                    .selectedParticipants.isNotEmpty,
                                child: const SizedBox(
                                  height: 12,
                                ),
                              ),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: taskCreateEditController
                                    .selectedParticipants
                                    .map<Widget>((participant) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.kPrimaryColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: EdgeInsets.only(left: 8, right: 4),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: Text(
                                              participant != null &&
                                                      participant.name != null
                                                  ? taskCreateEditController
                                                      .truncateSelectedEmployeeName(
                                                          participant.name!)
                                                  : "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                      color: Colors.white)),
                                        ),
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            if (participant != null) {
                                              taskCreateEditController
                                                  .removeSelectedParticipant(
                                                      participant);
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(4),
                                            child: Icon(
                                              Icons.close_rounded,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => taskCreateEditController.areProjectsLoading.value ||
                            taskCreateEditController.areEmployeesLoading.value
                        ? Shimmer.fromColors(
                            baseColor: AppColors.shimmerBaseColor,
                            highlightColor: AppColors.shimmerHighlightColor,
                            child: Container(
                              height: 20,
                              width: 60,
                              decoration: BoxDecoration(
                                color: AppColors.shimmerBaseColor,
                              ),
                            ))
                        : Text(
                            'observers'.tr.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize:
                                        AppConsts.commonFontSizeFactor * 14),
                          ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Obx(
                    () => taskCreateEditController.areProjectsLoading.value ||
                            taskCreateEditController.areEmployeesLoading.value
                        ? Shimmer.fromColors(
                            baseColor: AppColors.shimmerBaseColor,
                            highlightColor: AppColors.shimmerHighlightColor,
                            child: Container(
                              height: 55.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.shimmerBaseColor,
                              ),
                            ))
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonDropdownWidget(
                                trailingIcon: AppIcons.icDropdown2,
                                trailingIconColor: AppColors.color040404,
                                backgroundColor: AppColors.colorF9F9F9,
                                maxDropdownHeight: 200,
                                height: 55,
                                items: taskCreateEditController.observers
                                    .map((observer) =>
                                        DropdownMenuItem<EmployeeModel>(
                                          value: observer,
                                          child: Text(
                                            observer != null
                                                ? observer.name ?? ""
                                                : "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontSize: AppConsts
                                                            .commonFontSizeFactor *
                                                        14),
                                          ),
                                        ))
                                    .toList(),
                                value: taskCreateEditController
                                    .selectedDropdownObserver,
                                onChanged:
                                    taskCreateEditController.onObserverSelect,
                                selectedItemBuilder: (BuildContext context) {
                                  return taskCreateEditController.observers
                                      .map<Widget>((observer) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          observer != null
                                              ? observer.name ?? ""
                                              : "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  color:
                                                      AppColors.colorA9A9A9)),
                                    );
                                  }).toList();
                                },
                              ),
                              Visibility(
                                visible: taskCreateEditController
                                    .showSelectObserversMessage.value,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4, left: 14, right: 14),
                                  child: Text(
                                    "message_select_observers".tr,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.red,
                                          fontSize:
                                              AppConsts.commonFontSizeFactor *
                                                  12,
                                        ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: taskCreateEditController
                                    .selectedObservers.isNotEmpty,
                                child: const SizedBox(
                                  height: 12,
                                ),
                              ),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: taskCreateEditController
                                    .selectedObservers
                                    .map<Widget>((observer) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.kPrimaryColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: EdgeInsets.only(left: 8, right: 4),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: Text(
                                              observer != null &&
                                                      observer.name != null
                                                  ? taskCreateEditController
                                                      .truncateSelectedEmployeeName(
                                                          observer.name!)
                                                  : "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                      color: Colors.white)),
                                        ),
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            if (observer != null) {
                                              taskCreateEditController
                                                  .removeSelectedObserver(
                                                      observer);
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(4),
                                            child: Icon(
                                              Icons.close_rounded,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Obx(
                          () => taskCreateEditController
                                      .areProjectsLoading.value ||
                                  taskCreateEditController
                                      .areEmployeesLoading.value
                              ? CommonInputFieldShimmer(
                                  labelShimmerBorderRadius: 0,
                                )
                              : CommonInputField(
                                  controller: taskCreateEditController
                                      .startDateController,
                                  hint: "mm_dd_yy",
                                  label: "start_date",
                                  borderWidth: 0,
                                  inputType: TextInputType.datetime,
                                  validator:
                                      Validations.checkStartDateValidations,
                                  textInputAction: TextInputAction.done,
                                  fillColor: AppColors.colorF9F9F9,
                                  borderColor: Colors.transparent,
                                  isEnable: false,
                                  trailing: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                      AppIcons.icCalendar,
                                    ),
                                  ),
                                  onTap: taskCreateEditController
                                      .handleStartDateFieldOnTap,
                                  onTapFirstArg: context,
                                  errorMaxLines: 2,
                                ),
                        ),
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      Expanded(
                        child: Obx(
                          () => taskCreateEditController
                                      .areProjectsLoading.value ||
                                  taskCreateEditController
                                      .areEmployeesLoading.value
                              ? CommonInputFieldShimmer(
                                  labelShimmerBorderRadius: 0,
                                )
                              : CommonInputField(
                                  controller: taskCreateEditController
                                      .endDateController,
                                  hint: "mm_dd_yy",
                                  label: "end_date",
                                  borderWidth: 0,
                                  inputType: TextInputType.datetime,
                                  validator:
                                      Validations.checkEndDateValidations,
                                  textInputAction: TextInputAction.done,
                                  fillColor: AppColors.colorF9F9F9,
                                  borderColor: Colors.transparent,
                                  isEnable: false,
                                  trailing: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                      AppIcons.icCalendar,
                                    ),
                                  ),
                                  onTap: taskCreateEditController
                                      .handleEndDateFieldOnTap,
                                  onTapFirstArg: context,
                                  errorMaxLines: 2,
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => taskCreateEditController.areProjectsLoading.value ||
                            taskCreateEditController.areEmployeesLoading.value
                        ? CommonInputFieldShimmer(
                            labelShimmerBorderRadius: 0,
                            textFieldShimmerHeight: 124,
                          )
                        : CommonInputField(
                            fillColor: AppColors.colorF9F9F9,
                            borderColor: Colors.transparent,
                            controller:
                                taskCreateEditController.descriptionController,
                            maxLines: 4,
                            hint: 'enter_task_description',
                            label: 'description',
                            onChanged: (value) {},
                            validator:
                                Validations.checkTaskDescriptionValidations,
                            inputType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                          ),
                  ),
                  const SizedBox(
                    height: 44,
                  ),
                  Obx(
                    () => taskCreateEditController.areProjectsLoading.value ||
                            taskCreateEditController
                                .areEmployeesLoading.value ||
                            taskCreateEditController.isLoading.value
                        ? CommonButtonShimmer(
                            borderRadius: 0,
                          )
                        : CommonButton(
                            text: taskCreateEditController.fromTaskDetail.value
                                ? 'save'
                                : 'create_task',
                            onClick: () {
                              if (taskCreateEditController
                                  .fromTaskDetail.value) {
                                taskCreateEditController.editProject();
                              } else {
                                taskCreateEditController.createTask();
                              }
                            }),
                  ),
                  const SizedBox(
                    height: 44,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
