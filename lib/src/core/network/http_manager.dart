import 'dart:convert';
import 'package:dio/dio.dart';

import 'api_exception.dart';
import 'api_response.dart';
import 'http_config.dart';

class HttpManager {
  static final HttpManager _instance = HttpManager._internal();
  factory HttpManager() => _instance;
  HttpManager._internal();

  late Dio _dio;

  // 拦截器类型
  static const interceptorRequest = 1;
  static const interceptorResponse = 2;
  static const interceptorError = 3;

  void init({
    String? baseUrl,
    int? connectTimeout,
    int? receiveTimeout,
    Map<String, dynamic>? headers,
    List<Interceptor>? interceptors,
  }) {
    final options = BaseOptions(
      baseUrl: baseUrl ?? HttpConfig.baseUrl,
      connectTimeout: Duration(milliseconds: connectTimeout ?? HttpConfig.connectTimeout),
      receiveTimeout: Duration(milliseconds: receiveTimeout ?? HttpConfig.receiveTimeout),
      headers: headers ?? HttpConfig.headers,
      responseType: ResponseType.json,
    );

    _dio = Dio(options);

    // 添加默认拦截器
    // _dio.interceptors.add(LogInterceptor(
    //   request: true,
    //   requestHeader: true,
    //   requestBody: true,
    //   responseHeader: true,
    //   responseBody: true,
    // ));

    // 添加自定义拦截器
    if (interceptors != null) {
      _dio.interceptors.addAll(interceptors);
    }

    // 添加错误处理拦截器
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        _handleError(error);
        return handler.next(error);
      },
    ));
  }

  // GET 请求
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJsonT,
    bool showLoading = false,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse<T>(response, fromJsonT);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST 请求
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJsonT,
    bool showLoading = false,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse<T>(response, fromJsonT);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PUT 请求
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJsonT,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse<T>(response, fromJsonT);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE 请求
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJsonT,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse<T>(response, fromJsonT);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // 文件上传
  Future<ApiResponse<T>> upload<T>(
    String path, {
    required String filePath,
    String? fileName,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJsonT,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      fileName ??= filePath.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
        ...?data,
      });

      final response = await _dio.post(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
      );
      return _handleResponse<T>(response, fromJsonT);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // 处理响应
  ApiResponse<T> _handleResponse<T>(Response response, T Function(dynamic)? fromJsonT) {
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = response.data is Map ? response.data as Map<String, dynamic> : {'data': response.data};

      return ApiResponse<T>.fromJson(responseData, fromJsonT);
    } else {
      throw ApiException(
        code: response.statusCode ?? -1,
        message: 'HTTP Error: ${response.statusCode}',
      );
    }
  }

  // 处理错误
  ApiException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          code: error.response?.statusCode ?? -1,
          message: '网络连接超时，请检查网络设置',
        );
      case DioExceptionType.badResponse:
        final response = error.response;
        if (response != null && response.data != null) {
          try {
            final errorData = response.data is Map ? response.data as Map<String, dynamic> : json.decode(response.data);
            return ApiException(
              code: errorData['code'] ?? response.statusCode ?? -1,
              message: errorData['message'] ?? '服务器错误',
            );
          } catch (e) {
            return ApiException(
              code: response.statusCode ?? -1,
              message: '服务器错误: ${response.statusCode}',
            );
          }
        }
        return ApiException(
          code: response?.statusCode ?? -1,
          message: '服务器错误',
        );
      case DioExceptionType.cancel:
        return ApiException(
          code: -2,
          message: '请求已取消',
        );
      case DioExceptionType.unknown:
        return ApiException(
          code: -1,
          message: '网络连接失败，请检查网络设置',
          details: error.message,
        );
      default:
        return ApiException(
          code: -1,
          message: '网络请求失败',
          details: error.message,
        );
    }
  }

  // 取消请求
  void cancelRequests({CancelToken? token}) {
    token?.cancel('手动取消');
  }

  // 设置认证token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // 清除认证token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}
