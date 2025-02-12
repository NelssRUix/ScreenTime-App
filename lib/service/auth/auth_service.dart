import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio screenTimeApi;

  AuthService(this.screenTimeApi);

  Future<String?> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String? refreshToken = prefs.getString('refreshToken');

    if (refreshToken == null) return null;

    try {
      final response = await screenTimeApi.post('/auth/refresh', data: {'refreshToken': refreshToken});
      final String newToken = response.data['token'];
      await prefs.setString('jwt', newToken);
      return newToken;
    } catch (e) {
      return null;
    }
  }

    Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt');
    await prefs.remove('refreshToken');
  }
}
