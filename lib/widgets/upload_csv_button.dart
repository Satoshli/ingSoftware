import 'package:flutter/material.dart';
import '../services/csv_upload_service.dart';

class UploadCSVButton extends StatelessWidget {
  final String label;
  final String collection;

  const UploadCSVButton({
    super.key,
    required this.label,
    required this.collection,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.upload_file),
      label: Text(label),
      onPressed: () => uploadCSVFile(context, collection),
    );
  }
}
