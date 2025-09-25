import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistics_management_app/features/drivers/data/models/driver_model.dart';
import 'package:logistics_management_app/features/drivers/logic/cubit/drivers_state.dart';

class DriversCubit extends Cubit<DriversState> {
  DriversCubit() : super(const DriversState()) {
    loadDrivers();
  }

  Future<void> loadDrivers() async {
    emit(state.copyWith(status: DriversStatus.loading));

    await Future<void>.delayed(const Duration(milliseconds: 350));

    final drivers = _buildDrivers();

    emit(
      state.copyWith(
        status: DriversStatus.success,
        drivers: drivers,
        filteredDrivers: drivers,
        searchQuery: '',
      ),
    );
  }

  void retry() {
    emit(const DriversState());
    loadDrivers();
  }

  void onSearchChanged(String query) {
    final sanitizedQuery = query.trim();
    final lowerCaseQuery = sanitizedQuery.toLowerCase();

    final filteredDrivers = state.drivers.where((driver) {
      final matchesName = driver.name.toLowerCase().contains(lowerCaseQuery);
      final matchesStatus = driver.availability.name.contains(lowerCaseQuery);
      return lowerCaseQuery.isEmpty || matchesName || matchesStatus;
    }).toList();

    emit(state.copyWith(searchQuery: query, filteredDrivers: filteredDrivers));
  }

  List<DriverProfile> _buildDrivers() {
    return const [
      DriverProfile(
        name: 'Ethan Carter',
        availability: DriverAvailability.available,
        avatarUrl:
            'https://images.unsplash.com/photo-1616423644344-4f1b2fa14655?auto=format&fit=crop&w=400&q=80',
      ),
      DriverProfile(
        name: 'Olivia Bennett',
        availability: DriverAvailability.unavailable,
        avatarUrl:
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=400&q=80',
      ),
      DriverProfile(
        name: 'Noah Thompson',
        availability: DriverAvailability.available,
        avatarUrl:
            'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?auto=format&fit=crop&w=400&q=80',
      ),
      DriverProfile(
        name: 'Ava Harper',
        availability: DriverAvailability.unavailable,
        avatarUrl:
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=400&q=80',
      ),
      DriverProfile(
        name: 'Liam Foster',
        availability: DriverAvailability.available,
        avatarUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80',
      ),
      DriverProfile(
        name: 'Isabella Hayes',
        availability: DriverAvailability.unavailable,
        avatarUrl:
            'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?auto=format&fit=crop&w=400&q=80',
      ),
    ];
  }
}
