import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:teqtop_team/controllers/edit_employee_information/edit_employee_information_controller.dart';
import 'package:teqtop_team/utils/validations.dart';

import '../../../config/app_colors.dart';
import '../../../consts/app_icons.dart';
import '../../widgets/common/common_button.dart';
import '../../widgets/common/common_input_field.dart';

class EditEmployeeInformationPage extends StatelessWidget {
  final editEmployeeInformationController =
      Get.put(EditEmployeeInformationController());

  EditEmployeeInformationPage({super.key});

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
              'edit_employee_info'.tr,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            leading: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Image.asset(
                    AppIcons.icBack,
                    color: Colors.black,
                  ),
                )),
            leadingWidth: 40,
            backgroundColor: Colors.white,
            centerTitle: true,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            elevation: 0,
          ),
          backgroundColor: Colors.white,
          body: Form(
            key: editEmployeeInformationController.formKey,
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
                        CommonInputField(
                          controller: editEmployeeInformationController
                              .contactNoController,
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
                              editEmployeeInformationController.DOBController,
                          hint: "enter_date_of_birth",
                          label: "date_of_birth",
                          borderWidth: 0,
                          inputType: TextInputType.datetime,
                          validator: Validations.checkDateOfBirthValidations,
                          textInputAction: TextInputAction.next,
                          fillColor: AppColors.colorF9F9F9,
                          borderColor: Colors.transparent,
                          isEnable: false,
                          trailing: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              AppIcons.icCalendar,
                            ),
                          ),
                          onTap: editEmployeeInformationController
                              .handleDOBFieldOnTap,
                          onTapFirstArg: context,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CommonInputField(
                          controller:
                              editEmployeeInformationController.roleController,
                          hint: "enter_role",
                          label: "role",
                          borderWidth: 0,
                          inputType: TextInputType.text,
                          validator: Validations.checkRoleValidations,
                          textInputAction: TextInputAction.next,
                          fillColor: AppColors.colorF9F9F9,
                          borderColor: Colors.transparent,
                        ),
                        // const SizedBox(
                        //   height: 16,
                        // ),
                        // CommonInputField(
                        //   controller: editEmployeeInformationController
                        //       .positionController,
                        //   hint: "enter_position",
                        //   label: "position",
                        //   borderWidth: 0,
                        //   inputType: TextInputType.text,
                        //   validator: Validations.checkPositionValidations,
                        //   textInputAction: TextInputAction.next,
                        //   fillColor: AppColors.colorF9F9F9,
                        //   borderColor: Colors.transparent,
                        // ),
                        // const SizedBox(
                        //   height: 16,
                        // ),
                        // CommonInputField(
                        //   controller: editEmployeeInformationController
                        //       .employeeIDController,
                        //   hint: "enter_employee_id",
                        //   label: "employee_id",
                        //   borderWidth: 0,
                        //   inputType: TextInputType.text,
                        //   validator: Validations.checkEmployeeIDValidations,
                        //   textInputAction: TextInputAction.next,
                        //   fillColor: AppColors.colorF9F9F9,
                        //   borderColor: Colors.transparent,
                        // ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                )),
                Obx(
                  () => Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      child: editEmployeeInformationController.isLoading.value
                          ? Container(
                              height: 51,
                              width: 51,
                              padding: const EdgeInsets.all(8),
                              child: CircularProgressIndicator(
                                color: AppColors.kPrimaryColor,
                              ),
                            )
                          : CommonButton(
                              text: "save",
                              onClick: () {
                                editEmployeeInformationController.saveInfo();
                              })),
                )
              ],
            ),
          )),
    );
  }
}
