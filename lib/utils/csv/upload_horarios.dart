import 'package:flutter/material.dart';
import '../../../models/horario_model.dart';
import '../../../services/salas/sala_service.dart';
import 'upload_base.dart';

Future<void> uploadCSVHorarios(BuildContext context) async {
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
  final db = SalaService().db;
  const horariosCollection = 'horarios';

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

      final horarioRef = db.collection(horariosCollection).doc();

      final horario = Horario(
        id: horarioRef.id,
        salaId: data['salaId'] ?? '',
        dia: int.tryParse(data['dia'] ?? '') ?? 1,
        bloque: int.tryParse(data['bloque'] ?? '') ?? 1,
        cursoId: data['cursoId'] ?? '',
        seccionId: data['seccionId'] ?? '',
        estado: data['estado'] ?? 'en clases',
        horaInicio: data['horaInicio'] ?? '00:00',
        horaFin: data['horaFin'] ?? '00:00',
      );

      await horarioRef.set(horario.toMap());
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
          'Carga completa: $successCount de ${successCount + errorCount} horarios creados.\n'
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
