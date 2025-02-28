import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:teqtop_team/controllers/gallery/gallery_controller.dart';

import '../../../consts/app_consts.dart';

class GalleryPage extends StatelessWidget {
  final galleryController = Get.put(GalleryController());

  GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.bottomLeft, children: [
        PhotoViewGallery.builder(
            pageController: galleryController.pageController,
            itemCount: galleryController.images.length,
            onPageChanged: (index) {
              if (galleryController.index != null) {
                galleryController.index!.value = index;
              }
            },
            builder: (context, index) {
              var urlImage =
                  AppConsts.imgInitialUrl + galleryController.images[index];
              return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(urlImage));
            }),
        Obx(
          () => Visibility(
            visible: galleryController.index != null,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Image ${galleryController.index!.value + 1}/${galleryController.images.length}",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
