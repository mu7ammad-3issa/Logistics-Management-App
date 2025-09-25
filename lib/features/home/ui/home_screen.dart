import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logistics_management_app/core/theming/app_styles.dart';
import 'package:logistics_management_app/core/theming/colors_manager.dart';
import 'package:logistics_management_app/features/home/data/models/home_models.dart';
import 'package:logistics_management_app/features/home/logic/cubit/home_cubit.dart';
import 'package:logistics_management_app/features/home/logic/cubit/home_state.dart';
import 'package:logistics_management_app/features/home/ui/widgets/home_bottom_navigation.dart';
import 'package:logistics_management_app/features/home/ui/widgets/home_metric_card.dart';
import 'package:logistics_management_app/features/home/ui/widgets/home_quick_action_button.dart';
import 'package:logistics_management_app/features/drivers/ui/drivers_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => HomeCubit(), child: const _HomeView());
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.backgroundCanvas,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.isLoading || state.status == HomeStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.isFailure) {
              return _HomeErrorView(errorMessage: state.errorMessage);
            }

            return _HomeSuccessView(state: state);
          },
        ),
      ),
    );
  }
}

class _HomeSuccessView extends StatelessWidget {
  const _HomeSuccessView({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final horizontalPadding = _horizontalPaddingFor(width);
        final crossAxisCount = _metricCrossAxisCount(width);
        final gap = 16.w;
        final availableWidth = width - (horizontalPadding * 2);
        final itemWidth =
            (availableWidth - (gap * (crossAxisCount - 1))) / crossAxisCount;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: horizontalPadding,
                  right: horizontalPadding,
                  top: 16.h,
                  bottom: 24.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _HomeHeader(),
                    24.verticalSpace,
                    Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: state.metrics
                          .map(
                            (metric) => SizedBox(
                              width: crossAxisCount == 1
                                  ? double.infinity
                                  : itemWidth,
                              child: HomeMetricCard(
                                metric: metric,
                                isHorizontal: crossAxisCount > 1,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    24.verticalSpace,
                    _QuickActionsSection(actions: state.actions),
                  ],
                ),
              ),
            ),
            HomeBottomNavigation(
              items: state.navigationItems,
              activeIndex: state.activeNavigationIndex,
              onItemSelected: (index) => _handleNavigationTap(context, index),
            ),
          ],
        );
      },
    );
  }

  double _horizontalPaddingFor(double width) {
    if (width >= 1200) return 72.w;
    if (width >= 900) return 48.w;
    if (width >= 600) return 32.w;
    return 16.w;
  }

  int _metricCrossAxisCount(double width) {
    if (width >= 1100) return 3;
    if (width >= 750) return 2;
    return 1;
  }

  void _handleNavigationTap(BuildContext context, int index) {
    final cubit = context.read<HomeCubit>();

    if (index == 0) {
      cubit.selectNavigationItem(0);
      return;
    }

    if (index == 2) {
      cubit.selectNavigationItem(index);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const DriversScreen()))
          .then((_) => cubit.selectNavigationItem(0));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${state.navigationItems[index].label} is coming soon.'),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 24.r,
          backgroundColor: ColorsManager.surfaceMuted,
          backgroundImage: const NetworkImage(
            'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?auto=format&fit=crop&w=200&q=80',
          ),
        ),
        16.horizontalSpace,
        Expanded(
          child: Text(
            'Dashboard',
            style: AppStyles.pageTitle,
            textAlign: TextAlign.center,
          ),
        ),
        48.horizontalSpace,
      ],
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection({required this.actions});

  final List<HomeQuickAction> actions;

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final canLayoutHorizontally = maxWidth >= 360;
        final targetWidth = canLayoutHorizontally
            ? (maxWidth - 16.w) / 2
            : maxWidth;

        return Wrap(
          spacing: 16.w,
          runSpacing: 12.h,
          children: actions
              .map(
                (action) => SizedBox(
                  width: targetWidth.clamp(140.w, maxWidth).toDouble(),
                  child: HomeQuickActionButton(
                    action: action,
                    onPressed: () => _onActionPressed(context, action),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  void _onActionPressed(BuildContext context, HomeQuickAction action) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${action.label} tapped')));
  }
}

class _HomeErrorView extends StatelessWidget {
  const _HomeErrorView({this.errorMessage});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 40.sp,
            color: ColorsManager.textSecondary,
          ),
          12.verticalSpace,
          Text(
            errorMessage ?? 'We had trouble loading your dashboard.',
            style: AppStyles.bodyMeta,
            textAlign: TextAlign.center,
          ),
          16.verticalSpace,
          FilledButton(
            onPressed: context.read<HomeCubit>().retry,
            style: FilledButton.styleFrom(
              backgroundColor: ColorsManager.primaryActionBlue,
            ),
            child: Text('Retry', style: AppStyles.primaryButtonLabel),
          ),
        ],
      ),
    );
  }
}
