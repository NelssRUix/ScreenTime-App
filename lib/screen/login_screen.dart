import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:screen_time_app/api/api.dart';
import 'package:screen_time_app/hook/auth/use_login_google.dart';
import 'package:screen_time_app/widget/buttons/custom_button_sign_in.dart';
import 'package:screen_time_app/widget/inputs/custom_text_field.dart';
import 'package:screen_time_app/widget/titles/square_tile.dart';

class LoginScreen extends HookWidget {
  LoginScreen({super.key});

  // Text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() {
    // Aquí puedes implementar el login con email y contraseña más adelante.
    print("Login con email no implementado aún.");
  }

  @override
  Widget build(BuildContext context) {
    final api = useMemoized(() => Api());
    final login = useLoginGoogle(api);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // Envolver la columna en SingleChildScrollView
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 100.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "images/logo.png",
                      height: 70.0,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Bienvenido a Screen Time',
                      style: TextStyle(color: Colors.grey[700], fontSize: 16),
                    ),

                    // E-mail input
                    const SizedBox(height: 25),
                    CustomTextField(
                      controller: usernameController,
                      hintText: 'E-mail',
                      obscureText: false,
                    ),

                    // Password input
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),

                    // Olvidé mi contraseña
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Olvidé mi contraseña',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),

                    // Botón Sign In
                    const SizedBox(height: 25),
                    CustomButtonSignIn(onTap: signUserIn),

                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'O continuar con',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Botón de Google con estado de carga
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: login.isLoading
                              ? null
                              : () async {
                                  bool success = await login.loginWithGoogle();
                                  if (success) {
                                  
                                    if (!context.mounted) return;
                                      //Ruta para la otra vista
                                    Navigator.pushReplacementNamed(
                                        context, '/dashboard');

                                  } else {

                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Error al iniciar sesión. Inténtalo de nuevo."),

                                      ),
                                    );
                                  }
                                },
                          child: login.isLoading
                              ? CircularProgressIndicator()
                              : const SquareTile(
                                  imagePath: 'images/sign-in-google.png'),
                        ),
                        const SizedBox(width: 25),
                        const SquareTile(imagePath: 'images/sign-in-ios.png'),
                      ],
                    ),

                    const SizedBox(height: 50),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Registrarme con e-mail',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}