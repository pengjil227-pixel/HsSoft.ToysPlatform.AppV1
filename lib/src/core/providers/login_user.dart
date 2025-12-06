import 'package:flutter/foundation.dart';
import '../../shared/models/login_user_info.dart';

class LoginUser extends ChangeNotifier {
  LoginUser({
    LoginUserInfo? initialLoginUserInfo,
  });

  LoginUserInfo? get loginUser => LoginInfoSingleton.loginUserInfo;

  set loginUser(LoginUserInfo? info) {
    LoginInfoSingleton.loginUserInfo = info;

    // 不要删，测接口
    if (kDebugMode) {
      final token = info?.accessToken ?? '';

      debugPrint('🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥');
      debugPrint('  FULL TOKEN BELOW 👇');
      debugPrint('🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥');
      debugPrint(token.isEmpty ? 'EMPTY TOKEN' : token);
      debugPrint('🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥');
      debugPrint('  FULL TOKEN ABOVE ☝️');
      debugPrint('🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥');
    }

    notifyListeners();
  }

  bool get isLogin => LoginInfoSingleton.isLogin;
}

class LoginInfoSingleton {
  const LoginInfoSingleton._();

  static LoginUserInfo? loginUserInfo;

  static bool get isLogin {
    if (loginUserInfo == null) return false;
    if (loginUserInfo!.companyInfos.isEmpty) return false;
    return true;
  }
}
