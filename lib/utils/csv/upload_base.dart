import 'dart:io' as io;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

Future<List<String>> pickAndReadCSV() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['csv'],
    withData: kIsWeb,
  );

  if (result == null || result.files.isEmpty) return [];

  if (kIsWeb) {
    final fileBytes = result.files.single.bytes;
    if (fileBytes == null) throw Exception('Archivo vacío o corrupto');
    final content = String.fromCharCodes(fileBytes);
    return content.split(RegExp(r'\r?\n')).where((line) => line.trim().isNotEmpty).toList();
  } else {
    final file = io.File(result.files.single.path!);
    return await file.readAsLines();
  }
}
