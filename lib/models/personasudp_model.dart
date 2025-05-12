class Personasudp {
 final String correo;
  final String rol;

  Personasudp({
   required this.correo,
    required this.rol,
  });

  factory Personasudp.fromMap(Map<String, dynamic> data, String id) {
    return Personasudp(
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
