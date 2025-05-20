import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/sala_model.dart';



class SalaService {
  final CollectionReference salasRef =
      FirebaseFirestore.instance.collection('salas');

  FirebaseFirestore get db => FirebaseFirestore.instance;

  // Crear sala
  Future<void> crearSala(Sala sala) async {
    await salasRef.doc(sala.id).set(sala.toMap());
  }

  // Actualizar sala
  Future<void> actualizarSala(Sala sala) async {
    await salasRef.doc(sala.id).update(sala.toMap());
  }

  // Eliminar sala
  Future<void> eliminarSala(String id) async {
    await salasRef.doc(id).delete();
  }

  // Obtener sala por ID
  Future<Sala?> getSalaById(String id) async {
    final doc = await salasRef.doc(id).get();
    if (!doc.exists) return null;

    final data = doc.data() as Map<String, dynamic>;
    return Sala.fromMap(data, doc.id);
  }

  // Obtener todas las salas
  Future<List<Sala>> getTodasLasSalas() async {
    final query = await salasRef.get();
    return query.docs
        .map((doc) => Sala.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // Obtener salas bloqueadas
  Future<List<Sala>> getSalasBloqueadas() async {
    final query = await salasRef.where('bloqueada', isEqualTo: true).get();
    return query.docs
        .map((doc) => Sala.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // Obtener salas por edificio
  Future<List<Sala>> getSalasPorEdificio(String edificio) async {
    final query = await salasRef.where('edificio', isEqualTo: edificio).get();
    return query.docs
        .map((doc) => Sala.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // Obtener salas por piso
  Future<List<Sala>> getSalasPorPiso(int piso) async {
    final query = await salasRef.where('piso', isEqualTo: piso).get();
    return query.docs
        .map((doc) => Sala.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}