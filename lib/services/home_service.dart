import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeService {
  static Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // No redirección manual, AuthWrapper lo maneja
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $e')),
      );
    }
  }

  static void handleNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        break; // Ya estás en Home
      case 1:
        Navigator.pushReplacementNamed(context, '/salas');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/reservas');
        break;
    }
  }
}
