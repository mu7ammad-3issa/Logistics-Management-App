import 'package:equatable/equatable.dart';
import 'package:logistics_management_app/features/vehicles/data/models/vehicle_model.dart';

enum VehiclesStatus { initial, loading, success, failure }

class VehiclesState extends Equatable {
  const VehiclesState({
    this.status = VehiclesStatus.initial,
    this.vehicles = const [],
    this.filteredVehicles = const [],
    this.activeFilter = VehicleFilter.all,
    this.searchQuery = '',
    this.errorMessage,
  });

  final VehiclesStatus status;
  final List<VehicleProfile> vehicles;
  final List<VehicleProfile> filteredVehicles;
  final VehicleFilter activeFilter;
  final String searchQuery;
  final String? errorMessage;

  bool get isLoading => status == VehiclesStatus.loading;
  bool get isSuccess => status == VehiclesStatus.success;
  bool get isFailure => status == VehiclesStatus.failure;

  VehiclesState copyWith({
    VehiclesStatus? status,
    List<VehicleProfile>? vehicles,
    List<VehicleProfile>? filteredVehicles,
    VehicleFilter? activeFilter,
    String? searchQuery,
    String? errorMessage,
  }) {
    return VehiclesState(
      status: status ?? this.status,
      vehicles: vehicles ?? this.vehicles,
      filteredVehicles: filteredVehicles ?? this.filteredVehicles,
      activeFilter: activeFilter ?? this.activeFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    vehicles,
    filteredVehicles,
    activeFilter,
    searchQuery,
    errorMessage,
  ];
}
