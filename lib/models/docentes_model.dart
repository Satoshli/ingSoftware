class Docentes {
  final String correo;
  final String rol;

  Docentes({
    required this.correo,
    required this.rol,
  });

  factory Docentes.fromMap(Map<String, dynamic> data, String id) {
    return Docentes(
      correo: data['correo'],
      rol: data['rol'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'correo': correo,
      'rol': rol,
    };
  }
}
