import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teqtop_team/config/size_config.dart';
import 'package:teqtop_team/consts/app_consts.dart';

import 'app_colors.dart';

ThemeData appTheme(BuildContext context) {
  return ThemeData(
      colorScheme:
          ColorScheme.fromSwatch().copyWith(primary: AppColors.kPrimaryColor),
      primaryColor: AppColors.kPrimaryColor,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: appBarTheme(),
      buttonTheme: _buttonThemeData(),
      fontFamily: 'montserrat',
      textTheme: textTheme(),
      inputDecorationTheme: inputDecorationTheme(context),
      visualDensity: VisualDensity.adaptivePlatformDensity);
}

InputDecorationTheme inputDecorationTheme(BuildContext context) {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: const BorderSide(color: Colors.transparent),
      gapPadding: 0);
  OutlineInputBorder enabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(color: AppColors.kPrimaryColor),
      gapPadding: 0);

  return InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      contentPadding: EdgeInsets.symmetric(
          horizontal: 2 * SizeConfig.widthMultiplier,
          vertical: 2 * SizeConfig.heightMultiplier),
      enabledBorder: outlineInputBorder,
      focusedBorder: enabledBorder,
      hintStyle: Theme.of(context).textTheme.bodyMedium,
      labelStyle: Theme.of(context).textTheme.bodyMedium,
      errorStyle:
          Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
      border: outlineInputBorder);
}

TextTheme textTheme() {
  return TextTheme(
      bodyLarge: GoogleFonts.montserrat(
        textStyle: TextStyle(
          color: Colors.black,
          fontSize: AppConsts.commonFontSizeFactor * 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      bodyMedium: GoogleFonts.montserrat(
        textStyle: TextStyle(
          color: Colors.black,
          fontSize: AppConsts.commonFontSizeFactor * 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      bodySmall: GoogleFonts.montserrat(
        textStyle: TextStyle(
          color: Colors.black,
          fontSize: AppConsts.commonFontSizeFactor * 16,
          fontWeight: FontWeight.w400,
        ),
      ));
}

ButtonThemeData _buttonThemeData() {
  return ButtonThemeData(
      buttonColor: AppColors.kPrimaryColor,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)));
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
      color: Colors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark
          .copyWith(statusBarColor: Colors.transparent),
      iconTheme: const IconThemeData(color: Colors.black),
      titleTextStyle: GoogleFonts.montserrat(
          textStyle: TextStyle(
        color: Colors.black,
        fontSize: AppConsts.commonFontSizeFactor * 18,
        fontWeight: FontWeight.w600,
      )));
}
