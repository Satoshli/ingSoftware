import 'package:flutter/material.dart';
import '../../../models/cursos_model.dart';
import 'upload_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadCSVCursos(BuildContext context) async {
  List<String> lines = [];
  try {
    lines = await pickAndReadCSV();
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al leer el archivo: $e')));
    }
    return;
  }

  if (lines.isEmpty) return;

  final headers = lines.first.split(',').map((h) => h.trim()).toList();
  final db = FirebaseFirestore.instance;
  const collection = 'cursos';

  int successCount = 0;
  int errorCount = 0;

  for (var i = 1; i < lines.length; i++) {
    try {
      final values = lines[i].split(',').map((v) => v.trim()).toList();
      if (values.length != headers.length) throw FormatException('Línea ${i + 1} mal formada');

      final data = <String, String>{};
      for (int j = 0; j < headers.length; j++) {
        data[headers[j]] = values[j];
      }

      final curso = Curso(
        id: data['id'] ?? '',
        nombre: data['nombre'] ?? '',
      );

      await db.collection(collection).doc(curso.id).set(curso.toMap());
      successCount++;
    } catch (e) {
      errorCount++;
      debugPrint('Error línea ${i + 1}: $e');
    }
  }

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Cursos subidos: $successCount. Errores: $errorCount.'),
    ));
  }
}
