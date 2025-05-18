import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/validacion_model.dart';

class ValidacionService {
  final _db = FirebaseFirestore.instance;
  final String _collection = 'validaciones';

  // Registrar validación
  Future<void> registrarValidacion(Validacion validacion) async {
    await _db.collection(_collection).doc(validacion.id).set(validacion.toMap());
  }

  // Obtener validaciones por reserva
  Future<List<Validacion>> obtenerPorReserva(String reservaId) async {
    final query = await _db
        .collection(_collection)
        .where('reservaId', isEqualTo: reservaId)
        .get();
    return query.docs
        .map((doc) => Validacion.fromMap(doc.data(), doc.id))
        .toList();
  }
}