import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/config/app_route_observer.dart';
import 'package:teqtop_team/config/app_routes.dart';
import 'package:teqtop_team/config/app_theme.dart';
import 'package:teqtop_team/config/local_strings.dart';
import 'package:teqtop_team/config/size_config.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/utils/preference_manager.dart';
import 'package:teqtop_team/views/pages/daily_reports_listing/daily_reports_listing_page.dart';
import 'package:teqtop_team/views/pages/dashboard/dashboard_page.dart';
import 'package:teqtop_team/views/pages/drive_detail/drive_detail_page.dart';
import 'package:teqtop_team/views/pages/edit_employee_information/edit_employee_information_page.dart';
import 'package:teqtop_team/views/pages/edit_profile/edit_profile_page.dart';
import 'package:teqtop_team/views/pages/employee_daily_reports/employee_daily_reports_page.dart';
import 'package:teqtop_team/views/pages/employee_detail/employee_detail_page.dart';
import 'package:teqtop_team/views/pages/employees_listing/employees_listing_page.dart';
import 'package:teqtop_team/views/pages/folder_detail/folder_detail_page.dart';
import 'package:teqtop_team/views/pages/global_search/global_search_page.dart';
import 'package:teqtop_team/views/pages/leaves_listing/leaves_listing_page.dart';
import 'package:teqtop_team/views/pages/login/login_page.dart';
import 'package:teqtop_team/views/pages/logs_listing/logs_listing_page.dart';
import 'package:teqtop_team/views/pages/notifications/notifications_page.dart';
import 'package:teqtop_team/views/pages/profile_detail/profile_detail_page.dart';
import 'package:teqtop_team/views/pages/project_create_edit/project_create_edit_page.dart';
import 'package:teqtop_team/views/pages/project_detail/project_detail_page.dart';
import 'package:teqtop_team/views/pages/projects_listing/projects_listing_page.dart';
import 'package:teqtop_team/views/pages/splash/splash_page.dart';
import 'package:teqtop_team/views/pages/task_create_edit/task_create_edit_page.dart';
import 'package:teqtop_team/views/pages/task_detail/task_detail_page.dart';
import 'package:teqtop_team/views/pages/tasks_listing/tasks_listing_page.dart';

Future<void> main() async {
  // WidgetsBinding widgetsBinding =
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent));
  await PreferenceManager.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final int transitionDuration = 300;

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
        SizeConfig().init(constraints, orientation);
        return TextSelectionTheme(
            data: TextSelectionThemeData(
              selectionHandleColor: AppColors.kPrimaryColor,
            ),
            child: GetMaterialApp(
              translations: LocalStrings(),
              locale: const Locale('en', 'US'),
              debugShowCheckedModeBanner: false,
              title: AppConsts.appName,
              theme: appTheme(context),
              home: SplashPage(),
              getPages: [
                GetPage(name: AppRoutes.routeSplash, page: () => SplashPage()),
                GetPage(
                    name: AppRoutes.routeLogin,
                    page: () => LoginPage(),
                    transition: Transition.rightToLeft,
                    transitionDuration:
                        Duration(milliseconds: transitionDuration)),
                GetPage(
                    name: AppRoutes.routeDashboard,
                    page: () => DashboardPage(),
                    transition: Transition.rightToLeft,
                    transitionDuration:
                        Duration(milliseconds: transitionDuration)),
                GetPage(
                    name: AppRoutes.routeProfileDetail,
                    page: () => ProfileDetailPage(),
                    transition: Transition.rightToLeft,
                    transitionDuration:
                        Duration(milliseconds: transitionDuration)),
                GetPage(
                    name: AppRoutes.routeGlobalSearch,
                    page: () => GlobalSearchPage(),
                    transition: Transition.rightToLeft,
                    transitionDuration:
                        Duration(milliseconds: transitionDuration)),
                GetPage(
                    name: AppRoutes.routeEditProfile,
                    page: () => EditProfilePage(),
                    transition: Transition.rightToLeft,
                    transitionDuration:
                        Duration(milliseconds: transitionDuration)),
                GetPage(
                    name: AppRoutes.routeNotifications,
                    page: () => NotificationsPage(),
                    transition: Transition.rightToLeft,
                    transitionDuration:
                        Duration(milliseconds: transitionDuration)),
                GetPage(
                    name: AppRoutes.routeEmployeesListing,
                    page: () => EmployeesListingPage(),
                    transition: Transition.rightToLeft,
                    transitionDuration:
                        Duration(milliseconds: transitionDuration)),
                GetPage(
                    name: AppRoutes.routeDailyReportsListing,
                    page: () => DailyReportsListingPage(),
                    transition: Transition.rightToLeft,
                    transitionDuration:
                        Duration(milliseconds: transitionDuration)),
                GetPage(
                    name: AppRoutes.routeEmployeeDetail,
                    page: () => EmployeeDetailPage(),
                    transition: Transition.rightToLeft,
                    transitionDuration:
                        Duration(milliseconds: transitionDuration)),
                GetPage(
                    name: AppRoutes.routeEmployeeDailyReports,
                    page: () => EmployeeDailyReportsPage(),
                    transition: Transition.rightToLeft,
                    transitionDuration:
                        Duration(milliseconds: transitionDuration)),
                GetPage(
                    name: AppRoutes.routeProjectsListing,
                    page: () => ProjectsListingPage(),
                    transition: Transition.rightToLeft,
                    transitionDuration:
                        Duration(milliseconds: transitionDuration)),
                GetPage(
                    name: AppRoutes.routeProjectDetail,
                    page: () => ProjectDetailPage(),
                    transition: Transition.rightToLeft,
                    transitionDuration:
                        Duration(milliseconds: transitionDuration)),
                GetPage(
                    name: AppRoutes.routeDriveDetail,
                    page: () => DriveDetailPage(),
                    transition: Transition.rightToLeft,
                    transitionDuration:
                        Duration(milliseconds: transitionDuration)),
                GetPage(
                    name: AppRoutes.routeTasksListing,
                    page: () => TasksListingPage(),
                    transition: Transition.rightToLeft,
                    transitionDuration:
                        Duration(milliseconds: transitionDuration)),
                GetPage(
                    name: AppRoutes.routeProjectCreateEdit,
                    page: () => ProjectCreateEditPage(),
                    transition: Transition.rightToLeft,
                    transitionDuration:
                        Duration(milliseconds: transitionDuration)),
                GetPage(
                    name: AppRoutes.routeTaskCreateEdit,
                    page: () => TaskCreateEditPage(),
                    transition: Transition.rightToLeft,
                    transitionDuration:
                        Duration(milliseconds: transitionDuration)),
                GetPage(
                    name: AppRoutes.routeTaskDetail,
                    page: () => TaskDetailPage(),
                    transition: Transition.rightToLeft,
                    transitionDuration:
                        Duration(milliseconds: transitionDuration)),
                GetPage(
                    name: AppRoutes.routeLeavesListing,
                    page: () => LeavesListingPage(),
                    transition: Transition.rightToLeft,
                    transitionDuration:
                        Duration(milliseconds: transitionDuration)),
                GetPage(
                    name: AppRoutes.routeLogsListing,
                    page: () => LogsListingPage(),
                    transition: Transition.rightToLeft,
                    transitionDuration:
                        Duration(milliseconds: transitionDuration)),
                GetPage(
                    name: AppRoutes.routeFolderDetail,
                    page: () => FolderDetailPage(),
                    transition: Transition.rightToLeft,
                    transitionDuration:
                        Duration(milliseconds: transitionDuration)),
                GetPage(
                    name: AppRoutes.routeEditEmployeeInformation,
                    page: () => EditEmployeeInformationPage(),
                    transition: Transition.rightToLeft,
                    transitionDuration:
                        Duration(milliseconds: transitionDuration)),
              ],
              navigatorObservers: [AppRouteObserver()],
            ));
      });
    });
  }
}
