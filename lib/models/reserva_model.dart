import 'package:cloud_firestore/cloud_firestore.dart';

class Reserva {
  final String id;
  final String usuarioId;
  final String salaId;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String estado;
  final bool reservaTemporal;
  final String? motivo;

  Reserva({
    required this.id,
    required this.usuarioId,
    required this.salaId,
    required this.fechaInicio,
    required this.fechaFin,
    required this.estado,
    required this.reservaTemporal,
    this.motivo,
  });

  factory Reserva.fromMap(Map<String, dynamic> data, String id) {
    return Reserva(
      id: id,
      usuarioId: data['usuarioId'],
      salaId: data['salaId'],
      fechaInicio: (data['fechaInicio'] as Timestamp).toDate(),
      fechaFin: (data['fechaFin'] as Timestamp).toDate(),
      estado: data['estado'],
      reservaTemporal: data['reservaTemporal'],
      motivo: data['motivo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'usuarioId': usuarioId,
      'salaId': salaId,
      'fechaInicio': fechaInicio,
      'fechaFin': fechaFin,
      'estado': estado,
      'reservaTemporal': reservaTemporal,
      'motivo': motivo,
    };
  }
}
