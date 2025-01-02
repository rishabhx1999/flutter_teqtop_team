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
}
