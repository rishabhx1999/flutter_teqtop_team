import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../consts/app_consts.dart';
import '../../model/daily_reports_listing/daily_report.dart';
import '../../network/get_requests.dart';
import '../../utils/helpers.dart';
import '../../utils/preference_manager.dart';
import '../dashboard/dashboard_controller.dart';

class EmployeeDailyReportsController extends GetxController {
  late final String? profilePhoto;
  DateTime calendarFirstDay = DateTime(2013);
  DateTime calendarLastDay = DateTime.now();
  Rx<DateTime> selectedDay = DateTime.now().obs;
  late final CalendarController sfCalendarController;
  RxDouble startHour = 0.0.obs;
  RxDouble endHour = 24.0.obs;
  RxList<Appointment> appointmentsList = <Appointment>[].obs;
  bool isSfCalendarViewChanged = false;
  late final int? employeeId;
  late final String? employeeProfilePhoto;
  late final String? employeeName;
  RxBool isLoading = false.obs;
  DailyReport? dailyReportData;
  Rx<Duration?> totalWorkTime = Rx<Duration?>(null);
  RxInt notificationsCount = 0.obs;

  @override
  void onInit() {
    getProfilePhoto();
    initializeCalendarController();
    getEmployeeDetails();
    getNotificationsCount();

    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    disposeCalendarController();
    super.onClose();
  }

  void initializeCalendarController() {
    sfCalendarController = CalendarController();
  }

  void disposeCalendarController() {
    sfCalendarController.dispose();
  }

  void getProfilePhoto() {
    profilePhoto =
        (PreferenceManager.getPref(PreferenceManager.prefUserProfilePhoto)
                as String?) ??
            '';
  }

  void getNotificationsCount() {
    final dashboardController = Get.find<DashboardController>();
    notificationsCount = dashboardController.notificationsCount;
  }

  DateTime calculateFirstAccessibleDate(DateTime inputDate) {
    int daysToMonday = (inputDate.weekday - DateTime.monday + 7) % 7;
    DateTime firstAccessibleDate =
        inputDate.subtract(Duration(days: daysToMonday));

    if (firstAccessibleDate.isBefore(calendarFirstDay)) {
      // Helpers.printLog(
      //     description:
      //         'EMPLOYEE_DAILY_REPORTS_CONTROLLER_CALCULATE_FIRST_ACCESSIBLE_DATE',
      //     message: "RESULT = $calendarFirstDay");
      return calendarFirstDay;
    }

    // Helpers.printLog(
    //     description:
    //         'EMPLOYEE_DAILY_REPORTS_CONTROLLER_CALCULATE_FIRST_ACCESSIBLE_DATE',
    //     message: "RESULT = $firstAccessibleDate");
    return firstAccessibleDate;
  }

  bool isSelectedTableCalendarDay(DateTime day) {
    return isSameDay(selectedDay.value, day);
  }

  void handleTableCalendarDaySelection(DateTime selected, DateTime focused) {
    selectedDay.value = selected;
    sfCalendarController.displayDate = selected;
    getDailyReport();
  }

  void handleOnTableCalendarPageChange(DateTime day) {
    // Helpers.printLog(
    //     description:
    //         'EMPLOYEE_DAILY_REPORTS_CONTROLLER_HANDLE_ON_TABLE_CALENDAR_PAGE_CHANGE',
    //     message: "DATE = $day");
    // Helpers.printLog(
    //     description:
    //         'EMPLOYEE_DAILY_REPORTS_CONTROLLER_HANDLE_ON_TABLE_CALENDAR_PAGE_CHANGE',
    //     message: "IS_SF_CALENDAR_VIEW_CHANGED = $isSfCalendarViewChanged");
    if (isSfCalendarViewChanged == true) {
    } else {
      selectedDay.value = calculateFirstAccessibleDate(day);
      sfCalendarController.displayDate = selectedDay.value;
      getDailyReport();
    }
    isSfCalendarViewChanged == false;
  }

  void handleOnSfCalendarViewChange(ViewChangedDetails viewChangedDetail) {
    // Helpers.printLog(
    //     description:
    //         'EMPLOYEE_DAILY_REPORTS_CONTROLLER_HANDLE_ON_SF_CALENDAR_ON_VIEW_CHANGE');
    if (viewChangedDetail.visibleDates.isNotEmpty) {
      // Helpers.printLog(
      //     description:
      //         'EMPLOYEE_DAILY_REPORTS_CONTROLLER_HANDLE_ON_SF_CALENDAR_ON_VIEW_CHANGE',
      //     message:
      //         'VISIBLE_DATES_FIRST = ${viewChangedDetail.visibleDates.first}');
      final DateTime visibleEndDate = viewChangedDetail.visibleDates.last;
      if (visibleEndDate.isAfter(calendarLastDay)) {
        Future.delayed(const Duration(milliseconds: 500), () {
          sfCalendarController.displayDate = calendarLastDay;
          getDailyReport();
        });
      } else if (visibleEndDate.isBefore(calendarFirstDay)) {
        Future.delayed(const Duration(milliseconds: 500), () {
          sfCalendarController.displayDate = calendarFirstDay;
          getDailyReport();
        });
      } else {
        isSfCalendarViewChanged = true;
        Future.delayed(const Duration(milliseconds: 500), () {
          selectedDay.value = viewChangedDetail.visibleDates.first;
          getDailyReport();
          isSfCalendarViewChanged = false;
        });

        // _appointmentsController.getAppointmentStartDate =
        //     DateFormat("MM-dd-yyyy")
        //         .format(viewChangedDetail.visibleDates[0]);
        // _appointmentsController.getAppointmentEndDate =
        //     DateFormat("MM-dd-yyyy")
        //         .format(viewChangedDetail.visibleDates[0]);
        // _appointmentsController.getAppointments();
        //
        // _appointmentsController.updateCalendarDate =
        //     viewChangedDetail.visibleDates[0];
      }
    }
  }

  void getEmployeeDetails() {
    Map? data = Get.arguments;
    if (data != null && data.isNotEmpty) {
      if (data.containsKey(AppConsts.keyEmployeeId)) {
        employeeId = data[AppConsts.keyEmployeeId];
      }
      if (data.containsKey(AppConsts.keyEmployeeProfilePhoto)) {
        employeeProfilePhoto = data[AppConsts.keyEmployeeProfilePhoto];
      }
      if (data.containsKey(AppConsts.keyEmployeeName)) {
        employeeName = data[AppConsts.keyEmployeeName];
      }
      if (data.containsKey(AppConsts.keyDailyReportDate)) {
        selectedDay.value =
            data[AppConsts.keyDailyReportDate] ?? DateTime.now();
      }
      getDailyReport();
    }
  }

  Future<void> getDailyReport() async {
    if (employeeId != null) {
      appointmentsList.clear();
      totalWorkTime.value = Duration.zero;
      Map<String, String> requestBody = {
        'order%5B0%5D%5Bcolumn%5D': '0',
        'order%5B0%5D%5Bdir%5D': 'DESC',
        'start': '0',
        'length': '-1',
        'search%5Bvalue%5D': '',
        'search%5Bregex%5D': 'false',
        'user': employeeId.toString(),
        'date': DateFormat('y-M-d').format(selectedDay.value)
      };

      isLoading.value = true;
      try {
        var response = await GetRequests.getDailyReports(requestBody);
        if (response != null) {
          if (response.data != null) {
            dailyReportData = response.data!.last;
            parseDailyReport();
          }
        } else {
          Get.snackbar("error".tr, "message_server_error".tr);
        }
      } finally {
        isLoading.value = false;
      }
    }
  }

  void parseDailyReport() {
    if (dailyReportData!.report != null) {
      final List<dynamic> dailyReport = json.decode(dailyReportData!.report!);

      for (var entry in dailyReport) {
        final String? subject = entry['report'];
        final String? startTime = entry['from'];
        final String? endTime = entry['to'];

        if (subject != null && startTime != null && endTime != null) {
          DateTime parsedStartTime = Helpers.convert12HourTimeStringToDateTime(
              startTime, selectedDay.value);
          DateTime parsedEndTime = Helpers.convert12HourTimeStringToDateTime(
              endTime, selectedDay.value);

          // Helpers.printLog(
          //     description:
          //         "EMPLOYEE_DAILY_REPORTS_CONTROLLER_PARSE_DAILY_REPORT",
          //     message:
          //         "SUBJECT = $subject ===== START = $parsedStartTime ===== END = $parsedEndTime");

          Appointment appointment = Appointment(
            startTime: parsedStartTime,
            endTime: parsedEndTime,
            subject: subject,
          );

          appointmentsList.add(appointment);
        }
      }
      appointmentsList.refresh();
      calculateTotalWorkTime();
    }
  }

  void calculateTotalWorkTime() {
    Duration totalDuration = Duration.zero;

    for (var appointment in appointmentsList) {
      totalDuration += appointment.endTime.difference(appointment.startTime);
    }
    // Helpers.printLog(
    //     description:
    //         "EMPLOYEE_DAILY_REPORTS_CONTROLLER_CALCULATE_TOTAL_WORK_TIME",
    //     message:
    //         "IN_HOURS = ${totalDuration.inHours} ===== IN_MINUTES = ${totalDuration.inMinutes}");
    totalWorkTime.value = Duration.zero;
    totalWorkTime.value = totalDuration;
  }
}
