import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketsapce_app/theme/app_colors.dart';

final ThemeData theme = ThemeData();

final TextTheme textTheme = theme.textTheme.copyWith(
  bodySmall: GoogleFonts.karla(fontSize: 14, color: AppColors.gray700),
  bodyMedium: GoogleFonts.karla(fontSize: 16, color: AppColors.gray700),
  bodyLarge: GoogleFonts.karla(fontSize: 18, color: AppColors.gray700),
  displaySmall: GoogleFonts.karla(fontSize: 12, color: AppColors.gray700),
  displayMedium: GoogleFonts.karla(fontSize: 14, color: AppColors.gray700),
  displayLarge: GoogleFonts.karla(fontSize: 18, color: AppColors.gray700),
  labelSmall: GoogleFonts.karla(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: AppColors.gray500,
  ),
  labelMedium: GoogleFonts.karla(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.gray500,
  ),
  labelLarge: GoogleFonts.karla(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.gray500,
  ),
  titleLarge: GoogleFonts.karla(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.gray700,
  ),
  titleMedium: GoogleFonts.karla(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.gray700,
  ),
  titleSmall: GoogleFonts.karla(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.gray700,
  ),
);

final ThemeData lightModeTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorSchemeSeed: AppColors.blueLight,
  textTheme: textTheme,
  appBarTheme: theme.appBarTheme.copyWith(
    // systemOverlayStyle: SystemUiOverlayStyle(
    //   statusBarBrightness: Brightness.light,
    //   statusBarColor: Colors.transparent,
    //   statusBarIconBrightness: Brightness.light,
    // ),
  ),
);
