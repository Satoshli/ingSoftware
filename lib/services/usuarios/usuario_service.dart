import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/usuario_model.dart';

class UsuarioService {
  final _db = FirebaseFirestore.instance;
  final String _collection = 'usuarios';

  // Crear usuario
  Future<void> crearUsuario(Usuario usuario) async {
    await _db.collection(_collection).doc(usuario.id).set(usuario.toMap());
  }

  // Obtener usuario por ID
  Future<Usuario?> obtenerUsuario(String id) async {
    final doc = await _db.collection(_collection).doc(id).get();
    if (doc.exists) {
      return Usuario.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  // Actualizar datos del usuario
  Future<void> actualizarUsuario(Usuario usuario) async {
    await _db.collection(_collection).doc(usuario.id).update(usuario.toMap());
  }

  // Desactivar usuario (soft delete)
  Future<void> desactivarUsuario(String id) async {
    await _db.collection(_collection).doc(id).update({'activo': false});
  }
}