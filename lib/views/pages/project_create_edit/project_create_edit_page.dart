import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/model/project_create_edit/project_category_model.dart';
import 'package:teqtop_team/model/project_create_edit/proposal_model.dart';
import 'package:teqtop_team/views/widgets/common/common_input_field_shimmer.dart';

import '../../../consts/app_consts.dart';
import '../../../consts/app_icons.dart';
import '../../../controllers/project_create_edit/project_create_edit_controller.dart';
import '../../../utils/validations.dart';
import '../../widgets/common/common_button.dart';
import '../../widgets/common/common_button_shimmer.dart';
import '../../widgets/common/common_dropdown_button.dart';
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
          title: Obx(
            () => Text(
              projectCreateEditController.fromProjectDetail.value
                  ? 'edit_project'.tr
                  : 'create_new_project'.tr,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
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
          key: projectCreateEditController.formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
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
                  Obx(
                    () => projectCreateEditController
                            .areProjectCategoriesAndProposalLoading.value
                        ? const CommonInputFieldShimmer(
                            labelShimmerBorderRadius: 0,
                          )
                        : CommonInputField(
                            fillColor: AppColors.colorF9F9F9,
                            borderColor: Colors.transparent,
                            controller:
                                projectCreateEditController.nameController,
                            hint: 'enter_project_name',
                            label: 'name',
                            onChanged: (value) {},
                            validator: Validations.checkProjectNameValidations,
                            inputType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => projectCreateEditController
                            .areProjectCategoriesAndProposalLoading.value
                        ? Shimmer.fromColors(
                            baseColor: AppColors.shimmerBaseColor,
                            highlightColor: AppColors.shimmerHighlightColor,
                            child: Container(
                              height: 20,
                              width: 60,
                              decoration: BoxDecoration(
                                color: AppColors.shimmerBaseColor,
                              ),
                            ))
                        : Text(
                            'category'.tr.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize:
                                        AppConsts.commonFontSizeFactor * 14),
                          ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Obx(
                    () => projectCreateEditController
                            .areProjectCategoriesAndProposalLoading.value
                        ? Shimmer.fromColors(
                            baseColor: AppColors.shimmerBaseColor,
                            highlightColor: AppColors.shimmerHighlightColor,
                            child: Container(
                              height: 55.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.shimmerBaseColor,
                              ),
                            ))
                        : CommonDropdownWidget(
                            trailingIcon: AppIcons.icDropdown2,
                            trailingIconColor: AppColors.color040404,
                            backgroundColor: AppColors.colorF9F9F9,
                            maxDropdownHeight: 200,
                            height: 55,
                            onChanged: projectCreateEditController
                                .onChangeProjectCategory,
                            items: projectCreateEditController.projectCategories
                                .map((projectCategory) =>
                                    DropdownMenuItem<ProjectCategoryModel>(
                                      value: projectCategory,
                                      child: Text(
                                        projectCategory.name ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                fontSize: AppConsts
                                                        .commonFontSizeFactor *
                                                    14),
                                      ),
                                    ))
                                .toList(),
                            value: projectCreateEditController
                                .selectedProjectCategory,
                            selectedItemBuilder: (BuildContext context) {
                              return projectCreateEditController
                                  .projectCategories
                                  .map<Widget>((projectCategory) {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    projectCategory.name != null
                                        ? projectCreateEditController
                                            .truncateDropdownSelectedValue(
                                                projectCategory.name!)
                                        : "",
                                    style: projectCategory.name ==
                                            "select_category".tr
                                        ? Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                color: AppColors.colorA9A9A9)
                                        : Theme.of(context).textTheme.bodyLarge,
                                  ),
                                );
                              }).toList();
                            },
                          ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: projectCreateEditController
                          .showSelectProjectCategoryMessage.value,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 4, left: 14, right: 14),
                        child: Text(
                          "message_select_project_category".tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Colors.red,
                                  fontSize:
                                      AppConsts.commonFontSizeFactor * 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => projectCreateEditController
                            .areProjectCategoriesAndProposalLoading.value
                        ? const CommonInputFieldShimmer(
                            labelShimmerBorderRadius: 0,
                          )
                        : CommonInputField(
                            fillColor: AppColors.colorF9F9F9,
                            borderColor: Colors.transparent,
                            controller:
                                projectCreateEditController.clientController,
                            hint: 'enter_client',
                            label: 'client',
                            onChanged: (value) {},
                            validator: Validations.checkNameValidations,
                            inputType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => projectCreateEditController
                            .areProjectCategoriesAndProposalLoading.value
                        ? const CommonInputFieldShimmer(
                            labelShimmerBorderRadius: 0,
                          )
                        : CommonInputField(
                            fillColor: AppColors.colorF9F9F9,
                            borderColor: Colors.transparent,
                            controller:
                                projectCreateEditController.urlController,
                            hint: 'enter_url',
                            label: 'url',
                            onChanged: (value) {},
                            validator: Validations.checkURLValidations,
                            inputType: TextInputType.url,
                            textInputAction: TextInputAction.next,
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => projectCreateEditController
                            .areProjectCategoriesAndProposalLoading.value
                        ? const CommonInputFieldShimmer(
                            labelShimmerBorderRadius: 0,
                          )
                        : CommonInputField(
                            fillColor: AppColors.colorF9F9F9,
                            borderColor: Colors.transparent,
                            controller:
                                projectCreateEditController.portalController,
                            hint: 'enter_portal',
                            label: 'portal',
                            onChanged: (value) {},
                            validator: Validations.checkPortalValidations,
                            inputType: TextInputType.url,
                            textInputAction: TextInputAction.next,
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => projectCreateEditController
                            .areProjectCategoriesAndProposalLoading.value
                        ? const CommonInputFieldShimmer(
                            labelShimmerBorderRadius: 0,
                          )
                        : CommonInputField(
                            fillColor: AppColors.colorF9F9F9,
                            borderColor: Colors.transparent,
                            controller:
                                projectCreateEditController.profileController,
                            hint: 'enter',
                            label: 'profile',
                            onChanged: (value) {},
                            validator: Validations.checkProfileValidations,
                            inputType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => projectCreateEditController
                            .areProjectCategoriesAndProposalLoading.value
                        ? const CommonInputFieldShimmer(
                            labelShimmerBorderRadius: 0,
                            textFieldShimmerHeight: 124,
                          )
                        : CommonInputField(
                            fillColor: AppColors.colorF9F9F9,
                            borderColor: Colors.transparent,
                            controller: projectCreateEditController
                                .descriptionController,
                            hint: 'enter_project_description',
                            label: 'description',
                            maxLines: 4,
                            onChanged: (value) {},
                            validator:
                                Validations.checkProjectDescriptionValidations,
                            inputType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => projectCreateEditController
                            .areProjectCategoriesAndProposalLoading.value
                        ? Shimmer.fromColors(
                            baseColor: AppColors.shimmerBaseColor,
                            highlightColor: AppColors.shimmerHighlightColor,
                            child: Container(
                              height: 20,
                              width: 60,
                              decoration: BoxDecoration(
                                color: AppColors.shimmerBaseColor,
                              ),
                            ))
                        : Text(
                            'proposal'.tr.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize:
                                        AppConsts.commonFontSizeFactor * 14),
                          ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Obx(
                    () => projectCreateEditController
                            .areProjectCategoriesAndProposalLoading.value
                        ? Shimmer.fromColors(
                            baseColor: AppColors.shimmerBaseColor,
                            highlightColor: AppColors.shimmerHighlightColor,
                            child: Container(
                              height: 55.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.shimmerBaseColor,
                              ),
                            ))
                        : CommonDropdownWidget(
                            trailingIcon: AppIcons.icDropdown2,
                            trailingIconColor: AppColors.color040404,
                            backgroundColor: AppColors.colorF9F9F9,
                            maxDropdownHeight: 200,
                            height: 55,
                            onChanged:
                                projectCreateEditController.onChangeProposal,
                            items: projectCreateEditController.proposals
                                .map((proposal) =>
                                    DropdownMenuItem<ProposalModel>(
                                      value: proposal,
                                      child: Text(
                                        proposal.title ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                fontSize: AppConsts
                                                        .commonFontSizeFactor *
                                                    14),
                                      ),
                                    ))
                                .toList(),
                            value: projectCreateEditController.selectedProposal,
                            selectedItemBuilder: (BuildContext context) {
                              return projectCreateEditController.proposals
                                  .map<Widget>((proposal) {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    proposal.title != null
                                        ? projectCreateEditController
                                            .truncateDropdownSelectedValue(
                                                proposal.title!)
                                        : "",
                                    style: proposal.title ==
                                            "select_proposal".tr
                                        ? Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                color: AppColors.colorA9A9A9)
                                        : Theme.of(context).textTheme.bodyLarge,
                                  ),
                                );
                              }).toList();
                            },
                          ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: projectCreateEditController
                          .showSelectProposalMessage.value,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 4, left: 14, right: 14),
                        child: Text(
                          "message_select_proposal".tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Colors.red,
                                  fontSize:
                                      AppConsts.commonFontSizeFactor * 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 44,
                  ),
                  Obx(
                    () => projectCreateEditController
                                .areProjectCategoriesAndProposalLoading.value ||
                            projectCreateEditController.isLoading.value
                        ? const CommonButtonShimmer(
                            borderRadius: 0,
                          )
                        : CommonButton(
                            text: projectCreateEditController
                                    .fromProjectDetail.value
                                ? 'save'.tr
                                : 'create_project',
                            onClick: () {
                              if (projectCreateEditController
                                  .fromProjectDetail.value) {
                                projectCreateEditController.editProject();
                              } else {
                                projectCreateEditController.createProject();
                              }
                            }),
                  ),
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
