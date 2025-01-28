import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/consts/app_icons.dart';
import 'package:teqtop_team/model/dashboard/post_image_model.dart';
import 'package:teqtop_team/views/widgets/common/common_button.dart';

import '../../../../consts/app_consts.dart';

//If you make any changes here, then change its shimmer widget accordingly

class CreatePostWidget extends StatelessWidget {
  final TextEditingController textFieldController;
  final void Function(String)? onTextChange;
  final RxBool isPostButtonEnable;
  final void Function() onCameraTap;
  final RxList<XFile?> selectedImages;
  final void Function(XFile) removeSelectedImage;
  final void Function(PostImageModel) removeEditPostPreviousImage;
  final void Function(String) removeEditPostPreviousDocument;
  final void Function() onImageTap;
  final RxList<PlatformFile?> selectedDocuments;
  final void Function() onDocumentTap;
  final void Function(PlatformFile) removeSelectedDocument;
  final void Function() createPost;
  final void Function() editPost;
  final RxBool isPostCreating;
  final RxBool isPostEditing;
  final RxList<String> editPostPreviousDocuments;
  final RxList<PostImageModel> editPostPreviousImages;
  final RxBool isEditPost;

  final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.transparent, width: 0));

  CreatePostWidget({
    super.key,
    required this.textFieldController,
    this.onTextChange,
    required this.isPostButtonEnable,
    required this.onCameraTap,
    required this.selectedImages,
    required this.removeSelectedImage,
    required this.onImageTap,
    required this.selectedDocuments,
    required this.onDocumentTap,
    required this.removeSelectedDocument,
    required this.createPost,
    required this.isPostCreating,
    required this.editPostPreviousDocuments,
    required this.editPostPreviousImages,
    required this.isEditPost,
    required this.removeEditPostPreviousImage,
    required this.removeEditPostPreviousDocument,
    required this.editPost,
    required this.isPostEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IgnorePointer(
        ignoring: isPostCreating.value || isPostEditing.value,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Colors.black.withValues(alpha: 0.07), width: 1)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: textFieldController,
                    maxLines: 4,
                    style: Theme.of(context).textTheme.bodySmall,
                    keyboardType: TextInputType.multiline,
                    cursorColor: Colors.black,
                    textCapitalization: TextCapitalization.none,
                    decoration: InputDecoration(
                        hintText: 'whats_on_your_mind'.tr,
                        enabled: true,
                        hintStyle:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.black.withValues(alpha: 0.3),
                                ),
                        fillColor: Colors.white,
                        filled: true,
                        border: inputBorder,
                        errorBorder: inputBorder,
                        enabledBorder: inputBorder,
                        disabledBorder: inputBorder,
                        focusedBorder: inputBorder,
                        focusedErrorBorder: inputBorder,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10)),
                    onChanged: onTextChange,
                  ),
                  selectedImages.isNotEmpty || editPostPreviousImages.isNotEmpty
                      ? SizedBox(
                          height: 108,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(left: 14),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Stack(
                                        children: [
                                          Container(
                                              padding: EdgeInsets.only(
                                                  right: 8, top: 8),
                                              width: 108,
                                              height: 108,
                                              child: Image.network(
                                                AppConsts.imgInitialUrl +
                                                    editPostPreviousImages[
                                                            index]
                                                        .image,
                                                fit: BoxFit.cover,
                                              )),
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () {
                                                removeEditPostPreviousImage(
                                                    editPostPreviousImages[
                                                        index]);
                                              },
                                              child: Container(
                                                  width: 24,
                                                  height: 24,
                                                  decoration: BoxDecoration(
                                                      color: AppColors
                                                          .kPrimaryColor,
                                                      shape: BoxShape.circle),
                                                  child: Center(
                                                      child: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ))),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        width: 6,
                                      );
                                    },
                                    itemCount: editPostPreviousImages.length),
                                SizedBox(
                                  width: editPostPreviousImages.isEmpty &&
                                          selectedImages.isNotEmpty
                                      ? 14
                                      : 6,
                                ),
                                ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(right: 6),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return selectedImages[index] != null
                                          ? Stack(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      right: 8, top: 8),
                                                  width: 108,
                                                  height: 108,
                                                  child:
                                                      selectedImages[index] !=
                                                              null
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                if (isEditPost
                                                                        .value ==
                                                                    false) {
                                                                  OpenFile.open(
                                                                      selectedImages[
                                                                              index]!
                                                                          .path);
                                                                }
                                                              },
                                                              child: Image.file(
                                                                File(selectedImages[
                                                                        index]!
                                                                    .path),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  top: 0,
                                                  child: GestureDetector(
                                                    behavior:
                                                        HitTestBehavior.opaque,
                                                    onTap: () {
                                                      selectedImages[index] !=
                                                              null
                                                          ? removeSelectedImage(
                                                              selectedImages[
                                                                  index]!)
                                                          : null;
                                                    },
                                                    child: Container(
                                                        width: 24,
                                                        height: 24,
                                                        decoration: BoxDecoration(
                                                            color: AppColors
                                                                .kPrimaryColor,
                                                            shape: BoxShape
                                                                .circle),
                                                        child: Center(
                                                            child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 16,
                                                        ))),
                                                  ),
                                                )
                                              ],
                                            )
                                          : const SizedBox();
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        width: 6,
                                      );
                                    },
                                    itemCount: selectedImages.length)
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 14, right: 14, top: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Stack(children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(14, 10, 40, 10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: AppColors.kPrimaryColor
                                    .withValues(alpha: 0.1)),
                            child: Text(
                              editPostPreviousDocuments[index].split("/").last,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.kPrimaryColor,
                                  ),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                removeEditPostPreviousDocument(
                                    editPostPreviousDocuments[index]);
                              },
                              child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                      color: AppColors.kPrimaryColor,
                                      shape: BoxShape.circle),
                                  child: Center(
                                      child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ))),
                            ),
                          )
                        ]);
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: editPostPreviousDocuments.length),
                  SizedBox(
                    height: editPostPreviousDocuments.isEmpty &&
                            selectedDocuments.isEmpty
                        ? 0
                        : 10,
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 14, right: 14, bottom: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return selectedDocuments[index] != null
                            ? Stack(children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(14, 10, 40, 10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: AppColors.kPrimaryColor
                                          .withValues(alpha: 0.1)),
                                  child: Text(
                                    selectedDocuments[index]!.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.kPrimaryColor,
                                        ),
                                  ),
                                ),
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      selectedDocuments[index] != null
                                          ? removeSelectedDocument(
                                              selectedDocuments[index]!)
                                          : null;
                                    },
                                    child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                            color: AppColors.kPrimaryColor,
                                            shape: BoxShape.circle),
                                        child: Center(
                                            child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ))),
                                  ),
                                )
                              ])
                            : const SizedBox();
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: selectedDocuments.length),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                color: Colors.black.withValues(alpha: 0.07),
                                width: 1))),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: onCameraTap,
                              child: Container(
                                width: 26,
                                height: 26,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: AppColors.color2998BA
                                        .withValues(alpha: 0.3),
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: SvgPicture.asset(
                                    AppIcons.icPhotoCamera,
                                    width: 16,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: onImageTap,
                              child: Container(
                                width: 26,
                                height: 26,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: AppColors.colorEDDEA1
                                        .withValues(alpha: 0.3),
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: SvgPicture.asset(
                                    AppIcons.icImage,
                                    width: 16,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: onDocumentTap,
                              child: Container(
                                width: 26,
                                height: 26,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: AppColors.colorF1C40F
                                        .withValues(alpha: 0.3),
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: SvgPicture.asset(
                                    AppIcons.icDocument,
                                    width: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        isPostCreating.value || isPostEditing.value
                            ? Container(
                                height: 30,
                                width: 56,
                                padding: EdgeInsets.all(8),
                                child: Center(
                                  child: SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.kPrimaryColor,
                                    ),
                                  ),
                                ),
                              )
                            : CommonButton(
                                text: isEditPost.value ? 'save'.tr : 'post'.tr,
                                onClick:
                                    isEditPost.value ? editPost : createPost,
                                isEnable: isPostButtonEnable,
                                width: 56,
                                height: 30,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.colorF5F5F7,
                                    ),
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                right: 0,
                child: Visibility(
                  visible: isPostCreating.value || isPostEditing.value,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
