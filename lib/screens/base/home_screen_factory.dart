import 'package:flutter/material.dart';
import 'package:jesusapp/screens/christian_home_screen.dart';
import 'package:jesusapp/screens/default_home_screen.dart';
import 'package:jesusapp/theme/app_flavor.dart';

/// Factory para criar a tela inicial apropriada baseada no flavor
class HomeScreenFactory {
  /// Cria a tela inicial apropriada baseada no flavor atual
  static Widget createHomeScreen(String flavor) {
    switch (flavor) {
      case AppFlavor.christian:
        return const ChristianHomeScreen();
      case AppFlavor.defaultFlavor:
        return const DefaultHomeScreen();
      default:
        throw Exception('Flavor não suportado: $flavor');
    }
  }
}
