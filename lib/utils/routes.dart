import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/admin_screen.dart'; 
import '../utils/auth_wrapper.dart';
import '../screens/salas_simple_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
    '/': (context) => const AuthWrapper(),
    '/home': (context) => const HomeScreen(),
    '/login': (context) => const LoginScreen(),
    '/administracion': (context) => const AdminScreen(),
    '/salas': (context) => const SalasPorBloqueScreen(), //
    
  };
}
