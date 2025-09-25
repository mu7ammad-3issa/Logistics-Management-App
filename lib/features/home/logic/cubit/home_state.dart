import 'package:equatable/equatable.dart';
import 'package:logistics_management_app/features/home/data/models/home_models.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.metrics = const [],
    this.actions = const [],
    this.navigationItems = const [],
    this.activeNavigationIndex = 0,
    this.errorMessage,
  });

  final HomeStatus status;
  final List<HomeOverviewMetric> metrics;
  final List<HomeQuickAction> actions;
  final List<HomeNavigationItem> navigationItems;
  final int activeNavigationIndex;
  final String? errorMessage;

  bool get isLoading => status == HomeStatus.loading;
  bool get isSuccess => status == HomeStatus.success;
  bool get isFailure => status == HomeStatus.failure;

  HomeState copyWith({
    HomeStatus? status,
    List<HomeOverviewMetric>? metrics,
    List<HomeQuickAction>? actions,
    List<HomeNavigationItem>? navigationItems,
    int? activeNavigationIndex,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      metrics: metrics ?? this.metrics,
      actions: actions ?? this.actions,
      navigationItems: navigationItems ?? this.navigationItems,
      activeNavigationIndex:
          activeNavigationIndex ?? this.activeNavigationIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    metrics,
    actions,
    navigationItems,
    activeNavigationIndex,
    errorMessage,
  ];
}
