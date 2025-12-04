import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_wanhaoniu/src/shared/models/login_user_info.dart';
import 'package:provider/provider.dart';

import 'src/core/constants/app_constants.dart';
import 'src/core/network/http_manager.dart';
import 'src/core/providers/login_user.dart';
import 'src/core/theme/cms_theme/cms_theme.dart';
import 'src/routes/app_router.dart';
import 'src/shared/preferences/login_user_info.dart';

void main() async {
  HttpManager().init();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  LoginUserInfo? loginUserInfo;
  final loginUser = await loadLoginUserInfo();
  if (loginUser != null) {
    loginUserInfo = LoginUserInfo.fromJson(jsonDecode(loginUser));
    //每次请求带上token
    HttpManager().setAuthToken(loginUserInfo.accessToken);

    print("=========================================");
    print("🔑 我的 Token: ${loginUserInfo.accessToken}");
    print("=========================================");


  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LoginUser(initialLoginUserInfo: loginUserInfo)),
    ],
    child: MyApp(
      loginUserInfo: loginUserInfo,
    ),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
    required this.loginUserInfo,
  });

  final LoginUserInfo? loginUserInfo;

  late final route = AppRouter(initialLocation: AppConstants.isFactoryUser(loginUserInfo) ? '/factoryHome' : '/').router;

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
