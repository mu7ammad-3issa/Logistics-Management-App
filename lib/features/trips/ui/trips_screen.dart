import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logistics_management_app/core/theming/app_styles.dart';
import 'package:logistics_management_app/core/theming/colors_manager.dart';
import 'package:logistics_management_app/features/home/data/models/home_models.dart';
import 'package:logistics_management_app/features/home/ui/home_screen.dart';
import 'package:logistics_management_app/features/home/ui/widgets/home_bottom_navigation.dart';
import 'package:logistics_management_app/features/drivers/ui/drivers_screen.dart';
import 'package:logistics_management_app/features/trips/data/models/trip_model.dart';
import 'package:logistics_management_app/features/trips/logic/cubit/trips_cubit.dart';
import 'package:logistics_management_app/features/trips/logic/cubit/trips_state.dart';
import 'package:logistics_management_app/features/trips/ui/widgets/trip_card.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => TripsCubit(), child: const _TripsView());
  }
}

class _TripsView extends StatelessWidget {
  const _TripsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.backgroundCanvas,
      body: SafeArea(
        child: BlocBuilder<TripsCubit, TripsState>(
          builder: (context, state) {
            if (state.isLoading || state.status == TripsStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.isFailure) {
              return _TripsErrorView(errorMessage: state.errorMessage);
            }

            return _TripsSuccessView(state: state);
          },
        ),
      ),
    );
  }
}

class _TripsSuccessView extends StatelessWidget {
  const _TripsSuccessView({required this.state});

  final TripsState state;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final horizontalPadding = _horizontalPaddingFor(width);
        final crossAxisCount = _gridCrossAxisCount(width);

        return Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      16.h,
                      horizontalPadding,
                      0,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _TripsHeader(),
                          16.verticalSpace,
                          const _TripsFilterTabs(),
                          24.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                  if (state.filteredTrips.isEmpty)
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 24.h,
                      ),
                      sliver: const SliverToBoxAdapter(
                        child: _TripsEmptyState(),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        0,
                        horizontalPadding,
                        24.h,
                      ),
                      sliver: _TripsCollection(
                        trips: state.filteredTrips,
                        crossAxisCount: crossAxisCount,
                      ),
                    ),
                ],
              ),
            ),
            HomeBottomNavigation(
              items: dashboardNavigationItems,
              activeIndex: 3,
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

  int _gridCrossAxisCount(double width) {
    if (width >= 1100) return 2;
    if (width >= 800) return 2;
    return 1;
  }

  void _handleNavigationTap(BuildContext context, int index) {
    if (index == 3) return;
    if (index == 0) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
      return;
    }

    if (index == 2) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DriversScreen()),
      );
      return;
    }

    final label = dashboardNavigationItems[index].label;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$label is coming soon.')));
  }
}

class _TripsHeader extends StatelessWidget {
  const _TripsHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 48.w),
        Expanded(
          child: Text(
            'Trips',
            style: AppStyles.pageTitle,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 48.w,
          child: Align(
            alignment: Alignment.centerRight,
            child: _AddTripButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add Trip tapped')),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _AddTripButton extends StatelessWidget {
  const _AddTripButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onPressed,
        child: Container(
          height: 44.r,
          width: 44.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: ColorsManager.surfaceMuted,
          ),
          child: Icon(Icons.add, color: ColorsManager.textPrimary, size: 24.sp),
        ),
      ),
    );
  }
}

class _TripsFilterTabs extends StatelessWidget {
  const _TripsFilterTabs();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripsCubit, TripsState>(
      buildWhen: (previous, current) =>
          previous.activeFilter != current.activeFilter,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: ColorsManager.borderSubtle, width: 1),
            ),
          ),
          child: Row(
            children: TripFilter.values.map((filter) {
              final isActive = filter == state.activeFilter;
              return Expanded(
                child: InkWell(
                  onTap: () => context.read<TripsCubit>().setFilter(filter),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          filter.label,
                          style: isActive
                              ? AppStyles.tabLabelActive
                              : AppStyles.tabLabelInactive,
                        ),
                        8.verticalSpace,
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 3,
                          width: 32.w,
                          decoration: BoxDecoration(
                            color: isActive
                                ? ColorsManager.primaryActionBlue
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _TripsCollection extends StatelessWidget {
  const _TripsCollection({required this.trips, required this.crossAxisCount});

  final List<TripSummary> trips;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    if (crossAxisCount == 1) {
      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final trip = trips[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == trips.length - 1 ? 0 : 16.h,
            ),
            child: TripCard(
              trip: trip,
              onViewPressed: () => _onViewPressed(context, trip),
            ),
          );
        }, childCount: trips.length),
      );
    }

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        mainAxisExtent: 220.h,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => TripCard(
          trip: trips[index],
          isHorizontal: true,
          onViewPressed: () => _onViewPressed(context, trips[index]),
        ),
        childCount: trips.length,
      ),
    );
  }

  void _onViewPressed(BuildContext context, TripSummary trip) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Viewing ${trip.displayTitle}')));
  }
}

class _TripsEmptyState extends StatelessWidget {
  const _TripsEmptyState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.map_outlined,
          size: 48.sp,
          color: ColorsManager.textSecondary,
        ),
        12.verticalSpace,
        Text('No trips to display', style: AppStyles.cardTitle),
        8.verticalSpace,
        Text(
          'Try adjusting your filters or refresh to load more trips.',
          style: AppStyles.bodyMeta,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _TripsErrorView extends StatelessWidget {
  const _TripsErrorView({this.errorMessage});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 40.sp, color: ColorsManager.errorRed),
          12.verticalSpace,
          Text(
            errorMessage ?? 'Unable to load trips right now.',
            style: AppStyles.bodyMeta,
            textAlign: TextAlign.center,
          ),
          16.verticalSpace,
          FilledButton(
            onPressed: context.read<TripsCubit>().retry,
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
