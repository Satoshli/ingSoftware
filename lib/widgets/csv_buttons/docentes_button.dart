import 'package:flutter/material.dart';
import '../../utils/csv/upload_docentes.dart';

class UploadCSVDocentesButton extends StatelessWidget {
  final String label;

  const UploadCSVDocentesButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.upload_file),
      label: Text(label),
      onPressed: () => uploadCSVDocentes(context),
    );
  }
}
