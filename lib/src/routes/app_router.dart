import 'package:flutter_wanhaoniu/src/routes/modules/factory_routes.dart';
import 'package:go_router/go_router.dart';

import 'modules/app_routes.dart';
import 'modules/auth_routes.dart';
import 'modules/company_routes.dart';

class AppRouter {
  AppRouter({
    required this.initialLocation,
  });

  final String initialLocation;

  GoRouter get router {
    return GoRouter(
      initialLocation: initialLocation,
      routes: <RouteBase>[
        ...AppRoutes.routes,
        ...AuthRoutes.routes,
        ...CompanyRoutes.routes,
        ...FactoryRoutes.routes,
      ],
    );
  }
}
