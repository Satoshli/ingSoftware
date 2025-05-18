class Sala {
  final String id;
  final String nombre;
  final String edificio;
  final int piso;
  final String nrosala;
  final int capacidad;
  final bool bloqueada;
  final String? motivoBloqueo;

  Sala({
    required this.nombre,
    required this.id,
    required this.piso,
    required this.edificio,
    required this.nrosala,
    required this.capacidad,
    required this.bloqueada,
    this.motivoBloqueo,
  });

  factory Sala.fromMap(Map<String, dynamic> data, String id) {
    return Sala(
      id: id,
      nombre: data['nombre'],
      piso: data['piso'],
      edificio: data['edificio'],
      nrosala: data['nrosala'],
      capacidad: data['capacidad'],
      bloqueada: data['bloqueada'],
      motivoBloqueo: data['motivoBloqueo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'edificio': edificio,
      'piso': piso,  // Agregado el campo piso que faltaba
      'nrosala': nrosala,
      'capacidad': capacidad,
      'bloqueada': bloqueada,
      'motivoBloqueo': motivoBloqueo,
    };
  }

  /// Utilidad para crear copias modificadas fácilmente (ideal para updates y batch)
  Sala copyWith({
    String? id,
    String? nombre,
    int? piso,
    String? edificio,
    String? nrosala,
    int? capacidad,
    bool? bloqueada,
    String? motivoBloqueo,
  }) {
    return Sala(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      edificio: edificio ?? this.edificio,
      nrosala: nrosala ?? this.nrosala,
      piso: piso ?? this.piso,
      capacidad: capacidad ?? this.capacidad,
      bloqueada: bloqueada ?? this.bloqueada,
      motivoBloqueo: motivoBloqueo ?? this.motivoBloqueo,
    );
  }
}