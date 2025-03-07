import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:teqtop_team/controllers/employee_daily_reports_controller/employee_daily_reports_controller.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../consts/app_consts.dart';
import '../../../consts/app_icons.dart';
import '../../../consts/app_images.dart';

class EmployeeDailyReportsPage extends StatelessWidget {
  final employeeDailyReportsController =
      Get.put(EmployeeDailyReportsController());

  EmployeeDailyReportsPage({super.key});

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
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Get.toNamed(AppRoutes.routeGlobalSearch);
                },
                child: Image.asset(
                  AppIcons.icSearch,
                  width: 24,
                  color: Colors.black,
                )),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Get.toNamed(AppRoutes.routeNotifications);
            },
            child: Obx(
              () => Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4, right: 16),
                    child: Image.asset(
                      AppIcons.icBell,
                      width: 24,
                    ),
                  ),
                  Positioned(
                      left: 12,
                      top: 0,
                      child: Visibility(
                          visible: employeeDailyReportsController
                                  .notificationsCount.value >
                              0,
                          child: Container(
                            height: 12,
                            width: employeeDailyReportsController
                                        .notificationsCount.value
                                        .toString()
                                        .length >
                                    1
                                ? (12 +
                                        ((employeeDailyReportsController
                                                    .notificationsCount.value
                                                    .toString()
                                                    .length -
                                                1) *
                                            4))
                                    .toDouble()
                                : 12,
                            decoration: BoxDecoration(
                                color: AppColors.colorFFB400,
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: Text(
                                employeeDailyReportsController
                                    .notificationsCount.value
                                    .toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        fontSize:
                                            AppConsts.commonFontSizeFactor * 8),
                              ),
                            ),
                          )))
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 1, color: AppColors.colorFFB400)),
                        child: Center(
                          child: CircleAvatar(
                            radius: 36,
                            backgroundImage:
                                const AssetImage(AppImages.imgPersonPlaceholder),
                            foregroundImage: employeeDailyReportsController
                                        .employeeProfilePhoto !=
                                    null
                                ? NetworkImage(AppConsts.imgInitialUrl +
                                    employeeDailyReportsController
                                        .employeeProfilePhoto!)
                                : const AssetImage(AppImages.imgPersonPlaceholder),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              employeeDailyReportsController.employeeName ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontSize:
                                          AppConsts.commonFontSizeFactor * 18),
                            ),
                            Obx(
                              () => Text(
                                DateFormat('MMM dd, yyyy').format(
                                    employeeDailyReportsController
                                        .selectedDay.value),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color:
                                            Colors.black.withValues(alpha: 0.7),
                                        fontSize:
                                            AppConsts.commonFontSizeFactor *
                                                14),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Obx(
                      () => employeeDailyReportsController.isLoading.value
                          ? Shimmer.fromColors(
                              baseColor: AppColors.shimmerBaseColor,
                              highlightColor: AppColors.shimmerHighlightColor,
                              child: Container(
                                height: 28.0,
                                width: 72,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.0),
                                  color: AppColors.shimmerBaseColor,
                                ),
                              ))
                          : Text(
                              employeeDailyReportsController
                                          .totalWorkTime.value !=
                                      null
                                  ? "${employeeDailyReportsController.totalWorkTime.value!.inHours.toString().padLeft(2, '0')}:${(employeeDailyReportsController.totalWorkTime.value!.inMinutes % 60).toString().padLeft(2, '0')}"
                                  : "",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontSize:
                                          AppConsts.commonFontSizeFactor * 18),
                            ),
                    ),
                    Text(
                      "total_hours".tr,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black.withValues(alpha: 0.7),
                          fontSize: AppConsts.commonFontSizeFactor * 14),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Obx(
            () => TableCalendar(
              currentDay: DateTime.now(),
              calendarStyle: const CalendarStyle(
                isTodayHighlighted: false,
              ),
              firstDay: employeeDailyReportsController.calendarFirstDay,
              lastDay: employeeDailyReportsController.calendarLastDay,
              focusedDay: employeeDailyReportsController.selectedDay.value,
              headerVisible: false,
              daysOfWeekVisible: false,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarFormat: CalendarFormat.week,
              selectedDayPredicate:
                  employeeDailyReportsController.isSelectedTableCalendarDay,
              onDaySelected: employeeDailyReportsController
                  .handleTableCalendarDaySelection,
              onPageChanged: employeeDailyReportsController
                  .handleOnTableCalendarPageChange,
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  return Container(
                    width: 40,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent,
                        border: Border.all(
                            width: 0.5,
                            color: Colors.black.withValues(alpha: 0.1))),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat.d().format(day),
                            style: GoogleFonts.notoSans(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        AppConsts.commonFontSizeFactor * 16,
                                    fontWeight: FontWeight.w400)),
                          ),
                          Text(
                            DateFormat.E().format(day).toLowerCase(),
                            style: GoogleFonts.notoSans(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        AppConsts.commonFontSizeFactor * 16,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                selectedBuilder: (context, day, focusedDay) {
                  return Container(
                    width: 40,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.kPrimaryColor,
                        border: Border.all(
                            width: 0.5,
                            color: Colors.black.withValues(alpha: 0.1))),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat.d().format(day),
                            style: GoogleFonts.notoSans(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        AppConsts.commonFontSizeFactor * 16,
                                    fontWeight: FontWeight.w400)),
                          ),
                          Text(
                            DateFormat.E().format(day).toLowerCase(),
                            style: GoogleFonts.notoSans(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        AppConsts.commonFontSizeFactor * 16,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 28,
          ),
          Obx(
            () => Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SfCalendar(
                      controller:
                          employeeDailyReportsController.sfCalendarController,
                      viewHeaderHeight: 0,
                      appointmentBuilder:
                          (context, calendarAppointmentDetails) {
                        if (calendarAppointmentDetails
                            .isMoreAppointmentRegion) {
                          return Container(
                            width: calendarAppointmentDetails.bounds.width,
                            height: calendarAppointmentDetails.bounds.height,
                            color: Colors.red,
                            child: const Text('+More'),
                          );
                        } else {
                          final Appointment appointment =
                              calendarAppointmentDetails.appointments.first;
                          return Container(
                            decoration: BoxDecoration(
                                color: AppColors.colorF9F9F9,
                                borderRadius: BorderRadius.circular(10)),
                            width: calendarAppointmentDetails.bounds.width,
                            height: calendarAppointmentDetails.bounds.height,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 5,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                      color: AppColors.colorFFB400),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10, right: 14),
                                    child: RichText(
                                        overflow: TextOverflow.clip,
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: appointment.subject,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                      color: Colors.black
                                                          .withValues(
                                                              alpha: 0.7),
                                                      fontSize: AppConsts
                                                              .commonFontSizeFactor *
                                                          14)),
                                          TextSpan(
                                              text:
                                                  "\n${DateFormat('HH:mm').format(appointment.startTime)} - ${DateFormat('HH:mm').format(appointment.endTime)}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                      color: Colors.black
                                                          .withValues(
                                                              alpha: 0.7),
                                                      fontSize: AppConsts
                                                              .commonFontSizeFactor *
                                                          12))
                                        ])),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      onViewChanged: employeeDailyReportsController
                          .handleOnSfCalendarViewChange,
                      headerHeight: 0,
                      allowedViews: const <CalendarView>[
                        CalendarView.day,
                      ],
                      resourceViewSettings: const ResourceViewSettings(
                          visibleResourceCount: 1, showAvatar: false),
                      timeSlotViewSettings: TimeSlotViewSettings(
                          timeTextStyle:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.black.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                          timeIntervalHeight: 50,
                          startHour:
                              employeeDailyReportsController.startHour.value,
                          endHour: employeeDailyReportsController.endHour.value,
                          timeFormat: "HH:mm",
                          timeInterval: const Duration(hours: 1)),
                      showNavigationArrow: false,
                      showDatePickerButton: false,
                      allowViewNavigation: true,
                      initialSelectedDate:
                          employeeDailyReportsController.selectedDay.value,
                      initialDisplayDate:
                          employeeDailyReportsController.selectedDay.value,
                      viewNavigationMode: ViewNavigationMode.snap,
                      allowDragAndDrop: false,
                      dragAndDropSettings: const DragAndDropSettings(
                        allowNavigation: true,
                        allowScroll: true,
                        autoNavigateDelay: Duration(seconds: 1),
                        indicatorTimeFormat: 'HH:mm',
                        showTimeIndicator: true,
                      ),
                      view: CalendarView.day,
                      firstDayOfWeek: 1,
                      dataSource: MeetingDataSource(
                          employeeDailyReportsController.appointmentsList),
                    ),
                  ),
                  Visibility(
                    visible: employeeDailyReportsController.isLoading.value,
                    child: Center(
                      child: Container(
                        height: 51,
                        width: 51,
                        padding: const EdgeInsets.all(8),
                        child: CircularProgressIndicator(
                          color: AppColors.kPrimaryColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
    resources = [
      CalendarResource(
        displayName: 'John',
        id: '0001',
        color: Colors.red,
      )
    ];
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}
