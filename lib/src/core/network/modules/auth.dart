import 'package:dio/dio.dart';
import 'package:flutter_wanhaoniu/src/core/network/api_response.dart';

import '../../../shared/models/login_user_info.dart';
import '../http_manager.dart';

class AuthService {
  static Future<ApiResponse<LoginUserInfo>> loginByMobile(dynamic data) async {
    return HttpManager().post(
      '/auth/Auth/LoginByMobile',
      data: data,
      fromJsonT: (data) {
        return LoginUserInfo.fromJson(data);
      },
    );
  }

  static Future<ApiResponse<LoginUserInfo>> loginByCompany(dynamic data, Options options) async {
    return HttpManager().post(
      '/auth/Auth/LoginByCompany',
      data: data,
      options: options,
      fromJsonT: (data) {
        return LoginUserInfo.fromJson(data);
      },
    );
  }



}
