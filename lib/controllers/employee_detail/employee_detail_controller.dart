import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final TabController tabController;
  late final ScrollController scrollController;

  @override
  void onInit() {
    initializeTabController();
    initializeScrollController();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    disposeTabController();
    disposeScrollController();

    super.onClose();
  }

  void initializeTabController() {
    tabController = TabController(length: 3, vsync: this);
  }

  void disposeTabController() {
    tabController.dispose();
  }

  void initializeScrollController() {
    scrollController = ScrollController();
  }

  void disposeScrollController() {
    scrollController.dispose();
  }
}
