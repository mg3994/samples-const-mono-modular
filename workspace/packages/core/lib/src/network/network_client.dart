// import 'network_response.dart';

// /// An abstract interface for performing network requests.
// /// Follows the Dependency Inversion Principle (SOLID) to decouple the code
// /// from concrete network library details.
// abstract interface class const NetworkClient() {
//   /// Sends a GET request.
//   Future<NetworkResponse<T>> get<T>(
//     String path, {
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? headers,
//   });

//   /// Sends a query request.
//   Future<NetworkResponse<T>> query<T>(
//     String path, {
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? headers,
//   });

//   /// Sends a POST request.
//   Future<NetworkResponse<T>> post<T>(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? headers,
//   });

//   /// Sends a PUT request.
//   Future<NetworkResponse<T>> put<T>(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? headers,
//   });

//   /// Sends a PATCH request.
//   Future<NetworkResponse<T>> patch<T>(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? headers,
//   });

//   /// Sends a DELETE request.
//   Future<NetworkResponse<T>> delete<T>(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? headers,
//   });
// }

// import 'dart:async' show unawaited;

import 'package:blogstore_client/blogstore_client.dart';

import '../../core.dart' show AppFlavorConfig, currentFBConfig;

/// A wrapper service that manages backend communication through Serverpod.
///
/// Handles HTTP requests, WebSockets, real-time streaming, and session authentication
/// using the underlying Serverpod [Client].
class Network({
  /// Optional flavor configuration used to determine the backend base URL.
  AppFlavorConfig? config,
}) {
  /// Creates a new [Network] instance.
  this;

  /// The underlying Serverpod client instance configured for backend requests.
  final Client client = Client(
    config?.baseUrl ?? currentFBConfig.flavor.baseUrl,
  );
  //  we will handle them later somewhere else
  // ..connectivityMonitor = FlutterConnectivityMonitor()
  // ..authSessionManager = FlutterAuthSessionManager();

  /// Call this when starting up the app to restore auth state
  // Future<void> init() async {
  //   unawaited(client.auth.initialize());
  // }
}
