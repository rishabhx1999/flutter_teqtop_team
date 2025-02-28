import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teqtop_team/views/dialogs/assign_project_dialog.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../consts/app_consts.dart';
import '../../../consts/app_icons.dart';
import '../../../consts/app_images.dart';
import '../../../controllers/create_edit_employee_assigned_projects_hours/create_edit_employee_assigned_projects_hours_controller.dart';
import '../../../model/employees_listing/employee_model.dart';
import '../../widgets/common/common_button.dart';
import '../../widgets/common/common_dropdown_button.dart';
import 'components/edit_employee_assigned_project_widget.dart';

class CreateEditEmployeeAssignedProjectsHoursPage extends StatelessWidget {
  final createEditEmployeeAssignedProjectsHoursController =
      Get.put(CreateEditEmployeeAssignedProjectsHoursController());

  CreateEditEmployeeAssignedProjectsHoursPage({super.key});

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
            centerTitle: true,
            title: Text(
              createEditEmployeeAssignedProjectsHoursController
                      .fromAssignHoursListing
                  ? 'create'.tr
                  : 'edit_hours'.tr,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
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
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Get.toNamed(AppRoutes.routeGlobalSearch);
                    },
                    child: SvgPicture.asset(
                      AppIcons.icSearch,
                      width: 24,
                      colorFilter:
                          const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    )),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Get.toNamed(AppRoutes.routeNotifications);
                },
                child: Obx(
                  () => Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4, right: 18),
                        child: Image.asset(
                          AppIcons.icBell,
                          width: 24,
                        ),
                      ),
                      Positioned(
                          left: 12,
                          top: 0,
                          child: Container(
                            height: 12,
                            width: createEditEmployeeAssignedProjectsHoursController
                                        .notificationsCount.value
                                        .toString()
                                        .length >
                                    1
                                ? (12 +
                                        ((createEditEmployeeAssignedProjectsHoursController
                                                    .notificationsCount.value
                                                    .toString()
                                                    .length -
                                                1) *
                                            4))
                                    .toDouble()
                                : 12,
                            decoration: BoxDecoration(
                                color: AppColors.colorFFB400,
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: Text(
                                createEditEmployeeAssignedProjectsHoursController
                                    .notificationsCount.value
                                    .toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        fontSize:
                                            AppConsts.commonFontSizeFactor * 8),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                      key: createEditEmployeeAssignedProjectsHoursController
                          .formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          createEditEmployeeAssignedProjectsHoursController
                                  .fromAssignHoursListing
                              ? Obx(
                                  () =>
                                      createEditEmployeeAssignedProjectsHoursController
                                              .areUsersLoading.value
                                          ? Shimmer.fromColors(
                                              baseColor:
                                                  AppColors.shimmerBaseColor,
                                              highlightColor: AppColors
                                                  .shimmerHighlightColor,
                                              child: Container(
                                                height: 48.0,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: AppColors
                                                      .shimmerBaseColor,
                                                ),
                                              ))
                                          : Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CommonDropdownWidget(
                                                  maxDropdownHeight: 200,
                                                  height: 48,
                                                  onChanged:
                                                      createEditEmployeeAssignedProjectsHoursController
                                                          .onChangeUser,
                                                  items:
                                                      createEditEmployeeAssignedProjectsHoursController
                                                          .users
                                                          .map((user) =>
                                                              DropdownMenuItem<
                                                                  EmployeeModel>(
                                                                value: user,
                                                                child: Text(
                                                                  user != null
                                                                      ? user.name ??
                                                                          ""
                                                                      : "",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium
                                                                      ?.copyWith(
                                                                          fontSize:
                                                                              AppConsts.commonFontSizeFactor * 14),
                                                                ),
                                                              ))
                                                          .toList(),
                                                  value:
                                                      createEditEmployeeAssignedProjectsHoursController
                                                          .selectedUser,
                                                  selectedItemBuilder:
                                                      (BuildContext context) {
                                                    return createEditEmployeeAssignedProjectsHoursController
                                                        .users
                                                        .map<Widget>((user) {
                                                      return Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          user != null &&
                                                                  user.name !=
                                                                      null
                                                              ? user.name!
                                                              : "",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyMedium
                                                              ?.copyWith(
                                                                  color: Colors
                                                                      .black
                                                                      .withValues(
                                                                          alpha:
                                                                              0.5),
                                                                  fontSize:
                                                                      AppConsts
                                                                              .commonFontSizeFactor *
                                                                          14),
                                                        ),
                                                      );
                                                    }).toList();
                                                  },
                                                ),
                                                Visibility(
                                                  visible:
                                                      createEditEmployeeAssignedProjectsHoursController
                                                          .showSelectUserMessage
                                                          .value,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4,
                                                            left: 14,
                                                            right: 14),
                                                    child: Text(
                                                      "message_select_user".tr,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                              color: Colors.red,
                                                              fontSize: AppConsts
                                                                      .commonFontSizeFactor *
                                                                  12),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 34,
                                      backgroundImage: AssetImage(
                                          AppImages.imgPersonPlaceholder),
                                      foregroundImage:
                                          createEditEmployeeAssignedProjectsHoursController
                                                      .employeeProfilePhoto !=
                                                  null
                                              ? NetworkImage(AppConsts
                                                      .imgInitialUrl +
                                                  createEditEmployeeAssignedProjectsHoursController
                                                      .employeeProfilePhoto!)
                                              : AssetImage(AppImages
                                                  .imgPersonPlaceholder),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child: Text(
                                        createEditEmployeeAssignedProjectsHoursController
                                                .employeeName ??
                                            "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                fontSize: AppConsts
                                                        .commonFontSizeFactor *
                                                    18),
                                      ),
                                    )
                                  ],
                                ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              createEditEmployeeAssignedProjectsHoursController
                                  .projectSearchTextController
                                  .clear();
                              createEditEmployeeAssignedProjectsHoursController
                                  .getProjects();
                              AssignProjectDialog.show(
                                  context: context,
                                  searchController:
                                      createEditEmployeeAssignedProjectsHoursController
                                          .projectSearchTextController,
                                  handleSearchTextChange:
                                      createEditEmployeeAssignedProjectsHoursController
                                          .handleProjectSearchTextChange,
                                  showSearchFieldTrailing:
                                      createEditEmployeeAssignedProjectsHoursController
                                          .showProjectSearchFieldTrailing,
                                  onTapSearchFieldTrailing:
                                      createEditEmployeeAssignedProjectsHoursController
                                          .handleClearProjectSearchField,
                                  projects:
                                      createEditEmployeeAssignedProjectsHoursController
                                          .projects,
                                  areProjectsLoading:
                                      createEditEmployeeAssignedProjectsHoursController
                                          .areProjectsLoading,
                                  addRemoveProject:
                                      createEditEmployeeAssignedProjectsHoursController
                                          .addRemoveProject);
                            },
                            child: Container(
                              width: double.infinity,
                              color: AppColors.kPrimaryColor,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 12),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'add_remove_projects'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: Colors.white),
                                  ),
                                  SvgPicture.asset(
                                    AppIcons.icDropdownWhite,
                                    width: 16,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Obx(
                            () => ListView.separated(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return EditEmployeeAssignedProjectWidget(
                                    employeeAssignedProjectData:
                                        createEditEmployeeAssignedProjectsHoursController
                                                .employeeAssignedProjectsHours[
                                            index],
                                    playPauseProject:
                                        createEditEmployeeAssignedProjectsHoursController
                                            .playPauseProject,
                                    index: index,
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 16,
                                  );
                                },
                                itemCount:
                                    createEditEmployeeAssignedProjectsHoursController
                                        .employeeAssignedProjectsHours.length),
                          )
                        ],
                      )),
                ),
              ),
              Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Obx(
                    () => createEditEmployeeAssignedProjectsHoursController
                            .isCreateUpdateLoading.value
                        ? Container(
                            height: 51,
                            width: 51,
                            padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(
                              color: AppColors.kPrimaryColor,
                            ),
                          )
                        : CommonButton(
                            text:
                                createEditEmployeeAssignedProjectsHoursController
                                        .fromAssignHoursListing
                                    ? 'create'
                                    : 'update',
                            onClick: () {
                              if (createEditEmployeeAssignedProjectsHoursController
                                  .fromAssignHoursListing) {
                                createEditEmployeeAssignedProjectsHoursController
                                    .createEmployeeAssignedProjectsHours();
                              } else {
                                createEditEmployeeAssignedProjectsHoursController
                                    .updateData();
                              }
                            }),
                  )),
            ],
          ),
        ));
  }
}
