import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/model/search/drive.dart';
import 'package:teqtop_team/model/search/member.dart';
import 'package:teqtop_team/model/search/project.dart';
import 'package:teqtop_team/model/search/task.dart';
import 'package:teqtop_team/views/pages/drive/components/drive_header_widget.dart';
import 'package:teqtop_team/views/pages/tasks_listing/components/task_widget.dart';
import 'package:teqtop_team/views/widgets/common/common_search_field.dart';

import '../../../config/app_colors.dart';
import '../../../consts/app_icons.dart';
import '../../../controllers/global_search/global_search_controller.dart';
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
                            visible: globalSearchController.tasks.isNotEmpty,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 24,
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: AppColors.kPrimaryColor),
                                  child: Text(
                                    "tasks".tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return TaskWidget(
                                        taskData: globalSearchController
                                                .tasks[index] ??
                                            Task(),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        height: 16,
                                      );
                                    },
                                    itemCount:
                                        globalSearchController.tasks.length)
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
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: AppColors.kPrimaryColor),
                                  child: Text(
                                    "projects".tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return ProjectWidget(
                                        projectData: globalSearchController
                                                .projects[index] ??
                                            Project(),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        height: 16,
                                      );
                                    },
                                    itemCount:
                                        globalSearchController.projects.length)
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
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: AppColors.kPrimaryColor),
                                  child: Text(
                                    "drives".tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return DriveHeaderWidget(
                                        textAlignment: TextAlign.start,
                                        driveData: globalSearchController
                                                .drives[index] ??
                                            Drive(),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        height: 16,
                                      );
                                    },
                                    itemCount:
                                        globalSearchController.drives.length)
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
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: AppColors.kPrimaryColor),
                                  child: Text(
                                    "employees".tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return EmployeeWidget(
                                        employeeData: globalSearchController
                                                .employees[index] ??
                                            Member(),
                                        onTap: globalSearchController
                                            .handleEmployeeOnTap,
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        height: 16,
                                      );
                                    },
                                    itemCount:
                                        globalSearchController.employees.length)
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
