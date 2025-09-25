import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logistics_management_app/core/theming/app_styles.dart';
import 'package:logistics_management_app/core/theming/colors_manager.dart';
import 'package:logistics_management_app/features/drivers/data/models/driver_model.dart';

class DriverListItem extends StatelessWidget {
  const DriverListItem({super.key, required this.driver});

  final DriverProfile driver;

  @override
  Widget build(BuildContext context) {
    final isAvailable = driver.availability == DriverAvailability.available;
    final availabilityLabel = isAvailable ? 'Available' : 'Unavailable';
    final availabilityColor = isAvailable
        ? ColorsManager.statusAvailable
        : ColorsManager.textSecondary;

    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.backgroundWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          _DriverAvatar(imageUrl: driver.avatarUrl),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  driver.name,
                  style: AppStyles.listTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                4.verticalSpace,
                Text(
                  availabilityLabel,
                  style: AppStyles.bodyMeta.copyWith(
                    color: isAvailable
                        ? ColorsManager.textSecondary
                        : ColorsManager.textSecondary.withValues(alpha: 0.9),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          16.horizontalSpace,
          _AvailabilityIndicator(color: availabilityColor),
        ],
      ),
    );
  }
}

class _DriverAvatar extends StatelessWidget {
  const _DriverAvatar({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28.r),
      child: Image.network(
        imageUrl,
        height: 56.r,
        width: 56.r,
        fit: BoxFit.cover,
        errorBuilder: (context, _, __) => Container(
          height: 56.r,
          width: 56.r,
          color: ColorsManager.surfaceMuted,
          alignment: Alignment.center,
          child: Icon(
            Icons.person_outline,
            size: 28.sp,
            color: ColorsManager.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _AvailabilityIndicator extends StatelessWidget {
  const _AvailabilityIndicator({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28.r,
      width: 28.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorsManager.backgroundCanvas,
      ),
      alignment: Alignment.center,
      child: Container(
        height: 12.r,
        width: 12.r,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
