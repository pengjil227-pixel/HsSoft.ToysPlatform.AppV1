import 'dart:convert';

import 'package:flutter_wanhaoniu/src/shared/models/login_user_info.dart';
import 'package:go_router/go_router.dart';

import '../../pages/auth/character.dart';
import '../../pages/auth/login.dart';
import '../../pages/auth/phone_login.dart';
import '../../pages/auth/role.dart';
import '../page_builder.dart';

class AuthRoutes {
  static List<GoRoute> get routes {
    return [
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) {
          return SlideTransitionPage(child: LoginPage());
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'phoneLogin',
            name: 'phoneLogin',
            builder: (context, state) => const PhoneLogin(),
          ),
          GoRoute(
            path: 'character/:userInfo',
            name: 'character',
            pageBuilder: (_, GoRouterState state) {
              final String userInfo = state.pathParameters['userInfo']!;
              return SlideTransitionPage(
                child: Character(
                  userInfo: LoginUserInfo.fromJson(jsonDecode(userInfo)),
                ),
              );
            },
          ),
          GoRoute(
            path: 'roles',
            name: 'roles',
            builder: (context, state) => const Role(),
          ),
        ],
      ),
    ];
  }
}
