import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/consts/app_icons.dart';
import 'package:teqtop_team/model/dashboard/feed.dart';
import 'package:teqtop_team/utils/helpers.dart';

import '../../../../consts/app_images.dart';

class PostWidget extends StatelessWidget {
  final Function()? commentOnTap;
  final Feed postData;
  final List<String> images = [];
  final List<String> documents = [];
  final RxInt activeIndex = 0.obs;

  PostWidget({super.key, this.commentOnTap, required this.postData});

  void getImages() {
    var extractedImages = Helpers.extractImages(postData.description ?? "");
    for (var image in extractedImages) {
      if (!images.contains(image)) {
        images.add(image);
      }
    }

    if (postData.files != null && postData.files!.isNotEmpty) {
      try {
        List<String> extractedFiles =
            List<String>.from(jsonDecode(postData.files!) as List<dynamic>);

        for (var file in extractedFiles) {
          if (Helpers.isImage(file) && !images.contains(file)) {
            images.add(file);
          } else {
            documents.add(file);
          }
        }
      } catch (e) {
        debugPrint('Error parsing files: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    getImages();

    Helpers.printLog(
        description: "POST_WIDGET_BUILD_FUNCTION",
        message:
            "DESCRIPTION :- ${Helpers.cleanHtml(postData.description ?? "")} \n IMAGES :- $images");

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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundImage: AssetImage(AppImages.imgPersonPlaceholder),
                    foregroundImage: postData.userProfile != null &&
                            postData.userProfile!.isNotEmpty
                        ? NetworkImage(
                            AppConsts.imgInitialUrl + postData.userProfile!)
                        : AssetImage(AppImages.imgPersonPlaceholder),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    postData.userName ?? "",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                        color: AppColors.colorD9D9D9, shape: BoxShape.circle),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    postData.createdAt != null
                        ? Helpers.formatTimeAgo(postData.createdAt!)
                        : "",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
              SvgPicture.asset(
                AppIcons.icMoreHorizontal,
                width: 18,
              )
            ],
          ),
          const SizedBox(
            height: 6,
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
                    Text(
                      Helpers.cleanHtml(postData.description ?? ""),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w400),
                    ),
                    Visibility(
                      visible: images.isNotEmpty,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          images.length == 1
                              ? AspectRatio(
                                  aspectRatio: 1 / 1,
                                  child: FadeInImage.assetNetwork(
                                    placeholder: AppImages.imgPlaceholder,
                                    image: AppConsts.imgInitialUrl + images[0],
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : CarouselSlider(
                                  items: images.map((image) {
                                    return SizedBox(
                                      width: double.infinity,
                                      child: FadeInImage.assetNetwork(
                                        placeholder: AppImages.imgPlaceholder,
                                        image: AppConsts.imgInitialUrl + image,
                                        fit: BoxFit.contain,
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
                                ),
                          SizedBox(
                            height: images.length == 1 ? 0 : 8,
                          ),
                          images.length == 1
                              ? const SizedBox()
                              : Obx(() => AnimatedSmoothIndicator(
                                    activeIndex: activeIndex.value,
                                    count: images.length,
                                    effect: WormEffect(
                                        activeDotColor: AppColors.kPrimaryColor,
                                        dotHeight: 8,
                                        dotWidth: 8),
                                  ))
                        ],
                      ),
                    ),
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
                        Row(
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
                            Text(
                              postData.likeUsers != null &&
                                      postData.likeUsers!.isNotEmpty
                                  ? postData.likeUsers!.length.toString()
                                  : postData.likedBy == 1
                                      ? "1"
                                      : "0",
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 44,
                        ),
                        GestureDetector(
                          onTap: commentOnTap,
                          behavior: HitTestBehavior.opaque,
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
                              Text(
                                postData.commentCount != null
                                    ? postData.commentCount!.length.toString()
                                    : "0",
                                style: Theme.of(context).textTheme.bodyMedium,
                              )
                            ],
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
