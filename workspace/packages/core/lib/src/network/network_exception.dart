import 'network_response.dart';

/// Base class for all network-related exceptions.
sealed class NetworkException implements Exception {
  const NetworkException({this.message, this.response});

  final String? message;
  final NetworkResponse<dynamic>? response;

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when there is a connection timeout, handshake error, or no internet.
final class ConnectionException extends NetworkException {
  const ConnectionException({super.message});
}

/// Thrown when the server returns a 400 Bad Request.
final class BadRequestException extends NetworkException {
  const BadRequestException({super.message, super.response});
}

/// Thrown when the server returns a 401 Unauthorized.
final class UnauthorizedException extends NetworkException {
  const UnauthorizedException({super.message, super.response});
}

/// Thrown when the server returns a 403 Forbidden.
final class ForbiddenException extends NetworkException {
  const ForbiddenException({super.message, super.response});
}

/// Thrown when the server returns a 404 Not Found.
final class NotFoundException extends NetworkException {
  const NotFoundException({super.message, super.response});
}

/// Thrown when the server returns a 5xx Server Error.
final class ServerException extends NetworkException {
  const ServerException({super.message, super.response});
}

/// Thrown when a request is cancelled.
final class CancelledException extends NetworkException {
  const CancelledException({super.message});
}

/// Thrown for any other unhandled network/HTTP error.
final class UnknownNetworkException extends NetworkException {
  const UnknownNetworkException({super.message, super.response});
}
