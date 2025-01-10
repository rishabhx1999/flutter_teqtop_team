import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../config/app_routes.dart';
import '../../../consts/app_icons.dart';
import '../../../controllers/project_create_edit/project_create_edit_controller.dart';
import '../../../utils/validations.dart';
import '../../widgets/common/common_button.dart';
import '../../widgets/common/common_input_field.dart';

class ProjectCreateEditPage extends StatelessWidget {
  final projectCreateEditController = Get.put(ProjectCreateEditController());

  ProjectCreateEditPage({super.key});

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
            'create_new_project'.tr,
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
              padding: const EdgeInsets.only(right: 16),
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
          ],
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: projectCreateEditController.formKey,
          child: SingleChildScrollView(
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
                    height: 20,
                  ),
                  CommonInputField(
                    controller: projectCreateEditController.nameController,
                    hint: 'enter_project_name',
                    label: 'name',
                    onChanged: (value) {},
                    validator: Validations.checkProjectNameValidations,
                    inputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonInputField(
                    controller: projectCreateEditController.clientController,
                    hint: 'enter_client',
                    label: 'client',
                    onChanged: (value) {},
                    validator: Validations.checkNameValidations,
                    inputType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonInputField(
                    controller: projectCreateEditController.urlController,
                    hint: 'enter_url',
                    label: 'url',
                    onChanged: (value) {},
                    validator: Validations.checkURLValidations,
                    inputType: TextInputType.url,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonInputField(
                    controller: projectCreateEditController.portalController,
                    hint: 'enter_portal',
                    label: 'portal',
                    onChanged: (value) {},
                    validator: Validations.checkPortalValidations,
                    inputType: TextInputType.url,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonInputField(
                    controller: projectCreateEditController.profileController,
                    hint: 'enter',
                    label: 'profile',
                    onChanged: (value) {},
                    validator: Validations.checkProfileValidations,
                    inputType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonInputField(
                    controller:
                        projectCreateEditController.descriptionController,
                    hint: 'enter_project_description',
                    label: 'description',
                    onChanged: (value) {},
                    validator: Validations.checkProjectDescriptionValidations,
                    inputType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(
                    height: 44,
                  ),
                  CommonButton(
                      text: 'create_project',
                      onClick: () {
                        projectCreateEditController.createProject();
                      }),
                  const SizedBox(
                    height: 44,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
