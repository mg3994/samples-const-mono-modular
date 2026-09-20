/// A generic wrapper representing the uniform HTTP response across the application.
/// Decouples outer layers from specific HTTP client implementations (like Dio).
final class const NetworkResponse<T>({
  final T? data,
  final int? statusCode,
  final Map<String, List<String>> headers = const {},
}) {
  @override
  String toString() {
    return 'NetworkResponse(statusCode: $statusCode, data: $data)';
  }
}