import 'package:flutter/material.dart';
import '../widgets/base_scaffold.dart';
import '../../widgets/csv_buttons/docentes_button.dart' as docentes_btn;
import '../../widgets/csv_buttons/salas_button.dart' as salas_btn;
import '../../widgets/csv_buttons/horarios_button.dart' as horarios_btn;
import '../../widgets/csv_buttons/cursos_button.dart' as cursos_btn;
import '../../widgets/csv_buttons/secciones_button.dart' as secciones_btn;

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Panel de administración',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            docentes_btn.UploadCSVDocentesButton(label: 'Subir CSV de docentes'),
            SizedBox(height: 16),
            salas_btn.UploadCSVSalasButton(label: 'Subir CSV de salas'),
            SizedBox(height: 16),
            horarios_btn.UploadCSVHorariosButton(label: 'Subir CSV de horarios'),
            SizedBox(height: 16),
            cursos_btn.UploadCSVCursosButton(label: 'Subir CSV de cursos'),
            SizedBox(height: 16),
            SizedBox(height: 16),
            secciones_btn.UploadCSVSeccionesButton(label: 'Subir CSV de secciones'),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
