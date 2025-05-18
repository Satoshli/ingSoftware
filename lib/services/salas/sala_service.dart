import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/sala_model.dart';
import '../../../models/horario_model.dart';

class SalaService {
  final _db = FirebaseFirestore.instance;
  final String _collection = 'salas';
  final String _horariosCollection = 'horarios';
  FirebaseFirestore get db => _db;

  /// Crear sala usando el ID que ya viene en el modelo (por ejemplo desde CSV)
  Future<void> crearSala(Sala sala) async {
    final salaRef = _db.collection(_collection).doc(sala.id);
    await salaRef.set(sala.toMap());
  }

  /// Obtener horarios de una sala específica
  Future<List<Horario>> obtenerHorariosPorSala(String salaId) async {
    final snapshot = await _db
        .collection(_horariosCollection)
        .where('salaId', isEqualTo: salaId)
        .get();

    return snapshot.docs
        .map((doc) => Horario.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// Obtener horarios de una sala por día
  Future<List<Horario>> obtenerHorariosPorSalaYDia(String salaId, int dia) async {
    final snapshot = await _db
        .collection(_horariosCollection)
        .where('salaId', isEqualTo: salaId)
        .where('dia', isEqualTo: dia)
        .get();

    return snapshot.docs
        .map((doc) => Horario.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// Obtener bloques libres por sala y bloque específico
  Future<List<Horario>> obtenerBloquesLibresPorSalaYBloque(String salaId, int bloque) async {
    final snapshot = await _db
        .collection(_horariosCollection)
        .where('salaId', isEqualTo: salaId)
        .where('bloque', isEqualTo: bloque)
        .where('estado', isEqualTo: 'libre')
        .get();

    return snapshot.docs
        .map((doc) => Horario.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// Obtener salas sin clases por bloque (todas las salas con bloque libre)
  Future<List<String>> obtenerSalasSinClasePorBloque(int bloque) async {
    final snapshot = await _db
        .collection(_horariosCollection)
        .where('bloque', isEqualTo: bloque)
        .where('estado', isEqualTo: 'libre')
        .get();

    final salas = snapshot.docs.map((doc) => doc['salaId'] as String).toSet().toList();
    return salas;
  }
}
