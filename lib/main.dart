import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'src/core/constants/app_constants.dart';
import 'src/core/providers/goods_detail_info.dart';
import 'src/core/providers/login_user.dart';
import 'src/core/theme/cms_theme/cms_theme.dart';
import 'src/routes/app_router.dart';
import 'src/shared/models/login_user_info.dart';
import 'src/shared/preferences/login_user_info.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  LoginUserInfo? loginUserInfo;
  final loginUser = await loadLoginUserInfo();
  if (loginUser != null) {
    loginUserInfo = LoginUserInfo.fromJson(jsonDecode(loginUser));
  }

  LoginInfoSingleton.loginUserInfo = loginUserInfo;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LoginUser()),
      ChangeNotifierProvider(create: (_) => GoodsDetailInfo()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
  });

  late final route = AppRouter(initialLocation: AppConstants.isFactoryUser(LoginInfoSingleton.loginUserInfo) ? '/factoryHome' : '/').router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '玩好牛',
      debugShowCheckedModeBanner: false,
      scrollBehavior: MaterialScrollBehavior().copyWith(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: BouncingScrollPhysics(),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CN'),
        // const Locale('en', 'US'),
      ],
      theme: CmsTheme.lightTheme,
      routerConfig: route,
    );
  }
}
