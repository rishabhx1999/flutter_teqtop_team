import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/config/app_routes.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/consts/app_icons.dart';
import 'package:teqtop_team/controllers/dashboard/dashboard_controller.dart';
import 'package:teqtop_team/model/dashboard/feed.dart';
import 'package:teqtop_team/views/bottom_sheets/comment_bottom_sheet.dart';
import 'package:teqtop_team/views/pages/dashboard/components/create_comment_widget.dart';
import 'package:teqtop_team/views/pages/dashboard/components/create_post_widget.dart';
import 'package:teqtop_team/views/pages/dashboard/components/drawer_widget.dart';
import 'package:teqtop_team/views/pages/dashboard/components/post_widget.dart';
import 'package:teqtop_team/views/pages/dashboard/components/post_widget_shimmer.dart';

import '../../../consts/app_images.dart';

class DashboardPage extends StatelessWidget {
  final dashboardController = Get.put(DashboardController());

  DashboardPage({super.key});

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
          key: dashboardController.scaffoldKey,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.05),
                  height: 1,
                )),
            title: Text(
              'feeds'.tr,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            leading: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  dashboardController.scaffoldKey.currentState?.openDrawer();
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
                padding: const EdgeInsets.only(right: 14),
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
                                          AppConsts.commonFontSizeFactor * 8),
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
                  child: Obx(
                    () => CircleAvatar(
                      radius: 17,
                      backgroundImage:
                          AssetImage(AppImages.imgPersonPlaceholder),
                      foregroundImage: dashboardController.loggedInUser.value !=
                                  null &&
                              dashboardController.loggedInUser.value!.profile !=
                                  null
                          ? NetworkImage(AppConsts.imgInitialUrl +
                              dashboardController.loggedInUser.value!.profile!)
                          : AssetImage(AppImages.imgPersonPlaceholder),
                    ),
                  ),
                ),
              )
            ],
          ),
          backgroundColor: Colors.white,
          drawer: DrawerWidget(),
          body: RefreshIndicator(
            color: AppColors.kPrimaryColor,
            backgroundColor: Colors.white,
            onRefresh: dashboardController.refreshPage,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              controller: dashboardController.scrollController,
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
                    CreatePostWidget(
                      textFieldController:
                          dashboardController.createPostTextController,
                      onTextChange:
                          dashboardController.handleCreatePostTextChange,
                      isPostButtonEnable:
                          dashboardController.isPostButtonEnable,
                      onCameraTap: dashboardController.clickImage,
                      selectedImages: dashboardController.selectedImages,
                      removeSelectedImage:
                          dashboardController.removeSelectedImage,
                      onImageTap: dashboardController.pickImages,
                      selectedDocuments: dashboardController.selectedDocuments,
                      onDocumentTap: dashboardController.pickDocuments,
                      removeSelectedDocument:
                          dashboardController.removeSelectedDocument,
                    ),
                    Obx(
                      () => ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return dashboardController.arePostsLoading.value
                                ? PostWidgetShimmer()
                                : PostWidget(
                                    commentOnTap: () {
                                      CommentBottomSheet.show(
                                          context: context,
                                          createCommentWidget:
                                              CreateCommentWidget(
                                            controller: dashboardController
                                                .commentFieldController,
                                            hint: 'add_comment'.tr,
                                          ),
                                          commentCount: dashboardController
                                                          .posts[index] !=
                                                      null &&
                                                  dashboardController
                                                          .posts[index]!
                                                          .commentCount !=
                                                      null
                                              ? dashboardController
                                                  .posts[index]!
                                                  .commentCount!
                                                  .length
                                              : 0,
                                          componentId: dashboardController
                                                          .posts[index] !=
                                                      null &&
                                                  dashboardController
                                                          .posts[index]!
                                                          .commentCount !=
                                                      null
                                              ? dashboardController
                                                      .posts[index]!
                                                      .commentCount![0]
                                                      ?.componentId ??
                                                  0
                                              : 0,
                                          getComments:
                                              dashboardController.getComments,
                                          areCommentsLoading:
                                              dashboardController
                                                  .areCommentsLoading);
                                    },
                                    postData:
                                        dashboardController.posts[index] ??
                                            Feed(),
                                  );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 16,
                            );
                          },
                          itemCount: dashboardController.arePostsLoading.value
                              ? 5
                              : dashboardController.posts.length),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
