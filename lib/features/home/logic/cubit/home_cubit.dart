import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistics_management_app/core/theming/colors_manager.dart';
import 'package:logistics_management_app/features/home/data/models/home_models.dart';
import 'package:logistics_management_app/features/home/logic/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState()) {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    emit(state.copyWith(status: HomeStatus.loading));

    // Simulated network delay for showcasing loading state.
    await Future<void>.delayed(const Duration(milliseconds: 350));

    emit(
      state.copyWith(
        status: HomeStatus.success,
        metrics: _buildMetrics(),
        actions: _buildQuickActions(),
        navigationItems: _buildNavigationItems(),
      ),
    );
  }

  void retry() {
    emit(state.copyWith(status: HomeStatus.initial, errorMessage: null));
    loadDashboard();
  }

  void selectNavigationItem(int index) {
    emit(state.copyWith(activeNavigationIndex: index));
  }

  List<HomeOverviewMetric> _buildMetrics() {
    return const [
      HomeOverviewMetric(
        title: 'Trips',
        value: '12',
        statusLabel: 'Active',
        imageUrl:
            'https://images.unsplash.com/photo-1529429617124-aee64b04c02d?auto=format&fit=crop&w=900&q=80',
      ),
      HomeOverviewMetric(
        title: 'Drivers',
        value: '8',
        statusLabel: 'Available',
        imageUrl:
            'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&w=900&q=80',
      ),
      HomeOverviewMetric(
        title: 'Vehicles',
        value: '10',
        statusLabel: 'In Use',
        imageUrl:
            'https://images.unsplash.com/photo-1511919884226-fd3cad34687c?auto=format&fit=crop&w=900&q=80',
      ),
    ];
  }

  List<HomeQuickAction> _buildQuickActions() {
    return const [
      HomeQuickAction(
        label: 'Add Trip',
        backgroundColor: ColorsManager.primaryActionBlue,
        foregroundColor: ColorsManager.textOnPrimary,
      ),
      HomeQuickAction(
        label: 'Assign Driver',
        backgroundColor: ColorsManager.surfaceMuted,
        foregroundColor: ColorsManager.textPrimary,
      ),
    ];
  }

  List<HomeNavigationItem> _buildNavigationItems() {
    return const [
      HomeNavigationItem(label: 'Dashboard', icon: Icons.home_rounded),
      HomeNavigationItem(label: 'Vehicles', icon: Icons.local_shipping),
      HomeNavigationItem(label: 'Drivers', icon: Icons.people_alt_rounded),
      HomeNavigationItem(label: 'Trips', icon: Icons.map_outlined),
    ];
  }
}
