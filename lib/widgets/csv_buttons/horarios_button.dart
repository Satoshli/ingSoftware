import 'package:flutter/material.dart';
import '../../utils/csv/upload_horarios.dart';

class UploadCSVHorariosButton extends StatelessWidget {
  final String label;

  const UploadCSVHorariosButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.upload_file),
      label: Text(label),
      onPressed: () => uploadCSVHorarios(context),
    );
  }
}
