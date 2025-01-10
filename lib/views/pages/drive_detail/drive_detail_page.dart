import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/controllers/drive_detail/drive_detail_controller.dart';
import 'package:teqtop_team/model/global_search/drive_model.dart';
import 'package:teqtop_team/views/pages/drive_detail/components/drive_header_widget.dart';
import 'package:teqtop_team/views/pages/drive_detail/components/folder_widget.dart';

import '../../../config/app_colors.dart';
import '../../../consts/app_icons.dart';

class DriveDetailPage extends StatelessWidget {
  final driveDetailController = Get.put(DriveDetailController());

  DriveDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white));

    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                color: Colors.black.withValues(alpha: 0.05),
                height: 1,
              )),
          title: Text(
            'drive'.tr,
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
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
                      const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                ),
              )),
          leadingWidth: 40,
          backgroundColor: Colors.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 18,
              ),
              DriveHeaderWidget(driveData: DriveModel()),
              const SizedBox(
                height: 18,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: DottedBorder(
                    color: Colors.black.withValues(alpha: 0.2),
                    padding: EdgeInsets.zero,
                    dashPattern: [4],
                    strokeWidth: 1,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 34),
                      color: AppColors.colorF7F7F7,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.color7E869E
                                    .withValues(alpha: 0.25)),
                            child: Icon(
                              Icons.add_rounded,
                              color: AppColors.color222222,
                              size: 14,
                            ),
                          ),
                          const SizedBox(
                            width: 14,
                          ),
                          Text(
                            "add".tr,
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 22, horizontal: 16),
                  itemBuilder: (context, index) {
                    return FolderWidget();
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 16,
                    );
                  },
                  itemCount: 5)
            ],
          ),
        ));
  }
}
