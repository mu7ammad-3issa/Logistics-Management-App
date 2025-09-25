import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistics_management_app/features/trips/data/models/trip_model.dart';
import 'package:logistics_management_app/features/trips/logic/cubit/trips_state.dart';

class TripsCubit extends Cubit<TripsState> {
  TripsCubit() : super(const TripsState()) {
    loadTrips();
  }

  final List<String> _tripImagePool = const [
    'https://images.unsplash.com/photo-1464638681273-0962e9b53566?auto=format&fit=crop&w=900&q=80',
    'https://images.unsplash.com/photo-1519058082700-08a0b56da9b4?auto=format&fit=crop&w=900&q=80',
    'https://images.unsplash.com/photo-1502877338535-766e1452684a?auto=format&fit=crop&w=900&q=80',
    'https://images.unsplash.com/photo-1518644961665-ed172691aaa1?auto=format&fit=crop&w=900&q=80',
  ];
  int _imageCursor = 0;

  Future<void> loadTrips() async {
    emit(state.copyWith(status: TripsStatus.loading));

    await Future<void>.delayed(const Duration(milliseconds: 350));

    final trips = _buildTrips();

    emit(
      state.copyWith(
        status: TripsStatus.success,
        trips: trips,
        filteredTrips: trips,
        activeFilter: TripFilter.all,
      ),
    );
  }

  void retry() {
    emit(const TripsState());
    loadTrips();
  }

  void setFilter(TripFilter filter) {
    if (state.activeFilter == filter) return;

    final filteredTrips = _filterTrips(filter, state.trips);
    emit(state.copyWith(activeFilter: filter, filteredTrips: filteredTrips));
  }

  bool addTrip({
    required String driverName,
    required String vehicleName,
    required TripStatus status,
  }) {
    final sanitizedDriver = driverName.trim();
    final sanitizedVehicle = vehicleName.trim();
    if (sanitizedDriver.isEmpty || sanitizedVehicle.isEmpty) {
      return false;
    }

    final nextId = (_nextTripId(state.trips) + 1).toString().padLeft(5, '0');
    final newTrip = TripSummary(
      id: nextId,
      status: status,
      driverName: sanitizedDriver,
      vehicleName: sanitizedVehicle,
      imageUrl: _nextTripImage(),
    );

    final updatedTrips = [newTrip, ...state.trips];
    final filteredTrips = _filterTrips(state.activeFilter, updatedTrips);

    emit(state.copyWith(trips: updatedTrips, filteredTrips: filteredTrips));

    return true;
  }

  bool updateTrip(
    String id, {
    required TripStatus status,
    required String driverName,
    required String vehicleName,
  }) {
    final sanitizedDriver = driverName.trim();
    final sanitizedVehicle = vehicleName.trim();
    if (sanitizedDriver.isEmpty || sanitizedVehicle.isEmpty) {
      return false;
    }

    final updatedTrips = state.trips
        .map((trip) {
          if (trip.id == id) {
            return trip.copyWith(
              status: status,
              driverName: sanitizedDriver,
              vehicleName: sanitizedVehicle,
            );
          }
          return trip;
        })
        .toList(growable: false);

    final filteredTrips = _filterTrips(state.activeFilter, updatedTrips);

    emit(state.copyWith(trips: updatedTrips, filteredTrips: filteredTrips));

    return true;
  }

  List<TripSummary> _filterTrips(TripFilter filter, List<TripSummary> trips) {
    if (filter == TripFilter.all) return trips;
    return trips
        .where((trip) => filterForStatus(trip.status) == filter)
        .toList();
  }

  List<TripSummary> _buildTrips() {
    return const [
      TripSummary(
        id: '12345',
        status: TripStatus.pending,
        driverName: 'Alex Johnson',
        vehicleName: 'Truck 1',
        imageUrl:
            'https://images.unsplash.com/photo-1519181245277-cffeb31da2fb?auto=format&fit=crop&w=900&q=80',
      ),
      TripSummary(
        id: '67890',
        status: TripStatus.ongoing,
        driverName: 'Sarah Lee',
        vehicleName: 'Van 2',
        imageUrl:
            'https://images.unsplash.com/photo-1477414348463-c0eb7f1359b6?auto=format&fit=crop&w=900&q=80',
      ),
      TripSummary(
        id: '11223',
        status: TripStatus.completed,
        driverName: 'David Chen',
        vehicleName: 'Truck 3',
        imageUrl:
            'https://images.unsplash.com/photo-1605106702844-30fb3c0b89f7?auto=format&fit=crop&w=900&q=80',
      ),
      TripSummary(
        id: '44556',
        status: TripStatus.pending,
        driverName: 'Mia Clarke',
        vehicleName: 'Sprinter Van',
        imageUrl:
            'https://images.unsplash.com/photo-1489515217757-5fd1be406fef?auto=format&fit=crop&w=900&q=80',
      ),
      TripSummary(
        id: '77889',
        status: TripStatus.ongoing,
        driverName: 'Oscar Diaz',
        vehicleName: 'Truck 4',
        imageUrl:
            'https://images.unsplash.com/photo-1493238792000-8113da705763?auto=format&fit=crop&w=900&q=80',
      ),
    ];
  }

  int _nextTripId(List<TripSummary> trips) {
    return trips.fold<int>(0, (previousValue, element) {
      final parsed = int.tryParse(element.id) ?? 0;
      return max(previousValue, parsed);
    });
  }

  String _nextTripImage() {
    if (_tripImagePool.isEmpty) {
      return 'https://images.unsplash.com/photo-1454496522488-7a8e488e8606?auto=format&fit=crop&w=900&q=80';
    }
    final image = _tripImagePool[_imageCursor % _tripImagePool.length];
    _imageCursor += 1;
    return image;
  }
}
