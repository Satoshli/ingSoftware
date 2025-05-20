import 'package:flutter/material.dart';
import '../widgets/base_scaffold.dart';
import '../../widgets/csv_buttons/salas_button.dart' as salas_btn;
import '../../widgets/csv_buttons/horarios_button.dart' as horarios_btn;
import '../../widgets/csv_buttons/cursos_button.dart' as cursos_btn;
import '../../widgets/csv_buttons/secciones_button.dart' as secciones_btn;

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentIndex: 2, // Asume que index 2 es el Admin
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            break;
          case 1:
            Navigator.pushNamedAndRemoveUntil(context, '/salas', (route) => false);
            break;
          case 2:
            // Ya estamos en Admin, no hacer nada
            break;
        }
      },
      onLogout: () {
        Navigator.pushReplacementNamed(context, '/login');
      },
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Panel de administración',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: 250,
                  child: salas_btn.UploadCSVSalasButton(label: 'Subir CSV de salas'),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: 250,
                  child: horarios_btn.UploadCSVHorariosButton(label: 'Subir CSV de horarios'),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: 250,
                  child: cursos_btn.UploadCSVCursosButton(label: 'Subir CSV de cursos'),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: 250,
                  child: secciones_btn.UploadCSVSeccionesButton(label: 'Subir CSV de secciones'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
