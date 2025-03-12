import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/consts/app_icons.dart';
import 'package:teqtop_team/model/media_content_model.dart';
import 'package:teqtop_team/views/widgets/common/common_button_outline.dart';

import '../../../consts/app_consts.dart';
import '../../../consts/app_images.dart';
import 'common_button.dart';

class CommonMultimediaContentCreateWidget extends StatelessWidget {
  final String hint;
  final String? Function(String?)? validator;
  final HtmlEditorController htmlEditorController;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatter;
  final int? maxLines;
  final bool? isEnable;
  final bool? showFloatingLabel;
  final TextCapitalization? textCapitalization;
  final Function()? createComment;
  final Function()? cancelEditing;
  final FocusNode? focusNode;
  final RxBool? isEditingComment;
  final Future<void> Function()? editComment;
  final RxBool isTextFieldEmpty;
  final Function(String) onTextChanged;
  final RxList<MediaContentModel> contentItems;
  final Function() clickImage;
  final Function() pickImages;
  final Function() pickVideos;
  final Function() addText;
  final Function() pickFiles;
  final Function(MediaContentModel) removeContentItem;
  final Function(int) addContentAfter;
  final Function(int) editText;
  final bool showCreateEditButton;
  final bool? showShadow;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final Color? textFieldBackgroundColor;
  final RxBool isCreateOrEditLoading;
  final Function()? htmlEditorOnInit;
  final Function(String?)? htmlEditorOnChange;
  final RxList<String> attachedImages;
  final RxList<String> attachedDocuments;
  final Function(String) removeAttachedImage;
  final Function(String) removeAttachedDocument;
  final inputBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: Colors.transparent));
  final bool? expandEditor;
  final RxBool areAttachedFilesLoading;

  const CommonMultimediaContentCreateWidget(
      {super.key,
      required this.htmlEditorController,
      required this.hint,
      required this.isTextFieldEmpty,
      required this.onTextChanged,
      required this.contentItems,
      required this.clickImage,
      required this.pickImages,
      required this.addText,
      required this.removeContentItem,
      required this.addContentAfter,
      required this.pickFiles,
      required this.editText,
      required this.showCreateEditButton,
      required this.isCreateOrEditLoading,
      this.validator,
      this.inputType,
      this.inputFormatter,
      this.maxLines,
      this.isEnable,
      this.showFloatingLabel,
      this.textCapitalization,
      this.createComment,
      this.focusNode,
      this.isEditingComment,
      this.editComment,
      this.showShadow,
      this.backgroundColor,
      this.borderRadius,
      this.textFieldBackgroundColor,
      this.htmlEditorOnInit,
      this.cancelEditing,
      this.htmlEditorOnChange,
      required this.attachedImages,
      required this.attachedDocuments,
      required this.removeAttachedImage,
      required this.removeAttachedDocument,
      this.expandEditor,
      required this.areAttachedFilesLoading,
      required this.pickVideos});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IgnorePointer(
        ignoring: isCreateOrEditLoading.value,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                  color: backgroundColor ?? AppColors.colorF9F9F9,
                  borderRadius: borderRadius ?? BorderRadius.zero,
                  boxShadow: showShadow ?? false
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            offset: const Offset(0, 0),
                            blurRadius: 14,
                            spreadRadius: 0,
                          ),
                        ]
                      : null),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Expanded(
                  //     child: Obx(
                  //   () => ListView.separated(
                  //       shrinkWrap: true,
                  //       itemBuilder: (context, index) {
                  //         return Padding(
                  //           padding: const EdgeInsets.symmetric(horizontal: 16),
                  //           child: Stack(
                  //             children: [
                  //               contentItems[index].text != null
                  //                   ? GestureDetector(
                  //                       behavior: HitTestBehavior.opaque,
                  //                       onTap: () {
                  //                         editText(index);
                  //                       },
                  //                       child: Padding(
                  //                         padding:
                  //                             const EdgeInsets.only(right: 16),
                  //                         child: Text(
                  //                           contentItems[index].text!,
                  //                           style: Theme.of(context)
                  //                               .textTheme
                  //                               .bodySmall
                  //                               ?.copyWith(
                  //                                   fontSize: AppConsts
                  //                                           .commonFontSizeFactor *
                  //                                       14),
                  //                         ),
                  //                       ),
                  //                     )
                  //                   : contentItems[index].image != null
                  //                       ? Image.file(
                  //                           File(contentItems[index]
                  //                               .image!
                  //                               .path),
                  //                           fit: BoxFit.cover,
                  //                         )
                  //                       : contentItems[index].imageString !=
                  //                               null
                  //                           ? Image.network(
                  //                               AppConsts.imgInitialUrl +
                  //                                   contentItems[index]
                  //                                       .imageString!,
                  //                               fit: BoxFit.cover,
                  //                             )
                  //                           : contentItems[index].file != null
                  //                               ? Container(
                  //                                   padding: const EdgeInsets
                  //                                       .fromLTRB(
                  //                                       14, 10, 40, 10),
                  //                                   width: double.infinity,
                  //                                   decoration: BoxDecoration(
                  //                                       color: AppColors
                  //                                           .kPrimaryColor
                  //                                           .withValues(
                  //                                               alpha: 0.1)),
                  //                                   child: Text(
                  //                                     contentItems[index]
                  //                                         .file!
                  //                                         .name,
                  //                                     style: Theme.of(context)
                  //                                         .textTheme
                  //                                         .bodyMedium
                  //                                         ?.copyWith(
                  //                                           color: AppColors
                  //                                               .kPrimaryColor,
                  //                                         ),
                  //                                   ),
                  //                                 )
                  //                               : contentItems[index]
                  //                                           .fileString !=
                  //                                       null
                  //                                   ? Container(
                  //                                       padding:
                  //                                           const EdgeInsets
                  //                                               .fromLTRB(
                  //                                               14, 10, 40, 10),
                  //                                       width: double.infinity,
                  //                                       decoration: BoxDecoration(
                  //                                           color: AppColors
                  //                                               .kPrimaryColor
                  //                                               .withValues(
                  //                                                   alpha:
                  //                                                       0.1)),
                  //                                       child: Text(
                  //                                         contentItems[index]
                  //                                             .fileString!
                  //                                             .split("/")
                  //                                             .last,
                  //                                         style:
                  //                                             Theme.of(context)
                  //                                                 .textTheme
                  //                                                 .bodyMedium
                  //                                                 ?.copyWith(
                  //                                                   color: AppColors
                  //                                                       .kPrimaryColor,
                  //                                                 ),
                  //                                       ),
                  //                                     )
                  //                                   : const SizedBox(),
                  //               Positioned(
                  //                 right: 0,
                  //                 top: 0,
                  //                 child: GestureDetector(
                  //                   behavior: HitTestBehavior.opaque,
                  //                   onTap: () {
                  //                     removeContentItem(contentItems[index]);
                  //                   },
                  //                   child: Container(
                  //                       width: 18,
                  //                       height: 18,
                  //                       margin: contentItems[index].text == null
                  //                           ? const EdgeInsets.only(
                  //                               top: 4, right: 4)
                  //                           : null,
                  //                       decoration: BoxDecoration(
                  //                           color: AppColors.kPrimaryColor,
                  //                           shape: BoxShape.circle),
                  //                       child: const Center(
                  //                           child: Icon(
                  //                         Icons.close,
                  //                         color: Colors.white,
                  //                         size: 12,
                  //                       ))),
                  //                 ),
                  //               )
                  //             ],
                  //           ),
                  //         );
                  //       },
                  //       separatorBuilder: (context, index) {
                  //         return GestureDetector(
                  //           behavior: HitTestBehavior.opaque,
                  //           onTap: () {
                  //             addContentAfter(index);
                  //             // Helpers.printLog(
                  //             //     description:
                  //             //         "CREATE_COMMENT_WIDGET_CONTENT_ITEMS_SEPARATOR_TAPPED",
                  //             //     message: "INDEX = $index");
                  //           },
                  //           child: const SizedBox(
                  //             height: 16,
                  //           ),
                  //         );
                  //       },
                  //       itemCount: contentItems.length),
                  // )),
                  // const SizedBox(
                  //   height: 16,
                  // ),
                  // Obx(
                  //   () =>
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: expandEditor ?? false
                        ? HtmlEditor(
                            controller: htmlEditorController,
                            callbacks: Callbacks(
                                onInit: htmlEditorOnInit,
                                onChangeContent: htmlEditorOnChange),
                            htmlToolbarOptions: HtmlToolbarOptions(
                              defaultToolbarButtons: const [
                                InsertButtons(
                                    link: true,
                                    picture: true,
                                    audio: false,
                                    video: false,
                                    otherFile: false,
                                    table: false,
                                    hr: true)
                              ],
                              mediaLinkInsertInterceptor:
                                  (String url, InsertFileType type) async {
                                return type == InsertFileType.image;
                              },
                              mediaUploadInterceptor: (type, file) {
                                return false;
                              },
                            ),
                          )
                        : SizedBox(
                            height: 180,
                            child: HtmlEditor(
                              controller: htmlEditorController,
                              callbacks: Callbacks(
                                  onInit: htmlEditorOnInit,
                                  onChangeContent: htmlEditorOnChange),
                              htmlToolbarOptions: HtmlToolbarOptions(
                                defaultToolbarButtons: const [
                                  InsertButtons(
                                      link: true,
                                      picture: true,
                                      audio: false,
                                      video: false,
                                      otherFile: false,
                                      table: false,
                                      hr: true)
                                ],
                                mediaLinkInsertInterceptor:
                                    (String url, InsertFileType type) async {
                                  return type == InsertFileType.image;
                                },
                                mediaUploadInterceptor: (type, file) {
                                  return false;
                                },
                              ),
                            ),
                          ),

                    // TextField(
                    //   controller: textController,
                    //   maxLines: 2,
                    //   style: Theme.of(context).textTheme.bodyMedium,
                    //   keyboardType: TextInputType.multiline,
                    //   cursorColor: Colors.black,
                    //   textCapitalization:
                    //       textCapitalization ?? TextCapitalization.none,
                    //   textInputAction: TextInputAction.newline,
                    //   decoration: InputDecoration(
                    //     hintText: (showFloatingLabel ?? false) ? '' : hint.tr,
                    //     enabled: isEnable ?? true,
                    //     hintStyle:
                    //         Theme.of(context).textTheme.bodyMedium?.copyWith(
                    //               color: Colors.black.withValues(alpha: 0.3),
                    //             ),
                    //     fillColor: textFieldBackgroundColor ?? Colors.white,
                    //     filled: true,
                    //     border: inputBorder,
                    //     errorBorder: inputBorder,
                    //     enabledBorder: inputBorder,
                    //     disabledBorder: inputBorder,
                    //     focusedBorder: inputBorder,
                    //     focusedErrorBorder: inputBorder,
                    //     contentPadding:
                    //         const EdgeInsets.fromLTRB(10, 10, 60, 10),
                    //     suffixIcon: isTextFieldEmpty.value
                    //         ? const SizedBox()
                    //         : GestureDetector(
                    //             behavior: HitTestBehavior.opaque,
                    //             onTap: addText,
                    //             child: Icon(
                    //               Icons.check,
                    //               color: AppColors.color54B435,
                    //             ),
                    //           ),
                    //   ),
                    //   inputFormatters: inputFormatter,
                    //   onChanged: onTextChanged,
                    //   focusNode: focusNode,
                    // )

                    // ),
                  ),
                  Obx(() => Visibility(
                      visible: areAttachedFilesLoading.value ||
                          attachedImages.isNotEmpty ||
                          attachedDocuments.isNotEmpty,
                      child: areAttachedFilesLoading.value
                          ? Container(
                              margin:
                                  const EdgeInsets.only(left: 10, bottom: 10),
                              width: 70,
                              height: 70,
                              child: Center(
                                child: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: AppColors.kPrimaryColor,
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 80,
                                      child: ListView.separated(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return Stack(
                                              children: [
                                                FadeInImage.assetNetwork(
                                                  width: 70,
                                                  height: 70,
                                                  placeholder:
                                                      AppImages.imgPlaceholder,
                                                  image:
                                                      AppConsts.imgInitialUrl +
                                                          attachedImages[index],
                                                  imageErrorBuilder:
                                                      (BuildContext context,
                                                          Object error,
                                                          StackTrace?
                                                              stackTrace) {
                                                    return Image.asset(
                                                      AppImages.imgPlaceholder,
                                                      width: 70,
                                                      height: 70,
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                  fit: BoxFit.cover,
                                                ),
                                                Positioned(
                                                    top: 0,
                                                    left: 0,
                                                    bottom: 0,
                                                    right: 0,
                                                    child: GestureDetector(
                                                      behavior: HitTestBehavior
                                                          .opaque,
                                                      onTap: () async {
                                                        await Clipboard.setData(
                                                            ClipboardData(
                                                                text: AppConsts
                                                                        .imgInitialUrl +
                                                                    attachedImages[
                                                                        index]));
                                                        Get.snackbar(
                                                            "success".tr,
                                                            "message_copied_to_clipboard"
                                                                .tr);
                                                      },
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white
                                                              .withValues(
                                                                  alpha: 0.6),
                                                        ),
                                                        child: Icon(
                                                          Icons.copy_rounded,
                                                          color: Colors.black
                                                              .withValues(
                                                                  alpha: 0.5),
                                                        ),
                                                      ),
                                                    )),
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: GestureDetector(
                                                    behavior:
                                                        HitTestBehavior.opaque,
                                                    onTap: () {
                                                      removeAttachedImage(
                                                          attachedImages[
                                                              index]);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      child: Container(
                                                        width: 16,
                                                        height: 16,
                                                        decoration: BoxDecoration(
                                                            color: AppColors
                                                                .kPrimaryColor,
                                                            shape: BoxShape
                                                                .circle),
                                                        child: const Center(
                                                          child: Icon(
                                                            Icons.close_rounded,
                                                            size: 12,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(
                                              width: 10,
                                            );
                                          },
                                          itemCount: attachedImages.length),
                                    ),
                                    SizedBox(
                                      height: 80,
                                      child: ListView.separated(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          padding: EdgeInsets.only(
                                              left: attachedImages.isNotEmpty
                                                  ? 10
                                                  : 0,
                                              bottom: 10),
                                          itemBuilder: (context, index) {
                                            return Stack(
                                              children: [
                                                Container(
                                                  width: 150,
                                                  height: 70,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          right: 14,
                                                          top: 14,
                                                          bottom: 10),
                                                  decoration: BoxDecoration(
                                                      color: AppColors
                                                          .kPrimaryColor
                                                          .withValues(
                                                              alpha: 0.1)),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          attachedDocuments[
                                                                  index]
                                                              .split("/")
                                                              .last,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall
                                                                  ?.copyWith(
                                                                    color: AppColors
                                                                        .kPrimaryColor,
                                                                  ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 4,
                                                      ),
                                                      Icon(
                                                        Icons.copy_rounded,
                                                        color: AppColors
                                                            .kPrimaryColor,
                                                        size: 16,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                    top: 0,
                                                    left: 0,
                                                    bottom: 0,
                                                    right: 0,
                                                    child: GestureDetector(
                                                      behavior: HitTestBehavior
                                                          .opaque,
                                                      onTap: () async {
                                                        await Clipboard.setData(
                                                            ClipboardData(
                                                                text: AppConsts
                                                                        .imgInitialUrl +
                                                                    attachedDocuments[
                                                                        index]));
                                                        Get.snackbar(
                                                            "success".tr,
                                                            "message_copied_to_clipboard"
                                                                .tr);
                                                      },
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white
                                                              .withValues(
                                                                  alpha: 0.6),
                                                        ),
                                                      ),
                                                    )),
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: GestureDetector(
                                                    behavior:
                                                        HitTestBehavior.opaque,
                                                    onTap: () {
                                                      removeAttachedDocument(
                                                          attachedDocuments[
                                                              index]);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      child: Container(
                                                        width: 16,
                                                        height: 16,
                                                        decoration: BoxDecoration(
                                                            color: AppColors
                                                                .kPrimaryColor,
                                                            shape: BoxShape
                                                                .circle),
                                                        child: const Center(
                                                          child: Icon(
                                                            Icons.close_rounded,
                                                            size: 12,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(
                                              width: 10,
                                            );
                                          },
                                          itemCount: attachedDocuments.length),
                                    )
                                  ],
                                ),
                              ),
                            ))),
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
                              onTap: clickImage,
                              child: Container(
                                width: 26,
                                height: 26,
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: AppColors.color2998BA
                                        .withValues(alpha: 0.3),
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Image.asset(
                                    AppIcons.icPhotoCamera,
                                    width: 16,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: pickImages,
                              child: Container(
                                width: 26,
                                height: 26,
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: AppColors.colorEDDEA1
                                        .withValues(alpha: 0.3),
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Image.asset(
                                    AppIcons.icImage,
                                    width: 16,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: pickVideos,
                              child: Container(
                                width: 26,
                                height: 26,
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: AppColors.colorE67E22
                                        .withValues(alpha: 0.3),
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Image.asset(
                                    AppIcons.icVideo,
                                    width: 16,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: pickFiles,
                              child: Container(
                                width: 26,
                                height: 26,
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: AppColors.colorF1C40F
                                        .withValues(alpha: 0.3),
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Image.asset(
                                    AppIcons.icDocument,
                                    width: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // isPostCreating.value || isPostEditing.value
                        //     ? Container(
                        //   height: 30,
                        //   width: 56,
                        //   padding: EdgeInsets.all(8),
                        //   child: Center(
                        //     child: SizedBox(
                        //       width: 14,
                        //       height: 14,
                        //       child: CircularProgressIndicator(
                        //         strokeWidth: 2,
                        //         color: AppColors.kPrimaryColor,
                        //       ),
                        //     ),
                        //   ),
                        // )
                        //     :
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            showCreateEditButton
                                ? Obx(
                                    () => Visibility(
                                      visible:
                                          isCreateOrEditLoading.value == false,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: CommonButtonOutline(
                                          borderColor: Colors.transparent,
                                          text: 'cancel'.tr,
                                          onClick: cancelEditing == null
                                              ? () {}
                                              : cancelEditing!,
                                          // isEnable: isPostButtonEnable,
                                          width: 64,
                                          height: 30,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: AppColors.kPrimaryColor,
                                              ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            showCreateEditButton
                                ? Obx(
                                    () => isCreateOrEditLoading.value
                                        ? Container(
                                            height: 30,
                                            width: 64,
                                            padding: const EdgeInsets.all(8),
                                            child: Center(
                                              child: SizedBox(
                                                width: 14,
                                                height: 14,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color:
                                                      AppColors.kPrimaryColor,
                                                ),
                                              ),
                                            ),
                                          )
                                        : CommonButton(
                                            text: isEditingComment != null &&
                                                    isEditingComment!.value
                                                ? 'edit'.tr
                                                : 'create'.tr,
                                            onClick: isEditingComment != null &&
                                                    isEditingComment!.value
                                                ? editComment != null
                                                    ? editComment!
                                                    : () {}
                                                : createComment != null
                                                    ? createComment!
                                                    : () {},
                                            // isEnable: isPostButtonEnable,
                                            width: 64,
                                            height: 30,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: AppColors.colorF5F5F7,
                                                ),
                                          ),
                                  )
                                : const SizedBox(),
                          ],
                        )
                      ],
                    ),
                  )
                  // Positioned(
                  //     right: 0,
                  //     top: 0,
                  //     child: GestureDetector(
                  //       behavior: HitTestBehavior.opaque,
                  //       onTap: () {
                  //         createComment();
                  //       },
                  //       child: Container(
                  //         width: 54,
                  //         height: 52,
                  //         decoration: BoxDecoration(
                  //             color: AppColors.kPrimaryColor,
                  //             borderRadius: BorderRadius.circular(4)),
                  //         child: Center(
                  //           child: Image.asset(
                  //             AppIcons.icSend,
                  //             width: 36,
                  //           ),
                  //         ),
                  //       ),
                  //     ))
                ],
              ),
            ),
            Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                right: 0,
                child: Visibility(
                  visible: isCreateOrEditLoading.value,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: borderRadius ?? BorderRadius.zero,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
