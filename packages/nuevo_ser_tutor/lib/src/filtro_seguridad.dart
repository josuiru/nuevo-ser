/// Filtro de seguridad para entrada y salida del Tutor IA.
///
/// Doble capa: este filtro corre en el cliente (Flutter) antes de
/// enviar la petición y al recibir la respuesta. El plugin WordPress
/// debe replicar las reglas en PHP — si las dos capas discrepan, este
/// es el contrato canónico.
///
/// Principios (doc 01 §5, doc 03 §11):
/// - El tutor SOLO ayuda con matemáticas del MVP. Nada de consejos
///   personales, médicos, emocionales o ajenos al ámbito.
/// - Sin PII saliente: bloqueamos email, teléfono y URLs en la
///   pregunta del niño (puede pegarlos sin querer).
/// - Sin inyección de prompt: detectamos los patrones más comunes
///   ("ignora las instrucciones anteriores"…) y rechazamos.
/// - Las respuestas se limitan en longitud para evitar muros de texto.
library;

/// Resultado de la revisión. Sealed para forzar exhaustividad en el
/// dispatcher que decide si llama al backend o muestra un mensaje.
sealed class ResultadoRevision {
  const ResultadoRevision();
}

/// La revisión pasó. `contenidoLimpio` es el texto que efectivamente
/// se envía o se muestra (puede ser distinto del original tras sanear
/// espacios redundantes).
class RevisionAceptada extends ResultadoRevision {
  final String contenidoLimpio;
  const RevisionAceptada(this.contenidoLimpio);
}

/// La revisión rechazó el contenido. `motivo` permite a la UI elegir
/// el mensaje que ve el niño (cariñoso, no acusatorio).
class RevisionRechazada extends ResultadoRevision {
  final MotivoRechazo motivo;
  const RevisionRechazada(this.motivo);
}

enum MotivoRechazo {
  vacio,
  demasiadoLargo,
  contieneEmail,
  contieneTelefono,
  contieneUrl,
  posibleInyeccionPrompt,
  fueraDeAlcance,
}

/// Límites duros. La respuesta del LLM puede ser más corta — esto es
/// solo el techo para que el filtro lo trunque/rechace.
const int longitudMaximaPregunta = 280;
const int longitudMaximaRespuesta = 1200;

/// Patrones obvios de inyección de prompt. Lista corta — cualquier
/// patrón sutil pasará, pero los obvios (que es lo que un niño podría
/// pegar de Internet) los pillamos. La capa servidor refuerza esto.
const _patronesInyeccion = <String>[
  'ignora las instrucciones',
  'ignore previous',
  'disregard',
  'olvida lo anterior',
  'olvida las reglas',
  'system prompt',
  'eres un',
  'pretend you are',
  'jailbreak',
];

/// Lista corta de palabras clave que indican inequívocamente fuera de
/// alcance. Conscientemente corta — preferimos pasar a la API y dejar
/// que Claude se niegue (con su propia capa) que rechazar prematuro.
/// Lo que cortamos aquí es lo que ni queremos enviar.
const _palabrasFueraDeAlcance = <String>[
  'medicamento',
  'medicina',
  'suicid',
  'novia',
  'novio',
];

final _patronEmail = RegExp(
  r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b',
);

final _patronTelefono = RegExp(
  // Secuencia de 9-15 dígitos opcionalmente con prefijo internacional,
  // separadores blandos (espacios, guiones).
  r'(\+?\d[\d\s\-]{7,14}\d)',
);

final _patronUrl = RegExp(
  r'https?://\S+|www\.\S+\.\S+',
  caseSensitive: false,
);

class FiltroSeguridad {
  const FiltroSeguridad();

  /// Revisa la pregunta del niño antes de enviarla al tutor.
  ResultadoRevision revisarPregunta(String pregunta) {
    final saneada = pregunta.trim();
    if (saneada.isEmpty) {
      return const RevisionRechazada(MotivoRechazo.vacio);
    }
    if (saneada.length > longitudMaximaPregunta) {
      return const RevisionRechazada(MotivoRechazo.demasiadoLargo);
    }
    if (_patronEmail.hasMatch(saneada)) {
      return const RevisionRechazada(MotivoRechazo.contieneEmail);
    }
    if (_patronTelefono.hasMatch(saneada)) {
      return const RevisionRechazada(MotivoRechazo.contieneTelefono);
    }
    if (_patronUrl.hasMatch(saneada)) {
      return const RevisionRechazada(MotivoRechazo.contieneUrl);
    }
    final saneadaMin = saneada.toLowerCase();
    for (final patron in _patronesInyeccion) {
      if (saneadaMin.contains(patron)) {
        return const RevisionRechazada(MotivoRechazo.posibleInyeccionPrompt);
      }
    }
    for (final palabra in _palabrasFueraDeAlcance) {
      if (saneadaMin.contains(palabra)) {
        return const RevisionRechazada(MotivoRechazo.fueraDeAlcance);
      }
    }
    return RevisionAceptada(saneada);
  }

  /// Revisa la respuesta del tutor antes de mostrarla. Si pasa todos
  /// los chequeos pero supera la longitud máxima, la trunca (no la
  /// rechaza — un poquito de muro de texto es preferible a nada).
  ResultadoRevision revisarRespuesta(String respuesta) {
    final saneada = respuesta.trim();
    if (saneada.isEmpty) {
      return const RevisionRechazada(MotivoRechazo.vacio);
    }
    if (_patronEmail.hasMatch(saneada)) {
      return const RevisionRechazada(MotivoRechazo.contieneEmail);
    }
    if (_patronTelefono.hasMatch(saneada)) {
      return const RevisionRechazada(MotivoRechazo.contieneTelefono);
    }
    if (_patronUrl.hasMatch(saneada)) {
      return const RevisionRechazada(MotivoRechazo.contieneUrl);
    }
    final truncada = saneada.length > longitudMaximaRespuesta
        ? '${saneada.substring(0, longitudMaximaRespuesta - 1)}…'
        : saneada;
    return RevisionAceptada(truncada);
  }

  /// Mensaje cariñoso (en castellano, voz neutra para Sora) para que
  /// la UI lo muestre al niño cuando rechazamos. No acusatorio: el
  /// tutor "no sabe responder a eso", no "has hecho algo mal".
  String mensajeAmableParaMotivo(MotivoRechazo motivo) {
    switch (motivo) {
      case MotivoRechazo.vacio:
        return 'Cuéntame qué te ha trabado, con tus palabras.';
      case MotivoRechazo.demasiadoLargo:
        return 'Hazlo más corto, con lo justo.';
      case MotivoRechazo.contieneEmail:
      case MotivoRechazo.contieneTelefono:
      case MotivoRechazo.contieneUrl:
        return 'No me cuentes datos personales — solo de matemáticas.';
      case MotivoRechazo.posibleInyeccionPrompt:
      case MotivoRechazo.fueraDeAlcance:
        return 'De eso no sé. Pregúntame del Fragmento que tienes delante.';
    }
  }
}
