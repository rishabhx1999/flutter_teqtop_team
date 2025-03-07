import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/consts/app_icons.dart';
import 'package:teqtop_team/model/dashboard/feed_model.dart';
import 'package:teqtop_team/model/drive_detail/file_model.dart';
import 'package:teqtop_team/utils/helpers.dart';

import '../../../../config/app_colors.dart';
import '../../../../consts/app_images.dart';
import '../../../../model/media_content_model.dart';

class PostWidget extends StatelessWidget {
  final Function()? commentOnTap;
  final FeedModel postData;
  final RxInt activeIndex = 0.obs;
  final Function(int) toggleLike;
  final Function(int) handleOnTapDelete;
  final Function(int) handleOnTapEdit;
  final Function(int, String?) handleImageOnTap;
  final List<MediaContentModel> postItems;

  PostWidget({
    super.key,
    this.commentOnTap,
    required this.postData,
    required this.toggleLike,
    required this.handleOnTapDelete,
    required this.handleOnTapEdit,
    required this.postItems,
    required this.handleImageOnTap,
  });

  @override
  Widget build(BuildContext context) {
    List<String> images = [];
    List<FileModel> documents = [];

    if (postData.description != null) {
      postData.description =
          Helpers.updateHtmlAttributes(postData.description!);
    }

    if (postData.files is String && postData.files.isNotEmpty) {
      var decode = json.decode(postData.files);
      if (decode != null) {
        var files = List<String>.from(decode);
        for (var file in files) {
          if (Helpers.isImage(file)) {
            images.add(file);
          } else {
            documents.add(FileModel(file: file));
          }
        }
      }
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0),
          border:
              Border.all(color: Colors.black.withValues(alpha: 0.05), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              offset: const Offset(0, 0),
              blurRadius: 7,
              spreadRadius: 0,
            ),
          ]),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundImage:
                          const AssetImage(AppImages.imgPersonPlaceholder),
                      foregroundImage: postData.userProfile != null &&
                              postData.userProfile!.isNotEmpty
                          ? NetworkImage(
                              AppConsts.imgInitialUrl + postData.userProfile!)
                          : const AssetImage(AppImages.imgPersonPlaceholder),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: postData.userName ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    fontSize:
                                        AppConsts.commonFontSizeFactor * 18)),
                        const WidgetSpan(
                            child: SizedBox(
                          width: 4,
                        )),
                        TextSpan(
                            text: postData.createdAt != null
                                ? Helpers.formatTimeAgo(postData.createdAt!)
                                : "",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.black.withValues(alpha: 0.5),
                                ))
                      ])),
                    ),
                  ],
                ),
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
                    if (postData.id != null) {
                      if (value == "delete".tr) {
                        handleOnTapDelete(postData.id!);
                      }
                      if (value == "edit".tr) {
                        handleOnTapEdit(postData.id!);
                      }
                    }
                  },
                  itemBuilder: (context) => [
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
                                          AppConsts.commonFontSizeFactor * 14),
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
          const SizedBox(
            height: 2,
          ),
          postData.description != null && postData.description!.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: Html(
                    data: postData.description,
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
              margin: const EdgeInsets.only(top: 10, left: 36),
              height: 2,
              width: 120,
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ),
          Visibility(
              visible: images.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(left: 36, right: 8),
                child: SizedBox(
                  height: 100,
                  child: ListView.separated(
                      padding: const EdgeInsets.only(right: 10, top: 10),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (postData.id != null) {
                              handleImageOnTap(postData.id!, images[index]);
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
                                width: 70,
                                height: 70,
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
                padding: const EdgeInsets.only(left: 36, right: 8),
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
                              Obx(
                                () => documents[index].isLoading.value
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
                                      ),
                              )
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

          // ListView.separated(
          //     padding: const EdgeInsets.only(left: 36),
          //     physics: NeverScrollableScrollPhysics(),
          //     shrinkWrap: true,
          //     itemBuilder: (context, index) {
          //       return postItems[index].text != null
          //           ? SelectableText(
          //               postItems[index].text!,
          //               style: Theme.of(context).textTheme.bodySmall?.copyWith(
          //                   fontSize: AppConsts.commonFontSizeFactor * 14),
          //             )
          //           : postItems[index].imageString != null &&
          //                   postItems[index].downloadedImage != null
          //               ? GestureDetector(
          //                   behavior: HitTestBehavior.opaque,
          //                   onTap: () {
          //                     handleImageOnTap(postData.id!, index);
          //                   },
          //                   child: Image.file(
          //                     postItems[index].downloadedImage!,
          //                     height: 250,
          //                     fit: BoxFit.contain,
          //                   ),
          //                 )
          //               : postItems[index].fileString != null
          //                   ? GestureDetector(
          //                       behavior: HitTestBehavior.opaque,
          //                       onTap: () async {
          //                         if (postItems[index].fileString!.isNotEmpty) {
          //                           postItems[index].isFileLoading.value = true;
          //                           postItems[index].isFileLoading.refresh();
          //                           await Helpers.openFile(
          //                               path: postItems[index].fileString!,
          //                               fileName: postItems[index]
          //                                   .fileString!
          //                                   .split("/")
          //                                   .last);
          //                           postItems[index].isFileLoading.value =
          //                               false;
          //                           postItems[index].isFileLoading.refresh();
          //                         }
          //                       },
          //                       child: Container(
          //                         padding: EdgeInsets.fromLTRB(14, 10, 10, 10),
          //                         width: double.infinity,
          //                         decoration: BoxDecoration(
          //                             color: AppColors.kPrimaryColor
          //                                 .withValues(alpha: 0.1)),
          //                         child: Row(
          //                           mainAxisSize: MainAxisSize.max,
          //                           mainAxisAlignment: MainAxisAlignment.start,
          //                           crossAxisAlignment:
          //                               CrossAxisAlignment.center,
          //                           children: [
          //                             Expanded(
          //                               child: Text(
          //                                 postItems[index]
          //                                     .fileString!
          //                                     .split("/")
          //                                     .last,
          //                                 style: Theme.of(context)
          //                                     .textTheme
          //                                     .bodySmall
          //                                     ?.copyWith(
          //                                       color: AppColors.kPrimaryColor,
          //                                     ),
          //                               ),
          //                             ),
          //                             const SizedBox(
          //                               width: 12,
          //                             ),
          //                             Padding(
          //                               padding: const EdgeInsets.all(4.0),
          //                               child: Obx(() => postItems[index]
          //                                       .isFileLoading
          //                                       .value
          //                                   ? Container(
          //                                       height: 24,
          //                                       width: 24,
          //                                       padding: EdgeInsets.all(4),
          //                                       child:
          //                                           CircularProgressIndicator(
          //                                         strokeWidth: 2,
          //                                         color:
          //                                             AppColors.kPrimaryColor,
          //                                       ),
          //                                     )
          //                                   : Image.asset(
          //                                       AppIcons.icDownload,
          //                                       width: 24,
          //                                       colorFilter: ColorFilter.mode(
          //                                           AppColors.kPrimaryColor,
          //                                           BlendMode.srcIn),
          //                                     )),
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                     )
          //                   : const SizedBox();
          //     },
          //     separatorBuilder: (context, index) {
          //       return const SizedBox(
          //         height: 10,
          //       );
          //     },
          //     itemCount: postItems.length),

          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 12, left: 36),
            height: 1,
            width: 238,
            color: Colors.black.withValues(alpha: 0.1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 36,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (postData.id != null) {
                    toggleLike(postData.id!);
                  }
                },
                child: SizedBox(
                  width: 68,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        postData.likedBy == 1
                            ? AppIcons.icLikeFilled
                            : AppIcons.icLike,
                        width: 24,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: Text(
                          postData.likeUsers != null &&
                                  postData.likeUsers!.isNotEmpty
                              ? postData.likeUsers!.length.toString()
                              : postData.likedBy == 1
                                  ? "1"
                                  : "0",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              GestureDetector(
                onTap: commentOnTap,
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 68,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AppIcons.icComment,
                        width: 24,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: Text(
                          postData.commentCount != null
                              ? postData.commentCount!.length.toString()
                              : "0",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
