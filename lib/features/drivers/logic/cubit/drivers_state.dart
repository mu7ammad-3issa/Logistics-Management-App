import 'package:equatable/equatable.dart';
import 'package:logistics_management_app/features/drivers/data/models/driver_model.dart';

enum DriversStatus { initial, loading, success, failure }

class DriversState extends Equatable {
  const DriversState({
    this.status = DriversStatus.initial,
    this.drivers = const [],
    this.filteredDrivers = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  final DriversStatus status;
  final List<DriverProfile> drivers;
  final List<DriverProfile> filteredDrivers;
  final String searchQuery;
  final String? errorMessage;

  bool get isLoading => status == DriversStatus.loading;
  bool get isSuccess => status == DriversStatus.success;
  bool get isFailure => status == DriversStatus.failure;

  DriversState copyWith({
    DriversStatus? status,
    List<DriverProfile>? drivers,
    List<DriverProfile>? filteredDrivers,
    String? searchQuery,
    String? errorMessage,
  }) {
    return DriversState(
      status: status ?? this.status,
      drivers: drivers ?? this.drivers,
      filteredDrivers: filteredDrivers ?? this.filteredDrivers,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    drivers,
    filteredDrivers,
    searchQuery,
    errorMessage,
  ];
}
