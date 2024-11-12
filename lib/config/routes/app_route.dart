import 'package:flutter/material.dart';
import 'package:quran_mentor/features/home/presentation/screens/home_screen.dart';
import 'package:quran_mentor/features/mentor/data/models/analyze_result_model/analyze_result_model.dart';
import 'package:quran_mentor/features/mentor/presentation/screens/analyze_result_screen.dart';
import 'package:quran_mentor/features/splash/presentation/screens/splash_screen.dart';

import '../../core/utils/app_strings.dart';

class Routes {
  static const String initialRoute = '/';
  static const String homeScreen = '/homeScreen';
  static const String aboutAppScreen = '/aboutAppScreen';
  static const String analyzeResultScreen = '/analyzeResultScreen';
}

class AppRoutes {
  static Route? onGenerateRoute(RouteSettings routeSettings) {
    // final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case Routes.initialRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case Routes.analyzeResultScreen:
      AnalyzeResultModel? analyzeResult = routeSettings.arguments as AnalyzeResultModel?; 
        return MaterialPageRoute(
            builder: (_) => AnalyzeResultScreen(
                  analyzeResult: analyzeResult!,
                ));

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text(AppStrings.noRouteFound),
              ),
              body: const Center(child: Text(AppStrings.noRouteFound)),
            ));
  }
}
