import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/utils/validations.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../consts/app_consts.dart';
import '../../../consts/app_icons.dart';
import '../../../consts/app_images.dart';
import '../../../controllers/edit_profile/edit_profile_controller.dart';
import '../../bottom_sheets/take_image_bottom_sheet.dart';
import '../../widgets/common/common_button.dart';
import '../../widgets/common/common_input_field.dart';

class EditProfilePage extends StatelessWidget {
  final editProfileController = Get.put(EditProfileController());

  EditProfilePage({super.key});

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
              'edit_profile'.tr,
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
                padding: const EdgeInsets.only(right: 16),
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
                                  .bodySmall
                                  ?.copyWith(
                                      fontSize:
                                          AppConsts.commonFontSizeFactor * 8,
                                      fontWeight: FontWeight.w600),
                            )),
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: Form(
            key: editProfileController.formKey,
            child: Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Stack(
                            children: [
                              Obx(
                                () => CircleAvatar(
                                  radius: 54,
                                  backgroundImage: AssetImage(
                                      AppImages.imgPersonPlaceholder),
                                  foregroundImage: editProfileController
                                              .selectedImage.value !=
                                          null
                                      ? FileImage(File(editProfileController
                                          .selectedImage.value!.path))
                                      : editProfileController.profilePhoto !=
                                              null
                                          ? NetworkImage(
                                              AppConsts.imgInitialUrl +
                                                  editProfileController
                                                      .profilePhoto!)
                                          : AssetImage(
                                              AppImages.imgPersonPlaceholder),
                                ),
                              ),
                              Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      TakeImageBottomSheet.show(
                                          context: context,
                                          imageSource: (source) {
                                            Navigator.of(context).pop();
                                            editProfileController
                                                .pickImage(source);
                                          });
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: AppColors.kPrimaryColor,
                                              width: 1)),
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          color: AppColors.kPrimaryColor,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        CommonInputField(
                          controller: editProfileController.nameController,
                          hint: "enter_name",
                          label: "name",
                          inputType: TextInputType.name,
                          validator: Validations.checkNameValidations,
                          textInputAction: TextInputAction.next,
                          borderWidth: 0,
                          fillColor: AppColors.colorF9F9F9,
                          borderColor: Colors.transparent,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CommonInputField(
                          controller: editProfileController.contactNoController,
                          hint: "enter_contact_number",
                          label: "contact_number",
                          borderWidth: 0,
                          inputType: TextInputType.phone,
                          validator: Validations.checkContactNoValidations,
                          textInputAction: TextInputAction.next,
                          fillColor: AppColors.colorF9F9F9,
                          borderColor: Colors.transparent,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CommonInputField(
                          controller:
                              editProfileController.alternateNoController,
                          hint: "enter_alternate_number",
                          label: "alternate_number",
                          borderWidth: 0,
                          inputType: TextInputType.phone,
                          validator:
                              Validations.checkAlternateContactNoValidations,
                          textInputAction: TextInputAction.next,
                          fillColor: AppColors.colorF9F9F9,
                          borderColor: Colors.transparent,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CommonInputField(
                          controller: editProfileController.DOBController,
                          hint: "enter_date_of_birth",
                          label: "date_of_birth",
                          borderWidth: 0,
                          inputType: TextInputType.datetime,
                          validator: Validations.checkDateOfBirthValidations,
                          textInputAction: TextInputAction.next,
                          fillColor: AppColors.colorF9F9F9,
                          borderColor: Colors.transparent,
                          isEnable: false,
                          trailing: Icon(
                            Icons.calendar_month_rounded,
                            color: Colors.black,
                          ),
                          onTap: editProfileController.handleDOBFieldOnTap,
                          onTapFirstArg: context,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CommonInputField(
                          controller:
                              editProfileController.currentAddressController,
                          hint: "enter_current_address",
                          label: "current_address",
                          borderWidth: 0,
                          inputType: TextInputType.streetAddress,
                          validator: Validations.checkCurrentAddressValidations,
                          textInputAction: TextInputAction.next,
                          fillColor: AppColors.colorF9F9F9,
                          borderColor: Colors.transparent,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CommonInputField(
                          controller:
                              editProfileController.additionalInfoController,
                          hint: "enter_additional_info",
                          label: "additional_info",
                          borderWidth: 0,
                          inputType: TextInputType.text,
                          validator: Validations.checkAdditionalInfoValidations,
                          textInputAction: TextInputAction.done,
                          fillColor: AppColors.colorF9F9F9,
                          borderColor: Colors.transparent,
                          maxLines: 4,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                )),
                Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: CommonButton(
                        text: "save",
                        onClick: () {
                          editProfileController.saveInfo();
                        }))
              ],
            ),
          )),
    );
  }
}
