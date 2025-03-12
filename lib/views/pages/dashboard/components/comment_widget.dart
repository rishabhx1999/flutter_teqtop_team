import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as html_parser;

import 'package:get/get.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/model/drive_detail/file_model.dart';
import 'package:teqtop_team/utils/helpers.dart';

import '../../../../config/app_colors.dart';
import '../../../../consts/app_icons.dart';
import '../../../../consts/app_images.dart';
import '../../../../model/dashboard/comment_list.dart';

class CommentWidget extends StatefulWidget {
  final CommentList commentData;
  final Function(int)? onTapEdit;
  final Function(int) onTapDelete;
  final Function(int, String?) handleImageOnTap;
  final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.transparent, width: 0));

  CommentWidget(
      {super.key,
      required this.commentData,
      this.onTapEdit,
      required this.onTapDelete,
      required this.handleImageOnTap});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<String> images = [];
    List<FileModel> documents = [];

    if (widget.commentData.comment != null) {
      widget.commentData.comment = Helpers.updateHtmlAttributes(widget
          .commentData.comment!
          .replaceAll(r'\"', '"')
          .replaceAll(r'\\', ''));
      if (widget.commentData.comment!.length >= 2 &&
          widget.commentData.comment!.startsWith('"') &&
          widget.commentData.comment!.endsWith('"')) {
        widget.commentData.comment = widget.commentData.comment!
            .substring(1, widget.commentData.comment!.length - 1);
      }
      widget.commentData.comment =
          Helpers.updateImgStyles(widget.commentData.comment!);
      // Helpers.printLog(
      //     description: "COMMENT_WIDGET_BUILD",
      //     message: "COMMENT = ${widget.commentData.comment}");
    }

    // Helpers.printLog(
    //     description: "COMMENT_WIDGET_BUILD",
    //     message: "FILES_PARAM = ${widget.commentData.files.toString()}");
    if (widget.commentData.files is String &&
        widget.commentData.files.isNotEmpty) {
      var decode = json.decode(widget.commentData.files);
      // Helpers.printLog(
      //     description: "COMMENT_WIDGET_BUILD",
      //     message: "FILES_IS_STRING ===== DECODE_FILES_PARAM = $decode");
      if (decode != null) {
        var files = List<String>.from(decode);
        for (var file in files) {
          if (Helpers.isImage(file)) {
            images.add(file);
          } else {
            documents.add(FileModel(file: file));
          }
        }
        // Helpers.printLog(
        //     description: "COMMENT_WIDGET_BUILD",
        //     message:
        //         "FILES_IS_STRING ===== IMAGES = ${images.toString()} ===== DOCUMENTS = ${documents.toString()}");
      }
    } else if (widget.commentData.files is List &&
        widget.commentData.files.isNotEmpty) {
      var files = widget.commentData.files;
      for (var file in files) {
        if (Helpers.isImage(file)) {
          images.add(file);
        } else {
          documents.add(file);
        }
      }
      // Helpers.printLog(
      //     description: "COMMENT_WIDGET_BUILD",
      //     message:
      //         "FILES_IS_LIST ===== IMAGES = ${images.toString()} ===== DOCUMENTS = ${documents.toString()}");
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
                foregroundImage: widget.commentData.profile != null
                    ? NetworkImage(
                        AppConsts.imgInitialUrl + widget.commentData.profile!)
                    : const AssetImage(AppImages.imgPersonPlaceholder),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: widget.commentData.userName ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const WidgetSpan(
                      child: SizedBox(
                    width: 4,
                  )),
                  TextSpan(
                      text: widget.commentData.createdAt != null
                          ? Helpers.formatTimeAgo(widget.commentData.createdAt!)
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
                    if (widget.commentData.id != null) {
                      if (value == "delete".tr) {
                        widget.onTapDelete(widget.commentData.id!);
                      }
                      if (value == "edit".tr) {
                        widget.onTapEdit!(widget.commentData.id!);
                      }
                    }
                  },
                  itemBuilder: (context) => [
                        if (widget.onTapEdit != null)
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
          widget.commentData.comment != null &&
                  widget.commentData.comment!.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Html(
                          data: widget.commentData.comment,
                          onLinkTap: (url, attributes, element) {
                            if (url != null) {
                              Helpers.openLink(url);
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          String plainText = html_parser
                                  .parse(widget.commentData.comment)
                                  .body
                                  ?.children
                                  .map((e) => e.text)
                                  .join("\n") ??
                              "";
                          Clipboard.setData(ClipboardData(text: plainText));
                          Get.snackbar(
                              "success".tr, "message_copied_to_clipboard".tr);
                        },
                        child: const Icon(
                          Icons.copy_rounded,
                          color: Colors.black,
                          size: 24,
                        ),
                      )
                    ],
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
                            if (widget.commentData.id != null) {
                              widget.handleImageOnTap(
                                  widget.commentData.id!, images[index]);
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

// class CommentWidget extends StatelessWidget {
//   final CommentList widget.commentData;
//   final Function(int)? onTapEdit;
//   final Function(int) onTapDelete;
//   final Function(int, String?) handleImageOnTap;
//   final inputBorder = OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10),
//       borderSide: const BorderSide(color: Colors.transparent, width: 0));
//
//   CommentWidget({
//     super.key,
//     required this.widget.commentData,
//     this.onTapEdit,
//     required this.onTapDelete,
//     required this.handleImageOnTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     List<String> images = [];
//     List<FileModel> documents = [];
//
//     if (widget.commentData.comment != null) {
//       widget.commentData.comment = Helpers.updateHtmlAttributes(
//           widget.commentData.comment!.replaceAll(r'\"', '"').replaceAll(r'\\', ''));
//       if (widget.commentData.comment!.length >= 2 &&
//           widget.commentData.comment!.startsWith('"') &&
//           widget.commentData.comment!.endsWith('"')) {
//         widget.commentData.comment =
//             widget.commentData.comment!.substring(1, widget.commentData.comment!.length - 1);
//       }
//       widget.commentData.comment = Helpers.updateImgStyles(widget.commentData.comment!);
//       // Helpers.printLog(
//       //     description: "COMMENT_WIDGET_BUILD",
//       //     message: "COMMENT = ${widget.commentData.comment}");
//     }
//
//     // Helpers.printLog(
//     //     description: "COMMENT_WIDGET_BUILD",
//     //     message: "FILES_PARAM = ${widget.commentData.files.toString()}");
//     if (widget.commentData.files is String && widget.commentData.files.isNotEmpty) {
//       var decode = json.decode(widget.commentData.files);
//       // Helpers.printLog(
//       //     description: "COMMENT_WIDGET_BUILD",
//       //     message: "FILES_IS_STRING ===== DECODE_FILES_PARAM = $decode");
//       if (decode != null) {
//         var files = List<String>.from(decode);
//         for (var file in files) {
//           if (Helpers.isImage(file)) {
//             images.add(file);
//           } else {
//             documents.add(FileModel(file: file));
//           }
//         }
//         // Helpers.printLog(
//         //     description: "COMMENT_WIDGET_BUILD",
//         //     message:
//         //         "FILES_IS_STRING ===== IMAGES = ${images.toString()} ===== DOCUMENTS = ${documents.toString()}");
//       }
//     } else if (widget.commentData.files is List && widget.commentData.files.isNotEmpty) {
//       var files = widget.commentData.files;
//       for (var file in files) {
//         if (Helpers.isImage(file)) {
//           images.add(file);
//         } else {
//           documents.add(file);
//         }
//       }
//       // Helpers.printLog(
//       //     description: "COMMENT_WIDGET_BUILD",
//       //     message:
//       //         "FILES_IS_LIST ===== IMAGES = ${images.toString()} ===== DOCUMENTS = ${documents.toString()}");
//     }
//
//     return SizedBox(
//       width: double.infinity,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircleAvatar(
//                 radius: 15,
//                 backgroundImage:
//                     const AssetImage(AppImages.imgPersonPlaceholder),
//                 foregroundImage: widget.commentData.profile != null
//                     ? NetworkImage(
//                         AppConsts.imgInitialUrl + widget.commentData.profile!)
//                     : const AssetImage(AppImages.imgPersonPlaceholder),
//               ),
//               const SizedBox(
//                 width: 8,
//               ),
//               Expanded(
//                 child: RichText(
//                     text: TextSpan(children: [
//                   TextSpan(
//                     text: widget.commentData.userName ?? "",
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                   const WidgetSpan(
//                       child: SizedBox(
//                     width: 4,
//                   )),
//                   TextSpan(
//                       text: widget.commentData.createdAt != null
//                           ? Helpers.formatTimeAgo(widget.commentData.createdAt!)
//                           : "",
//                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                           color: Colors.black.withValues(alpha: 0.5),
//                           fontSize: AppConsts.commonFontSizeFactor * 14))
//                 ])),
//               ),
//               PopupMenuButton(
//                   padding: EdgeInsets.zero,
//                   menuPadding: EdgeInsets.zero,
//                   shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.zero),
//                   style: IconButton.styleFrom(
//                       splashFactory: NoSplash.splashFactory),
//                   icon: Image.asset(
//                     AppIcons.icMoreHorizontal,
//                     width: 18,
//                   ),
//                   onSelected: (value) {
//                     if (widget.commentData.id != null) {
//                       if (value == "delete".tr) {
//                         onTapDelete(widget.commentData.id!);
//                       }
//                       if (value == "edit".tr) {
//                         onTapEdit!(widget.commentData.id!);
//                       }
//                     }
//                   },
//                   itemBuilder: (context) => [
//                         if (onTapEdit != null)
//                           PopupMenuItem(
//                               value: "edit".tr,
//                               padding: const EdgeInsets.only(left: 16),
//                               child: Text(
//                                 "edit".tr,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyLarge
//                                     ?.copyWith(
//                                         fontSize:
//                                             AppConsts.commonFontSizeFactor *
//                                                 14),
//                               )),
//                         PopupMenuItem(
//                             value: "delete".tr,
//                             padding: const EdgeInsets.only(left: 16),
//                             child: Text(
//                               "delete".tr,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .bodyLarge
//                                   ?.copyWith(
//                                       fontSize:
//                                           AppConsts.commonFontSizeFactor * 14),
//                             ))
//                       ])
//             ],
//           ),
//           widget.commentData.comment != null && widget.commentData.comment!.isNotEmpty
//               ? Padding(
//                   padding: const EdgeInsets.only(left: 30),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: Html(
//                           data: widget.commentData.comment,
//                           onLinkTap: (url, attributes, element) {
//                             if (url != null) {
//                               Helpers.openLink(url);
//                             }
//                           },
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 12,
//                       ),
//                       GestureDetector(
//                         behavior: HitTestBehavior.opaque,
//                         onTap: () {
//                           String plainText = html_parser
//                                   .parse(widget.commentData.comment)
//                                   .body
//                                   ?.children
//                                   .map((e) => e.text)
//                                   .join("\n") ??
//                               "";
//                           Clipboard.setData(ClipboardData(text: plainText));
//                           Get.snackbar(
//                               "success".tr, "message_copied_to_clipboard".tr);
//                         },
//                         child: const Icon(
//                           Icons.copy_rounded,
//                           color: Colors.black,
//                           size: 24,
//                         ),
//                       )
//                     ],
//                   ),
//                 )
//               : const SizedBox(),
//           Visibility(
//             visible: images.isNotEmpty || documents.isNotEmpty,
//             child: Container(
//               margin: const EdgeInsets.only(top: 10, left: 38),
//               height: 2,
//               width: 120,
//               color: Colors.black.withValues(alpha: 0.1),
//             ),
//           ),
//           Visibility(
//               visible: images.isNotEmpty,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 38, right: 8),
//                 child: SizedBox(
//                   height: 100,
//                   child: ListView.separated(
//                       padding: const EdgeInsets.only(top: 10),
//                       physics: const BouncingScrollPhysics(),
//                       shrinkWrap: true,
//                       scrollDirection: Axis.horizontal,
//                       itemBuilder: (context, index) {
//                         return GestureDetector(
//                           behavior: HitTestBehavior.opaque,
//                           onTap: () {
//                             if (widget.commentData.id != null) {
//                               handleImageOnTap(widget.commentData.id!, images[index]);
//                             }
//                           },
//                           child: FadeInImage.assetNetwork(
//                             width: 90,
//                             height: 90,
//                             placeholder: AppImages.imgPlaceholder,
//                             image: AppConsts.imgInitialUrl + images[index],
//                             imageErrorBuilder: (BuildContext context,
//                                 Object error, StackTrace? stackTrace) {
//                               return Image.asset(
//                                 AppImages.imgPlaceholder,
//                                 width: 90,
//                                 height: 90,
//                                 fit: BoxFit.cover,
//                               );
//                             },
//                             fit: BoxFit.cover,
//                           ),
//                         );
//                       },
//                       separatorBuilder: (context, index) {
//                         return const SizedBox(
//                           width: 10,
//                         );
//                       },
//                       itemCount: images.length),
//                 ),
//               )),
//           Visibility(
//               visible: documents.isNotEmpty,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 38, right: 8),
//                 child: ListView.separated(
//                     physics: const NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     padding: const EdgeInsets.only(top: 10),
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         behavior: HitTestBehavior.opaque,
//                         onTap: () async {
//                           documents[index].isLoading.value = true;
//                           await Helpers.openFile(
//                               path: documents[index].file,
//                               fileName: documents[index].file.split("/").last);
//                           documents[index].isLoading.value = false;
//                         },
//                         child: Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.only(
//                               left: 10, right: 10, top: 10, bottom: 10),
//                           decoration: BoxDecoration(
//                               color: AppColors.kPrimaryColor
//                                   .withValues(alpha: 0.1)),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.max,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   documents[index].file.split("/").last,
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 2,
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodySmall
//                                       ?.copyWith(
//                                         color: AppColors.kPrimaryColor,
//                                       ),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 10,
//                               ),
//                               Obx(() => documents[index].isLoading.value
//                                   ? SizedBox(
//                                       width: 20,
//                                       height: 20,
//                                       child: CircularProgressIndicator(
//                                           strokeWidth: 2,
//                                           color: AppColors.kPrimaryColor),
//                                     )
//                                   : Image.asset(
//                                       AppIcons.icDownload,
//                                       width: 20,
//                                     ))
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                     separatorBuilder: (context, index) {
//                       return const SizedBox(
//                         height: 10,
//                       );
//                     },
//                     itemCount: documents.length),
//               )),
//         ],
//       ),
//     );
//   }
// }
