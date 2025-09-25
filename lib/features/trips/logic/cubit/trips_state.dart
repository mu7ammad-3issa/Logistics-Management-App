import 'package:equatable/equatable.dart';
import 'package:logistics_management_app/features/trips/data/models/trip_model.dart';

enum TripsStatus { initial, loading, success, failure }

class TripsState extends Equatable {
  const TripsState({
    this.status = TripsStatus.initial,
    this.trips = const [],
    this.filteredTrips = const [],
    this.activeFilter = TripFilter.all,
    this.errorMessage,
  });

  final TripsStatus status;
  final List<TripSummary> trips;
  final List<TripSummary> filteredTrips;
  final TripFilter activeFilter;
  final String? errorMessage;

  bool get isLoading => status == TripsStatus.loading;
  bool get isSuccess => status == TripsStatus.success;
  bool get isFailure => status == TripsStatus.failure;

  TripsState copyWith({
    TripsStatus? status,
    List<TripSummary>? trips,
    List<TripSummary>? filteredTrips,
    TripFilter? activeFilter,
    String? errorMessage,
  }) {
    return TripsState(
      status: status ?? this.status,
      trips: trips ?? this.trips,
      filteredTrips: filteredTrips ?? this.filteredTrips,
      activeFilter: activeFilter ?? this.activeFilter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    trips,
    filteredTrips,
    activeFilter,
    errorMessage,
  ];
}
