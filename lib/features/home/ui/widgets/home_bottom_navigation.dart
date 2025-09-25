import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logistics_management_app/core/theming/app_styles.dart';
import 'package:logistics_management_app/core/theming/colors_manager.dart';
import 'package:logistics_management_app/features/home/data/models/home_models.dart';

class HomeBottomNavigation extends StatelessWidget {
  const HomeBottomNavigation({
    super.key,
    required this.items,
    required this.activeIndex,
    required this.onItemSelected,
  });

  final List<HomeNavigationItem> items;
  final int activeIndex;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.backgroundCanvas,
        border: Border(
          top: BorderSide(color: ColorsManager.borderSubtle, width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isActive = index == activeIndex;
          final color = isActive
              ? ColorsManager.textPrimary
              : ColorsManager.textSecondary;

          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(24.r),
              onTap: () => onItemSelected(index),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item.icon, color: color, size: 24.sp),
                    6.verticalSpace,
                    Text(
                      item.label,
                      style: isActive
                          ? AppStyles.bottomNavLabelActive
                          : AppStyles.bottomNavLabelInactive,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
