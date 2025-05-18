class Horario {
  final String id;
  final String salaId;        // Referencia a sala
  final int dia;              // 1 (lunes) ... 6 (sábado)
  final int bloque;           // Bloques 1-8
  final String cursoId;       // ID del curso (ej: CIT2111)
  final String seccionId;     // ID de la sección
  final String estado;        // 'en clases', 'libre', etc.
  final String horaInicio;    // Nuevo: ahora es String tipo "08:30"
  final String horaFin;       // Nuevo: ahora es String tipo "09:50"

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
  });

  factory Horario.fromMap(Map<String, dynamic> data, String id) {
    return Horario(
      id: id,
      salaId: data['salaId'],
      dia: data['dia'] is int ? data['dia'] : int.parse(data['dia']),
      bloque: data['bloque'],
      cursoId: data['cursoId'],
      seccionId: data['seccionId'],
      estado: data['estado'],
      horaInicio: data['horaInicio'],
      horaFin: data['horaFin'],
    );
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
    };
  }
}
