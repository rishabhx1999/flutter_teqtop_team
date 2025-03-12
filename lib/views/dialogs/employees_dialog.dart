import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teqtop_team/model/employees_listing/employee_model.dart';

import '../../config/app_colors.dart';
import '../../model/global_search/project_model.dart';
import '../widgets/common/common_search_field.dart';

class EmployeesDialog {
  EmployeesDialog._();

  static show(
      {required TextEditingController searchController,
      required void Function(String) handleSearchTextChange,
      required RxBool showSearchFieldTrailing,
      required void Function() onTapSearchFieldTrailing,
      required RxList<EmployeeModel?> employees,
      required RxBool areEmployeesLoading,
      required void Function(int?) employeeOnTap,
      required FocusNode searchFieldFocusNode}) {
    Get.dialog(Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: EmployeesDialogContent(
        searchController: searchController,
        handleSearchTextChange: handleSearchTextChange,
        showSearchFieldTrailing: showSearchFieldTrailing,
        onTapSearchFieldTrailing: onTapSearchFieldTrailing,
        employees: employees,
        areEmployeesLoading: areEmployeesLoading,
        employeeOnTap: employeeOnTap,
        searchFieldFocusNode: searchFieldFocusNode,
      ),
    ));
  }
}

class EmployeesDialogContent extends StatelessWidget {
  final TextEditingController searchController;
  final void Function(String) handleSearchTextChange;
  final RxBool showSearchFieldTrailing;
  final void Function() onTapSearchFieldTrailing;
  final RxList<EmployeeModel?> employees;
  final RxBool areEmployeesLoading;
  final void Function(int?) employeeOnTap;
  final FocusNode searchFieldFocusNode;

  const EmployeesDialogContent(
      {super.key,
      required this.searchController,
      required this.handleSearchTextChange,
      required this.showSearchFieldTrailing,
      required this.onTapSearchFieldTrailing,
      required this.employees,
      required this.areEmployeesLoading,
      required this.employeeOnTap,
      required this.searchFieldFocusNode});

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
              focusNode: searchFieldFocusNode,
              isShowLeading: true,
              controller: searchController,
              onChanged: handleSearchTextChange,
              hint: "search_employees",
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
                      return areEmployeesLoading.value
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
                                if (employees[index] != null) {
                                  employeeOnTap(employees[index]!.id);
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      employees[index] == null
                                          ? ""
                                          : employees[index]!.name ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: Obx(() => employees[index] != null &&
                                            employees[index]!.multiUse.value
                                        ? SizedBox(
                                            height: 12,
                                            width: 12,
                                            child: CircularProgressIndicator(
                                              color: AppColors.kPrimaryColor,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const SizedBox(
                                            width: 12,
                                          )),
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
                        areEmployeesLoading.value ? 10 : employees.length)))
          ],
        ),
      ),
    );
  }
}
