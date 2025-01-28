import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/config/app_routes.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/consts/app_icons.dart';
import 'package:teqtop_team/controllers/tasks_listing/tasks_listing_controller.dart';
import 'package:teqtop_team/model/global_search/task_model.dart';
import 'package:teqtop_team/views/pages/dashboard/components/menu_drawer_widget.dart';
import 'package:teqtop_team/views/pages/tasks_listing/components/task_widget.dart';
import 'package:teqtop_team/views/pages/tasks_listing/components/task_widget_shimmer.dart';

import '../../../consts/app_images.dart';
import '../../widgets/common/common_search_field.dart';

class TasksListingPage extends StatelessWidget {
  final tasksListingController = Get.put(TasksListingController());

  TasksListingPage({super.key});

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
        key: tasksListingController.scaffoldKey,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                color: Colors.black.withValues(alpha: 0.05),
                height: 1,
              )),
          title: Text(
            'task'.tr,
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          leading: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                tasksListingController.scaffoldKey.currentState?.openDrawer();
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SvgPicture.asset(
                  AppIcons.icMenu,
                  colorFilter:
                      const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                ),
              )),
          backgroundColor: Colors.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: tasksListingController.handleOnGlobalSearchTap,
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
                          width: tasksListingController.notificationsCount.value
                                      .toString()
                                      .length >
                                  1
                              ? (12 +
                                      ((tasksListingController
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
                              tasksListingController.notificationsCount.value
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
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Get.toNamed(AppRoutes.routeProfileDetail);
                },
                child: CircleAvatar(
                  radius: 17,
                  backgroundImage: AssetImage(AppImages.imgPersonPlaceholder),
                  foregroundImage: tasksListingController.profilePhoto != null
                      ? NetworkImage(AppConsts.imgInitialUrl +
                          tasksListingController.profilePhoto!)
                      : AssetImage(AppImages.imgPersonPlaceholder),
                ),
              ),
            )
          ],
        ),
        backgroundColor: Colors.white,
        drawer: MenuDrawerWidget(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 16,
                ),
                CommonSearchField(
                  isShowLeading: true,
                  controller: tasksListingController.searchTextController,
                  onChanged: tasksListingController.handleSearchTextChange,
                  hint: "search_task",
                  isShowTrailing:
                      tasksListingController.showSearchFieldTrailing,
                  onTapTrailing: tasksListingController.handleClearSearchField,
                ),
                const SizedBox(
                  height: 18,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Get.toNamed(AppRoutes.routeTaskCreateEdit);
                  },
                  child: DottedBorder(
                    color: Colors.black.withValues(alpha: 0.2),
                    padding: EdgeInsets.zero,
                    dashPattern: [4],
                    strokeWidth: 1,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 34),
                      color: AppColors.colorF7F7F7,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.color7E869E
                                    .withValues(alpha: 0.25)),
                            child: Icon(
                              Icons.add_rounded,
                              color: AppColors.color222222,
                              size: 14,
                            ),
                          ),
                          const SizedBox(
                            width: 14,
                          ),
                          Text(
                            "add_new_task".tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize:
                                        AppConsts.commonFontSizeFactor * 18),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return tasksListingController.isLoading.value
                            ? TaskWidgetShimmer()
                            : TaskWidget(
                                taskData: tasksListingController.tasks[index] ??
                                    TaskModel(),
                                onTap: tasksListingController.handleTaskOnTap,
                              );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 20,
                        );
                      },
                      itemCount: tasksListingController.isLoading.value
                          ? 5
                          : tasksListingController.tasks.length),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
