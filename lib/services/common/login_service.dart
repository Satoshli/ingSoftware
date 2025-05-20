import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum LoginResult { success, invalidEmail, error, cancelled }

class LoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb
        ? '822099798682-6uh43itul691950jauafmtf4entm5pd4.apps.googleusercontent.com'
        : null,
  );

  Future<LoginResult> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return LoginResult.cancelled;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) return LoginResult.error;

      final email = user.email ?? '';
      final allowedDomains = ['@udp.cl', '@alumnos.udp.cl', '@mail.udp.cl'];

      if (!allowedDomains.any((domain) => email.endsWith(domain))) {
        await _auth.signOut();
        await _googleSignIn.signOut();
        return LoginResult.invalidEmail;
      }

      final userDocRef = _firestore.collection('usuarios').doc(user.uid);
      final userSnapshot = await userDocRef.get();

      // Datos base
      String rol = 'estudiante'; // Rol por defecto
      String nombre = user.displayName ?? 'Sin nombre';

      if (userSnapshot.exists) {
        // Si el usuario ya existe, mantener su rol actual
        final data = userSnapshot.data();
        if (data != null && data.containsKey('rol')) {
          rol = data['rol'] ?? 'estudiante';
        }
      }

      // Crear o actualizar el documento sin sobreescribir datos previos
      await userDocRef.set({
        'id': user.uid,
        'nombre': nombre,
        'correo': email,
        'rol': rol,
        'activo': true,
        'photoURL': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return LoginResult.success;
    } catch (e) {
      debugPrint('Error en LoginService.signInWithGoogle: $e');
      return LoginResult.error;
    }
  }
}
