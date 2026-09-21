// import 'package:core/core.dart';
// import 'package:dio/dio.dart';
// import 'package:test/test.dart';

// class MockInterceptor extends Interceptor {
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     if (options.path == '/success') {
//       handler.resolve(Response(
//         requestOptions: options,
//         data: {'status': 'ok'},
//         statusCode: 200,
//         headers: Headers.fromMap({
//           'content-type': ['application/json'],
//         }),
//       ));
//     } else if (options.path == '/timeout') {
//       handler.reject(DioException(
//         requestOptions: options,
//         type: DioExceptionType.connectionTimeout,
//         message: 'Connection timed out',
//       ));
//     } else if (options.path == '/400') {
//       handler.reject(DioException(
//         requestOptions: options,
//         type: DioExceptionType.badResponse,
//         response: Response(
//           requestOptions: options,
//           statusCode: 400,
//           data: 'Bad Request',
//         ),
//       ));
//     } else if (options.path == '/401') {
//       handler.reject(DioException(
//         requestOptions: options,
//         type: DioExceptionType.badResponse,
//         response: Response(
//           requestOptions: options,
//           statusCode: 401,
//           data: 'Unauthorized',
//         ),
//       ));
//     } else if (options.path == '/500') {
//       handler.reject(DioException(
//         requestOptions: options,
//         type: DioExceptionType.badResponse,
//         response: Response(
//           requestOptions: options,
//           statusCode: 500,
//           data: 'Server Error',
//         ),
//       ));
//     } else {
//       handler.next(options);
//     }
//   }
// }

// void main() {
//   late DioNetworkClient client;
//   late Dio dio;

//   setUp(() {
//     dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
//     dio.interceptors.add(MockInterceptor());
//     client = DioNetworkClient(config: currentFBConfig, dio: dio);
//   });

//   group('DioNetworkClient Requests', () {
//     test('DioNetworkClient can be instantiated as const', () {
//       const constClient = DioNetworkClient();
//       expect(constClient, isNotNull);
//     });

//     test('query request returns successful NetworkResponse', () async {
//       final response = await client.query<Map<String, dynamic>>('/success');

//       expect(response.statusCode, 200);
//       expect(response.data, {'status': 'ok'});
//     });

//     test('GET request returns successful NetworkResponse', () async {
//       final response = await client.get<Map<String, dynamic>>('/success');

//       expect(response.statusCode, 200);
//       expect(response.data, {'status': 'ok'});
//       expect(response.headers['content-type'], contains('application/json'));
//     });

//     test('POST request returns successful NetworkResponse', () async {
//       final response = await client.post<Map<String, dynamic>>('/success', data: {'key': 'value'});

//       expect(response.statusCode, 200);
//       expect(response.data, {'status': 'ok'});
//     });
//   });

//   group('DioNetworkClient Error Mapping', () {
//     test('ConnectionTimeout throws ConnectionException', () async {
//       expect(
//         () => client.get<dynamic>('/timeout'),
//         throwsA(isA<ConnectionException>()),
//       );
//     });

//     test('400 status code throws BadRequestException', () async {
//       expect(
//         () => client.get<dynamic>('/400'),
//         throwsA(isA<BadRequestException>()),
//       );
//     });

//     test('401 status code throws UnauthorizedException', () async {
//       expect(
//         () => client.get<dynamic>('/401'),
//         throwsA(isA<UnauthorizedException>()),
//       );
//     });

//     test('500 status code throws ServerException', () async {
//       expect(
//         () => client.get<dynamic>('/500'),
//         throwsA(isA<ServerException>()),
//       );
//     });
//   });
// }
