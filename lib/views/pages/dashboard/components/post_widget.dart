import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/consts/app_icons.dart';
import 'package:teqtop_team/model/dashboard/feed_model.dart';
import 'package:teqtop_team/model/dashboard/post_image_model.dart';
import 'package:teqtop_team/utils/helpers.dart';

import '../../../../consts/app_images.dart';

class PostWidget extends StatelessWidget {
  final Function()? commentOnTap;
  final FeedModel postData;

  // final List<String> images = [];
  // final List<String> documents = [];
  final RxInt activeIndex = 0.obs;
  final Function(int) toggleLike;
  final List<PostImageModel>? images;
  final List<String>? documents;
  final Function(int) handleOnTapDelete;
  final Function(int) handleOnTapEdit;

  PostWidget({
    super.key,
    this.commentOnTap,
    required this.postData,
    required this.toggleLike,
    this.images,
    this.documents,
    required this.handleOnTapDelete,
    required this.handleOnTapEdit,
  });

  // void getImages() {
  //   var extractedImages = Helpers.extractImages(postData.description ?? "");
  //   for (var image in extractedImages) {
  //     if (!images.contains(image)) {
  //       images.add(image);
  //     }
  //   }
  //
  //   if (postData.files != null && postData.files!.isNotEmpty) {
  //     try {
  //       List<String> extractedFiles = postData.files!
  //           .where((file) => file != null)
  //           .cast<String>()
  //           .toList();
  //
  //       for (var file in extractedFiles) {
  //         if (Helpers.isImage(file) && !images.contains(file)) {
  //           images.add(file);
  //         } else {
  //           documents.add(file);
  //         }
  //       }
  //     } catch (e) {
  //       debugPrint('Error parsing files: $e');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // getImages();

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
                          AssetImage(AppImages.imgPersonPlaceholder),
                      foregroundImage: postData.userProfile != null &&
                              postData.userProfile!.isNotEmpty
                          ? NetworkImage(
                              AppConsts.imgInitialUrl + postData.userProfile!)
                          : AssetImage(AppImages.imgPersonPlaceholder),
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
                        WidgetSpan(
                            child: const SizedBox(
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
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  style: IconButton.styleFrom(
                      splashFactory: NoSplash.splashFactory),
                  icon: SvgPicture.asset(
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
                            padding: EdgeInsets.only(left: 16),
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
          const SizedBox(
            height: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                width: 36,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(
                      visible: Helpers.cleanHtml(postData.description ?? "")
                          .isNotEmpty,
                      child: Text(
                        Helpers.cleanHtml(postData.description ?? ""),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    Visibility(
                      visible: images != null && images!.isNotEmpty,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          images != null && images!.length == 1
                              ? AspectRatio(
                                  aspectRatio: 1 / 1,
                                  child: FadeInImage.assetNetwork(
                                    placeholder: AppImages.imgPlaceholder,
                                    image: AppConsts.imgInitialUrl +
                                        images![0].image,
                                    imageErrorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      return Image.asset(
                                          AppImages.imgPlaceholder);
                                    },
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : images != null && images!.isNotEmpty
                                  ? CarouselSlider(
                                      items: images!.map((image) {
                                        return GestureDetector(
                                          child: AspectRatio(
                                            aspectRatio: 1 / 1,
                                            child: FadeInImage.assetNetwork(
                                              placeholder:
                                                  AppImages.imgPlaceholder,
                                              image: AppConsts.imgInitialUrl +
                                                  image.image,
                                              imageErrorBuilder:
                                                  (BuildContext context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                return Image.asset(
                                                    AppImages.imgPlaceholder);
                                              },
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      options: CarouselOptions(
                                        aspectRatio: 1 / 1,
                                        viewportFraction: 1,
                                        initialPage: 0,
                                        enableInfiniteScroll: true,
                                        reverse: false,
                                        autoPlay: false,
                                        autoPlayInterval:
                                            const Duration(seconds: 3),
                                        autoPlayAnimationDuration:
                                            const Duration(milliseconds: 800),
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        enlargeCenterPage: true,
                                        onPageChanged: (index, reason) {
                                          activeIndex.value = index;
                                        },
                                        scrollDirection: Axis.horizontal,
                                      ),
                                    )
                                  : const SizedBox(),
                          SizedBox(
                            height: images != null &&
                                    images!.isNotEmpty &&
                                    images!.length != 1
                                ? 8
                                : 0,
                          ),
                          images != null && images!.length > 1
                              ? Obx(() => AnimatedSmoothIndicator(
                                    activeIndex: activeIndex.value,
                                    count: images!.length,
                                    effect: WormEffect(
                                        activeDotColor: AppColors.kPrimaryColor,
                                        dotHeight: 8,
                                        dotWidth: 8),
                                  ))
                              : const SizedBox()
                        ],
                      ),
                    ),
                    Visibility(
                        visible: documents != null && documents!.isNotEmpty,
                        child: ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  if (documents != null &&
                                      documents![index].isNotEmpty) {
                                    Helpers.openFile(
                                        path: documents![index],
                                        fileName:
                                            documents![index].split("/").last);
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
                                          documents != null
                                              ? documents![index]
                                                  .split("/")
                                                  .last
                                              : "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
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
                                        child: SvgPicture.asset(
                                          AppIcons.icDownload,
                                          width: 24,
                                          colorFilter: ColorFilter.mode(
                                              AppColors.kPrimaryColor,
                                              BlendMode.srcIn),
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
                            itemCount:
                                documents != null ? documents!.length : 0)),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      height: 1,
                      width: 238,
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                                SvgPicture.asset(
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
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
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
                                SvgPicture.asset(
                                  AppIcons.icComment,
                                  width: 24,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child: Text(
                                    postData.commentCount != null
                                        ? postData.commentCount!.length
                                            .toString()
                                        : "0",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
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
              )
            ],
          )
        ],
      ),
    );
  }
}
