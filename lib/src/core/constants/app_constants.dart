import 'dart:io';

import '../../shared/models/login_user_info.dart';

class AppConstants {
  static int get sourceType {
    return Platform.isAndroid ? 0 : 1;
  }

  static bool isFactoryUser(LoginUserInfo? loginUser) {
    if (loginUser?.companyInfos.isEmpty ?? true) return false;
    if (loginUser!.companyInfos.first.roleType == 1) return true;
    return false;
  }
}
