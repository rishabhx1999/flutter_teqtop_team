import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/model/drive_detail/file_model.dart';
import 'package:teqtop_team/utils/helpers.dart';

import '../../../../config/app_colors.dart';
import '../../../../consts/app_icons.dart';
import '../../../../consts/app_images.dart';
import '../../../../model/dashboard/comment_list.dart';

class CommentWidget extends StatelessWidget {
  final CommentList commentData;
  final Function(int)? onTapEdit;
  final Function(int) onTapDelete;
  final Function(int, String?) handleImageOnTap;
  final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.transparent, width: 0));

  CommentWidget({
    super.key,
    required this.commentData,
    this.onTapEdit,
    required this.onTapDelete,
    required this.handleImageOnTap,
  });

  @override
  Widget build(BuildContext context) {
    List<String> images = [];
    List<FileModel> documents = [];

    if (commentData.comment != null) {
      commentData.comment = Helpers.updateHtmlAttributes(
          commentData.comment!.replaceAll(r'\"', '"').replaceAll(r'\\', ''));
      if (commentData.comment!.length >= 2 &&
          commentData.comment!.startsWith('"') &&
          commentData.comment!.endsWith('"')) {
        commentData.comment =
            commentData.comment!.substring(1, commentData.comment!.length - 1);
      }
      Helpers.printLog(
          description: "COMMENT_WIDGET_BUILD",
          message: "COMMENT = ${commentData.comment}");
    }

    Helpers.printLog(
        description: "COMMENT_WIDGET_BUILD",
        message: "FILES_PARAM = ${commentData.files.toString()}");
    if (commentData.files is String && commentData.files.isNotEmpty) {
      var decode = json.decode(commentData.files);
      Helpers.printLog(
          description: "COMMENT_WIDGET_BUILD",
          message: "FILES_IS_STRING ===== DECODE_FILES_PARAM = $decode");
      if (decode != null) {
        var files = List<String>.from(decode);
        for (var file in files) {
          if (Helpers.isImage(file)) {
            images.add(file);
          } else {
            documents.add(FileModel(file: file));
          }
        }
        Helpers.printLog(
            description: "COMMENT_WIDGET_BUILD",
            message:
                "FILES_IS_STRING ===== IMAGES = ${images.toString()} ===== DOCUMENTS = ${documents.toString()}");
      }
    } else if (commentData.files is List && commentData.files.isNotEmpty) {
      var files = commentData.files;
      for (var file in files) {
        if (Helpers.isImage(file)) {
          images.add(file);
        } else {
          documents.add(file);
        }
      }
      Helpers.printLog(
          description: "COMMENT_WIDGET_BUILD",
          message:
              "FILES_IS_LIST ===== IMAGES = ${images.toString()} ===== DOCUMENTS = ${documents.toString()}");
    }

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
                backgroundImage:
                    const AssetImage(AppImages.imgPersonPlaceholder),
                foregroundImage: commentData.profile != null
                    ? NetworkImage(
                        AppConsts.imgInitialUrl + commentData.profile!)
                    : const AssetImage(AppImages.imgPersonPlaceholder),
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
                  const WidgetSpan(
                      child: SizedBox(
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
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero),
                  style: IconButton.styleFrom(
                      splashFactory: NoSplash.splashFactory),
                  icon: Image.asset(
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
                              padding: const EdgeInsets.only(left: 16),
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
                            padding: const EdgeInsets.only(left: 16),
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
          commentData.comment != null && commentData.comment!.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Html(
                    data: commentData.comment,
                    onLinkTap: (url, attributes, element) {
                      if (url != null) {
                        Helpers.openLink(url);
                      }
                    },
                  ),
                )
              : const SizedBox(),
          Visibility(
            visible: images.isNotEmpty || documents.isNotEmpty,
            child: Container(
              margin: const EdgeInsets.only(top: 10, left: 38),
              height: 2,
              width: 120,
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ),
          Visibility(
              visible: images.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(left: 38, right: 8),
                child: SizedBox(
                  height: 100,
                  child: ListView.separated(
                      padding: const EdgeInsets.only(top: 10),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (commentData.id != null) {
                              handleImageOnTap(commentData.id!, images[index]);
                            }
                          },
                          child: FadeInImage.assetNetwork(
                            width: 90,
                            height: 90,
                            placeholder: AppImages.imgPlaceholder,
                            image: AppConsts.imgInitialUrl + images[index],
                            imageErrorBuilder: (BuildContext context,
                                Object error, StackTrace? stackTrace) {
                              return Image.asset(
                                AppImages.imgPlaceholder,
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              );
                            },
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          width: 10,
                        );
                      },
                      itemCount: images.length),
                ),
              )),
          Visibility(
              visible: documents.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(left: 38, right: 8),
                child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 10),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          documents[index].isLoading.value = true;
                          await Helpers.openFile(
                              path: documents[index].file,
                              fileName: documents[index].file.split("/").last);
                          documents[index].isLoading.value = false;
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              color: AppColors.kPrimaryColor
                                  .withValues(alpha: 0.1)),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  documents[index].file.split("/").last,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.kPrimaryColor,
                                      ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Obx(() => documents[index].isLoading.value
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.kPrimaryColor),
                                    )
                                  : Image.asset(
                                      AppIcons.icDownload,
                                      width: 20,
                                    ))
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    itemCount: documents.length),
              )),
        ],
      ),
    );
  }
}
