import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:teqtop_team/controllers/task_detail/task_detail_controller.dart';
import 'package:teqtop_team/controllers/tasks_listing/tasks_listing_controller.dart';
import 'package:teqtop_team/model/employees_listing/employee_model.dart';
import 'package:teqtop_team/model/task_create_edit/task_priority.dart';
import 'package:teqtop_team/utils/helpers.dart';

import '../../config/app_routes.dart';
import '../../model/global_search/project_model.dart';
import '../../model/global_search/task_model.dart';
import '../../model/media_content_model.dart';
import '../../network/get_requests.dart';
import '../../network/post_requests.dart';
import '../../utils/permission_handler.dart';
import '../../utils/preference_manager.dart';

class TaskCreateEditController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey();
  late TextEditingController nameController;
  late TextEditingController descriptionTextController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  RxBool areProjectsLoading = false.obs;
  RxBool areEmployeesLoading = false.obs;
  RxList<ProjectModel?> projects = <ProjectModel>[].obs;
  RxList<EmployeeModel?> persons = <EmployeeModel>[].obs;
  RxList<EmployeeModel?> participants = <EmployeeModel>[].obs;
  RxList<EmployeeModel?> selectedParticipants = <EmployeeModel>[].obs;
  RxList<EmployeeModel?> observers = <EmployeeModel>[].obs;
  RxList<EmployeeModel?> selectedObservers = <EmployeeModel>[].obs;
  Rx<ProjectModel?> selectedProject = Rx<ProjectModel?>(null);
  Rx<EmployeeModel?> selectedDropdownParticipant = Rx<EmployeeModel?>(null);
  Rx<EmployeeModel?> selectedDropdownObserver = Rx<EmployeeModel?>(null);
  Rx<EmployeeModel?> selectedResponsiblePerson = Rx<EmployeeModel?>(null);
  List<TaskPriority> taskPriorities = [
    TaskPriority(
      priorityText: "select_priority".tr,
    ),
    TaskPriority(
      priorityText: "low".tr,
      priorityNumber: 1,
    ),
    TaskPriority(
      priorityText: "medium".tr,
      priorityNumber: 2,
    ),
    TaskPriority(
      priorityText: "high".tr,
      priorityNumber: 3,
    ),
  ];
  Rx<TaskPriority?> selectedPriority = Rx<TaskPriority?>(null);
  RxBool showSelectProjectMessage = false.obs;
  RxBool showSelectResponsiblePersonMessage = false.obs;
  RxBool showSelectPriorityMessage = false.obs;
  RxBool showSelectParticipantsMessage = false.obs;
  RxBool showSelectObserversMessage = false.obs;
  RxBool showAddDescriptionMessage = false.obs;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  RxBool isLoading = false.obs;
  RxBool fromTaskDetail = false.obs;
  Rx<TaskModel?> editTaskDetail = Rx<TaskModel?>(null);
  RxList<MediaContentModel> descriptionItems = <MediaContentModel>[].obs;
  int? addDescriptionItemAfterIndex;
  int? descriptionItemEditIndex;
  final ImagePicker _imagePicker = ImagePicker();
  RxBool isDescriptionTextFieldEmpty = true.obs;
  final FilePicker _filePicker = FilePicker.platform;

  @override
  void onInit() {
    initializeTextEditingControllers();
    initializeSelectedPriority();
    getData();

    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    disposeTextEditingControllers();
    super.onClose();
  }

  Future<void> getData() async {
    getTaskDetail();
    await getProjects();
    await getEmployees();
    setInitialFieldValues();
  }

  void getTaskDetail() {
    var previousRoute = Get.previousRoute;
    if (previousRoute == AppRoutes.routeTaskDetail) {
      fromTaskDetail.value = true;
      final taskDetailController = Get.find<TaskDetailController>();
      editTaskDetail = taskDetailController.taskDetail;
    }
  }

  void initializeSelectedPriority() {
    selectedPriority.value = taskPriorities.first;
  }

  void initializeTextEditingControllers() {
    nameController = TextEditingController();
    descriptionTextController = TextEditingController();
    startDateController = TextEditingController();
    endDateController = TextEditingController();
  }

  void disposeTextEditingControllers() {
    nameController.dispose();
    descriptionTextController.dispose();
    startDateController.dispose();
    endDateController.dispose();
  }

  Future<void> editTask() async {
    // FocusManager.instance.primaryFocus?.unfocus();
    // if (areRequiredFieldsFilled() && editTaskDetail.value!.id != null) {
    //   Map<String, dynamic> requestBody = {
    //     'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
    //         as String?,
    //     'id': editTaskDetail.value!.id,
    //     'extras':
    //         convertToCustomJsonFormat(selectedParticipants, selectedObservers),
    //     'description':
    //         Helpers.convertToHTMLParagraphs(descriptionTextController.text),
    //     'deadline': selectedEndDate == null
    //         ? ''
    //         : DateFormat('yyyy-MM-dd').format(selectedEndDate!),
    //     'name': nameController.text.toString().trim(),
    //     'project': selectedProject.value!.id,
    //     'responsible': selectedResponsiblePerson.value!.id,
    //     'priority': selectedPriority.value!.priorityNumber == null
    //         ? null
    //         : selectedPriority.value!.priorityNumber! - 1,
    //     'observer': generateIdsString(selectedObservers),
    //     'participants': generateIdsString(selectedParticipants),
    //   };
    //
    //   isLoading.value = true;
    //   try {
    //     var response = await PostRequests.editTask(requestBody);
    //     if (response != null) {
    //       if (response.status == "success") {
    //         Get.back();
    //         final taskDetailController = Get.find<TaskDetailController>();
    //         taskDetailController.getTaskDetail();
    //       } else {
    //         Get.snackbar("error".tr, "message_server_error".tr);
    //       }
    //     } else {
    //       Get.snackbar("error".tr, "message_server_error".tr);
    //     }
    //   } finally {
    //     isLoading.value = false;
    //   }
    // }
  }

  void setInitialFieldValues() {
    if (editTaskDetail.value != null && fromTaskDetail.value) {
      nameController.text = editTaskDetail.value!.name ?? "";

      var project = projects.firstWhereOrNull((project) =>
          project != null &&
          project.id != null &&
          project.id == editTaskDetail.value!.project);
      if (project != null) {
        onChangeProject(project);
      }

      var person = persons.firstWhereOrNull((person) =>
          person != null &&
          person.id != null &&
          person.id == editTaskDetail.value!.assignedTo);
      if (person != null) {
        onChangeResponsiblePerson(person);
      }

      var priority = taskPriorities.firstWhereOrNull((priority) =>
          editTaskDetail.value!.priority != null &&
          int.parse(editTaskDetail.value!.priority!) + 1 ==
              priority.priorityNumber);
      if (priority != null) {
        onChangeTaskPriority(priority);
      }

      List<int>? initialParticipants;
      if (editTaskDetail.value!.participants != null &&
          editTaskDetail.value!.participants!.isNotEmpty) {
        initialParticipants =
            convertStringToIntList(editTaskDetail.value!.participants!);
      }
      if (initialParticipants != null && initialParticipants.isNotEmpty) {
        for (var initialParticipant in initialParticipants) {
          var participant = participants.firstWhereOrNull((participant) =>
              participant != null && participant.id == initialParticipant);
          if (participant != null) {
            onParticipantSelect(participant);
          }
        }
      }

      List<int>? initialObservers;
      if (editTaskDetail.value!.observers != null &&
          editTaskDetail.value!.observers!.isNotEmpty) {
        initialObservers =
            convertStringToIntList(editTaskDetail.value!.observers!);
      }
      if (initialObservers != null && initialObservers.isNotEmpty) {
        for (var initialObserver in initialObservers) {
          var observer = observers.firstWhereOrNull(
              (observer) => observer != null && observer.id == initialObserver);
          if (observer != null) {
            onObserverSelect(observer);
          }
        }
      }

      selectedStartDate = editTaskDetail.value!.createdAt;
      if (selectedStartDate != null) {
        startDateController.text =
            DateFormat('MM/dd/yy').format(selectedStartDate!);
      }

      if (editTaskDetail.value!.deadline is String) {
        selectedEndDate = DateTime.parse(editTaskDetail.value!.deadline);
      }
      if (selectedEndDate != null) {
        endDateController.text =
            DateFormat('MM/dd/yy').format(selectedEndDate!);
      }

      descriptionTextController.text =
          Helpers.formatHtmlParagraphs(editTaskDetail.value!.description ?? "");
    }
  }

  Future<void> createTask() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (areRequiredFieldsFilled()) {
      // Map<String, dynamic> requestBody = {
      //   'token': PreferenceManager.getPref(PreferenceManager.prefUserToken)
      //       as String?,
      //   'name': nameController.text.toString().trim(),
      //   'project': selectedProject.value!.id,
      //   'responsible': selectedResponsiblePerson.value!.id,
      //   'priority': selectedPriority.value!.priorityNumber,
      //   'observer': generateIdsString(selectedObservers),
      //   'participants': generateIdsString(selectedParticipants),
      //   'extras':
      //       convertToCustomJsonFormat(selectedParticipants, selectedObservers),
      //   'description':
      //       Helpers.convertToHTMLParagraphs(descriptionTextController.text),
      //   'deadline': selectedEndDate == null
      //       ? ''
      //       : DateFormat('yyyy-MM-dd').format(selectedEndDate!),
      //   'created_at': selectedStartDate == null
      //       ? ''
      //       : DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime(
      //           selectedStartDate!.year,
      //           selectedStartDate!.month,
      //           selectedStartDate!.day,
      //           DateTime.now().hour,
      //           DateTime.now().minute,
      //           DateTime.now().second,
      //         )),
      // };
      //
      // isLoading.value = true;
      // try {
      //   var response = await PostRequests.createTask(requestBody);
      //   if (response != null) {
      //     if (response.status == "Added a new task") {
      //       Get.back();
      //       final tasksListingController = Get.find<TasksListingController>();
      //       tasksListingController.getTasks();
      //     } else {
      //       Get.snackbar("error".tr, "message_server_error".tr);
      //     }
      //   } else {
      //     Get.snackbar("error".tr, "message_server_error".tr);
      //   }
      // } finally {
      //   isLoading.value = false;
      // }
    }
  }

  bool areRequiredFieldsFilled() {
    bool isProjectSelected = selectedProject.value != null &&
        selectedProject.value!.name != "select_project".tr;
    showSelectProjectMessage.value = !isProjectSelected;

    bool isResponsiblePersonSelected =
        selectedResponsiblePerson.value != null &&
            selectedResponsiblePerson.value!.name != "select_person".tr;
    showSelectResponsiblePersonMessage.value = !isResponsiblePersonSelected;

    bool isPrioritySelected = selectedPriority.value != null &&
        selectedPriority.value!.priorityText != "select_priority".tr;
    showSelectPriorityMessage.value = !isPrioritySelected;

    bool areParticipantsSelected = selectedParticipants.isNotEmpty;
    showSelectParticipantsMessage.value = !areParticipantsSelected;

    bool areObserversSelected = selectedObservers.isNotEmpty;
    showSelectObserversMessage.value = !areObserversSelected;

    bool areDescriptionItemsPresent = descriptionItems.isNotEmpty;
    showAddDescriptionMessage.value = !areDescriptionItemsPresent;

    bool areTextFieldsFilled = formKey.currentState!.validate();

    return isProjectSelected &&
        isResponsiblePersonSelected &&
        isPrioritySelected &&
        areParticipantsSelected &&
        areObserversSelected &&
        areDescriptionItemsPresent &&
        areTextFieldsFilled;
  }

  Future<void> getProjects() async {
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
      'start': '0',
      'length': '-1',
      'search%5Bvalue%5D': '',
      'search%5Bregex%5D': 'false'
    };

    areProjectsLoading.value = true;
    try {
      var response = await GetRequests.getProjects(requestBody);
      if (response != null) {
        if (response.data != null) {
          projects.assignAll(response.data!.toList());
          projects.insert(0, ProjectModel(name: "select_project".tr));
          selectedProject.value = projects[0];
        }
      } else {
        Get.snackbar("error".tr, "message_server_error".tr);
      }
    } finally {
      areProjectsLoading.value = false;
    }
  }

  void addTextInDescription() {
    if (descriptionTextController.text.isEmpty) return;

    final newItem = MediaContentModel(text: descriptionTextController.text);

    if (descriptionItemEditIndex != null) {
      descriptionItems.insert(descriptionItemEditIndex!, newItem);
    } else {
      final insertIndex = (addDescriptionItemAfterIndex != null)
          ? addDescriptionItemAfterIndex! + 1
          : descriptionItems.length;
      descriptionItems.insert(insertIndex, newItem);
    }
    descriptionItemEditIndex = null;
    addDescriptionItemAfterIndex = null;
    descriptionTextController.clear();
    isDescriptionTextFieldEmpty.value = true;
  }

  void onDescriptionTextChange(String value) {
    isDescriptionTextFieldEmpty.value = value.isEmpty;
  }

  void clickDescriptionImage() async {
    FocusManager.instance.primaryFocus?.unfocus();
    var havePermission = await PermissionHandler.requestCameraPermission();
    if (havePermission) {
      var image = await _imagePicker.pickImage(source: ImageSource.camera);
      if (image != null) {
        if (addDescriptionItemAfterIndex == null) {
          descriptionItems.add(MediaContentModel(image: image));
        } else {
          descriptionItems.insert(addDescriptionItemAfterIndex! + 1,
              MediaContentModel(image: image));
        }
        addDescriptionItemAfterIndex = null;
      }
      // handlePostButtonEnable();
    }
  }

  void pickDescriptionImages() async {
    FocusManager.instance.primaryFocus?.unfocus();
    var images = await _imagePicker.pickMultiImage();
    if (images.isEmpty) return;

    for (var image in images) {
      if (addDescriptionItemAfterIndex == null) {
        descriptionItems.add(MediaContentModel(image: image));
      } else {
        descriptionItems.insert(
            addDescriptionItemAfterIndex! + 1, MediaContentModel(image: image));
        addDescriptionItemAfterIndex = addDescriptionItemAfterIndex! + 1;
      }
    }
    addDescriptionItemAfterIndex = null;
    // handlePostButtonEnable();
  }

  void onChangeProject(var newProject) {
    selectedProject.value = newProject as ProjectModel;
  }

  void pickDescriptionDocuments() async {
    var files = await _filePicker.pickFiles(allowMultiple: true);
    if (files == null) return;

    for (var file in files.files) {
      if (file.path == null) continue;

      var mediaContent = (file.extension != null &&
              ['jpg', 'jpeg', 'png'].contains(file.extension!.toLowerCase()))
          ? MediaContentModel(image: XFile(file.path!))
          : MediaContentModel(file: file);

      if (addDescriptionItemAfterIndex == null) {
        descriptionItems.add(mediaContent);
      } else {
        addDescriptionItemAfterIndex = addDescriptionItemAfterIndex! + 1;
        descriptionItems.insert(addDescriptionItemAfterIndex!, mediaContent);
      }
    }
    addDescriptionItemAfterIndex = null;
  }

  String truncateDropdownSelectedValue(String text) {
    if (text == "select_project".tr || text == "select_person".tr) {
      return text;
    }
    if (text.length > 16) {
      return '${text.substring(0, 16)}...';
    }
    return text;
  }

  String truncateSelectedEmployeeName(String text) {
    if (text.length > 15) {
      return '${text.substring(0, 15)}...';
    }
    return text;
  }

  Future<void> getEmployees() async {
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
      'start': '0',
      'length': '-1',
      'search%5Bvalue%5D': '',
      'search%5Bregex%5D': 'false'
    };

    areEmployeesLoading.value = true;
    try {
      var response = await GetRequests.getEmployees(requestBody);
      if (response != null) {
        if (response.data != null) {
          persons.assignAll(response.data!.toList());
          persons.insert(0, EmployeeModel(name: "select_person".tr));
          selectedResponsiblePerson.value = persons[0];

          participants.assignAll(response.data!.toList());
          participants.insert(0, EmployeeModel(name: "choose_participants".tr));
          selectedDropdownParticipant.value = participants[0];

          observers.assignAll(response.data!.toList());
          observers.insert(0, EmployeeModel(name: "choose_observers".tr));
          selectedDropdownObserver.value = observers[0];
        }
      } else {
        Get.snackbar("error".tr, "message_server_error".tr);
      }
    } finally {
      areEmployeesLoading.value = false;
    }
  }

  void onChangeResponsiblePerson(var newPerson) {
    selectedResponsiblePerson.value = newPerson as EmployeeModel;
  }

  void onChangeTaskPriority(var newPriority) {
    selectedPriority.value = newPriority as TaskPriority;
  }

  void onParticipantSelect(var newParticipant) {
    if ((newParticipant as EmployeeModel).name != "choose_participants".tr) {
      selectedParticipants.add(newParticipant);
      participants.removeWhere((participant) =>
          participant != null && participant.id == newParticipant.id);
    }
  }

  void onObserverSelect(var newObserver) {
    if ((newObserver as EmployeeModel).name != "choose_observers".tr) {
      selectedObservers.add(newObserver);
      observers.removeWhere(
          (observer) => observer != null && observer.id == newObserver.id);
    }
  }

  void removeSelectedParticipant(EmployeeModel removeParticipant) {
    selectedParticipants.removeWhere((participant) =>
        participant != null && participant.id == removeParticipant.id);
    participants.add(removeParticipant);
  }

  void removeSelectedObserver(EmployeeModel removeObserver) {
    selectedObservers.removeWhere(
        (observer) => observer != null && observer.id == removeObserver.id);
    observers.add(removeObserver);
  }

  Future<void> handleStartDateFieldOnTap(dynamic context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    selectedStartDate = await showDatePicker(
      initialDate: selectedStartDate,
      firstDate: DateTime(2013),
      lastDate: DateTime.now().add(Duration(days: 365)),
      context: context,
    );
    if (selectedStartDate != null) {
      startDateController.text =
          DateFormat('MM/dd/yy').format(selectedStartDate!);
    }
  }

  Future<void> handleEndDateFieldOnTap(dynamic context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    selectedEndDate = await showDatePicker(
      initialDate: selectedEndDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 3650)),
      context: context,
    );
    if (selectedEndDate != null) {
      endDateController.text = DateFormat('MM/dd/yy').format(selectedEndDate!);
    }
  }

  String convertToCustomJsonFormat(RxList<EmployeeModel?> selectedParticipants,
      RxList<EmployeeModel?> selectedObservers) {
    List<Map<String, dynamic>> observers = selectedObservers
        .where((observer) => observer != null)
        .map((observer) => {
              "id": observer!.id,
              "name": observer.name,
              "is_edit": false,
            })
        .toList();

    List<Map<String, dynamic>> participants = selectedParticipants
        .where((participant) => participant != null)
        .map((participant) => {
              "id": participant!.id,
              "name": participant.name,
              "is_edit": false, // Always set to false
            })
        .toList();

    Map<String, dynamic> result = {
      "observer": observers,
      "participants": participants,
    };

    return json.encode(result);
  }

  String generateIdsString(RxList<EmployeeModel?> selectedObservers) {
    final ids = selectedObservers
        .where((e) => e?.id != null)
        .map((e) => e!.id)
        .toList();

    return '[${ids.join(',')}]';
  }

  List<int> convertStringToIntList(String input) {
    String trimmedInput = input.replaceAll(RegExp(r'[\[\]]'), '');

    if (trimmedInput.isEmpty) {
      return [];
    }

    List<int> intList =
        trimmedInput.split(',').map((e) => int.parse(e.trim())).toList();

    return intList;
  }

  void removeDescriptionItem(MediaContentModel item) {
    descriptionItems.remove(item);
  }

  void addDescriptionItemAfter(int index) {
    addDescriptionItemAfterIndex = index;
    Get.snackbar("success".tr, "message_adding_content_in_between".tr);
  }

  void editDescriptionText(int index) {
    if (descriptionItems[index].text != null &&
        descriptionItems[index].text!.isNotEmpty) {
      descriptionTextController.clear();
      descriptionTextController.text = descriptionItems[index].text!;
      descriptionItems.removeAt(index);
      descriptionItemEditIndex = index;
    }
  }
}
