import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:screen_time_app/service/auth/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  late final Dio screenTimeApi;
  late final AuthService authService;

  Api() {
    final String baseUrl = dotenv.env['API_URL'] ?? '';
    final String secretKey = dotenv.env['SECRET_KEY'] ?? '';

    screenTimeApi = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'api-key': secretKey,
        },
      ),
    );
    authService = AuthService(screenTimeApi);
    _initializeInterceptors();
    
  }

  void _initializeInterceptors() {
    screenTimeApi.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final String? jwt = prefs.getString('jwt');

          if (jwt != null) {
            options.headers['Authorization'] = 'Bearer $jwt';
          }
          return handler.next(options);
        },

           // Error y refresh token
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          final newToken = await authService.refreshToken();

          if (newToken != null) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('jwt', newToken);

            final RequestOptions newRequest = error.requestOptions.copyWith(
              headers: {
                ...error.requestOptions.headers,
                'Authorization': 'Bearer $newToken',
              },
            );

            try {
              final response = await screenTimeApi.fetch(newRequest);
              return handler.resolve(response);
            } catch (e) {
              print('Reintento de petición fallido: $e');
            }
          }

          // Si el refresh token también falló, cerrar sesión
          await authService.logout();
          return handler.reject(error);
        }

        return handler.next(error);
      },
      ),
    );
  }
}
