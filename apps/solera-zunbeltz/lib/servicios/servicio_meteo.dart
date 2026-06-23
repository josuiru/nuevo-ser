import 'dart:convert';

import 'package:http/http.dart' as http;

/// Previsión meteorológica de 7 días sobre una finca, vía Open-Meteo
/// (gratuito, sin clave de API). Los avisos son meteorológicos (helada,
/// viento, lluvia, calor) — orientativos, no sustituyen el criterio del
/// ganadero ni del veterinario.
class PrevisionMeteo {
  const PrevisionMeteo({
    required this.latitud,
    required this.longitud,
    required this.dias,
    required this.actualizado,
  });

  final double latitud;
  final double longitud;
  final List<DiaMeteo> dias;
  final DateTime actualizado;

  DiaMeteo? get hoy => dias.isEmpty ? null : dias.first;
}

class DiaMeteo {
  const DiaMeteo({
    required this.fecha,
    this.tempMin,
    this.tempMax,
    this.lluviaMm,
    this.probLluviaMax,
    this.vientoMaxKmh,
    this.rachaMaxKmh,
    this.humedadMedia,
  });

  final DateTime fecha;
  final double? tempMin;
  final double? tempMax;
  final double? lluviaMm;
  final double? probLluviaMax;
  final double? vientoMaxKmh;
  final double? rachaMaxKmh;
  final double? humedadMedia;

  /// Riesgo de helada (aviso preventivo desde 0 °C): frío para el ganado
  /// en extensivo y para los abrevaderos/tuberías.
  bool get riesgoHelada => (tempMin ?? 99) <= 0;

  /// Lluvia relevante: dificulta el manejo, el desbroce y los traslados.
  bool get lluviaRelevante =>
      (lluviaMm ?? 0) >= 5 || (probLluviaMax ?? 0) >= 60;

  /// Viento fuerte: revisar cierres y refugios; cuidado con quemas.
  bool get vientoFuerte => (rachaMaxKmh ?? 0) >= 50;

  /// Calor intenso: vigilar sombra y agua para el ganado.
  bool get calorIntenso => (tempMax ?? 0) >= 34;

  /// Día favorable para trabajos de campo (manejo, esquileo, desbroce):
  /// sin lluvia, viento moderado y temperatura razonable.
  bool get buenDiaManejo =>
      (lluviaMm ?? 0) < 1 &&
      (rachaMaxKmh ?? 0) < 35 &&
      (tempMax ?? 0) >= 5 &&
      (tempMax ?? 0) <= 32;
}

class ServicioMeteo {
  static const _endpoint = 'https://api.open-meteo.com/v1/forecast';

  Future<PrevisionMeteo> obtener({
    required double latitud,
    required double longitud,
  }) async {
    final uri = Uri.parse(_endpoint).replace(
      queryParameters: {
        'latitude': latitud.toStringAsFixed(5),
        'longitude': longitud.toStringAsFixed(5),
        'timezone': 'auto',
        'forecast_days': '7',
        'daily': [
          'temperature_2m_max',
          'temperature_2m_min',
          'precipitation_sum',
          'precipitation_probability_max',
          'wind_speed_10m_max',
          'wind_gusts_10m_max',
        ].join(','),
        'hourly': 'relative_humidity_2m',
        'wind_speed_unit': 'kmh',
        'precipitation_unit': 'mm',
      },
    );

    final respuesta = await http.get(uri).timeout(const Duration(seconds: 10));
    if (respuesta.statusCode < 200 || respuesta.statusCode >= 300) {
      throw MeteoException('Respuesta meteo ${respuesta.statusCode}');
    }

    final json =
        jsonDecode(utf8.decode(respuesta.bodyBytes)) as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>? ?? const {};
    final hourly = json['hourly'] as Map<String, dynamic>? ?? const {};
    final fechas = _lista<String>(daily['time']);
    final dias = <DiaMeteo>[];
    for (var i = 0; i < fechas.length; i++) {
      final rangoHorario = _indicesDeDia(hourly['time'], fechas[i]);
      dias.add(DiaMeteo(
        fecha: DateTime.parse(fechas[i]),
        tempMax: _numEn(daily['temperature_2m_max'], i),
        tempMin: _numEn(daily['temperature_2m_min'], i),
        lluviaMm: _numEn(daily['precipitation_sum'], i),
        probLluviaMax: _numEn(daily['precipitation_probability_max'], i),
        vientoMaxKmh: _numEn(daily['wind_speed_10m_max'], i),
        rachaMaxKmh: _numEn(daily['wind_gusts_10m_max'], i),
        humedadMedia: _media(hourly['relative_humidity_2m'], rangoHorario),
      ));
    }

    return PrevisionMeteo(
      latitud: latitud,
      longitud: longitud,
      dias: dias,
      actualizado: DateTime.now(),
    );
  }

  List<int> _indicesDeDia(Object? tiempos, String diaIso) {
    final lista = _lista<String>(tiempos);
    final indices = <int>[];
    for (var i = 0; i < lista.length; i++) {
      if (lista[i].startsWith(diaIso)) indices.add(i);
    }
    return indices;
  }

  static List<T> _lista<T>(Object? valor) {
    if (valor is List) return valor.whereType<T>().toList();
    return const [];
  }

  static double? _numEn(Object? valor, int indice) {
    if (valor is! List || indice < 0 || indice >= valor.length) return null;
    final v = valor[indice];
    return v is num ? v.toDouble() : null;
  }

  static double? _media(Object? valor, List<int> indices) {
    if (valor is! List || indices.isEmpty) return null;
    var suma = 0.0;
    var n = 0;
    for (final i in indices) {
      if (i >= 0 && i < valor.length && valor[i] is num) {
        suma += (valor[i] as num).toDouble();
        n++;
      }
    }
    return n == 0 ? null : suma / n;
  }
}

class MeteoException implements Exception {
  const MeteoException(this.mensaje);
  final String mensaje;

  @override
  String toString() => mensaje;
}
