import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:screen_time_app/screen/dashboard.dart';
import 'package:screen_time_app/screen/login_screen.dart';

void main() async {
  // Cargar variables de entorno
  await dotenv.load(fileName: ".env");
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false, // Quitar la etiqueta de depuración
    title: 'Screen Time App',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    initialRoute: '/login', // Define la pantalla inicial
    routes: {
      '/login': (context) => LoginScreen(),
      '/dashboard': (context) => const DashboardScreen(), // Agrega la ruta del Dashboard
    },
  );
  }
}