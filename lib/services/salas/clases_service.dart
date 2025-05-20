// Archivo: clases_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/clases_model.dart';

class HorarioService {
  final CollectionReference _horariosCollection =
      FirebaseFirestore.instance.collection('horarios');

  /// Cache de horarios para evitar consultas repetidas
  final Map<String, List<Horario>> _cacheFiltros = {};

  /// Crea un nuevo horario
  Future<void> crearHorario(Horario horario) async {
    await _horariosCollection.doc(horario.id).set(horario.toMap());
    // Invalidar caché para que se actualice en la próxima consulta
    _cacheFiltros.clear();
  }

  /// Actualiza un horario existente
  Future<void> actualizarHorario(Horario horario) async {
    await _horariosCollection.doc(horario.id).update(horario.toMap());
    // Invalidar caché para que se actualice en la próxima consulta
    _cacheFiltros.clear();
  }

  /// Elimina un horario
  Future<void> eliminarHorario(String id) async {
    await _horariosCollection.doc(id).delete();
    // Invalidar caché para que se actualice en la próxima consulta
    _cacheFiltros.clear();
  }

  /// Obtiene un horario por su ID
  Future<Horario?> getHorarioById(String id) async {
    try {
      final doc = await _horariosCollection.doc(id).get();
      if (!doc.exists) return null;
      return Horario.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      print('❌ Error al obtener horario por ID: $e');
      return null;
    }
  }

  /// Obtiene horarios aplicando filtros desde Firestore con caché
  Future<List<Horario>> getHorariosConFiltros(Map<String, dynamic> filtros) async {
    // Generar una clave para este conjunto de filtros
    final cacheKey = _generarClaveFiltro(filtros);
    
    // Verificar si ya tenemos estos resultados en caché
    if (_cacheFiltros.containsKey(cacheKey)) {
      return _cacheFiltros[cacheKey]!;
    }

    try {
      Query query = _horariosCollection;
      
      // Aplicar filtros a la consulta
      filtros.forEach((key, value) {
        if (value != null) {
          query = query.where(key, isEqualTo: value);
        }
      });
      
      final snapshot = await query.get();
      final horarios = snapshot.docs.map((doc) {
        return Horario.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      
      // Guardar en caché para uso futuro
      _cacheFiltros[cacheKey] = horarios;
      
      return horarios;
    } catch (e) {
      print('❌ Error al obtener horarios con filtros: $e');
      return [];
    }
  }
  
  /// Genera una clave única para la caché basada en los filtros
  String _generarClaveFiltro(Map<String, dynamic> filtros) {
    final entries = filtros.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    
    return entries.map((e) => '${e.key}:${e.value}').join('|');
  }
  
  /// Limpia la caché de horarios
  void limpiarCache() {
    _cacheFiltros.clear();
  }
}