import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/horario_model.dart';

class HorarioService {
  final _db = FirebaseFirestore.instance;

  /// Crear un horario en la subcolección `horarios` de una sala
  Future<void> crearHorario(String salaId, Horario horario) async {
    
      
  }

  /// Obtener todos los horarios de una sala
  Future<List<Horario>> obtenerHorarios(String salaId) async {
    final snapshot = await _db
        .collection('salas')
        .doc(salaId)
        .collection('horarios')
        .orderBy('horaInicio')
        .get();

    return snapshot.docs
        .map((doc) => Horario.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// Actualizar un horario específico
  Future<void> actualizarHorario(String salaId, Horario horario) async {
    await _db
        .collection('salas')
        .doc(salaId)
        .collection('horarios')
        .doc(horario.id)
        .update(horario.toMap());
  }

  /// Eliminar un horario por su ID
  Future<void> eliminarHorario(String salaId, String horarioId) async {
    await _db
        .collection('salas')
        .doc(salaId)
        .collection('horarios')
        .doc(horarioId)
        .delete();
  }
}
