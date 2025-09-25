import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logistics_management_app/core/theming/app_styles.dart';
import 'package:logistics_management_app/core/theming/colors_manager.dart';
import 'package:logistics_management_app/features/home/data/models/home_models.dart';

class HomeQuickActionButton extends StatelessWidget {
  const HomeQuickActionButton({
    super.key,
    required this.action,
    this.onPressed,
  });

  final HomeQuickAction action;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final baseStyle = action.foregroundColor == ColorsManager.textOnPrimary
        ? AppStyles.primaryButtonLabel
        : AppStyles.secondaryButtonLabel;

    return Material(
      color: action.backgroundColor,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onPressed,
        child: Container(
          constraints: BoxConstraints(minHeight: 40.h),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            action.label,
            style: baseStyle.copyWith(color: action.foregroundColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
