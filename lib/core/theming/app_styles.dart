import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logistics_management_app/core/theming/colors_manager.dart';
import 'package:logistics_management_app/core/theming/font_weight_helper.dart';

class AppStyles {
  static TextStyle get headline1 => TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.white,
  );
}
