// Archivo: salas_por_bloque_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/clases_model.dart';
import '../models/sala_model.dart';
import '../providers/clases_provider.dart';
import '../widgets/base_scaffold.dart';

class SalasPorBloqueScreen extends StatefulWidget {
  const SalasPorBloqueScreen({
    super.key,
  });

  @override
  State<SalasPorBloqueScreen> createState() => _SalasPorBloqueScreenState();
}

class _SalasPorBloqueScreenState extends State<SalasPorBloqueScreen> {
  final List<Map<String, dynamic>> dias = [
    {'nombre': 'Lunes', 'valor': 1},
    {'nombre': 'Martes', 'valor': 2},
    {'nombre': 'Miércoles', 'valor': 3},
    {'nombre': 'Jueves', 'valor': 4},
    {'nombre': 'Viernes', 'valor': 5},
  ];

  final List<Map<String, dynamic>> bloques = [
    {'nombre': 'Todos', 'valor': null},
    {'nombre': '8.30-9.50', 'valor': 1},
    {'nombre': '10.00-11.20', 'valor': 2},
    {'nombre': '11.30-12.50', 'valor': 3},
    {'nombre': '13.00-14.20', 'valor': 4},
    {'nombre': '14.30-15.50', 'valor': 5},
    {'nombre': '16.00-17.20', 'valor': 6},
    {'nombre': '17.25-18.45', 'valor': 7},
  ];

  int? _selectedBloque;
  String? _selectedCursoId;
  String? _selectedSeccionId;
  String? _selectedSalaId;
  String _estadoFiltro = 'todos'; // 'todos', 'libres', 'ocupadas'
  int _currentIndex = 2; // Asumiendo que esta pantalla es el índice 2 en la navegación

  @override
  void initState() {
    super.initState();
    // Inicializar datos usando el provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<HorarioProvider>(context, listen: false);
      provider.cargarDatosIniciales();
    });
  }

  Future<void> _onCursoSeleccionado(String? cursoId) async {
    setState(() {
      _selectedCursoId = cursoId;
      _selectedSeccionId = null;
    });

    if (cursoId != null) {
      final provider = Provider.of<HorarioProvider>(context, listen: false);
      await provider.cargarSecciones(cursoId);
    }
  }

  void _aplicarFiltros() {
    final provider = Provider.of<HorarioProvider>(context, listen: false);
    
    String? estado;
    if (_estadoFiltro == 'libres') estado = 'libre';
    if (_estadoFiltro == 'ocupadas') estado = 'en clases';

    provider.setFiltros(
      bloque: _selectedBloque,
      cursoId: _selectedCursoId,
      seccionId: _selectedSeccionId,
      salaId: _selectedSalaId,
      estado: estado,
    );
  }
  
  void _handleNavigation(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Navegación entre pantallas
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        // Otra ruta si es necesario
        break;
      case 2:
        // Ya estamos en esta pantalla
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/administracion');
        break;
    }
  }

  void _handleLogout() {
    // Implementar lógica de cierre de sesión
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HorarioProvider>(context);
    
    return BaseScaffold(
      currentIndex: _currentIndex,
      onTap: _handleNavigation,
      onLogout: _handleLogout,
      body: DefaultTabController(
        length: dias.length,
        initialIndex: 0,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              onTap: (index) {
                provider.cambiarDia(dias[index]['valor']);
              },
              tabs: dias.map((d) => Tab(text: d['nombre'])).toList(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Bloque
                    DropdownButtonFormField<int?>(
                      value: _selectedBloque,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Bloque'),
                      items: bloques.map((b) {
                        return DropdownMenuItem<int?>(
                          value: b['valor'],
                          child: Text(b['nombre']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedBloque = value;
                        });
                        _aplicarFiltros();
                      },
                    ),
                    const SizedBox(height: 10),

                    // Curso
                    DropdownButtonFormField<String?>(
                      value: _selectedCursoId,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Curso'),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('Todos'),
                        ),
                        ...provider.cursos.map((c) {
                          return DropdownMenuItem<String?>(
                            value: c.id,
                            child: Text(c.nombre),
                          );
                        })
                      ],
                      onChanged: (value) async {
                        await _onCursoSeleccionado(value);
                        _aplicarFiltros();
                      },
                    ),
                    const SizedBox(height: 10),

                    // Sección
                    DropdownButtonFormField<String?>(
                      value: _selectedSeccionId,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Sección'),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('Todas'),
                        ),
                        ...provider.secciones.map((s) {
                          return DropdownMenuItem<String?>(
                            value: s.id,
                            child: Text(s.id),
                          );
                        })
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedSeccionId = value;
                        });
                        _aplicarFiltros();
                      },
                    ),
                    const SizedBox(height: 10),

                    // Sala
                    DropdownButtonFormField<String?>(
                      value: _selectedSalaId,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Sala'),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('Todas'),
                        ),
                        ...provider.salas.map((s) {
                          return DropdownMenuItem<String?>(
                            value: s.id,
                            child: Text('${s.edificio} ${s.nrosala}'),
                          );
                        })
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedSalaId = value;
                        });
                        _aplicarFiltros();
                      },
                    ),
                    const SizedBox(height: 10),

                    // Filtro de estado (libre/ocupada)
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment<String>(
                          value: 'todos',
                          label: Text('Todas'),
                          icon: Icon(Icons.all_inclusive),
                        ),
                        ButtonSegment<String>(
                          value: 'libres',
                          label: Text('Libres'),
                          icon: Icon(Icons.check_circle),
                        ),
                        ButtonSegment<String>(
                          value: 'ocupadas',
                          label: Text('Ocupadas'),
                          icon: Icon(Icons.cancel),
                        ),
                      ],
                      selected: {_estadoFiltro},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() {
                          _estadoFiltro = newSelection.first;
                        });
                        _aplicarFiltros();
                      },
                    ),
                    
                    const Divider(),
                    
                    // Resultados
                    provider.loading
                        ? const Center(child: CircularProgressIndicator())
                        : Expanded(
                            child: provider.resultado.isEmpty
                                ? const Center(child: Text('No se encontraron resultados'))
                                : ListView.builder(
                                    itemCount: provider.resultado.length,
                                    itemBuilder: (context, index) {
                                      final item = provider.resultado[index];
                                      final sala = item['sala'] as Sala;
                                      final ocupada = item['ocupada'] as bool;
                                      final Horario? horario = item['horario'];
                                      final int? bloque = item['bloque'];
                                      
                                      final bloqueInfo = bloques.firstWhere(
                                        (b) => b['valor'] == bloque,
                                        orElse: () => {'nombre': bloque != null ? 'Bloque $bloque' : 'Bloque desconocido'},
                                      );

                                      // Determinar día de la semana
                                      final diaSeleccionado = provider.diaSeleccionado;
                                      final nombreDia = dias.firstWhere(
                                        (d) => d['valor'] == diaSeleccionado,
                                        orElse: () => {'nombre': 'Desconocido'},
                                      )['nombre'];

                                      return Card(
                                        margin: const EdgeInsets.symmetric(vertical: 4),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: InkWell(
                                            onTap: () {
                                              if (horario != null) {
                                                _mostrarDetallesHorario(context, horario, nombreDia);
                                              }
                                            },
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${sala.edificio} ${sala.nrosala}',
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    ocupada
                                                      ? const Icon(Icons.close, color: Colors.red)
                                                      : const Icon(Icons.check, color: Colors.green),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                if (horario != null) ...[
                                                  Text(
                                                    horario.nombreCurso,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    horario.nombreprofesor,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.calendar_today, size: 16),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        '$nombreDia, ${horario.horaInicio} - ${horario.horaFin}',
                                                        style: const TextStyle(fontSize: 13),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.people, size: 16),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        'Sección: ${horario.seccionId}',
                                                        style: const TextStyle(fontSize: 13),
                                                      ),
                                                    ],
                                                  ),
                                                ] else ...[
                                                  Text(
                                                    'LIBRE',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.green[700],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.access_time, size: 16),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        '${bloqueInfo['nombre']}',
                                                        style: const TextStyle(fontSize: 13),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _mostrarDetallesHorario(BuildContext context, Horario horario, String nombreDia) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            Text(
              horario.nombreCurso,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              horario.nombreprofesor,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$nombreDia, ${horario.horaInicio} - ${horario.horaFin}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.people),
                const SizedBox(width: 8),
                Text(
                  'Sección: ${horario.seccionId}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}