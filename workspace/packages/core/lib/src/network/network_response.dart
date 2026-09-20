/// A generic wrapper representing the uniform HTTP response across the application.
/// Decouples outer layers from specific HTTP client implementations (like Dio).
final class NetworkResponse<T> {
  const NetworkResponse({
    this.data,
    this.statusCode,
    this.headers = const {},
  });

  /// The parsed response body data.
  final T? data;

  /// The HTTP status code.
  final int? statusCode;

  /// The response headers.
  final Map<String, List<String>> headers;

  @override
  String toString() {
    return 'NetworkResponse(statusCode: $statusCode, data: $data)';
  }
}
