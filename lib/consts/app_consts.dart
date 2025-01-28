import 'package:teqtop_team/config/size_config.dart';

class AppConsts {
  AppConsts._();

  static const String appName = 'Teqtop Team';
  static const double tabFontFactor = 1.5;
  static const double mobileFontFactor = 1.0;
  static const String imgInitialUrl = "https://dev.team.teqtop.com";

  // false on release
  static const bool isDebug = true;

  static double commonFontSizeFactor =
      SizeConfig.isMobile ? mobileFontFactor : tabFontFactor;

  //Data Transfer Keys
  static String keyEmployeeId = 'key_employee_id';
  static String keyDriveURL = 'key_drive_url';
  static String keyDriveFolderDetail = 'key_drive_folder_detail';
  static String keyId = 'key_id';
  static String keyProjectId = 'key_project_id';
  static String keyTaskId = 'key_task_id';
  static String keyEmployeeProfilePhoto = 'key_employee_profile_photo';
  static String keyEmployeeName = 'key_employee_name';
  static String keyDailyReportDate = 'key_daily_report_date';
}
