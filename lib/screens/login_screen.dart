
import 'package:flutter/material.dart';
import 'package:salas_udp/services/common/login_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSigningIn = false;
  final LoginService _loginService = LoginService();

  Future<void> _handleSignIn() async {
    setState(() => _isSigningIn = true);
    final result = await _loginService.signInWithGoogle();

    if (!mounted) return;
    setState(() => _isSigningIn = false);

    switch (result) {
      case LoginResult.success:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case LoginResult.invalidEmail:
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
          title: const Text('Correo no permitido'),
          content: const Text('Solo se permite iniciar sesión con correos UDP.'),
          actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Aceptar'),
      ),
    ],
  ),
);
        break;
      case LoginResult.error:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al iniciar sesión.')),
        );
        break;
      case LoginResult.cancelled:
        // No hacer nada
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isSigningIn
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Iniciar sesión con Google'),
                onPressed: _handleSignIn,
              ),
      ),
    );
  }
}
