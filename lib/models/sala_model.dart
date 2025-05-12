class Sala {
  final String id;
  final String edificio;
  final String nrosala;
  final int capacidad;
  final bool disponible;
  final bool bloqueada;
  final String? motivoBloqueo;

  Sala({
    required this.id,
    required this.edificio,
    required this.nrosala,
    required this.capacidad,
    required this.disponible,
    required this.bloqueada,
    this.motivoBloqueo,
  });

  factory Sala.fromMap(Map<String, dynamic> data, String id) {
    return Sala(
      id: id,
      edificio: data['edificio'],
      nrosala: data['sala'],
      capacidad: data['capacidad'],
      disponible: data['disponible'],
      bloqueada: data['bloqueada'],
      motivoBloqueo: data['motivoBloqueo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': edificio,
      'ubicacion': nrosala,
      'capacidad': capacidad,
      'disponible': disponible,
      'bloqueada': bloqueada,
      'motivoBloqueo': motivoBloqueo,
    };
  }
}