import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadCSVFile(BuildContext context, String collection) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['csv'],
    withData: kIsWeb,
  );

  if (result == null || result.files.isEmpty) return;

  List<String> lines = [];

  try {
    if (kIsWeb) {
      final fileBytes = result.files.single.bytes;
      if (fileBytes == null) throw Exception('Archivo vacío o corrupto');
      final content = String.fromCharCodes(fileBytes);
      lines = content.split(RegExp(r'\r?\n')).where((line) => line.trim().isNotEmpty).toList();
    } else {
      final file = io.File(result.files.single.path!);
      lines = await file.readAsLines();
    }
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
  final firestore = FirebaseFirestore.instance;

  int successCount = 0;
  int errorCount = 0;
  List<String> errorDetails = [];

  for (var i = 1; i < lines.length; i++) {
    try {
      final values = lines[i].split(',').map((v) => v.trim()).toList();
      if (values.length != headers.length) {
        throw FormatException('Cantidad incorrecta de columnas en la línea ${i + 1}');
      }

      final data = <String, dynamic>{};
      for (int j = 0; j < headers.length; j++) {
        final key = headers[j];
        final value = values[j];

        if (key == 'capacidad') {
          data[key] = int.tryParse(value) ?? 0;
        } else if (key == 'disponible' || key == 'bloqueada') {
          data[key] = value.toLowerCase() == 'true';
        } else if (key == 'motivoBloqueo') {
          data[key] = value.toLowerCase() == 'null' || value.isEmpty ? null : value;
        } else {
          data[key] = value;
        }
      }

      await firestore.collection(collection).add(data);
      successCount++;
    } catch (e) {
      errorCount++;
      errorDetails.add('Línea ${i + 1}: $e');
    }
  }

  if (context.mounted) {
    final total = successCount + errorCount;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Carga completa: $successCount de $total documentos subidos.\n'
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
