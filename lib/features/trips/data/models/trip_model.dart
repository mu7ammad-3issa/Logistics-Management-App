import 'package:equatable/equatable.dart';

enum TripStatus { pending, ongoing, completed }

class TripSummary extends Equatable {
  const TripSummary({
    required this.id,
    required this.status,
    required this.driverName,
    required this.vehicleName,
    required this.imageUrl,
  });

  final String id;
  final TripStatus status;
  final String driverName;
  final String vehicleName;
  final String imageUrl;

  String get displayTitle => 'Trip #$id';
  String get subtitle => 'Driver: $driverName · Vehicle: $vehicleName';

  TripSummary copyWith({
    String? id,
    TripStatus? status,
    String? driverName,
    String? vehicleName,
    String? imageUrl,
  }) {
    return TripSummary(
      id: id ?? this.id,
      status: status ?? this.status,
      driverName: driverName ?? this.driverName,
      vehicleName: vehicleName ?? this.vehicleName,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [id, status, driverName, vehicleName, imageUrl];
}

enum TripFilter { all, pending, ongoing, completed }

extension TripFilterX on TripFilter {
  String get label {
    switch (this) {
      case TripFilter.all:
        return 'All';
      case TripFilter.pending:
        return 'Pending';
      case TripFilter.ongoing:
        return 'Ongoing';
      case TripFilter.completed:
        return 'Completed';
    }
  }
}

TripFilter filterForStatus(TripStatus status) {
  switch (status) {
    case TripStatus.pending:
      return TripFilter.pending;
    case TripStatus.ongoing:
      return TripFilter.ongoing;
    case TripStatus.completed:
      return TripFilter.completed;
  }
}
