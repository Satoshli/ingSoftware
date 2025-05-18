class Seccion {
  final String id; // ID del documento/ numero de sección
  final String nombreprofe;
  final String cursoId;
  

  Seccion({
    required this.id,
    required this.nombreprofe,
    required this.cursoId,
  });

  factory Seccion.fromMap(Map<String, dynamic> data, String id, String cursoId) {
    return Seccion(
      id: id,
      nombreprofe: data['nombre_profesor'],
      cursoId: cursoId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre_profesor': nombreprofe,
      'cursoId': cursoId,
    };
  }
}
