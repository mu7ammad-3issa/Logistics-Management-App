import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class HomeOverviewMetric extends Equatable {
  const HomeOverviewMetric({
    required this.title,
    required this.value,
    required this.statusLabel,
    required this.imageUrl,
  });

  final String title;
  final String value;
  final String statusLabel;
  final String imageUrl;

  @override
  List<Object?> get props => [title, value, statusLabel, imageUrl];
}

class HomeQuickAction extends Equatable {
  const HomeQuickAction({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  List<Object?> get props => [label, backgroundColor, foregroundColor];
}

class HomeNavigationItem extends Equatable {
  const HomeNavigationItem({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  List<Object?> get props => [label, icon];
}

const List<HomeNavigationItem> dashboardNavigationItems = [
  HomeNavigationItem(label: 'Dashboard', icon: Icons.home_rounded),
  HomeNavigationItem(label: 'Vehicles', icon: Icons.local_shipping),
  HomeNavigationItem(label: 'Drivers', icon: Icons.people_alt_rounded),
  HomeNavigationItem(label: 'Trips', icon: Icons.map_outlined),
];
