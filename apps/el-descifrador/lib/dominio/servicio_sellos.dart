// Servicio que evalúa qué sellos del cuaderno (doc 06 §4) se han
// activado en una transición concreta.
//
// La función pura toma estado previo + lo que acaba de pasar y
// devuelve las claves de los sellos que deberían registrarse. El
// llamador (PantallaDocumento) las persiste via RepositorioSellos
// antes de pop, y PantallaMesa las muestra como banda discreta.

import 'decision_documento.dart';
import 'identificaciones_lengua.dart';
import 'lengua.dart';
import 'sellos.dart';

class ServicioSellos {
  const ServicioSellos();

  /// Sellos que se conceden por haber identificado correctamente una
  /// lengua. Si es la primera vez que el niño la identifica con éxito,
  /// el sello "Hoy ha entrado el … en tu cuaderno" se concede.
  ///
  /// La identificación se considera nueva si todavía no había una
  /// previa para esa misma lengua en el conjunto de identificaciones.
  List<String> sellosTrasIdentificacionExitosa({
    required Lengua lenguaIdentificada,
    required IdentificacionesPiezas identificacionesPrevias,
    required Sellos sellosPrevios,
  }) {
    final clave = claveLenguaDescubierta(lenguaIdentificada);
    if (sellosPrevios.tieneSello(clave)) return const [];

    // Comprobar si ya había alguna identificación correcta previa de
    // esta lengua en otra pieza — para no conceder el sello de
    // "descubrimiento" la segunda vez si el sello no se registró
    // por algún motivo (migración, borrado).
    final yaHabia = identificacionesPrevias
        .idsCorrectamenteIdentificadas()
        .isNotEmpty;
    if (yaHabia) {
      // Verificación específica por lengua: el método yaIdentificada
      // por idPieza no nos sirve directamente. Hacemos un repaso.
      for (final id
          in identificacionesPrevias.idsCorrectamenteIdentificadas()) {
        final identificacion = identificacionesPrevias.identificacionDe(id);
        if (identificacion == null) continue;
        if (identificacion.intentos.contains(lenguaIdentificada)) {
          return const [];
        }
      }
    }
    return [clave];
  }

  /// Sellos que se conceden tras decidir sobre una pieza:
  /// - Primera pieza descifrada en una lengua concreta.
  /// - Primera publicación en el Boletín (independiente de la lengua).
  List<String> sellosTrasDecision({
    required Lengua lenguaDePieza,
    required DecisionDocumento decisionTomada,
    required Sellos sellosPrevios,
  }) {
    final nuevos = <String>[];

    final claveDescifrada = claveLenguaDescifrada(lenguaDePieza);
    if (!sellosPrevios.tieneSello(claveDescifrada)) {
      nuevos.add(claveDescifrada);
    }

    if (decisionesQueSellanBoletin.contains(decisionTomada) &&
        !sellosPrevios.tieneSello(clavePublicacionBoletin)) {
      nuevos.add(clavePublicacionBoletin);
    }

    return nuevos;
  }
}
