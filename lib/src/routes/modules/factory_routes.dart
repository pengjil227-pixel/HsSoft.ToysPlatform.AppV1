import 'package:flutter_wanhaoniu/src/pages/factory/home.dart';
import 'package:go_router/go_router.dart';

class FactoryRoutes {
  static List<GoRoute> get routes {
    return [
      GoRoute(
        path: '/factoryHome',
        name: 'factoryHome',
        builder: (context, state) => const FactoryHomePage(),
      ),
    ];
  }
}
