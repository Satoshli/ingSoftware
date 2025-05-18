import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/reserva_model.dart';

class ReservaService {
  final _db = FirebaseFirestore.instance;
  final String _collection = 'reservas';

  // Crear reserva
  Future<void> crearReserva(Reserva reserva) async {
    await _db.collection(_collection).doc(reserva.id).set(reserva.toMap());
  }

  // Obtener reservas por usuario
  Future<List<Reserva>> obtenerReservasPorUsuario(String usuarioId) async {
    final query = await _db
        .collection(_collection)
        .where('usuarioId', isEqualTo: usuarioId)
        .get();
    return query.docs
        .map((doc) => Reserva.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Cancelar reserva
  Future<void> cancelarReserva(String id, {String? motivo}) async {
    await _db.collection(_collection).doc(id).update({
      'estado': 'cancelada',
      'motivo': motivo,
    });
  }

  // Obtener reservas de una sala en un periodo
  Future<List<Reserva>> reservasDeSalaEnPeriodo(
      String salaId, DateTime inicio, DateTime fin) async {
    final query = await _db
        .collection(_collection)
        .where('salaId', isEqualTo: salaId)
        .where('fechaInicio', isLessThanOrEqualTo: fin)
        .where('fechaFin', isGreaterThanOrEqualTo: inicio)
        .get();
    return query.docs
        .map((doc) => Reserva.fromMap(doc.data(), doc.id))
        .toList();
  }
}