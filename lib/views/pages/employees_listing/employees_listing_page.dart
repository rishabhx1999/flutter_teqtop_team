import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/config/app_routes.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/consts/app_icons.dart';
import 'package:teqtop_team/controllers/employees_listing/employees_listing_controller.dart';
import 'package:teqtop_team/model/search/member.dart';
import 'package:teqtop_team/views/pages/dashboard/components/drawer_widget.dart';
import 'package:teqtop_team/views/pages/employees_listing/components/employee_widget.dart';

import '../../../consts/app_images.dart';
import '../../widgets/common/common_search_field.dart';

class EmployeesListingPage extends StatelessWidget {
  final employeesListingController = Get.put(EmployeesListingController());

  EmployeesListingPage({super.key});

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
          key: employeesListingController.scaffoldKey,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(120),
              child: AppBar(
                scrolledUnderElevation: 0,
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(60),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 12),
                          child: Text("${"employees".tr} (32)",
                              style: Theme.of(context)
                                  .appBarTheme
                                  .titleTextStyle
                                  ?.copyWith(
                                      fontSize:
                                          AppConsts.commonFontSizeFactor * 32)),
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.black.withValues(alpha: 0.05),
                        )
                      ],
                    )),
                leading: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      employeesListingController.scaffoldKey.currentState
                          ?.openDrawer();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SvgPicture.asset(
                        AppIcons.icMenu,
                        colorFilter: const ColorFilter.mode(
                            Colors.black, BlendMode.srcIn),
                      ),
                    )),
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                elevation: 0,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Get.toNamed(AppRoutes.routeGlobalSearch);
                        },
                        child: SvgPicture.asset(
                          AppIcons.icSearch,
                          width: 24,
                          colorFilter: const ColorFilter.mode(
                              Colors.black, BlendMode.srcIn),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Get.toNamed(AppRoutes.routeNotifications);
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Image.asset(
                              AppIcons.icBell,
                              width: 24,
                            ),
                          ),
                          Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                    color: AppColors.colorFFB400,
                                    shape: BoxShape.circle),
                                child: Center(
                                    child: Text(
                                  "2",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          fontSize:
                                              AppConsts.commonFontSizeFactor *
                                                  8),
                                )),
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
                        backgroundImage:
                            AssetImage(AppImages.imgPersonPlaceholder),
                        foregroundImage:
                            employeesListingController.profilePhoto != null
                                ? NetworkImage(AppConsts.imgInitialUrl +
                                    employeesListingController.profilePhoto!)
                                : AssetImage(AppImages.imgPersonPlaceholder),
                      ),
                    ),
                  )
                ],
              )),
          backgroundColor: Colors.white,
          drawer: DrawerWidget(),
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
                    height: 14,
                  ),
                  CommonSearchField(
                    isShowLeading: true,
                    controller: employeesListingController.searchTextController,
                    onChanged:
                        employeesListingController.handleSearchTextChange,
                    hint: "search_employees",
                    isShowTrailing:
                        employeesListingController.showSearchFieldTrailing,
                    onTapTrailing:
                        employeesListingController.handleClearSearchField,
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return EmployeeWidget(
                          employeeData: Member(),
                          onTap: employeesListingController.handleEmployeeOnTap,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 14,
                        );
                      },
                      itemCount: 10),
                  const SizedBox(
                    height: 14,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
