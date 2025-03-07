import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../config/app_colors.dart';
import '../../model/global_search/project_model.dart';
import '../widgets/common/common_search_field.dart';

class AssignProjectDialog {
  AssignProjectDialog._();

  static show({
    required BuildContext context,
    required TextEditingController searchController,
    required void Function(String) handleSearchTextChange,
    required RxBool showSearchFieldTrailing,
    required void Function() onTapSearchFieldTrailing,
    required RxList<ProjectModel?> projects,
    required RxBool areProjectsLoading,
    required void Function(int?) addRemoveProject,
  }) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              child: AssignProjectDialogContent(
                searchController: searchController,
                handleSearchTextChange: handleSearchTextChange,
                showSearchFieldTrailing: showSearchFieldTrailing,
                onTapSearchFieldTrailing: onTapSearchFieldTrailing,
                projects: projects,
                areProjectsLoading: areProjectsLoading,
                addRemoveProject: addRemoveProject,
              ),
            ));
  }
}

class AssignProjectDialogContent extends StatelessWidget {
  final TextEditingController searchController;
  final void Function(String) handleSearchTextChange;
  final RxBool showSearchFieldTrailing;
  final void Function() onTapSearchFieldTrailing;
  final RxList<ProjectModel?> projects;
  final RxBool areProjectsLoading;
  final void Function(int?) addRemoveProject;

  const AssignProjectDialogContent(
      {super.key,
      required this.searchController,
      required this.handleSearchTextChange,
      required this.showSearchFieldTrailing,
      required this.onTapSearchFieldTrailing,
      required this.projects,
      required this.areProjectsLoading,
      required this.addRemoveProject});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonSearchField(
              isShowLeading: true,
              controller: searchController,
              onChanged: handleSearchTextChange,
              hint: "search_projects",
              isShowTrailing: showSearchFieldTrailing,
              onTapTrailing: onTapSearchFieldTrailing,
            ),
            const SizedBox(
              height: 8,
            ),
            Flexible(
                child: Obx(() => ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return areProjectsLoading.value
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Shimmer.fromColors(
                                      baseColor: AppColors.shimmerBaseColor,
                                      highlightColor:
                                          AppColors.shimmerHighlightColor,
                                      child: Container(
                                        height: 24.0,
                                        width: double.infinity,
                                        margin:
                                            const EdgeInsets.only(right: 32),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3.0),
                                          color: AppColors.shimmerBaseColor,
                                        ),
                                      )),
                                  Shimmer.fromColors(
                                      baseColor: AppColors.shimmerBaseColor,
                                      highlightColor:
                                          AppColors.shimmerHighlightColor,
                                      child: Container(
                                        height: 24.0,
                                        width: double.infinity,
                                        margin: const EdgeInsets.only(
                                            right: 32, top: 2),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3.0),
                                          color: AppColors.shimmerBaseColor,
                                        ),
                                      )),
                                ])
                          : GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                if (projects[index] != null) {
                                  addRemoveProject(projects[index]!.id);
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      projects[index] == null
                                          ? ""
                                          : projects[index]!.name ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  projects[index] != null &&
                                          projects[index]!.multiUse.value
                                      ? Icon(
                                          Icons.check,
                                          size: 20,
                                          color: AppColors.color54B435,
                                        )
                                      : const SizedBox(
                                          width: 20,
                                        )
                                ],
                              ),
                            );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: Colors.black.withValues(alpha: 0.09),
                        thickness: 1,
                        height: 32,
                      );
                    },
                    itemCount:
                        areProjectsLoading.value ? 10 : projects.length)))
          ],
        ),
      ),
    );
  }
}
