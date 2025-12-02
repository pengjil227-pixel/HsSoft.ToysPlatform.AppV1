class ApiException implements Exception {
  final int code;
  final String message;
  final String? details;

  ApiException({
    required this.code,
    required this.message,
    this.details,
  });

  @override
  String toString() {
    return 'ApiException{code: $code, message: $message, details: $details}';
  }
}