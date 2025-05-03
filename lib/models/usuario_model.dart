class Usuario {
  final String id;
  final String nombre;
  final String correo;
  final String rol;
  final bool activo;

  Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.rol,
    required this.activo,
  });

  factory Usuario.fromMap(Map<String, dynamic> data, String id) {
    return Usuario(
      id: id,
      nombre: data['nombre'],
      correo: data['correo'],
      rol: data['rol'],
      activo: data['activo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'correo': correo,
      'rol': rol,
      'activo': activo,
    };
  }
}
