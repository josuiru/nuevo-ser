// Modelo POJO de una pieza del corpus de El Descifrador.
//
// Estructura derivada de `el-descifrador-10-pedagogia-del-documento.md`
// §4 ("Estructura física de una pieza del corpus"). Inmutable — las
// piezas no se modifican en runtime; el niño anota encima pero la pieza
// original queda intacta.
//
// Las piezas del corpus se cargan al inicio del juego desde
// `assets/corpus/piezas/*.json` por el `CargadorCorpus`.

import 'decision_documento.dart';
import 'habilidad_atomica.dart';
import 'lengua.dart';
import 'operacion_descifrador.dart';
import 'voz_remitente.dart';

/// Una pieza del corpus: carta, panfleto, receta, etiqueta, lista,
/// recorte, cartel, copia de canción.
class PiezaCorpus {
  PiezaCorpus({
    required this.id,
    required this.tipo,
    required this.remitenteRecurrente,
    required this.remitenteTextoLibre,
    required this.destinatario,
    required this.lenguaPrincipal,
    required this.lenguasInfiltradas,
    required this.ocasion,
    required this.habilidadesAtomicas,
    required this.operacionCentral,
    required this.dificultad,
    required this.decisionesValidas,
    required this.soporte,
    required this.crucesConCorpus,
    required this.textoDocumento,
    required this.estadoValidacion,
    this.glosario = const {},
  });

  /// ID único en snake-kebab-case (ej: "carta-ines-bacalao-001").
  final String id;

  /// Tipo de pieza: carta, nota, etiqueta, panfleto, etc.
  final TipoPieza tipo;

  /// Si el remitente es uno de los ocho recurrentes, el enum corresponde.
  /// Si es voz puntual no recurrente, queda null y se usa
  /// `remitenteTextoLibre`.
  final VozRemitente? remitenteRecurrente;

  /// Descripción textual del remitente. Para remitentes recurrentes es
  /// redundante (su voz declarada está en `remitenteRecurrente`).
  /// Para remitentes puntuales es el único marcador (ej. "vecino
  /// anónimo del muelle", "músico de Bilbao").
  final String remitenteTextoLibre;

  /// A quién va dirigida la pieza. Puede ser un personaje recurrente,
  /// el aprendiz, "a quien encuentre esto", la ciudad entera, etc.
  /// Se mantiene como texto libre porque hay variedad amplia.
  final String destinatario;

  /// Lengua principal del documento.
  final Lengua lenguaPrincipal;

  /// Lenguas que aparecen infiltradas en el documento. Vacío si no hay.
  final List<Lengua> lenguasInfiltradas;

  /// Qué pasa en la vida del remitente que motiva la pieza. Sin esto
  /// la pieza es genérica y falla la regla 1.1 del doc 10.
  final String ocasion;

  /// Habilidades atómicas del mapa que la pieza ejercita. Entre 3 y 6
  /// según regla 1.3.
  final Set<HabilidadAtomica> habilidadesAtomicas;

  /// La operación central que la pieza ejercita.
  final OperacionDescifrador operacionCentral;

  /// Nivel de dificultad declarado de 1 a 5, opaco al niño. El motor
  /// de selección lo usa para calibrar qué llega a la mesa.
  final int dificultad;

  /// Decisiones válidas para esta pieza. No todas las cinco aplican
  /// a toda pieza (un cartel callejero no se devuelve al remitente
  /// porque es público).
  final Set<DecisionDocumento> decisionesValidas;

  /// Descripción del soporte físico (papel, tinta, sello, manchas).
  /// El ilustrador trabaja sobre este texto.
  final SoporteFisico soporte;

  /// IDs de otras piezas del corpus con las que esta cruza. Permite
  /// al motor detectar uniones de fragmentos y consecuencias narrativas.
  final List<String> crucesConCorpus;

  /// Texto literal del documento. Puede contener marcas tipográficas
  /// ligeras (`*cursiva*`, `**negrita**`).
  final String textoDocumento;

  /// Estado de validación editorial de la pieza. Bloquea su inclusión
  /// al corpus v1.0 hasta que no esté en `validadaParaProduccion`.
  final EstadoValidacion estadoValidacion;

  /// Equivalencias en castellano para palabras concretas (normalizadas).
  /// Sostiene la pista de traducción del maestro (mecánica nuclear §3.5).
  /// Mapa palabra-normalizada → traducción. Vacío si la pieza no tiene
  /// glosario aún (caso típico: piezas en castellano, donde no hace falta).
  final Map<String, String> glosario;

  /// True si la pieza ha pasado validación lingüística y editorial
  /// firmada y puede servirse al niño en producción.
  bool get listaParaProduccion =>
      estadoValidacion == EstadoValidacion.validadaParaProduccion;

  /// Construye desde Map<String, dynamic> tal y como viene del JSON.
  /// Lanza FormatException si faltan campos críticos o si los valores
  /// no parsean — el corpus viene del propio repo, debe reventar al
  /// arrancar si está roto.
  factory PiezaCorpus.desdeMapa(Map<String, dynamic> mapa) {
    String campo(String nombre) {
      final valor = mapa[nombre];
      if (valor is! String || valor.isEmpty) {
        throw FormatException(
          'Pieza del corpus mal formada: falta o vacío "$nombre"',
        );
      }
      return valor;
    }

    List<String> listaStrings(String nombre) {
      final valor = mapa[nombre];
      if (valor == null) return const [];
      if (valor is! List) {
        throw FormatException(
          'Pieza del corpus mal formada: "$nombre" debe ser lista',
        );
      }
      return valor.cast<String>();
    }

    final identificadorRemitente = campo('remitente');
    final tipoTexto = campo('tipo');

    return PiezaCorpus(
      id: campo('id'),
      tipo: TipoPieza.desdeIdentificador(tipoTexto),
      remitenteRecurrente: VozRemitente.desdeIdentificador(
        identificadorRemitente,
      ),
      remitenteTextoLibre: identificadorRemitente,
      destinatario: campo('destinatario'),
      lenguaPrincipal: Lengua.desdeCodigo(campo('lengua_principal')),
      lenguasInfiltradas: listaStrings('lenguas_infiltradas')
          .map(Lengua.desdeCodigo)
          .toList(),
      ocasion: campo('ocasion'),
      habilidadesAtomicas: listaStrings('habilidades_atomicas')
          .map(HabilidadAtomica.desdeIdentificador)
          .toSet(),
      operacionCentral: OperacionDescifrador.desdeIdentificador(
        campo('operacion_central'),
      ),
      dificultad: _parsearDificultad(mapa['dificultad']),
      decisionesValidas: listaStrings('decisiones_validas')
          .map(DecisionDocumento.desdeIdentificador)
          .toSet(),
      soporte: SoporteFisico.desdeMapa(
        mapa['soporte'] as Map<String, dynamic>? ?? const {},
      ),
      crucesConCorpus: listaStrings('cruces_con_corpus'),
      textoDocumento: campo('texto_documento'),
      estadoValidacion: EstadoValidacion.desdeIdentificador(
        (mapa['estado_validacion'] as String?) ?? 'borrador',
      ),
      glosario: _parsearGlosario(mapa['glosario']),
    );
  }

  static Map<String, String> _parsearGlosario(dynamic valor) {
    if (valor == null) return const {};
    if (valor is! Map) {
      throw FormatException(
        'Pieza del corpus mal formada: "glosario" debe ser objeto',
      );
    }
    final resultado = <String, String>{};
    for (final entrada in valor.entries) {
      final clave = entrada.key;
      final traduccion = entrada.value;
      if (clave is String && traduccion is String) {
        resultado[clave.toLowerCase().trim()] = traduccion;
      }
    }
    return Map.unmodifiable(resultado);
  }

  static int _parsearDificultad(dynamic valor) {
    if (valor is int && valor >= 1 && valor <= 5) return valor;
    throw FormatException(
      'Pieza del corpus mal formada: "dificultad" debe ser entero 1-5, '
      'recibido "$valor"',
    );
  }
}

/// Tipos de pieza que admite el corpus.
enum TipoPieza {
  carta('carta'),
  notaBreve('nota_breve'),
  cartaFamiliar('carta_familiar'),
  cartaMarina('carta_marina'),
  etiqueta('etiqueta'),
  etiquetaComercial('etiqueta_comercial'),
  panfleto('panfleto'),
  cartel('cartel'),
  copiaDeCancion('copia_de_cancion'),
  receta('receta'),
  recibo('recibo'),
  listaInventario('lista_inventario'),
  recortePeriodico('recorte_periodico');

  const TipoPieza(this.identificadorTecnico);

  final String identificadorTecnico;

  static TipoPieza desdeIdentificador(String identificador) {
    for (final tipo in TipoPieza.values) {
      if (tipo.identificadorTecnico == identificador) return tipo;
    }
    throw ArgumentError('Tipo de pieza desconocido: "$identificador"');
  }
}

/// Descripción del soporte físico de la pieza. El ilustrador trabaja
/// sobre este texto para componer la pieza visualmente.
class SoporteFisico {
  const SoporteFisico({
    required this.tipo,
    required this.papel,
    required this.tinta,
    required this.rasgosVisuales,
  });

  /// Tipo de soporte (carta manuscrita, etiqueta impresa, cartel pegado…).
  final String tipo;

  /// Descripción del papel (color, calidad, edad).
  final String papel;

  /// Descripción de la tinta.
  final String tinta;

  /// Rasgos visuales puntuales (manchas, sellos, dobleces, firmas).
  final List<String> rasgosVisuales;

  factory SoporteFisico.desdeMapa(Map<String, dynamic> mapa) {
    return SoporteFisico(
      tipo: mapa['tipo'] as String? ?? 'sin especificar',
      papel: mapa['papel'] as String? ?? 'sin especificar',
      tinta: mapa['tinta'] as String? ?? 'sin especificar',
      rasgosVisuales: (mapa['rasgos_visuales'] as List?)?.cast<String>() ??
          const [],
    );
  }
}

/// Estado de validación editorial de una pieza.
///
/// Una pieza solo se sirve al niño en producción cuando llega a
/// `validadaParaProduccion`. Los demás estados existen para que
/// asesores, autor responsable y equipo editorial sepan qué falta.
enum EstadoValidacion {
  /// Borrador escrito por humano o asistido por IA. Falta toda
  /// validación.
  borrador('borrador'),

  /// Borrador producido por Claude como asistencia editorial el
  /// 2026-05-13. Pendiente de revisión humana profunda y de validación
  /// lingüística.
  borradorClaudePendienteHumano('borrador_claude_2026_05_13_pendiente_humano'),

  /// Validada lingüísticamente por asesor firmado. Falta validación
  /// editorial del autor responsable.
  validadaLinguisticamente('validada_linguisticamente'),

  /// Validada editorialmente por autor responsable tras validación
  /// lingüística previa.
  validadaEditorialmente('validada_editorialmente'),

  /// Lista para producción. Sirve al niño en v1.0.
  validadaParaProduccion('validada_para_produccion');

  const EstadoValidacion(this.identificadorTecnico);

  final String identificadorTecnico;

  static EstadoValidacion desdeIdentificador(String identificador) {
    for (final estado in EstadoValidacion.values) {
      if (estado.identificadorTecnico == identificador) return estado;
    }
    throw ArgumentError(
      'Estado de validación desconocido: "$identificador"',
    );
  }
}
