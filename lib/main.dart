import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'src/core/constants/app_constants.dart';
import 'src/core/providers/cart_provider.dart';
import 'src/core/providers/home_infos.dart';
import 'src/core/providers/login_user.dart';
import 'src/core/theme/cms_theme/cms_theme.dart';
import 'src/routes/app_router.dart';
import 'src/shared/models/login_user_info.dart';
import 'src/shared/preferences/login_user_info.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);

  LoginUserInfo? loginUserInfo;
  final String? loginUser = await loadLoginUserInfo();
  if (loginUser != null) {
    loginUserInfo = LoginUserInfo.fromJson(jsonDecode(loginUser) as Map<String, dynamic>);
  }
  LoginInfoSingleton.loginUserInfo = loginUserInfo;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginUser>(create: (_) => LoginUser()),
        ChangeNotifierProvider<HomeInfos>(create: (_) => HomeInfos()),
        ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final RouterConfig<Object> route = AppRouter(
    initialLocation: AppConstants.isFactoryUser(LoginInfoSingleton.loginUserInfo) ? '/factoryHome' : '/',
  ).router;

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      headerTriggerDistance: 70,
      springDescription: const SpringDescription(mass: 0.3, stiffness: 140.0, damping: 14),
      child: MaterialApp.router(
        title: '玩好牛',
        debugShowCheckedModeBanner: false,
        builder: FlutterSmartDialog.init(),
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(),
        ),
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[
          Locale('zh', 'CN'),
          // Locale('en', 'US'),
        ],
        theme: CmsTheme.lightTheme,
        routerConfig: route,
      ),
    );
  }
}
