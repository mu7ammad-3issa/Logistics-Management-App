import 'package:equatable/equatable.dart';

enum VehicleStatus { available, inUse, maintenance }

enum VehicleFilter { all, available, inUse, maintenance }

class VehicleProfile extends Equatable {
  const VehicleProfile({
    required this.name,
    required this.type,
    required this.plateNumber,
    required this.status,
    required this.imageUrl,
    this.driverName,
    this.lastService,
    this.odometerKm,
  });

  final String name;
  final String type;
  final String plateNumber;
  final VehicleStatus status;
  final String imageUrl;
  final String? driverName;
  final String? lastService;
  final int? odometerKm;

  String get statusLabel => status.label;
  String get driverDisplay => driverName ?? 'Unassigned';
  String get summary => '$type · Plate $plateNumber';

  VehicleProfile copyWith({
    String? name,
    String? type,
    String? plateNumber,
    VehicleStatus? status,
    String? imageUrl,
    String? driverName,
    String? lastService,
    int? odometerKm,
  }) {
    return VehicleProfile(
      name: name ?? this.name,
      type: type ?? this.type,
      plateNumber: plateNumber ?? this.plateNumber,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      driverName: driverName ?? this.driverName,
      lastService: lastService ?? this.lastService,
      odometerKm: odometerKm ?? this.odometerKm,
    );
  }

  @override
  List<Object?> get props => [
    name,
    type,
    plateNumber,
    status,
    imageUrl,
    driverName,
    lastService,
    odometerKm,
  ];
}

extension VehicleStatusX on VehicleStatus {
  String get label {
    switch (this) {
      case VehicleStatus.available:
        return 'Available';
      case VehicleStatus.inUse:
        return 'In Use';
      case VehicleStatus.maintenance:
        return 'Maintenance';
    }
  }
}

VehicleFilter filterForVehicleStatus(VehicleStatus status) {
  switch (status) {
    case VehicleStatus.available:
      return VehicleFilter.available;
    case VehicleStatus.inUse:
      return VehicleFilter.inUse;
    case VehicleStatus.maintenance:
      return VehicleFilter.maintenance;
  }
}

extension VehicleFilterX on VehicleFilter {
  String get label {
    switch (this) {
      case VehicleFilter.all:
        return 'All';
      case VehicleFilter.available:
        return 'Available';
      case VehicleFilter.inUse:
        return 'In Use';
      case VehicleFilter.maintenance:
        return 'Maintenance';
    }
  }
}
