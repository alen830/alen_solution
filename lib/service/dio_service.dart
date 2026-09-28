import 'package:alen_solution/service/simpan_token.dart';
import 'package:dio/dio.dart';

Dio createDioService() {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://absensib1.mobileprojp.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await SimpanToken.getToken();

        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        handler.next(options);
      },
    ),
  );

  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  return dio;
}
