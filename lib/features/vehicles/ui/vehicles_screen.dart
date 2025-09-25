import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logistics_management_app/core/theming/app_styles.dart';
import 'package:logistics_management_app/core/theming/colors_manager.dart';
import 'package:logistics_management_app/features/drivers/ui/drivers_screen.dart';
import 'package:logistics_management_app/features/home/data/models/home_models.dart';
import 'package:logistics_management_app/features/home/ui/home_screen.dart';
import 'package:logistics_management_app/features/home/ui/widgets/home_bottom_navigation.dart';
import 'package:logistics_management_app/features/trips/ui/trips_screen.dart';
import 'package:logistics_management_app/features/vehicles/data/models/vehicle_model.dart';
import 'package:logistics_management_app/features/vehicles/logic/cubit/vehicles_cubit.dart';
import 'package:logistics_management_app/features/vehicles/logic/cubit/vehicles_state.dart';
import 'package:logistics_management_app/features/vehicles/ui/widgets/vehicle_card.dart';

class VehiclesScreen extends StatelessWidget {
  const VehiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VehiclesCubit(),
      child: const _VehiclesView(),
    );
  }
}

class _VehiclesView extends StatelessWidget {
  const _VehiclesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.backgroundCanvas,
      body: SafeArea(
        child: BlocBuilder<VehiclesCubit, VehiclesState>(
          builder: (context, state) {
            if (state.isLoading || state.status == VehiclesStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.isFailure) {
              return _VehiclesErrorView(errorMessage: state.errorMessage);
            }

            return _VehiclesSuccessView(state: state);
          },
        ),
      ),
    );
  }
}

class _VehiclesSuccessView extends StatelessWidget {
  const _VehiclesSuccessView({required this.state});

  final VehiclesState state;

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
                          const _VehiclesHeader(),
                          16.verticalSpace,
                          const _VehiclesSearchField(),
                          16.verticalSpace,
                          const _VehiclesFilterTabs(),
                        ],
                      ),
                    ),
                  ),
                  if (state.filteredVehicles.isEmpty)
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 32.h,
                      ),
                      sliver: const SliverToBoxAdapter(
                        child: _VehiclesEmptyState(),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        24.h,
                        horizontalPadding,
                        24.h,
                      ),
                      sliver: _VehicleCollection(
                        vehicles: state.filteredVehicles,
                        crossAxisCount: crossAxisCount,
                      ),
                    ),
                ],
              ),
            ),
            HomeBottomNavigation(
              items: dashboardNavigationItems,
              activeIndex: 1,
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
    if (width >= 1280) return 3;
    if (width >= 900) return 2;
    return 1;
  }

  void _handleNavigationTap(BuildContext context, int index) {
    if (index == 1) return;

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

    if (index == 3) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const TripsScreen()));
      return;
    }

    final label = dashboardNavigationItems[index].label;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$label is coming soon.')));
  }
}

class _VehiclesHeader extends StatelessWidget {
  const _VehiclesHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 48.w),
        Expanded(
          child: Text(
            'Vehicles',
            style: AppStyles.pageTitle,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 48.w,
          child: Align(
            alignment: Alignment.centerRight,
            child: _AddVehicleButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add Vehicle tapped')),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _AddVehicleButton extends StatelessWidget {
  const _AddVehicleButton({required this.onPressed});

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
          child: Icon(Icons.add, size: 24.sp, color: ColorsManager.textPrimary),
        ),
      ),
    );
  }
}

class _VehiclesSearchField extends StatefulWidget {
  const _VehiclesSearchField();

  @override
  State<_VehiclesSearchField> createState() => _VehiclesSearchFieldState();
}

class _VehiclesSearchFieldState extends State<_VehiclesSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final state = context.read<VehiclesCubit>().state;
    _controller = TextEditingController(text: state.searchQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VehiclesCubit, VehiclesState>(
      listenWhen: (previous, current) =>
          previous.searchQuery != current.searchQuery,
      listener: (context, state) {
        if (_controller.text != state.searchQuery) {
          _controller.value = TextEditingValue(
            text: state.searchQuery,
            selection: TextSelection.collapsed(
              offset: state.searchQuery.length,
            ),
          );
        }
      },
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: ColorsManager.surfaceMuted,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            16.horizontalSpace,
            Icon(Icons.search, size: 22.sp, color: ColorsManager.textSecondary),
            12.horizontalSpace,
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: context.read<VehiclesCubit>().onSearchChanged,
                style: AppStyles.searchInput,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search vehicles',
                  hintStyle: AppStyles.searchPlaceholder,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VehiclesFilterTabs extends StatelessWidget {
  const _VehiclesFilterTabs();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehiclesCubit, VehiclesState>(
      buildWhen: (previous, current) =>
          previous.activeFilter != current.activeFilter ||
          previous.vehicles != current.vehicles,
      builder: (context, state) {
        final counts = _buildCounts(state.vehicles);

        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: ColorsManager.borderSubtle, width: 1),
            ),
          ),
          child: Row(
            children: VehicleFilter.values.map((filter) {
              final isActive = state.activeFilter == filter;
              final label = '${filter.label} (${counts[filter] ?? 0})';

              return Expanded(
                child: InkWell(
                  onTap: () => context.read<VehiclesCubit>().setFilter(filter),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
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

  Map<VehicleFilter, int> _buildCounts(List<VehicleProfile> vehicles) {
    final counts = <VehicleFilter, int>{
      for (final filter in VehicleFilter.values) filter: 0,
    };

    for (final vehicle in vehicles) {
      final filter = filterForVehicleStatus(vehicle.status);
      counts[filter] = (counts[filter] ?? 0) + 1;
    }

    counts[VehicleFilter.all] = vehicles.length;
    return counts;
  }
}

class _VehicleCollection extends StatelessWidget {
  const _VehicleCollection({
    required this.vehicles,
    required this.crossAxisCount,
  });

  final List<VehicleProfile> vehicles;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    if (crossAxisCount == 1) {
      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final vehicle = vehicles[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == vehicles.length - 1 ? 0 : 16.h,
            ),
            child: VehicleCard(
              vehicle: vehicle,
              onManagePressed: () => _onManagePressed(context, vehicle),
            ),
          );
        }, childCount: vehicles.length),
      );
    }

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 16.w,
        mainAxisExtent: 260.h,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => VehicleCard(
          vehicle: vehicles[index],
          isHorizontal: true,
          onManagePressed: () => _onManagePressed(context, vehicles[index]),
        ),
        childCount: vehicles.length,
      ),
    );
  }

  void _onManagePressed(BuildContext context, VehicleProfile vehicle) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Manage ${vehicle.name} tapped')));
  }
}

class _VehiclesEmptyState extends StatelessWidget {
  const _VehiclesEmptyState();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.local_shipping_outlined,
          size: 48.sp,
          color: ColorsManager.textSecondary,
        ),
        12.verticalSpace,
        Text('No vehicles found', style: AppStyles.cardTitle),
        8.verticalSpace,
        Text(
          'Try adjusting your filters or add a new vehicle.',
          style: AppStyles.bodyMeta,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _VehiclesErrorView extends StatelessWidget {
  const _VehiclesErrorView({this.errorMessage});

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
            errorMessage ?? 'Unable to load vehicles right now.',
            style: AppStyles.bodyMeta,
            textAlign: TextAlign.center,
          ),
          16.verticalSpace,
          FilledButton(
            onPressed: context.read<VehiclesCubit>().retry,
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
