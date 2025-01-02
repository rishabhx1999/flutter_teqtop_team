import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/config/app_route_observer.dart';
import 'package:teqtop_team/config/app_routes.dart';
import 'package:teqtop_team/config/app_theme.dart';
import 'package:teqtop_team/config/local_strings.dart';
import 'package:teqtop_team/config/size_config.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/utils/preference_manager.dart';
import 'package:teqtop_team/views/pages/daily_reports/daily_reports_page.dart';
import 'package:teqtop_team/views/pages/dashboard/dashboard_page.dart';
import 'package:teqtop_team/views/pages/edit_profile/edit_profile_page.dart';
import 'package:teqtop_team/views/pages/employee_detail/employee_detail_page.dart';
import 'package:teqtop_team/views/pages/employees_listing/employees_listing_page.dart';
import 'package:teqtop_team/views/pages/global_search/global_search_page.dart';
import 'package:teqtop_team/views/pages/login/login_page.dart';
import 'package:teqtop_team/views/pages/notifications/notifications_page.dart';
import 'package:teqtop_team/views/pages/profile_detail/profile_detail_page.dart';
import 'package:teqtop_team/views/pages/splash/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
                    name: AppRoutes.routeDailyReports,
                    page: () => DailyReportsPage(),
                    transition: Transition.rightToLeft,
                    transitionDuration:
                        Duration(milliseconds: transitionDuration)),
                GetPage(
                    name: AppRoutes.routeEmployeeDetail,
                    page: () => EmployeeDetailPage(),
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
