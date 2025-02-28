import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/model/media_content_model.dart';
import 'package:teqtop_team/utils/helpers.dart';

import '../../../../config/app_colors.dart';
import '../../../../consts/app_icons.dart';
import '../../../../consts/app_images.dart';
import '../../../../model/dashboard/comment_list.dart';

class CommentWidget extends StatelessWidget {
  final CommentList commentData;
  final Function(int)? onTapEdit;
  final Function(int) onTapDelete;
  final List<MediaContentModel> commentItems;
  final Function(int, int) handleImageOnTap;

  // final RxBool? isEditLoading;

  final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.transparent, width: 0));

  CommentWidget({
    super.key,
    required this.commentData,
    this.onTapEdit,
    // this.isEditLoading,
    required this.onTapDelete,
    required this.commentItems,
    required this.handleImageOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage(AppImages.imgPersonPlaceholder),
                foregroundImage: commentData.profile != null
                    ? NetworkImage(
                        AppConsts.imgInitialUrl + commentData.profile!)
                    : AssetImage(AppImages.imgPersonPlaceholder),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: commentData.userName ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  WidgetSpan(
                      child: const SizedBox(
                    width: 4,
                  )),
                  TextSpan(
                      text: commentData.createdAt != null
                          ? Helpers.formatTimeAgo(commentData.createdAt!)
                          : "",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black.withValues(alpha: 0.5),
                          fontSize: AppConsts.commonFontSizeFactor * 14))
                ])),
              ),
              PopupMenuButton(
                  padding: EdgeInsets.zero,
                  menuPadding: EdgeInsets.zero,
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  style: IconButton.styleFrom(
                      splashFactory: NoSplash.splashFactory),
                  icon: SvgPicture.asset(
                    AppIcons.icMoreHorizontal,
                    width: 18,
                  ),
                  onSelected: (value) {
                    if (commentData.id != null) {
                      if (value == "delete".tr) {
                        onTapDelete(commentData.id!);
                      }
                      if (value == "edit".tr) {
                        onTapEdit!(commentData.id!);
                      }
                    }
                  },
                  itemBuilder: (context) => [
                        if (onTapEdit != null)
                          PopupMenuItem(
                              value: "edit".tr,
                              padding: EdgeInsets.only(left: 16),
                              child: Text(
                                "edit".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        fontSize:
                                            AppConsts.commonFontSizeFactor *
                                                14),
                              )),
                        PopupMenuItem(
                            value: "delete".tr,
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              "delete".tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontSize:
                                          AppConsts.commonFontSizeFactor * 14),
                            ))
                      ])
            ],
          ),
          // Obx(
          //   () => commentData.isEditing.value
          //       ? SizedBox(
          //           height: 19,
          //           child: TextField(
          //             controller: commentData.editController,
          //             style: Theme.of(context).textTheme.bodySmall?.copyWith(
          //                 fontSize: AppConsts.commonFontSizeFactor * 14),
          //             keyboardType: TextInputType.text,
          //             cursorColor: Colors.black,
          //             textCapitalization: TextCapitalization.none,
          //             focusNode: commentData.focusNode,
          //             onChanged: (value) {
          //               if (value.isNotEmpty) {
          //                 commentData.showTextFieldSuffix.value = true;
          //               } else {
          //                 commentData.showTextFieldSuffix.value = false;
          //               }
          //             },
          //             decoration: InputDecoration(
          //                 hintText: 'edit_comment'.tr,
          //                 enabled: true,
          //                 hintStyle: Theme.of(context)
          //                     .textTheme
          //                     .bodySmall
          //                     ?.copyWith(
          //                       fontSize: AppConsts.commonFontSizeFactor * 14,
          //                       color: Colors.black.withValues(alpha: 0.3),
          //                     ),
          //                 fillColor: Colors.white,
          //                 filled: true,
          //                 border: inputBorder,
          //                 errorBorder: inputBorder,
          //                 enabledBorder: inputBorder,
          //                 disabledBorder: inputBorder,
          //                 focusedBorder: inputBorder,
          //                 focusedErrorBorder: inputBorder,
          //                 suffixIcon:
          //                     isEditLoading != null && isEditLoading!.value
          //                         ? Container(
          //                             height: 18,
          //                             width: 48,
          //                             padding: const EdgeInsets.symmetric(
          //                                 horizontal: 15, vertical: 0),
          //                             child: CircularProgressIndicator(
          //                               strokeWidth: 2,
          //                               color: AppColors.kPrimaryColor,
          //                             ),
          //                           )
          //                         : commentData.showTextFieldSuffix.value
          //                             ? GestureDetector(
          //                                 behavior: HitTestBehavior.opaque,
          //                                 onTap: () {
          //                                   if (commentData.id != null &&
          //                                       editComment != null) {
          //                                     editComment!(commentData.id!);
          //                                   }
          //                                 },
          //                                 child: Icon(
          //                                   Icons.check,
          //                                   color: AppColors.color54B435,
          //                                 ),
          //                               )
          //                             : const SizedBox(),
          //                 contentPadding: EdgeInsets.only(
          //                     left: 38, right: 0, top: 0, bottom: 0)),
          //           ),
          //         )
          //       :
          ListView.separated(
              padding: const EdgeInsets.only(left: 38),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return commentItems[index].text != null
                    ? SelectableText(
                        commentItems[index].text!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: AppConsts.commonFontSizeFactor * 14),
                      )
                    : commentItems[index].imageString != null &&
                            commentItems[index].downloadedImage != null
                        ? GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (commentData.id != null) {
                                handleImageOnTap(commentData.id!, index);
                              }
                            },
                            child: Image.file(
                              commentItems[index].downloadedImage!,
                              height: 250,
                              fit: BoxFit.contain,
                            ))
                        : commentItems[index].fileString != null
                            ? GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  if (commentItems[index]
                                      .fileString!
                                      .isNotEmpty) {
                                    commentItems[index].isFileLoading.value =
                                        true;
                                    commentItems[index].isFileLoading.refresh();
                                    await Helpers.openFile(
                                        path: commentItems[index].fileString!,
                                        fileName: commentItems[index]
                                            .fileString!
                                            .split("/")
                                            .last);
                                    commentItems[index].isFileLoading.value =
                                        false;
                                    commentItems[index].isFileLoading.refresh();
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(14, 10, 10, 10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: AppColors.kPrimaryColor
                                          .withValues(alpha: 0.1)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          commentItems[index]
                                              .fileString!
                                              .split("/")
                                              .last,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: AppColors.kPrimaryColor,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Obx(() => commentItems[index]
                                                .isFileLoading
                                                .value
                                            ? Container(
                                                height: 24,
                                                width: 24,
                                                padding: EdgeInsets.all(4),
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color:
                                                      AppColors.kPrimaryColor,
                                                ),
                                              )
                                            : SvgPicture.asset(
                                                AppIcons.icDownload,
                                                width: 24,
                                                colorFilter: ColorFilter.mode(
                                                    AppColors.kPrimaryColor,
                                                    BlendMode.srcIn),
                                              )),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox();
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemCount: commentItems.length),

          // )
        ],
      ),
    );
  }
}
