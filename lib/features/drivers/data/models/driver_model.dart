import 'package:equatable/equatable.dart';

enum DriverAvailability { available, unavailable }

class DriverProfile extends Equatable {
  const DriverProfile({
    required this.name,
    required this.avatarUrl,
    required this.availability,
  });

  final String name;
  final String avatarUrl;
  final DriverAvailability availability;

  @override
  List<Object?> get props => [name, avatarUrl, availability];
}
