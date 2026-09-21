// import 'network_response.dart';

// /// Base class for all network-related exceptions.
// sealed class const NetworkException({
//   final String? message,
//   final NetworkResponse<dynamic>? response,
// }) implements Exception {
//   @override
//   String toString() => '$runtimeType: $message';
// }

// /// Thrown when there is a connection timeout, handshake error, or no internet.
// final class const ConnectionException({super.message})
//     extends NetworkException;

// /// Thrown when the server returns a 400 Bad Request.
// final class const BadRequestException({super.message, super.response})
//     extends NetworkException;

// /// Thrown when the server returns a 401 Unauthorized.
// final class const UnauthorizedException({super.message, super.response})
//     extends NetworkException;

// /// Thrown when the server returns a 403 Forbidden.
// final class const ForbiddenException({super.message, super.response})
//     extends NetworkException;

// /// Thrown when the server returns a 404 Not Found.
// final class const NotFoundException({super.message, super.response})
//     extends NetworkException;

// /// Thrown when the server returns a 5xx Server Error.
// final class const ServerException({super.message, super.response})
//     extends NetworkException;

// /// Thrown when a request is cancelled.
// final class const CancelledException({super.message})
//     extends NetworkException;

// /// Thrown for any other unhandled network/HTTP error.
// final class const UnknownNetworkException({super.message, super.response})
//     extends NetworkException;