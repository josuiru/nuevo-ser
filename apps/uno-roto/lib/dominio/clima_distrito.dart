import 'ambiente_cielo.dart';

/// Resuelve qué [AmbienteCielo] corresponde a un distrito en una fecha
/// dada. Determinista: la pareja `(idDistrito, fecha)` siempre devuelve
/// el mismo ambiente, y solo cambia al pasar al día siguiente.
///
/// El criterio NO es realismo meteorológico — es **carácter del
/// distrito**. Cada distrito tiene su distribución estable de climas
/// que refleja la crónica de Mire Cordo en el Faro (E13, "Las tres
/// lluvias"): los Canales tragan la lluvia humilde, en los Tejados
/// llueve ruidoso, en el Mercado llueve molesto, en Industria llueve
/// negra por el humo, en el Puerto llueve salada, en las Afueras casi
/// no llueve. Las distribuciones aquí codifican ese encuadre — al niño
/// que pasa varias semanas por todos los distritos se le va instalando
/// la diferencia, sin que nadie se la diga.
///
/// El módulo es puro (sin Flutter, sin reloj global). Se le pasa
/// [ahora] desde fuera para que los tests lo congelen.
class ClimaDistrito {
  /// Devuelve el ambiente que toca al [idDistrito] el día de [ahora].
  ///
  /// Si el id no está catalogado, cae en `tejados` (igual que el
  /// pintor por defecto). El minuto y la hora se ignoran a propósito
  /// — solo importa el día.
  static AmbienteCielo delDia({
    required String idDistrito,
    required DateTime ahora,
  }) {
    final tabla = _tablaPorDistrito[idDistrito] ?? _tablaPorDistrito['tejados']!;
    final semilla = _semillaDelDia(ahora: ahora, idDistrito: idDistrito);
    return _elegirPonderado(tabla: tabla, semilla: semilla);
  }

  /// Catálogos de pesos por distrito. Los pesos no necesitan sumar
  /// 100 — `_elegirPonderado` los normaliza por el total.
  static final Map<String, List<_PesoAmbiente>> _tablaPorDistrito = {
    // Tejados — donde llueve ruidoso. Predominio de noche despejada,
    // niebla suave de vez en cuando, lluvia de tarde en tarde.
    'tejados': const [
      _PesoAmbiente(70, AmbienteCielo.nocheDespejada),
      _PesoAmbiente(20, AmbienteCielo.nieblaSuave),
      _PesoAmbiente(10, AmbienteCielo.lluviaLigera),
    ],

    // Canales — niebla humilde casi siempre. La lluvia entra
    // discretamente y los canales la tragan.
    'canales': const [
      _PesoAmbiente(45, AmbienteCielo.niebla),
      _PesoAmbiente(25, AmbienteCielo.lluviaLigera),
      _PesoAmbiente(20, AmbienteCielo.nocheDespejada),
      _PesoAmbiente(10, AmbienteCielo.cieloLimpioMontana),
    ],

    // Mercado — clima molesto. Noche normal, lluvia que atraviesa los
    // toldos, alguna niebla suave que no estorba al comercio.
    'mercado': const [
      _PesoAmbiente(60, AmbienteCielo.nocheDespejada),
      _PesoAmbiente(25, AmbienteCielo.lluviaLigera),
      _PesoAmbiente(15, AmbienteCielo.nieblaSuave),
    ],

    // Industria — niebla negra por el humo de las chimeneas casi la
    // mitad de los días. Cuando aclara, noche oscura.
    'industria': const [
      _PesoAmbiente(50, AmbienteCielo.niebla),
      _PesoAmbiente(30, AmbienteCielo.nocheDespejada),
      _PesoAmbiente(20, AmbienteCielo.lluviaLigera),
    ],

    // Puerto — niebla salada frecuente. Cuando se levanta, noche con
    // las dos lunas claras y el faro lejano. Lluvia ligera ocasional.
    'puerto': const [
      _PesoAmbiente(40, AmbienteCielo.niebla),
      _PesoAmbiente(30, AmbienteCielo.nocheDespejada),
      _PesoAmbiente(20, AmbienteCielo.lluviaLigera),
      _PesoAmbiente(10, AmbienteCielo.cieloLimpioMontana),
    ],

    // Afueras — casi no llueve. Cielo limpio con la Montaña entera la
    // mitad de los días, noche despejada el resto. Lluvia rarísima.
    'afueras': const [
      _PesoAmbiente(45, AmbienteCielo.cieloLimpioMontana),
      _PesoAmbiente(40, AmbienteCielo.nocheDespejada),
      _PesoAmbiente(10, AmbienteCielo.lluviaLigera),
      _PesoAmbiente(5, AmbienteCielo.niebla),
    ],
  };

  /// Combina año, día del año e id del distrito en un entero positivo.
  /// El hash de cadena de Dart es estable dentro del proceso para una
  /// versión dada, suficiente para nuestro uso (no es criptográfico).
  ///
  /// Importante: incluimos el id del distrito en la semilla para que
  /// los seis distritos no caigan en el mismo bucket el mismo día —
  /// si solo dependiera de la fecha, todos amanecerían con el mismo
  /// ambiente, lo que rompería el efecto de carácter.
  static int _semillaDelDia({
    required DateTime ahora,
    required String idDistrito,
  }) {
    final clave = '${ahora.year}-${_diaDelAnio(ahora)}-$idDistrito';
    return clave.hashCode & 0x7FFFFFFF;
  }

  /// Día del año 1..366. No usamos `DateTime.daysInYear` porque no
  /// existe; lo calculamos a mano con la diferencia desde 1 de enero.
  static int _diaDelAnio(DateTime fecha) {
    final inicioAnio = DateTime(fecha.year);
    return fecha.difference(inicioAnio).inDays + 1;
  }

  static AmbienteCielo _elegirPonderado({
    required List<_PesoAmbiente> tabla,
    required int semilla,
  }) {
    final total = tabla.fold<int>(0, (acumulado, p) => acumulado + p.peso);
    final modulo = semilla % total;
    var acumulado = 0;
    for (final entrada in tabla) {
      acumulado += entrada.peso;
      if (modulo < acumulado) return entrada.ambiente;
    }
    // Fallback inalcanzable mientras la tabla no esté vacía — la
    // construcción garantiza que `acumulado` llega a `total > modulo`.
    return tabla.last.ambiente;
  }
}

class _PesoAmbiente {
  final int peso;
  final AmbienteCielo ambiente;
  const _PesoAmbiente(this.peso, this.ambiente);
}
