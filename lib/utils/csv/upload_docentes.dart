import 'package:flutter/material.dart';
import '../../../models/docentes_model.dart';
import '../../services/usuarios/docentes_services.dart';
import 'upload_base.dart';

Future<void> uploadCSVDocentes(BuildContext context) async {
  List<String> lines = [];
  try {
    lines = await pickAndReadCSV();
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al leer el archivo: $e')),
      );
    }
    return;
  }

  if (lines.isEmpty) return;

  final headers = lines.first.split(',').map((h) => h.trim()).toList();
  final docentesService = DocentesService();

  int successCount = 0;
  int errorCount = 0;
  List<String> errorDetails = [];

  for (var i = 1; i < lines.length; i++) {
    try {
      final values = lines[i].split(',').map((v) => v.trim()).toList();
      if (values.length != headers.length) {
        throw FormatException('Cantidad incorrecta de columnas en la línea ${i + 1}');
      }

      final data = <String, String>{};
      for (int j = 0; j < headers.length; j++) {
        data[headers[j]] = values[j];
      }

      final docente = Docentes(
        correo: data['correo'] ?? '',
        rol: data['rol'] ?? 'profesor',
      );

      await docentesService.crearDocente(docente);
      successCount++;
    } catch (e) {
      errorCount++;
      errorDetails.add('Línea ${i + 1}: $e');
    }
  }

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Carga completa: $successCount de ${successCount + errorCount} docentes creados.\n'
          '${errorCount > 0 ? 'Errores: $errorCount (ver consola)' : ''}',
        ),
      ),
    );
  }

  if (errorDetails.isNotEmpty) {
    for (var error in errorDetails) {
      debugPrint(error);
    }
  }
}
