import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; // NECESARIO para usar debugPrint
import '../../models/seccion_model.dart';

class SeccionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String cursoId;

  SeccionService({required this.cursoId});

  CollectionReference get _seccionesRef =>
      _firestore.collection('cursos').doc(cursoId).collection('secciones');

  /// Obtener todas las secciones de un curso
 Future<List<Seccion>> getSeccionesPorCurso(String cursoId) async {
  try {
    final snapshot = await _seccionesRef
        .where('cursoId', isEqualTo: cursoId)
        .get();

    return snapshot.docs.map((doc) {
      return Seccion.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  } catch (e) {
    debugPrint('❌ Error al obtener secciones del curso $cursoId: $e');
    rethrow;
  }
}

  /// Obtener una sección por su ID
   Future<Seccion?> getSeccionById(String id) async {
    try {
      final doc = await _seccionesRef.doc(id).get();
      if (doc.exists) {
        return Seccion.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('❌ Error al obtener la sección: $e');
      rethrow;
    }
  }

  /// Crear o actualizar una sección
  Future<void> upsertSeccion(Seccion seccion) async {
    try {
      await _seccionesRef.doc(seccion.id).set(seccion.toMap(), SetOptions(merge: true));
    } catch (e) {
      debugPrint('❌ Error al guardar la sección: $e');
      rethrow;
    }
  }

  /// Eliminar una sección
  Future<void> deleteSeccion(String id) async {
    try {
      await _seccionesRef.doc(id).delete();
    } catch (e) {
      debugPrint('❌ Error al eliminar la sección: $e');
      rethrow;
    }
  }
}
