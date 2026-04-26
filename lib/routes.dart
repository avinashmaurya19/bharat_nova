import 'package:bharat_nova/features/home/presentation/bottom_nav_page.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRoutes {
  static const String home = '/';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const BottomNavPage(),
    ),
  ],
);
