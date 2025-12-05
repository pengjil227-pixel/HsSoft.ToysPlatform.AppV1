class HttpConfig {
  // 公共 IP 地址
  static const String _host = 'http://192.168.110.150';

  // 1. 登录服务的地址 (端口 8220)
  static const String authBaseUrl = '$_host:8220';

  // 2. 业务服务的地址 (端口 8221)
  static const String businessBaseUrl = '$_host:8221';

  // 默认 baseUrl (保持为登录地址，或者留空都可以，因为我们会手动拼接)
  static const String baseUrl = authBaseUrl;

  static const int connectTimeout = 5000;
  static const int receiveTimeout = 3000;
  static const Map<String, dynamic> headers = {
    'Content-Type': 'application/json',
  };
}