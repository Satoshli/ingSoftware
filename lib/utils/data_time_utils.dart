import 'package:flutter/material.dart';

class DateTimeUtils {
  static final Map<String, int> _bloques = {
    '08:30': 1,
    '10:00': 2,
    '11:30': 3,
    '13:00': 4,
    '14:30': 5,
    '16:00': 6,
    '17:25': 7,
    '19:00': 8,
  };

  static int getDiaActual() {
    final ahora = DateTime.now();
    return (ahora.weekday <= 6) ? ahora.weekday : 6;
  }

  static Map<String, int?> getBloqueActualYSiguiente() {
    final ahora = TimeOfDay.now();

    final sortedBloques = _bloques.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    int? actual;
    int? siguiente;

    for (int i = 0; i < sortedBloques.length; i++) {
      final inicio = _parseTime(sortedBloques[i].key);
      final fin = (i < sortedBloques.length - 1)
          ? _parseTime(sortedBloques[i + 1].key)
          : const TimeOfDay(hour: 21, minute: 0); // Fin del último bloque

      final ahoraMin = ahora.hour * 60 + ahora.minute;
      final inicioMin = inicio.hour * 60 + inicio.minute;
      final finMin = fin.hour * 60 + fin.minute;

      if (ahoraMin >= inicioMin && ahoraMin < finMin) {
        actual = sortedBloques[i].value;
        siguiente = (i + 1 < sortedBloques.length)
            ? sortedBloques[i + 1].value
            : null;
        break;
      }
    }

    return {
      'actual': actual,
      'siguiente': siguiente,
    };
  }

  static TimeOfDay _parseTime(String horaStr) {
    final partes = horaStr.split(':');
    return TimeOfDay(hour: int.parse(partes[0]), minute: int.parse(partes[1]));
  }
}
