import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logistics_management_app/core/theming/app_styles.dart';
import 'package:logistics_management_app/core/theming/colors_manager.dart';
import 'package:logistics_management_app/features/vehicles/data/models/vehicle_model.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({
    super.key,
    required this.vehicle,
    this.isHorizontal = false,
    this.onManagePressed,
  });

  final VehicleProfile vehicle;
  final bool isHorizontal;
  final VoidCallback? onManagePressed;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final useHorizontalLayout = isHorizontal || media.size.width >= 720;

    final details = _VehicleDetails(
      vehicle: vehicle,
      onManagePressed: onManagePressed,
    );

    final preview = _VehiclePreview(imageUrl: vehicle.imageUrl);

    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.backgroundWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 6),
            blurRadius: 18,
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: useHorizontalLayout
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 5, child: details),
                16.horizontalSpace,
                Expanded(flex: 4, child: preview),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [details, 16.verticalSpace, preview],
            ),
    );
  }
}

class _VehicleDetails extends StatelessWidget {
  const _VehicleDetails({required this.vehicle, this.onManagePressed});

  final VehicleProfile vehicle;
  final VoidCallback? onManagePressed;

  Color get _statusColor {
    switch (vehicle.status) {
      case VehicleStatus.available:
        return ColorsManager.statusAvailable;
      case VehicleStatus.inUse:
        return ColorsManager.statusInUse;
      case VehicleStatus.maintenance:
        return ColorsManager.statusMaintenance;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: _statusColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Text(
            vehicle.statusLabel,
            style: AppStyles.bodyMeta.copyWith(
              color: _statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        12.verticalSpace,
        Text(vehicle.name, style: AppStyles.cardTitle),
        4.verticalSpace,
        Text(vehicle.summary, style: AppStyles.bodyMeta),
        12.verticalSpace,
        _VehicleMetaRow(label: 'Assigned to', value: vehicle.driverDisplay),
        8.verticalSpace,
        _VehicleMetaRow(
          label: 'Last service',
          value: vehicle.lastService ?? 'No record',
        ),
        if (vehicle.odometerKm != null) ...[
          8.verticalSpace,
          _VehicleMetaRow(
            label: 'Odometer',
            value: '${vehicle.odometerKm!.toString()} km',
          ),
        ],
        16.verticalSpace,
        Align(
          alignment: Alignment.centerLeft,
          child: Material(
            color: ColorsManager.surfaceMuted,
            borderRadius: BorderRadius.circular(12.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: onManagePressed,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Text('Manage', style: AppStyles.filterChipLabel),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _VehicleMetaRow extends StatelessWidget {
  const _VehicleMetaRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90.w,
          child: Text(label, style: AppStyles.bodyMeta),
        ),
        Expanded(
          child: Text(
            value,
            style: AppStyles.bodyMeta.copyWith(
              color: ColorsManager.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _VehiclePreview extends StatelessWidget {
  const _VehiclePreview({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, _, __) => Container(
            color: ColorsManager.surfaceMuted,
            alignment: Alignment.center,
            child: Icon(
              Icons.directions_bus_filled_outlined,
              size: 32.sp,
              color: ColorsManager.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
