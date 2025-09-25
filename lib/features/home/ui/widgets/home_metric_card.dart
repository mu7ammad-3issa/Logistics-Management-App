import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logistics_management_app/core/theming/app_styles.dart';
import 'package:logistics_management_app/core/theming/colors_manager.dart';
import 'package:logistics_management_app/features/home/data/models/home_models.dart';

class HomeMetricCard extends StatelessWidget {
  const HomeMetricCard({
    super.key,
    required this.metric,
    this.isHorizontal = false,
  });

  final HomeOverviewMetric metric;
  final bool isHorizontal;

  @override
  Widget build(BuildContext context) {
    final cardContent = <Widget>[
      Expanded(flex: 2, child: _MetricDetails(metric: metric)),
      16.horizontalSpace,
      Expanded(flex: 3, child: _MetricPreview(imageUrl: metric.imageUrl)),
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
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: isHorizontal
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: cardContent,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MetricDetails(metric: metric),
                  16.verticalSpace,
                  _MetricPreview(imageUrl: metric.imageUrl),
                ],
              ),
      ),
    );
  }
}

class _MetricDetails extends StatelessWidget {
  const _MetricDetails({required this.metric});

  final HomeOverviewMetric metric;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(metric.title, style: AppStyles.bodyMeta),
        4.verticalSpace,
        Text(metric.value, style: AppStyles.cardTitle),
        4.verticalSpace,
        Text(metric.statusLabel, style: AppStyles.bodyMeta),
      ],
    );
  }
}

class _MetricPreview extends StatelessWidget {
  const _MetricPreview({required this.imageUrl});

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
