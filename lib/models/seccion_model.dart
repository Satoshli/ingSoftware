class Seccion {
  final String id; // ID del documento (número de sección)
  final String nombreprofe;
  final String cursoId;

  Seccion({
    required this.id,
    required this.nombreprofe,
    required this.cursoId,
  });

  factory Seccion.fromMap(Map<String, dynamic> data, String id) {
    return Seccion(
      id: id,
      nombreprofe: data['nombre_profesor'] ?? '',
      cursoId: data['cursoId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre_profesor': nombreprofe,
      'cursoId': cursoId,
    };
  }
}
