import 'package:flutter/material.dart';
import 'package:logistics_management_app/core/routing/routes.dart';
import 'package:logistics_management_app/features/home/ui/home_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    // this arguments to be passed to any screen like this {arguments as className}
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      default:
        return null;
    }
  }
}
