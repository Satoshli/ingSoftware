import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/docentes_model.dart';

class DocentesService {
  final _collection = FirebaseFirestore.instance.collection('Docentes');

  /// Buscar docente por correo (único)
  Future<Docentes?> buscarPorCorreo(String correo) async {
    final snapshot = await _collection
        .where('correo', isEqualTo: correo)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    return Docentes.fromMap(doc.data(), doc.id);
  }

  /// Crear docente con autoId
  Future<void> crearDocente(Docentes docente) async {
    await _collection.add(docente.toMap());
  }
}
