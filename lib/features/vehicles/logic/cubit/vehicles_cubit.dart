import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistics_management_app/features/vehicles/data/models/vehicle_model.dart';
import 'package:logistics_management_app/features/vehicles/logic/cubit/vehicles_state.dart';

class VehiclesCubit extends Cubit<VehiclesState> {
  VehiclesCubit() : super(const VehiclesState()) {
    loadVehicles();
  }

  Future<void> loadVehicles() async {
    emit(state.copyWith(status: VehiclesStatus.loading));

    await Future<void>.delayed(const Duration(milliseconds: 350));

    final vehicles = _buildVehicles();
    final filtered = _applyFilters(
      vehicles: vehicles,
      filter: VehicleFilter.all,
      query: '',
    );

    emit(
      state.copyWith(
        status: VehiclesStatus.success,
        vehicles: vehicles,
        filteredVehicles: filtered,
        activeFilter: VehicleFilter.all,
        searchQuery: '',
      ),
    );
  }

  void retry() {
    emit(const VehiclesState());
    loadVehicles();
  }

  void setFilter(VehicleFilter filter) {
    if (state.activeFilter == filter) return;

    final filtered = _applyFilters(
      vehicles: state.vehicles,
      filter: filter,
      query: state.searchQuery,
    );

    emit(state.copyWith(activeFilter: filter, filteredVehicles: filtered));
  }

  void onSearchChanged(String query) {
    final sanitizedQuery = query.trim();

    final filtered = _applyFilters(
      vehicles: state.vehicles,
      filter: state.activeFilter,
      query: sanitizedQuery,
    );

    emit(
      state.copyWith(searchQuery: sanitizedQuery, filteredVehicles: filtered),
    );
  }

  List<VehicleProfile> _applyFilters({
    required List<VehicleProfile> vehicles,
    required VehicleFilter filter,
    required String query,
  }) {
    Iterable<VehicleProfile> filtered = vehicles;

    if (filter != VehicleFilter.all) {
      filtered = filtered.where(
        (vehicle) => filterForVehicleStatus(vehicle.status) == filter,
      );
    }

    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      filtered = filtered.where((vehicle) {
        final matchesName = vehicle.name.toLowerCase().contains(lowerQuery);
        final matchesType = vehicle.type.toLowerCase().contains(lowerQuery);
        final matchesDriver =
            vehicle.driverName?.toLowerCase().contains(lowerQuery) ?? false;
        final matchesPlate = vehicle.plateNumber.toLowerCase().contains(
          lowerQuery,
        );
        return matchesName || matchesType || matchesDriver || matchesPlate;
      });
    }

    return List<VehicleProfile>.unmodifiable(filtered);
  }

  List<VehicleProfile> _buildVehicles() {
    return const [
      VehicleProfile(
        name: 'Freightliner Cascadia',
        type: 'Heavy Truck',
        plateNumber: 'TX-8421',
        status: VehicleStatus.inUse,
        driverName: 'Alex Johnson',
        lastService: 'Aug 12, 2025',
        odometerKm: 182340,
        imageUrl:
            'https://images.unsplash.com/photo-1502877338535-766e1452684a?auto=format&fit=crop&w=900&q=80',
      ),
      VehicleProfile(
        name: 'Mercedes Sprinter',
        type: 'Cargo Van',
        plateNumber: 'CA-3178',
        status: VehicleStatus.available,
        driverName: 'Sarah Lee',
        lastService: 'Jul 30, 2025',
        odometerKm: 98210,
        imageUrl:
            'https://images.unsplash.com/photo-1529429617124-aee64b04c02d?auto=format&fit=crop&w=900&q=80',
      ),
      VehicleProfile(
        name: 'Ford Transit',
        type: 'Delivery Van',
        plateNumber: 'NV-5534',
        status: VehicleStatus.maintenance,
        driverName: 'Maintenance Bay',
        lastService: 'Sep 02, 2025',
        odometerKm: 135420,
        imageUrl:
            'https://images.unsplash.com/photo-1549924231-f129b911e442?auto=format&fit=crop&w=900&q=80',
      ),
      VehicleProfile(
        name: 'Volvo FH16',
        type: 'Heavy Truck',
        plateNumber: 'UT-2645',
        status: VehicleStatus.inUse,
        driverName: 'David Chen',
        lastService: 'Aug 28, 2025',
        odometerKm: 210540,
        imageUrl:
            'https://images.unsplash.com/photo-1541447271487-096b39888e47?auto=format&fit=crop&w=900&q=80',
      ),
      VehicleProfile(
        name: 'Isuzu N-Series',
        type: 'Box Truck',
        plateNumber: 'AZ-9984',
        status: VehicleStatus.available,
        driverName: 'Unassigned',
        lastService: 'Aug 04, 2025',
        odometerKm: 76450,
        imageUrl:
            'https://images.unsplash.com/photo-1582095133179-bfd08e2fc6b3?auto=format&fit=crop&w=900&q=80',
      ),
    ];
  }
}
