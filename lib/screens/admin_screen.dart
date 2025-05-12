import 'package:flutter/material.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/upload_csv_button.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentIndex: 0,
      onTap: (index) {
        Navigator.popUntil(context, ModalRoute.withName('/'));
      },
      onLogout: () {
        Navigator.pushReplacementNamed(context, '/login');
      },
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Panel de administración',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            UploadCSVButton(label: 'Subir CSV de alumnos', collection: 'PersonasUDP'),
            SizedBox(height: 16),
            UploadCSVButton(label: 'Subir CSV de salas', collection: 'salas'),
          ],
        ),
      ),
    );
  }
}
