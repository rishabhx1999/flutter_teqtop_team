import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/controllers/profile_detail/profile_detail_controller.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../consts/app_consts.dart';
import '../../../consts/app_icons.dart';
import '../../../consts/app_images.dart';
import '../../widgets/common/common_button.dart';
import 'components/profile_info_widget.dart';

class ProfileDetailPage extends StatelessWidget {
  final profileDetailController = Get.put(ProfileDetailController());

  ProfileDetailPage({super.key});

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
          title: Text(
            'profile'.tr,
            style: Theme.of(context).appBarTheme.titleTextStyle,
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
                          width: profileDetailController
                                      .notificationsCount.value
                                      .toString()
                                      .length >
                                  1
                              ? (12 +
                                      ((profileDetailController
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
                              profileDetailController.notificationsCount.value
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
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Obx(
                  () => Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: CircleAvatar(
                          radius: 90,
                          backgroundImage:
                              AssetImage(AppImages.imgPersonPlaceholder),
                          foregroundImage: profileDetailController
                                  .profilePhoto.value.isNotEmpty
                              ? NetworkImage(AppConsts.imgInitialUrl +
                                  profileDetailController.profilePhoto.value)
                              : AssetImage(AppImages.imgPersonPlaceholder),
                        ),
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Text(
                        profileDetailController.personName.value,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: AppConsts.commonFontSizeFactor * 20),
                      ),
                      Text(
                        profileDetailController.personEmail.value,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ProfileInfoWidget(
                          title: "contact_number",
                          data: profileDetailController
                                  .personContactNo.value.isNotEmpty
                              ? "+91 ${profileDetailController.personContactNo.value}"
                              : ""),
                      ProfileInfoWidget(
                          title: "alternate_number",
                          data: profileDetailController
                                  .personAlternatedNo.isNotEmpty
                              ? "+91 ${profileDetailController.personAlternatedNo.value}"
                              : ""),
                      ProfileInfoWidget(
                          title: "date_of_birth",
                          data: profileDetailController.personDOB.value),
                      ProfileInfoWidget(
                          title: "current_address",
                          data: profileDetailController
                              .personCurrentAddress.value),
                      ProfileInfoWidget(
                          title: "additional_info",
                          data: profileDetailController
                              .personAdditionalInfo.value),
                      const SizedBox(
                        height: 28,
                      ),
                    ],
                  ),
                ),
              ),
            )),
            Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: CommonButton(
                    text: 'edit_detail',
                    onClick: () {
                      Get.toNamed(AppRoutes.routeEditProfile);
                    }))
          ],
        ),
      ),
    );
  }
}
