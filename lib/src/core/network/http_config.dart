class HttpConfig {
  static const String baseUrl = 'http://192.168.110.150:8220';
  static const int connectTimeout = 5000;
  static const int receiveTimeout = 3000;
  static const Map<String, dynamic> headers = {
    'Content-Type': 'application/json',
  };
}
