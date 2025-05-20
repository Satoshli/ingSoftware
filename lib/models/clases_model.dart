// Archivo: clases_model.dart
import 'package:flutter/foundation.dart';

class Horario {
  final String id;
  final String salaId;        // Referencia a sala
  final int dia;              // 1 (lunes) ... 6 (sábado)
  final int bloque;           // Bloques 1-8
  final String cursoId;       // ID del curso (ej: CIT2111)
  final String seccionId;     // ID de la sección
  final String estado;        // 'en clases', 'libre', etc.
  final String horaInicio;    
  final String horaFin;  
  final String nombreprofesor;
  final String nombreCurso;

  Horario({
    required this.id,
    required this.salaId,
    required this.dia,
    required this.bloque,
    required this.cursoId,
    required this.seccionId,
    required this.estado,
    required this.horaInicio,
    required this.horaFin,
    required this.nombreprofesor,
    required this.nombreCurso
  });

  factory Horario.fromMap(Map<String, dynamic> data, String id) {
    try {
      return Horario(
        id: id,
        salaId: data['salaId'] ?? '',
        dia: data['dia'] is int ? data['dia'] : int.tryParse(data['dia']?.toString() ?? '0') ?? 0,
        bloque: data['bloque'] is int ? data['bloque'] : int.tryParse(data['bloque']?.toString() ?? '0') ?? 0,
        cursoId: data['cursoId'] ?? '',
        seccionId: data['seccionId'] ?? '',
        estado: data['estado'] ?? 'libre',
        horaInicio: data['horaInicio'] ?? '',
        horaFin: data['horaFin'] ?? '',
        nombreprofesor: data['nombreprofesor'] ?? '',
        nombreCurso: data['nombreCurso'] ?? '',
      );
    } catch (e) {
      debugPrint('❌ Error al procesar horario: $e\nDatos: $data');
      // En lugar de reenviar el error, retornamos un objeto por defecto
      return Horario(
        id: id,
        salaId: '',
        dia: 0,
        bloque: 0,
        cursoId: '',
        seccionId: '',
        estado: 'error',
        horaInicio: '',
        horaFin: '',
        nombreprofesor: '',
        nombreCurso: 'Error en los datos'
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'salaId': salaId,
      'dia': dia,
      'bloque': bloque,
      'cursoId': cursoId,
      'seccionId': seccionId,
      'estado': estado,
      'horaInicio': horaInicio,
      'horaFin': horaFin,
      'nombreprofesor': nombreprofesor,
      'nombreCurso': nombreCurso
    };
  }
  
  @override
  String toString() {
    return 'Horario{id: $id, cursoId: $cursoId, nombreCurso: $nombreCurso, bloque: $bloque, estado: $estado}';
  }
}