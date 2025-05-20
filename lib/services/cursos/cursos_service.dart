import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/cursos_model.dart';

class CursoService {
  final CollectionReference cursosRef =
      FirebaseFirestore.instance.collection('cursos');

  // Crear curso
  Future<void> crearCurso(Curso curso) async {
    await cursosRef.doc(curso.id).set(curso.toMap());
  }

  // Actualizar curso
  Future<void> actualizarCurso(Curso curso) async {
    await cursosRef.doc(curso.id).update(curso.toMap());
  }

  // Eliminar curso
  Future<void> eliminarCurso(String id) async {
    await cursosRef.doc(id).delete();
  }

  // Obtener curso por ID
  Future<Curso?> getCursoById(String id) async {
    final doc = await cursosRef.doc(id).get();
    if (!doc.exists) return null;

    final data = doc.data() as Map<String, dynamic>;
    return Curso.fromMap(data, doc.id);
  }

  // Obtener todos los cursos
  Future<List<Curso>> getTodosLosCursos() async {
    final query = await cursosRef.get();
    return query.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Curso.fromMap(data, doc.id);
    }).toList();
  }

  
}
