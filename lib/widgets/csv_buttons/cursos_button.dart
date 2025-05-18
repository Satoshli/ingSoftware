import 'package:flutter/material.dart';
import '../../utils/csv/upload_cursos.dart';

class UploadCSVCursosButton extends StatelessWidget {
  final String label;

  const UploadCSVCursosButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.upload_file),
      label: Text(label),
      onPressed: () => uploadCSVCursos(context),
    );
  }
}