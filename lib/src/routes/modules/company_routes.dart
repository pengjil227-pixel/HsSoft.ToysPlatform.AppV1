import 'package:go_router/go_router.dart';

import '../../pages/company/goods_detail.dart';
import '../../pages/company/home_screen.dart';
import '../../pages/company/setting.dart';
//个人信息
import '../../pages/company/setting_pages/user_info_page.dart';
//关于我们
import '../../pages/company/setting_pages/about_us_page.dart';

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
            routes: [],
          ),
        ],
      ),
    ];
  }
}
