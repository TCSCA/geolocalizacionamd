import 'package:geolocalizacionamd/app/pages/sources/amd_history/amd_history_page.dart';
import 'package:geolocalizacionamd/app/pages/sources/amd_location/amd_location_page.dart';
import 'package:geolocalizacionamd/app/pages/sources/amd_pending/amd_pending_page.dart';
import 'package:geolocalizacionamd/app/pages/sources/main/main_page.dart';
import 'package:geolocalizacionamd/app/pages/sources/navigation/navigation_page.dart';
import 'package:geolocalizacionamd/app/pages/sources/profile/profile_page.dart';
import 'package:go_router/go_router.dart';

import '../sources/login/login_page.dart';

class GeoAmdRoutes {
  static const login = '/';
  static const home = '/home';
  //static const amdPending = '/amdPending';
  static const amdLocation = '/amdLocation';
  static const profile = '/profile';
  static const medicalCareAccepted = '/medicalCareAccepted';
  static const medicalCareHistory = '/medicalCareHistory';
  static const changePassword = '/changePassword';

  static final GoRouter router = GoRouter(initialLocation: login, routes: [
    GoRoute(path: login, builder: (context, state) => const LoginPage()),
    GoRoute(path: home, builder: (context, state) => const MainPage()),
    GoRoute(
        path: amdLocation,
        builder: (context, state) => const AmdLocationPage()),
    GoRoute(
        path: medicalCareAccepted,
        builder: (context, state) => const AmdPendingPage()),
    GoRoute(
        path: medicalCareHistory,
        builder: (context, state) => const AmdHistoryPage()),
    GoRoute(path: profile, builder: (context, state) => const ProfilePage())
  ]);

  static GoRouter get routerConfig => router;
}
