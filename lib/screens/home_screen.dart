import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/home/home_service.dart';
import '../widgets/base_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return BaseScaffold(
      currentIndex: 0,
      onTap: (index) => HomeService.handleNavTap(context, index),
      onLogout: () => HomeService.signOut(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenido a la app de salas UDP!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (user != null)
              Text(
                'Correo: ${user.email}',
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
