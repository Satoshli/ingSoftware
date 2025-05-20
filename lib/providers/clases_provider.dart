// Archivo: clases_provider.dart
import 'package:flutter/material.dart';
import '../services/salas/sala_service.dart';
import '../services/salas/clases_service.dart';
import '../models/sala_model.dart';
import '../models/clases_model.dart';
import '../models/cursos_model.dart';
import '../models/seccion_model.dart';
import '../services/cursos/cursos_service.dart';
import '../services/cursos/seccion_service.dart';

class HorarioProvider with ChangeNotifier {
  final SalaService _salaService = SalaService();
  final HorarioService _horarioService = HorarioService();
  final CursoService _cursoService = CursoService();

  // Caché de datos
  Map<String, Sala> _salasMap = {};
  Map<int, List<Horario>> _horariosPorDia = {};
  
  // Datos para la UI
  List<Curso> _cursos = [];
  List<Seccion> _secciones = [];
  List<Sala> _salas = [];
  List<Map<String, dynamic>> _resultado = [];
  
  // Getters
  List<Curso> get cursos => _cursos;
  List<Seccion> get secciones => _secciones;
  List<Sala> get salas => _salas;
  List<Map<String, dynamic>> get resultado => _resultado;
  
  // Estado
  bool _loading = false;
  bool get loading => _loading;
  int _diaSeleccionado = 1;
  int get diaSeleccionado => _diaSeleccionado;

  // Filtros activos
  int? _bloque;
  String? _cursoId;
  String? _seccionId;
  String? _salaId;
  String? _estado;

  /// Carga inicial de datos (cursos y salas)
  Future<void> cargarDatosIniciales() async {
    _setLoading(true);
    try {
      // Cargar cursos y salas en paralelo
      final resultados = await Future.wait([
        _cursoService.getTodosLosCursos(),
        _salaService.getTodasLasSalas(),
      ]);
      
      _cursos = resultados[0] as List<Curso>;
      _salas = resultados[1] as List<Sala>;
      
      // Inicializar salasMap
      _salasMap = {for (var s in _salas) s.id: s};
      
      // Cargar horarios del día actual
      await _cargarHorariosPorDia(_diaSeleccionado);
      await _aplicarFiltrosYActualizarResultado();
    } catch (e) {
      debugPrint('❌ Error en cargarDatosIniciales: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Carga las secciones para un curso específico
  Future<void> cargarSecciones(String cursoId) async {
    _setLoading(true);
    try {
      final seccionesService = SeccionService(cursoId: cursoId);
      _secciones = await seccionesService.getSeccionesPorCurso(cursoId);
    } catch (e) {
      debugPrint('❌ Error en cargarSecciones: $e');
      _secciones = [];
    } finally {
      _setLoading(false);
    }
  }

  /// Cambia el día y actualiza la información
  void cambiarDia(int nuevoDia) async {
    if (_diaSeleccionado != nuevoDia) {
      _setLoading(true);
      _diaSeleccionado = nuevoDia;
      
      try {
        // Cargar horarios si no están en caché
        if (!_horariosPorDia.containsKey(nuevoDia)) {
          await _cargarHorariosPorDia(nuevoDia);
        }
        await _aplicarFiltrosYActualizarResultado();
      } catch (e) {
        debugPrint('❌ Error al cambiar día: $e');
      } finally {
        _setLoading(false);
      }
    }
  }

  /// Establece los filtros y actualiza el resultado
  void setFiltros({
    int? bloque,
    String? cursoId,
    String? seccionId,
    String? salaId,
    String? estado,
  }) async {
    _setLoading(true);
    
    // Actualizar filtros
    _bloque = bloque;
    _cursoId = cursoId;
    _seccionId = seccionId;
    _salaId = salaId;
    _estado = estado;
    
    try {
      await _aplicarFiltrosYActualizarResultado();
    } catch (e) {
      debugPrint('❌ Error al aplicar filtros: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Métodos privados para manejo de estado
  void _setLoading(bool val) {
    if (_loading != val) {
      _loading = val;
      notifyListeners();
    }
  }

  void _actualizarResultado(List<Map<String, dynamic>> res) {
    _resultado = res;
    notifyListeners();
  }

  /// Carga horarios para un día específico
  Future<void> _cargarHorariosPorDia(int dia) async {
    final filtros = {'dia': dia};
    final horarios = await _horarioService.getHorariosConFiltros(filtros);
    _horariosPorDia[dia] = horarios;
  }

  /// Aplica filtros localmente y actualiza el resultado
  Future<void> _aplicarFiltrosYActualizarResultado() async {
    if (_salasMap.isEmpty) {
      _salasMap = {for (var s in _salas) s.id: s};
    }
    
    // Asegurarse de que tenemos los horarios del día actual
    if (!_horariosPorDia.containsKey(_diaSeleccionado)) {
      await _cargarHorariosPorDia(_diaSeleccionado);
    }
    
    // Obtener horarios del día actual
    final horariosDelDia = _horariosPorDia[_diaSeleccionado] ?? [];
    
    // Organizar horarios por sala y bloque para acceso rápido
    final bloquesOcupadosPorSala = <String, Map<int, Horario>>{};
    for (final h in horariosDelDia) {
      bloquesOcupadosPorSala[h.salaId] ??= {};
      bloquesOcupadosPorSala[h.salaId]![h.bloque] = h;
    }

    // Crear resultado completo
    final resultadoCompleto = <Map<String, dynamic>>[];

    // Aplicar filtros localmente
    for (final sala in _salas) {
      // Filtro de sala
      if (_salaId != null && sala.id != _salaId) continue;

      for (int bloque = 1; bloque <= 7; bloque++) {
        // Filtro de bloque
        if (_bloque != null && bloque != _bloque) continue;

        final horario = bloquesOcupadosPorSala[sala.id]?[bloque];
        final ocupada = horario != null && horario.estado == 'en clases';

        // Filtro de curso
        if (_cursoId != null && (horario?.cursoId != _cursoId)) continue;

        // Filtro de sección
        if (_seccionId != null && (horario?.seccionId != _seccionId)) continue;

        // Filtro de estado
        if (_estado == 'libre' && ocupada) continue;
        if (_estado == 'en clases' && !ocupada) continue;

        resultadoCompleto.add({
          'sala': sala,
          'bloque': bloque,
          'horario': horario,
          'ocupada': ocupada,
        });
      }
    }

    // Ordenar por bloque y nombre de sala para mejor visualización
    resultadoCompleto.sort((a, b) {
      int comparaBloque = (a['bloque'] as int).compareTo(b['bloque'] as int);
      if (comparaBloque != 0) return comparaBloque;
      
      final salaA = a['sala'] as Sala;
      final salaB = b['sala'] as Sala;
      return '${salaA.edificio}${salaA.nrosala}'.compareTo('${salaB.edificio}${salaB.nrosala}');
    });
    
    _actualizarResultado(resultadoCompleto);
  }
  
  /// Limpia la caché para forzar recarga de datos
  void limpiarCache() {
    _horariosPorDia.clear();
    _salasMap.clear();
    notifyListeners();
  }
}