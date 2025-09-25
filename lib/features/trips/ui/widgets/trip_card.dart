import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logistics_management_app/core/theming/app_styles.dart';
import 'package:logistics_management_app/core/theming/colors_manager.dart';
import 'package:logistics_management_app/features/trips/data/models/trip_model.dart';

class TripCard extends StatelessWidget {
  const TripCard({
    super.key,
    required this.trip,
    this.isHorizontal = false,
    this.onViewPressed,
  });

  final TripSummary trip;
  final bool isHorizontal;
  final VoidCallback? onViewPressed;

  @override
  Widget build(BuildContext context) {
    final content = <Widget>[
      Expanded(
        flex: 2,
        child: _TripDetails(trip: trip, onViewPressed: onViewPressed),
      ),
      16.horizontalSpace,
      Expanded(flex: 3, child: _TripPreview(imageUrl: trip.imageUrl)),
    ];

    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.backgroundWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: isHorizontal
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: content,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TripDetails(trip: trip, onViewPressed: onViewPressed),
                16.verticalSpace,
                _TripPreview(imageUrl: trip.imageUrl),
              ],
            ),
    );
  }
}

class _TripDetails extends StatelessWidget {
  const _TripDetails({required this.trip, this.onViewPressed});

  final TripSummary trip;
  final VoidCallback? onViewPressed;

  Color get _statusColor {
    switch (trip.status) {
      case TripStatus.pending:
        return ColorsManager.statusPending;
      case TripStatus.ongoing:
        return ColorsManager.statusOngoing;
      case TripStatus.completed:
        return ColorsManager.statusCompleted;
    }
  }

  String get _statusLabel {
    switch (trip.status) {
      case TripStatus.pending:
        return 'Pending';
      case TripStatus.ongoing:
        return 'Ongoing';
      case TripStatus.completed:
        return 'Completed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _statusLabel,
          style: AppStyles.bodyMeta.copyWith(color: _statusColor),
        ),
        4.verticalSpace,
        Text(trip.displayTitle, style: AppStyles.cardTitle),
        4.verticalSpace,
        Text(trip.subtitle, style: AppStyles.bodyMeta),
        16.verticalSpace,
        Align(
          alignment: Alignment.centerLeft,
          child: Material(
            color: ColorsManager.surfaceMuted,
            borderRadius: BorderRadius.circular(12.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: onViewPressed,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Text('View', style: AppStyles.filterChipLabel),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TripPreview extends StatelessWidget {
  const _TripPreview({required this.imageUrl});

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
              Icons.image_not_supported_outlined,
              color: ColorsManager.textSecondary,
              size: 32.sp,
            ),
          ),
        ),
      ),
    );
  }
}
