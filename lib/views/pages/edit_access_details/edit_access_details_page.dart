import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:teqtop_team/controllers/project_detail/project_detail_controller.dart';

import '../../../consts/app_icons.dart';

class EditAccessDetailsPage extends StatelessWidget {
  final projectDetailController = Get.find<ProjectDetailController>();

  EditAccessDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white));

    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          projectDetailController.wholePageFocus.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.05),
                  height: 1,
                )),
            leading: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Image.asset(
                    AppIcons.icBack,
                    color: Colors.black,
                  ),
                )),
            leadingWidth: 40,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Obx(
                  () => projectDetailController.isAccessDetailEditLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ))
                      : GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            projectDetailController.editAccessDetails();
                          },
                          child: Text(
                            'save'.tr,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                ),
              )
            ],
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: HtmlEditor(
                    controller: projectDetailController.accessDetailController,
                    htmlToolbarOptions: const HtmlToolbarOptions(
                        toolbarPosition: ToolbarPosition.custom),
                    callbacks: Callbacks(
                        onInit: projectDetailController
                            .accessDetailHtmlEditorOnInit),
                  )
                  // TextField(
                  //         controller: projectDetailController
                  //             .accessDetailController,
                  //         maxLines: 5,
                  //         style: Theme.of(context).textTheme.bodyMedium,
                  //         keyboardType: TextInputType.multiline,
                  //         cursorColor: Colors.black,
                  //         textInputAction: TextInputAction.newline,
                  //         decoration: InputDecoration(
                  //           hintText: 'enter_access_details'.tr,
                  //           enabled: true,
                  //           hintStyle: Theme.of(context)
                  //               .textTheme
                  //               .bodyMedium
                  //               ?.copyWith(
                  //                 color: Colors.black
                  //                     .withValues(alpha: 0.3),
                  //               ),
                  //           fillColor:
                  //               Colors.grey.withValues(alpha: 0.1),
                  //           filled: true,
                  //           border: inputBorder,
                  //           errorBorder: inputBorder,
                  //           enabledBorder: inputBorder,
                  //           disabledBorder: inputBorder,
                  //           focusedBorder: inputBorder,
                  //           focusedErrorBorder: inputBorder,
                  //           contentPadding: const EdgeInsets.all(10),
                  //         ),
                  //         focusNode: projectDetailController
                  //             .accessDetailFocusNode,
                  //       )
                  ,
                ),
                const SizedBox(
                  height: 16,
                )
              ],
            ),
          ),
        ));
  }
}
