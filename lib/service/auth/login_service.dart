import 'package:google_sign_in/google_sign_in.dart';
import 'package:screen_time_app/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  final Api api;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email'
    ],
  );

  LoginService(this.api);

  Future<bool> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken != null) {
        final response = await api.screenTimeApi.post('/auth/google', data: {
          'idToken': idToken,
        });

        if (response.statusCode == 200) {
          final token = response.data['token'];
          final refreshToken = response.data['refreshToken'];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt', token);
          await prefs.setString('refreshToken', refreshToken);

          return true;
        }
      }
    } catch (e) {
      print('Login failed: $e');
    }
    return false;
  }
}
