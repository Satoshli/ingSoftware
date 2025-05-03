import 'package:cloud_firestore/cloud_firestore.dart';

class Validacion {
  final String id;
  final String reservaId;
  final String validadoPor;
  final DateTime fechaValidacion;
  final bool resultado;
  final String? comentario;

  Validacion({
    required this.id,
    required this.reservaId,
    required this.validadoPor,
    required this.fechaValidacion,
    required this.resultado,
    this.comentario,
  });

  factory Validacion.fromMap(Map<String, dynamic> data, String id) {
    return Validacion(
      id: id,
      reservaId: data['reservaId'],
      validadoPor: data['validadoPor'],
      fechaValidacion: (data['fechaValidacion'] as Timestamp).toDate(),
      resultado: data['resultado'],
      comentario: data['comentario'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reservaId': reservaId,
      'validadoPor': validadoPor,
      'fechaValidacion': fechaValidacion,
      'resultado': resultado,
      'comentario': comentario,
    };
  }
}