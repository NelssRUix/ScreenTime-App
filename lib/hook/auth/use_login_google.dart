import 'package:screen_time_app/api/api.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:screen_time_app/service/auth/login_service.dart';

class UseLoginGoogle {
  final Future<bool> Function() loginWithGoogle;
  final bool isLoading;

  UseLoginGoogle({required this.loginWithGoogle, required this.isLoading});
}

UseLoginGoogle useLoginGoogle(Api api) {
  final loginService = useMemoized(() => LoginService(api));
  final isLoading = useState(false);

  Future<bool> loginWithGoogle() async {
    isLoading.value = true;
    try {
      final success = await loginService.loginWithGoogle();
      return success;
    } finally {
      isLoading.value = false;
    }
  }

  return UseLoginGoogle(
      loginWithGoogle: loginWithGoogle, isLoading: isLoading.value);
}
