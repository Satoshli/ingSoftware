import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/personasudp_model.dart';

class PersonaUDPService {
  final _collection = FirebaseFirestore.instance.collection('personas_udp');

Future<Personasudp?> buscarPorCorreo(String correo) async {
  final snapshot = await _collection
      .where('correo', isEqualTo: correo)
      .limit(1)
      .get();

  if (snapshot.docs.isEmpty) return null;
  final doc = snapshot.docs.first;
  return Personasudp.fromMap(doc.data(), doc.id);
}

}
