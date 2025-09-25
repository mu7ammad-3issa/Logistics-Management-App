import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logistics_management_app/core/theming/app_styles.dart';
import 'package:logistics_management_app/core/theming/colors_manager.dart';
import 'package:logistics_management_app/features/drivers/data/models/driver_model.dart';
import 'package:logistics_management_app/features/drivers/logic/cubit/drivers_cubit.dart';
import 'package:logistics_management_app/features/drivers/logic/cubit/drivers_state.dart';
import 'package:logistics_management_app/features/drivers/ui/widgets/driver_list_item.dart';
import 'package:logistics_management_app/features/home/data/models/home_models.dart';
import 'package:logistics_management_app/features/home/ui/widgets/home_bottom_navigation.dart';
import 'package:logistics_management_app/features/home/ui/home_screen.dart';
import 'package:logistics_management_app/features/trips/ui/trips_screen.dart';
import 'package:logistics_management_app/features/vehicles/ui/vehicles_screen.dart';

class DriversScreen extends StatelessWidget {
  const DriversScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DriversCubit(),
      child: const _DriversView(),
    );
  }
}

class _DriversView extends StatelessWidget {
  const _DriversView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.backgroundCanvas,
      body: SafeArea(
        child: BlocBuilder<DriversCubit, DriversState>(
          builder: (context, state) {
            if (state.isLoading || state.status == DriversStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.isFailure) {
              return _DriversErrorView(errorMessage: state.errorMessage);
            }

            return _DriversSuccessView(state: state);
          },
        ),
      ),
    );
  }
}

class _DriversSuccessView extends StatelessWidget {
  const _DriversSuccessView({required this.state});

  final DriversState state;

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
                          const _DriversHeader(),
                          16.verticalSpace,
                          const _DriversSearchField(),
                          24.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                  if (state.filteredDrivers.isEmpty)
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 24.h,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: _DriversEmptyState(query: state.searchQuery),
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
                      sliver: _DriverCollection(
                        drivers: state.filteredDrivers,
                        crossAxisCount: crossAxisCount,
                      ),
                    ),
                ],
              ),
            ),
            HomeBottomNavigation(
              items: dashboardNavigationItems,
              activeIndex: 2,
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
    if (width >= 1100) return 3;
    if (width >= 800) return 2;
    return 1;
  }

  void _handleNavigationTap(BuildContext context, int index) {
    if (index == 2) return;
    if (index == 0) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
      return;
    }

    if (index == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const VehiclesScreen()),
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

class _DriversHeader extends StatelessWidget {
  const _DriversHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 48.w),
        Expanded(
          child: Text(
            'Drivers',
            style: AppStyles.pageTitle,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 48.w,
          child: Align(
            alignment: Alignment.centerRight,
            child: _AddDriverButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add Driver tapped')),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _AddDriverButton extends StatelessWidget {
  const _AddDriverButton({required this.onPressed});

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

class _DriversSearchField extends StatefulWidget {
  const _DriversSearchField();

  @override
  State<_DriversSearchField> createState() => _DriversSearchFieldState();
}

class _DriversSearchFieldState extends State<_DriversSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final state = context.read<DriversCubit>().state;
    _controller = TextEditingController(text: state.searchQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DriversCubit, DriversState>(
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
            Icon(Icons.search, color: ColorsManager.textSecondary, size: 22.sp),
            12.horizontalSpace,
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: context.read<DriversCubit>().onSearchChanged,
                style: AppStyles.searchInput,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search drivers',
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

class _DriverCollection extends StatelessWidget {
  const _DriverCollection({
    required this.drivers,
    required this.crossAxisCount,
  });

  final List<DriverProfile> drivers;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    if (crossAxisCount == 1) {
      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final driver = drivers[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == drivers.length - 1 ? 0 : 16.h,
            ),
            child: DriverListItem(driver: driver),
          );
        }, childCount: drivers.length),
      );
    }

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 16.w,
        mainAxisExtent: 96.h,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => DriverListItem(driver: drivers[index]),
        childCount: drivers.length,
      ),
    );
  }
}

class _DriversEmptyState extends StatelessWidget {
  const _DriversEmptyState({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.group_off_rounded,
          size: 48.sp,
          color: ColorsManager.textSecondary,
        ),
        12.verticalSpace,
        Text(
          'No drivers found',
          style: AppStyles.cardTitle,
          textAlign: TextAlign.center,
        ),
        8.verticalSpace,
        Text(
          query.isEmpty
              ? 'Try refreshing or adding a new driver.'
              : 'No drivers match "$query". Update your search and try again.',
          style: AppStyles.bodyMeta,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _DriversErrorView extends StatelessWidget {
  const _DriversErrorView({this.errorMessage});

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
            errorMessage ?? 'Unable to load drivers right now.',
            style: AppStyles.bodyMeta,
            textAlign: TextAlign.center,
          ),
          16.verticalSpace,
          FilledButton(
            onPressed: context.read<DriversCubit>().retry,
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
