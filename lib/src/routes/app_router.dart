import 'package:flutter/widgets.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
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
      observers: <NavigatorObserver>[
        FlutterSmartDialog.observer,
      ],
      routes: <RouteBase>[
        ...AppRoutes.routes,
        ...AuthRoutes.routes,
        ...CompanyRoutes.routes,
        ...FactoryRoutes.routes,
      ],
    );
  }
}
