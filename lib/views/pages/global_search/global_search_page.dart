import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/model/employees_listing/employee_model.dart';
import 'package:teqtop_team/views/pages/global_search/components/group_widget.dart';
import 'package:teqtop_team/views/pages/tasks_listing/components/task_widget.dart';
import 'package:teqtop_team/views/widgets/common/common_search_field.dart';

import '../../../config/app_colors.dart';
import '../../../consts/app_icons.dart';
import '../../../controllers/global_search/global_search_controller.dart';
import '../../../model/global_search/drive_model.dart';
import '../../../model/global_search/project_model.dart';
import '../../../model/global_search/task_model.dart';
import '../drive_detail/components/drive_header_widget.dart';
import '../employees_listing/components/employee_widget.dart';
import '../projects_listing/components/project_widget.dart';

class GlobalSearchPage extends StatelessWidget {
  final globalSearchController = Get.put(GlobalSearchController());

  GlobalSearchPage({super.key});

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
          title: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CommonSearchField(
              isShowLeading: false,
              controller: globalSearchController.searchTextController,
              onChanged: globalSearchController.handleSearchTextChange,
              hint: "search",
              isShowTrailing: globalSearchController.showSearchFieldTrailing,
              onTapTrailing: globalSearchController.handleClearSearchField,
            ),
          ),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: Obx(
          () => globalSearchController.isLoading.value
              ? Center(
                  child: Container(
                    height: 51,
                    width: 51,
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(
                      color: AppColors.kPrimaryColor,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                            visible: globalSearchController.projects.isNotEmpty,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 24,
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    globalSearchController
                                            .areGroupsShowing.value =
                                        !globalSearchController
                                            .areGroupsShowing.value;
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: AppColors.kPrimaryColor),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${"groups".tr} (${globalSearchController.projects.length})",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontSize: AppConsts
                                                          .commonFontSizeFactor *
                                                      18),
                                        ),
                                        Icon(
                                          globalSearchController
                                                  .areGroupsShowing.value
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                          color: Colors.white,
                                          size: 24,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: globalSearchController
                                      .areGroupsShowing.value,
                                  child: ListView.separated(
                                      padding: const EdgeInsets.only(top: 20),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return GroupWidget(
                                          groupData: globalSearchController
                                                  .projects[index] ??
                                              ProjectModel(),
                                          onTap: globalSearchController
                                              .handleGroupOnTap,
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(
                                          height: 16,
                                        );
                                      },
                                      itemCount: globalSearchController
                                          .projects.length),
                                )
                              ],
                            )),
                        Visibility(
                            visible: globalSearchController.tasks.isNotEmpty,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 24,
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    globalSearchController
                                            .areTasksShowing.value =
                                        !globalSearchController
                                            .areTasksShowing.value;
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: AppColors.kPrimaryColor),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${"tasks".tr} (${globalSearchController.tasks.length})",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontSize: AppConsts
                                                          .commonFontSizeFactor *
                                                      18),
                                        ),
                                        Icon(
                                          globalSearchController
                                                  .areTasksShowing.value
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                          color: Colors.white,
                                          size: 24,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: globalSearchController
                                      .areTasksShowing.value,
                                  child: ListView.separated(
                                      padding: const EdgeInsets.only(top: 20),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return TaskWidget(
                                          taskData: globalSearchController
                                                  .tasks[index] ??
                                              TaskModel(),
                                          onTap: globalSearchController
                                              .handleTaskOnTap,
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(
                                          height: 16,
                                        );
                                      },
                                      itemCount:
                                          globalSearchController.tasks.length),
                                )
                              ],
                            )),
                        Visibility(
                            visible: globalSearchController.projects.isNotEmpty,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 24,
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    globalSearchController
                                            .areProjectsShowing.value =
                                        !globalSearchController
                                            .areProjectsShowing.value;
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: AppColors.kPrimaryColor),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${"projects".tr} (${globalSearchController.projects.length})",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontSize: AppConsts
                                                          .commonFontSizeFactor *
                                                      18),
                                        ),
                                        Icon(
                                          globalSearchController
                                                  .areProjectsShowing.value
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                          color: Colors.white,
                                          size: 24,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: globalSearchController
                                      .areProjectsShowing.value,
                                  child: ListView.separated(
                                      padding: EdgeInsets.only(top: 20),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return ProjectWidget(
                                          projectData: globalSearchController
                                                  .projects[index] ??
                                              ProjectModel(),
                                          onTap: globalSearchController
                                              .handleProjectOnTap,
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(
                                          height: 16,
                                        );
                                      },
                                      itemCount: globalSearchController
                                          .projects.length),
                                )
                              ],
                            )),
                        Visibility(
                            visible: globalSearchController.drives.isNotEmpty,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 24,
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    globalSearchController
                                            .areDrivesShowing.value =
                                        !globalSearchController
                                            .areDrivesShowing.value;
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: AppColors.kPrimaryColor),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${"drives".tr} (${globalSearchController.drives.length})",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontSize: AppConsts
                                                          .commonFontSizeFactor *
                                                      18),
                                        ),
                                        Icon(
                                          globalSearchController
                                                  .areDrivesShowing.value
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                          color: Colors.white,
                                          size: 24,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: globalSearchController
                                      .areDrivesShowing.value,
                                  child: ListView.separated(
                                      padding: const EdgeInsets.only(top: 20),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return DriveHeaderWidget(
                                          onTap: globalSearchController
                                              .handleDriveOnTap,
                                          textAlignment: TextAlign.start,
                                          driveData: globalSearchController
                                                  .drives[index] ??
                                              DriveModel(),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(
                                          height: 16,
                                        );
                                      },
                                      itemCount:
                                          globalSearchController.drives.length),
                                )
                              ],
                            )),
                        Visibility(
                            visible:
                                globalSearchController.employees.isNotEmpty,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 24,
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    globalSearchController
                                            .areEmployeesShowing.value =
                                        !globalSearchController
                                            .areEmployeesShowing.value;
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: AppColors.kPrimaryColor),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${"employees".tr} (${globalSearchController.employees.length})",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontSize: AppConsts
                                                          .commonFontSizeFactor *
                                                      18),
                                        ),
                                        Icon(
                                          globalSearchController
                                                  .areEmployeesShowing.value
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                          color: Colors.white,
                                          size: 24,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: globalSearchController
                                      .areEmployeesShowing.value,
                                  child: ListView.separated(
                                      padding: EdgeInsets.only(top: 20),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return EmployeeWidget(
                                          employeeData: globalSearchController
                                                  .employees[index] ??
                                              EmployeeModel(),
                                          onTap: globalSearchController
                                              .handleEmployeeOnTap,
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(
                                          height: 16,
                                        );
                                      },
                                      itemCount: globalSearchController
                                          .employees.length),
                                )
                              ],
                            )),
                        const SizedBox(
                          height: 24,
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
