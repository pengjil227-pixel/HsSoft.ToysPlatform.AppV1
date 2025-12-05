import 'package:dio/dio.dart';
import 'package:flutter_wanhaoniu/src/core/network/api_response.dart';

import '../../../shared/models/login_user_info.dart';
import '../http_manager.dart';

const _baseUrl = 'http://192.168.110.150:8220';

class AuthService {
  static Future<ApiResponse<LoginUserInfo>> loginByMobile(dynamic data) async {
    return HttpManager().post(
      '/auth/Auth/LoginByMobile',
      baseUrl: _baseUrl,
      data: data,
      fromJsonT: (data) {
        return LoginUserInfo.fromJson(data);
      },
    );
  }

  static Future<ApiResponse<LoginUserInfo>> loginByCompany(dynamic data, Options options) async {
    return HttpManager().post(
      '/auth/Auth/LoginByCompany',
      baseUrl: _baseUrl,
      data: data,
      options: options,
      fromJsonT: (data) {
        return LoginUserInfo.fromJson(data);
      },
    );
  }
}
