import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:teqtop_team/controllers/gallery/gallery_controller.dart';


class GalleryPage extends StatelessWidget {
  final galleryController = Get.put(GalleryController());

  GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.bottomLeft, children: [
        PhotoViewGallery.builder(
            loadingBuilder: (context, event) {
              return Container(
                color: Colors.black,
                child: event == null
                    ? const SizedBox.shrink()
                    : Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            value: event.expectedTotalBytes != null
                                ? event.cumulativeBytesLoaded /
                                    (event.expectedTotalBytes ?? 1)
                                : null,
                            backgroundColor: Colors.grey,
                            color: Colors.white,
                          ),
                        ),
                      ),
              );
            },
            pageController: galleryController.pageController,
            itemCount: galleryController.images.length,
            onPageChanged: (index) {
              if (galleryController.index != null) {
                galleryController.index!.value = index;
              }
            },
            builder: (context, index) {
              var urlImage = galleryController.images[index];
              // Helpers.printLog(
              //     description: "GALLERY_PAGE_BUILD_PHOTO_VIEW_GALLERY_BUILDER",
              //     message: "IMAGE = $urlImage");

              return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(urlImage));
            }),
        Obx(
          () => Visibility(
            visible: galleryController.index != null,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black,
              width: double.infinity,
              child: Text(
                "Image ${galleryController.index!.value + 1}/${galleryController.images.length}",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
        ),
        Positioned(
            top: 50,
            right: 0,
            child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                        color: Colors.black, shape: BoxShape.circle),
                    child: const Center(
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                )))
      ]),
    );
  }
}
