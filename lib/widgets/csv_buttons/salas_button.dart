import 'package:flutter/material.dart';
import '../../utils/csv/upload_salas.dart';

class UploadCSVSalasButton extends StatelessWidget {
  final String label;

  const UploadCSVSalasButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.upload_file),
      label: Text(label),
      onPressed: () => uploadCSVSalas(context),
    );
  }
}
