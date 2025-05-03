class Sala {
  final String id;
  final String nombre;
  final String ubicacion;
  final int capacidad;
  final bool disponible;
  final List<String> equipamiento;
  final bool bloqueada;
  final String? motivoBloqueo;

  Sala({
    required this.id,
    required this.nombre,
    required this.ubicacion,
    required this.capacidad,
    required this.disponible,
    required this.equipamiento,
    required this.bloqueada,
    this.motivoBloqueo,
  });

  factory Sala.fromMap(Map<String, dynamic> data, String id) {
    return Sala(
      id: id,
      nombre: data['nombre'],
      ubicacion: data['ubicacion'],
      capacidad: data['capacidad'],
      disponible: data['disponible'],
      equipamiento: List<String>.from(data['equipamiento'] ?? []),
      bloqueada: data['bloqueada'],
      motivoBloqueo: data['motivoBloqueo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'ubicacion': ubicacion,
      'capacidad': capacidad,
      'disponible': disponible,
      'equipamiento': equipamiento,
      'bloqueada': bloqueada,
      'motivoBloqueo': motivoBloqueo,
    };
  }
}