import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    final redColor = Colors.red[600] ?? Colors.red;
    
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'imgns/imagen.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.5),
            colorBlendMode: BlendMode.darken,
          ),
          
          // Top bar with help and website buttons
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // AYUDA button
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: const Text(
                      'AYUDA',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  // UDP.CL button
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.language,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: const Text(
                      'UDP.CL',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Center content with logo and login button
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // UDP Logo
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: Colors.white,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'udp',
                        style: TextStyle(
                          color: redColor,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'UNIVERSIDAD',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'DIEGO PORTALES',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Login button
                Container(
                  width: 240,
                  height: 50,
                  margin: const EdgeInsets.only(top: 1),
                  child: _isSigningIn
                      ? Container(
                          color: redColor,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: _handleSignIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: redColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'INGRESAR',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}