import 'package:go_router/go_router.dart';

import '../../pages/company/goods_detail.dart';
import '../../pages/company/home_screen.dart';
import '../../pages/company/setting.dart';

class CompanyRoutes {
  static List<GoRoute> get routes {
    return [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => HomeScreen(),
        routes: [
          GoRoute(
            path: 'setting',
            name: 'setting',
            builder: (context, state) => Setting(),
          ),
          GoRoute(
            path: 'goodsDetail',
            name: 'goodsDetail',
            builder: (context, state) => GoodsDetail(),
          ),
        ],
      ),
    ];
  }
}
