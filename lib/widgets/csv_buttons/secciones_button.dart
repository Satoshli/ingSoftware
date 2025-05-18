import 'package:flutter/material.dart';
import '../../utils/csv/upload_secciones.dart';

class UploadCSVSeccionesButton extends StatelessWidget {
  final String label;

  const UploadCSVSeccionesButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.upload_file),
      label: Text(label),
      onPressed: () => uploadCSVSecciones(context),
    );
  }
}