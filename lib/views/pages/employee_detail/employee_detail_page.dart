import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/controllers/employee_detail/employee_detail_controller.dart';

import '../../../consts/app_icons.dart';
import '../../../consts/app_images.dart';

class EmployeeDetailPage extends StatelessWidget {
  final employeeDetailController = Get.put(EmployeeDetailController());

  EmployeeDetailPage({super.key});

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
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: NestedScrollView(
          controller: employeeDetailController.scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: CircleAvatar(
                        radius: 58,
                        backgroundImage:
                            AssetImage(AppImages.imgPersonPlaceholder),
                        foregroundImage:
                            AssetImage(AppImages.imgPersonPlaceholder),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Sunil Dhadwal",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "example@gmail.com",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.zero,
                          color: AppColors.color54B435),
                      child: Text(
                        "Active",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: employeeDetailController.tabController,
                    tabs: [
                      Tab(
                        text: "information".tr,
                      ),
                      Tab(
                        text: "document".tr,
                      ),
                      Tab(
                        text: "leaves".tr,
                      )
                    ],
                    labelColor: Colors.redAccent,
                    unselectedLabelColor: Colors.grey,
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: employeeDetailController.tabController,
            children: [
              // Replace Column() with appropriate scrollable widgets
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Add your information tab content here
                    Text("Information Content"),
                    Text("Information Content"),
                    Text("Information Content"),
                    Text("Information Content"),
                    Text("Information Content"),
                    Text("Information Content"),
                    Text("Information Content"),
                    Text("Information Content"),
                    Text("Information Content"),
                    Text("Information Content"),
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Add your document tab content here
                    Text("Document Content"),
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Add your leaves tab content here
                    Text("Leaves Content"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
