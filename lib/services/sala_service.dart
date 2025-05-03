import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/sala_model.dart';

class SalaService {
  final _db = FirebaseFirestore.instance;
  final String _collection = 'salas';

  // Crear sala
  Future<void> crearSala(Sala sala) async {
    await _db.collection(_collection).doc(sala.id).set(sala.toMap());
  }

  // Obtener sala por ID
  Future<Sala?> obtenerSala(String id) async {
    final doc = await _db.collection(_collection).doc(id).get();
    if (doc.exists) {
      return Sala.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  // Actualizar sala
  Future<void> actualizarSala(Sala sala) async {
    await _db.collection(_collection).doc(sala.id).update(sala.toMap());
  }

  // Bloquear sala
  Future<void> bloquearSala(String id, String motivo) async {
    await _db.collection(_collection).doc(id).update({
      'bloqueada': true,
      'motivoBloqueo': motivo,
    });
  }

  // Desbloquear sala
  Future<void> desbloquearSala(String id) async {
    await _db.collection(_collection).doc(id).update({
      'bloqueada': false,
      'motivoBloqueo': null,
    });
  }
}