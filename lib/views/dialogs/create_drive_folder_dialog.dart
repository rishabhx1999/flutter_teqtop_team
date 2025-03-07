import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/utils/validations.dart';
import 'package:teqtop_team/views/widgets/common/common_button.dart';
import 'package:teqtop_team/views/widgets/common/common_button_outline.dart';

import '../../config/app_colors.dart';

class CreateDriveFolderDialog {
  CreateDriveFolderDialog._();

  static showDialog({
    required final void Function() createFolder,
    required final TextEditingController nameController,
    required final GlobalKey<FormState> formKey,
    required final RxBool isFolderCreating,
  }) {
    Get.dialog(Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: CreateDriveFolderDialogContent(
        createFolder: createFolder,
        nameController: nameController,
        formKey: formKey,
        isFolderCreating: isFolderCreating,
      ),
    ));
  }
}

class CreateDriveFolderDialogContent extends StatelessWidget {
  final void Function() createFolder;
  final TextEditingController nameController;
  final GlobalKey<FormState> formKey;
  final RxBool isFolderCreating;

  const CreateDriveFolderDialogContent({
    super.key,
    required this.createFolder,
    required this.nameController,
    required this.formKey,
    required this.isFolderCreating,
  });

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide:
            BorderSide(color: Colors.black.withValues(alpha: 0.1), width: 0.5));
    final errorInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide:
            BorderSide(color: Colors.red.withValues(alpha: 0.1), width: 0.5));

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                enabled: true,
                controller: nameController,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyLarge,
                keyboardType: TextInputType.name,
                cursorColor: Colors.black,
                textCapitalization: TextCapitalization.none,
                decoration: InputDecoration(
                    hintText: "enter_folder_name".tr,
                    enabled: true,
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: AppColors.colorA9A9A9),
                    fillColor: Colors.white,
                    filled: true,
                    border: inputBorder,
                    errorMaxLines: 1,
                    errorBorder: errorInputBorder,
                    enabledBorder: inputBorder,
                    disabledBorder: inputBorder,
                    focusedBorder: inputBorder,
                    focusedErrorBorder: errorInputBorder,
                    errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.red,
                          fontSize: AppConsts.commonFontSizeFactor * 12,
                        ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 16)),
                validator: Validations.checkFolderNameValidations,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(
                height: 28,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      child: CommonButtonOutline(
                    text: "cancel".tr,
                    onClick: () {
                      Get.back();
                    },
                    fontWeight: FontWeight.w600,
                  )),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                      child: Obx(
                    () => isFolderCreating.value
                        ? Center(
                            child: Container(
                              height: 51,
                              width: 51,
                              padding: const EdgeInsets.all(8),
                              child: CircularProgressIndicator(
                                color: AppColors.kPrimaryColor,
                              ),
                            ),
                          )
                        : CommonButton(
                            text: "create".tr,
                            onClick: createFolder,
                            fontWeight: FontWeight.w600,
                            fontSize: AppConsts.commonFontSizeFactor * 16,
                          ),
                  ))
                ],
              )
            ],
          ),
        ));
  }
}
