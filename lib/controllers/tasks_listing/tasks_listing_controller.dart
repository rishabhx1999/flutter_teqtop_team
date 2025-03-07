import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/model/global_search/task_model.dart';
import '../../config/app_routes.dart';
import '../../consts/app_consts.dart';
import '../../network/get_requests.dart';
import '../../utils/preference_manager.dart';
import '../dashboard/dashboard_controller.dart';

class TasksListingController extends GetxController {
  late final scaffoldKey = GlobalKey<ScaffoldState>();
  late final String? profilePhoto;
  late TextEditingController searchTextController;
  RxBool showSearchFieldTrailing = false.obs;
  late Worker searchTextChangeListenerWorker;
  RxBool isLoading = false.obs;
  RxList<TaskModel?> tasks = <TaskModel>[].obs;
  RxInt notificationsCount = 0.obs;
  int? projectId;
  bool singleProjectTasks = false;
  RxString searchText = ''.obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    getProfilePhoto();
    initializeSearchTextController();
    setupSearchTextChangeListener();
    getNotificationsCount();
    checkIfSingleProjectTasks();
    addListenerToScrollController();

    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    disposeSearchTextChangeListenerWorker();
    disposeSearchTextController();
    scrollController.dispose();

    super.onClose();
  }

  void checkIfSingleProjectTasks() {
    var previousRoute = Get.previousRoute;
    if (previousRoute == AppRoutes.routeGlobalSearch ||
        previousRoute == AppRoutes.routeProjectDetail) {
      singleProjectTasks = true;
    }
    getProjectId();
  }

  void addListenerToScrollController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        isLoading.value = true;
        getTasks();
      }
    });
  }

  void getNotificationsCount() {
    final dashboardController = Get.find<DashboardController>();
    notificationsCount = dashboardController.notificationsCount;
  }

  void getProfilePhoto() {
    profilePhoto =
        (PreferenceManager.getPref(PreferenceManager.prefUserProfilePhoto)
                as String?) ??
            '';
  }

  void getProjectId() {
    Map? data = Get.arguments;
    if (data != null && data.isNotEmpty) {
      if (data.containsKey(AppConsts.keyProjectId)) {
        projectId = data[AppConsts.keyProjectId];
      }
    }
    getTasks();
  }

  void setupSearchTextChangeListener() {
    searchTextChangeListenerWorker = debounce(searchText, (callback) {
      tasks.clear();
      getTasks();
    });

    searchTextController.addListener(() {
      searchText.value = searchTextController.text.toString().trim();
    });
  }

  void disposeSearchTextChangeListenerWorker() {
    searchTextChangeListenerWorker.dispose();
  }

  void initializeSearchTextController() {
    searchTextController = TextEditingController();
  }

  void disposeSearchTextController() {
    searchTextController.dispose();
  }

  void handleSearchTextChange(String text) {
    showSearchFieldTrailing.value = text.isNotEmpty;
  }

  void handleClearSearchField() {
    searchTextController.clear();
    showSearchFieldTrailing.value = false;
  }

  void handleTaskOnTap(int? taskId) {
    Get.toNamed(AppRoutes.routeTaskDetail, arguments: {
      AppConsts.keyTaskId: taskId,
    });
  }

  Future<void> getTasks() async {
    if ((singleProjectTasks == true && projectId != null) ||
        (singleProjectTasks == false)) {
      Map<String, String> requestBody = {
        // 'draw': '20',
        // 'columns%5B0%5D%5Bdata%5D': 'DT_RowIndex',
        // 'columns%5B0%5D%5Bname%5D': '',
        // 'columns%5B0%5D%5Bsearchable%5D': 'true',
        // 'columns%5B0%5D%5Borderable%5D': 'true',
        // 'columns%5B0%5D%5Bsearch%5D%5Bvalue%5D': '',
        // 'columns%5B0%5D%5Bsearch%5D%5Bregex%5D': 'false',
        // 'columns%5B1%5D%5Bdata%5D': 'employee_id',
        // 'columns%5B1%5D%5Bname%5D': '',
        // 'columns%5B1%5D%5Bsearchable%5D': 'true',
        // 'columns%5B1%5D%5Borderable%5D': 'true',
        // 'columns%5B1%5D%5Bsearch%5D%5Bvalue%5D': '',
        // 'columns%5B1%5D%5Bsearch%5D%5Bregex%5D': 'false',
        // 'columns%5B2%5D%5Bdata%5D': 'name',
        // 'columns%5B2%5D%5Bname%5D': 'name',
        // 'columns%5B2%5D%5Bsearchable%5D': 'true',
        // 'columns%5B2%5D%5Borderable%5D': 'true',
        // 'columns%5B2%5D%5Bsearch%5D%5Bvalue%5D': '',
        // 'columns%5B2%5D%5Bsearch%5D%5Bregex%5D': 'false',
        // 'columns%5B3%5D%5Bdata%5D': 'registered',
        // 'columns%5B3%5D%5Bname%5D': 'registered',
        // 'columns%5B3%5D%5Borderable%5D': 'true',
        // 'columns%5B3%5D%5Bsearch%5D%5Bvalue%5D': '',
        // 'columns%5B3%5D%5Bsearch%5D%5Bregex%5D': 'false',
        // 'columns%5B4%5D%5Bdata%5D': 'roles',
        // 'columns%5B4%5D%5Bname%5D': '',
        // 'columns%5B4%5D%5Bsearchable%5D': 'true',
        // 'columns%5B4%5D%5Borderable%5D': 'true',
        // 'columns%5B4%5D%5Bsearch%5D%5Bvalue%5D': '',
        // 'columns%5B4%5D%5Bsearch%5D%5Bregex%5D': 'false',
        // 'columns%5B5%5D%5Bdata%5D': 'status',
        // 'columns%5B5%5D%5Bname%5D': '',
        // 'columns%5B5%5D%5Bsearchable%5D': 'true',
        // 'columns%5B5%5D%5Borderable%5D': 'true',
        // 'columns%5B5%5D%5Bsearch%5D%5Bvalue%5D': '',
        // 'columns%5B5%5D%5Bsearch%5D%5Bregex%5D': 'false',
        // 'columns%5B6%5D%5Bdata%5D': 'action',
        // 'columns%5B6%5D%5Bname%5D': '',
        // 'columns%5B6%5D%5Bsearchable%5D': 'false',
        // 'columns%5B6%5D%5Borderable%5D': 'false',
        // 'columns%5B6%5D%5Bsearch%5D%5Bvalue%5D': '',
        // 'columns%5B6%5D%5Bsearch%5D%5Bregex%5D': 'false',
        'order%5B0%5D%5Bcolumn%5D': '0',
        'order%5B0%5D%5Bdir%5D': 'DESC',
        'length': '10',
        'search%5Bvalue%5D': searchText.value,
        'search%5Bregex%5D': 'false'
      };
      int startValue = (tasks.length ~/ 10) * 10;
      requestBody['start'] = startValue.toString();

      if (projectId != null) {
        requestBody.addIf(projectId != null, 'project', projectId.toString());
      }

      isLoading.value = true;
      try {
        var response = await GetRequests.getTasks(requestBody);
        if (response != null) {
          if (response.data != null) {

            for (var existingTask in tasks) {
              response.data!.removeWhere((task) =>
              task != null &&
                  existingTask != null &&
                  task.id == existingTask.id);
            }

            tasks.addAll(response.data as Iterable<TaskModel?>);
          }
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } finally {
        isLoading.value = false;
      }
    }
  }

  void handleOnGlobalSearchTap() {
    if (singleProjectTasks == true) {
      Get.offNamedUntil(AppRoutes.routeGlobalSearch,
          (route) => route.settings.name == AppRoutes.routeDashboard);
    } else {
      Get.toNamed(AppRoutes.routeGlobalSearch);
    }
  }
}
