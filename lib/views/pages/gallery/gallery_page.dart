import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:teqtop_team/controllers/gallery/gallery_controller.dart';

import '../../../consts/app_consts.dart';
import '../../../consts/app_icons.dart';

class GalleryPage extends StatelessWidget {
  final galleryController = Get.put(GalleryController());

  GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: SvgPicture.asset(
                AppIcons.icBack,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            )),
        leadingWidth: 40,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
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
