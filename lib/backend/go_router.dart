import 'package:agronomist_partner/pages/splashscreen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(initialLocation: '/splashscreen', routes: [
  GoRoute(
    path: '/splashscreen',
    builder: (context, state) => SplashScreenWidget(),
  ),
]);
