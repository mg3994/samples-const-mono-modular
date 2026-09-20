import 'package:dio/dio.dart';
import '../config/flavor_config.dart' show AppFlavorConfig, currentFBConfig;
import 'network_client.dart';
import 'network_exception.dart';
import 'network_response.dart';

/// A concrete implementation of [NetworkClient] using the `dio` package.
final class const DioNetworkClient({
  final AppFlavorConfig? config,
  final Dio? _dio,
}) implements NetworkClient {
  /// Creates a [DioNetworkClient] using a primary const constructor.
  /// Both [config] and [dio] are optional named parameters.
  // const DioNetworkClient({
  //   this.config,
  //   Dio? dio,
  // }) : _dio = dio;
  //
  // /// The flavor configuration.
  // final AppFlavorConfig? config;
  // final Dio? _dio;

  static final Map<String, Dio> _dioCache = {};

  Dio get _effectiveDio {
    if (_dio != null) return _dio;
    final baseUrl = (config ?? currentFBConfig).baseUrl;
    return _dioCache.putIfAbsent(
      baseUrl,
      () => Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
        ),
      ),
    );
  }

  @override
  Future<NetworkResponse<T>> query<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _effectiveDio.get<T>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _mapResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<NetworkResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _effectiveDio.get<T>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _mapResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<NetworkResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _effectiveDio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _mapResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<NetworkResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _effectiveDio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _mapResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<NetworkResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _effectiveDio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _mapResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<NetworkResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _effectiveDio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _mapResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  NetworkResponse<T> _mapResponse<T>(Response<T> response) {
    final headersMap = <String, List<String>>{};
    response.headers.forEach((name, values) {
      headersMap[name] = values;
    });

    return NetworkResponse<T>(
      data: response.data,
      statusCode: response.statusCode,
      headers: headersMap,
    );
  }

  NetworkException _mapDioException(DioException exception) {
    final networkResponse = exception.response != null
        ? _mapResponse(exception.response!)
        : null;

    final message = exception.message ?? exception.error?.toString();

    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.transformTimeout:
        return ConnectionException(message: message);
      case DioExceptionType.cancel:
        return CancelledException(message: message);
      case DioExceptionType.badResponse:
        final statusCode = exception.response?.statusCode;
        if (statusCode == 400) {
          return BadRequestException(message: message, response: networkResponse);
        } else if (statusCode == 401) {
          return UnauthorizedException(message: message, response: networkResponse);
        } else if (statusCode == 403) {
          return ForbiddenException(message: message, response: networkResponse);
        } else if (statusCode == 404) {
          return NotFoundException(message: message, response: networkResponse);
        } else if (statusCode != null && statusCode >= 500) {
          return ServerException(message: message, response: networkResponse);
        }
        return UnknownNetworkException(message: message, response: networkResponse);
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return UnknownNetworkException(message: message, response: networkResponse);
    }
  }
}
