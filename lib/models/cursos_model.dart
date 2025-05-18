class Curso {
  final String id; // Código del curso, ej: CIT2111
  final String nombre;
  


  Curso({
    required this.id,
    required this.nombre,
    
    
  });

  factory Curso.fromMap(Map<String, dynamic> data, String id) {
    return Curso(
      id: id,
      nombre: data['nombre'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
    
    };
  }
}
