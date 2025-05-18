import 'package:flutter/material.dart';
import '../../../models/sala_model.dart';
import '../../../services/salas/sala_service.dart';
import 'package:csv/csv.dart';
import 'upload_base.dart';

Future<void> uploadCSVSalas(BuildContext context) async {
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

  final csvString = lines.join('\n'); // Junta todo el CSV como texto
  final csvTable = const CsvToListConverter(eol: '\n').convert(csvString);

  final headers = csvTable.first.map((h) => h.toString().trim()).toList();
  final salaService = SalaService();

  int successCount = 0;
  int errorCount = 0;
  List<String> errorDetails = [];

  for (var i = 1; i < csvTable.length; i++) {
    try {
      final row = csvTable[i];
      if (row.length != headers.length) {
        throw FormatException('Cantidad incorrecta de columnas en la línea ${i + 1}');
      }

      final data = <String, dynamic>{};
      for (int j = 0; j < headers.length; j++) {
        final key = headers[j];
        final value = row[j]?.toString().trim() ?? '';

        if (key == 'capacidad') {
          data[key] = int.tryParse(value) ?? 0;
        } else if (key == 'piso') {
          data[key] = int.tryParse(value) ?? 0;
        } else if (key == 'bloqueada') {
          data[key] = value.toLowerCase() == 'true';
        } else if (key == 'motivoBloqueo') {
          data[key] = value.toLowerCase() == 'null' || value.isEmpty ? null : value;
        } else {
          data[key] = value;
        }
      }

      final sala = Sala(
        id: data['id'],
        nombre: data['nombre'],
        edificio: data['edificio'],
        piso: data['piso'],
        nrosala: data['nrosala'],
        capacidad: data['capacidad'],
        bloqueada: data['bloqueada'],
        motivoBloqueo: data['motivoBloqueo'],
      );

      await salaService.crearSala(sala);
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
          'Carga completa: $successCount de ${successCount + errorCount} salas creadas.\n'
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
