import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logistics_management_app/core/theming/font_weight_helper.dart';
import 'package:logistics_management_app/core/theming/colors_manager.dart';

class AppStyles {
  static TextStyle get pageTitle => GoogleFonts.workSans(
    fontSize: 18.sp,
    fontWeight: FontWeightHelper.bold,
    height: 1.25,
    letterSpacing: -0.27,
    color: ColorsManager.textPrimary,
  );

  static TextStyle get toolbarAction => GoogleFonts.workSans(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.bold,
    height: 1.50,
    letterSpacing: 0.24,
    color: ColorsManager.textPrimary,
  );

  static TextStyle get primaryButtonLabel => GoogleFonts.workSans(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.bold,
    height: 1.50,
    letterSpacing: 0.21,
    color: ColorsManager.textOnPrimary,
  );

  static TextStyle get secondaryButtonLabel => GoogleFonts.workSans(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.bold,
    height: 1.50,
    letterSpacing: 0.21,
    color: ColorsManager.textPrimary,
  );

  static TextStyle get filterChipLabel => GoogleFonts.workSans(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.medium,
    height: 1.50,
    color: ColorsManager.textPrimary,
  );

  static TextStyle get bodyMeta => GoogleFonts.workSans(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.regular,
    height: 1.50,
    color: ColorsManager.textSecondary,
  );

  static TextStyle get cardTitle => GoogleFonts.workSans(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.bold,
    height: 1.25,
    color: ColorsManager.textPrimary,
  );

  static TextStyle get searchInput => GoogleFonts.workSans(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.regular,
    height: 1.50,
    color: ColorsManager.textPrimary,
  );

  static TextStyle get searchPlaceholder => GoogleFonts.workSans(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.regular,
    height: 1.50,
    color: ColorsManager.textSecondary,
  );

  static TextStyle get tabLabelActive => GoogleFonts.workSans(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.bold,
    height: 1.50,
    letterSpacing: 0.21,
    color: ColorsManager.textPrimary,
  );

  static TextStyle get tabLabelInactive => GoogleFonts.workSans(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.bold,
    height: 1.50,
    letterSpacing: 0.21,
    color: ColorsManager.textSecondary,
  );

  static TextStyle get listTitle => GoogleFonts.workSans(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.medium,
    height: 1.50,
    color: ColorsManager.textPrimary,
  );

  static TextStyle get bottomNavLabelActive => GoogleFonts.workSans(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.medium,
    height: 1.50,
    letterSpacing: 0.18,
    color: ColorsManager.textPrimary,
  );

  static TextStyle get bottomNavLabelInactive => GoogleFonts.workSans(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.medium,
    height: 1.50,
    letterSpacing: 0.18,
    color: ColorsManager.textSecondary,
  );
}
