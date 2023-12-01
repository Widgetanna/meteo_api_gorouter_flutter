// router.dart
import 'package:go_router/go_router.dart';
import 'package:my_meteo_flutter/pages/geolocalisation.dart';
import 'package:my_meteo_flutter/pages/home_page.dart';
import 'package:my_meteo_flutter/pages/localosation.dart';

class AppRouter {
  static final GoRouter instance = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/geoloc',
        builder: (context, state) => const Geolocalisation(),
      ),
      GoRoute(
        path: '/localisation',
        builder: (context, state) {
          String cityName = state.extra as String;
          print(cityName);
          return  Localisation( cityName: cityName); },
      ),
    ],
  );
}
