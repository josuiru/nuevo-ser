import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import 'ambiente_archivo.dart';
import 'voz_personaje.dart';

/// Catálogo de escenas cinemáticas del Arco 3 — *La forja del reino*
/// (doc 09). Cubre el periodo Aprendiz II → Aprendiz III, ~12-14
/// semanas de curso (marzo-mayo).
///
/// Estado: primera tanda implementada (F2-20a). Cubre la apertura
/// del Arco 3 (3.0.1 *Apertura del arco* + 3.0.2 *Eider y la
/// distancia*), la Estación 1 completa (3.1.1–3.1.5 *San Cernin*) y
/// la cinemática latente post-Estación 1 (3.A.1 *Marina y los
/// puentes*). Las restantes 5 Estaciones (3.2 Tudela y los Banu
/// Qasi, 3.3 Leyre y la leyenda del abad Virila, 3.4 Roncesvalles,
/// 3.5 Estella en su esplendor, 3.6 La Brecha del incendio de la
/// judería de Tudela de 1378) + las latentes 3.B.1/3.C.1/3.D.1 +
/// el cierre 3.Z + la ficha M3 quedan pendientes.
///
/// **TUDELA-1378** (Brecha 3.6) está marcada como **pendiente de
/// validación** del comité provisional según el README de
/// `coleccion-nuevo-ser-paquete-documental-v0.3` — es la más
/// sensible de las cinco validaciones críticas. Su implementación
/// no se aborda hasta que esa validación cierre.
///
/// El Arco 3 introduce el manejo de fuentes plurilingües (latín +
/// romance navarro + occitano gascón en San Cernin; árabe en Tudela)
/// y el primer encuentro narrativo con Tasio en la Estación 3.2 —
/// arco más cargado del MVP según anuncia el cabecero del doc 09.
class EscenasArco3 {
  EscenasArco3._();

  /// Lista ordenada de escenas del Arco 3 disponibles para el
  /// orquestador. La 3.0.1 requiere `arco_2_cerrado_por_la_cronista`
  /// (que la 2.Z.2 *La grabación* del Arco 2 activa). La 3.A.1 se
  /// ordena detrás de 3.1.5 porque requiere
  /// `arco_3_estacion_1_cerrada` (que la 3.1.5 activa). La Estación
  /// 3.2 arranca con 3.2.1 que requiere `escena_3_a_1_vista` (la
  /// latente de Marina cierra antes del viaje a Tudela). La 3.B.1
  /// se ordena detrás de 3.2.8 porque requiere
  /// `arco_3_estacion_2_cerrada` (que la 3.2.8 activa).
  static const List<EscenaCinematica> todas = [
    aperturaDelArco,
    eiderYLaDistancia,
    sanCernin,
    tresLenguas,
    elBarrioOccitano,
    concilioSanCernin,
    irunaCosmopolita,
    marinaYLosPuentes,
    caminoATudela,
    tudelaYLosBanuQasi,
    lasFuentesArabes,
    laCafeteria,
    elEncuentroConTasio,
    vueltaAlTrabajo,
    reconstruccionYConcilioBanuQasi,
    elSilencioDeMaren,
    teTratoBien,
    caminoALeyre,
    elMonasterio,
    laLeyendaDeVirila,
    cuandoSeEscribio,
    concilioLeyre,
    laLeyendaNoMienteDesplaza,
    naiaPreguntaOtraVez,
    caminoARoncesvalles,
    elPaso,
    lasDosVersiones,
    laChanson,
    reconstruccionRoncesvalles,
    concilioRoncesvalles,
    loBonitoMiente,
    eiderSeVa,
    llegadaAEstella,
    mesaYReconstruccionEstella,
    concilioEstella,
    calleRuaAlAnochecer,
    isauraPresenta,
    lasFuentesDe1378,
    viajeATudela,
    elBarrioJuderia,
    conversacionConKarim,
    laCuartaAfirmacion,
    reconstruccionFinal,
    elConcilioDelIncendio,
    tasioAlSalir,
    elSilencioSegundo,
    entregaDelMosaicoM3,
    aprendizIII,
  ];

  /// Flags institucionales adicionales que el orquestador activa al
  /// cerrar una escena del Arco 3. Mismo patrón que en Arcos 1 y 2.
  static const Map<String, Set<String>> flagsDeCierrePorEscena = {
    'escena_3_0_1_vista': {
      'arco_3_iniciado',
      'tudela_1378_anunciada',
    },
    'escena_3_0_2_vista': {
      'eider_distancia_3_0_2_vista',
    },
    'escena_3_1_1_vista': {
      'san_cernin_visitado',
      'tres_burgos_aprendidos',
    },
    'escena_3_1_2_vista': {
      'tres_lenguas_trabajadas',
    },
    'escena_3_1_3_vista': {
      'toponimos_occitanos_aprendidos',
    },
    'escena_3_1_4_vista': {
      'concilio_3_1_cerrado',
    },
    'escena_3_1_5_vista': {
      'arco_3_estacion_1_cerrada',
    },
    'escena_3_a_1_vista': {
      'consejo_marina_puentes_recibido',
    },
    'escena_3_2_1_vista': {
      'aviso_aitor_tasio_recibido',
      'viaje_a_tudela_iniciado',
    },
    'escena_3_2_2_vista': {
      'mezquita_catedral_visitada',
    },
    'escena_3_2_3_vista': {
      'fuentes_arabes_estudiadas',
    },
    'escena_3_2_4_vista': {
      'cafeteria_tudela_alcanzada',
    },
    'escena_3_2_5_vista': {
      'met_tasio',
      'tasio_first_encounter',
    },
    'escena_3_2_6_vista': {
      'reconstruccion_banu_qasi_iniciada',
    },
    'escena_3_2_7_vista': {
      'concilio_3_2_cerrado',
    },
    'escena_3_2_8_vista': {
      'arco_3_estacion_2_cerrada',
    },
    'escena_3_b_1_vista': {
      'isaura_supo_de_tasio',
    },
    'escena_3_3_1_vista': {
      'leyenda_virila_oida',
      'viaje_a_leyre_iniciado',
    },
    'escena_3_3_2_vista': {
      'monasterio_leyre_visitado',
    },
    'escena_3_3_3_vista': {
      'leyenda_virila_documentada_aprendida',
    },
    'escena_3_3_4_vista': {
      'leyenda_virila_estudiada',
    },
    'escena_3_3_5_vista': {
      'concilio_3_3_cerrado',
    },
    'escena_3_3_6_vista': {
      'arco_3_estacion_3_cerrada',
    },
    'escena_3_c_1_vista': {
      'naia_pregunto_oficio',
    },
    'escena_3_4_1_vista': {
      'aviso_chanson_recibido',
      'viaje_a_roncesvalles_iniciado',
    },
    'escena_3_4_2_vista': {
      'paso_roncesvalles_alcanzado',
    },
    'escena_3_4_3_vista': {
      'dos_versiones_estudiadas',
    },
    'escena_3_4_4_vista': {
      'chanson_como_propaganda_aprendida',
    },
    'escena_3_4_5_vista': {
      'reconstruccion_roncesvalles_producida',
    },
    'escena_3_4_6_vista': {
      'concilio_3_4_cerrado',
    },
    'escena_3_4_7_vista': {
      'arco_3_estacion_4_cerrada',
    },
    'escena_3_d_1_vista': {
      'eider_se_va',
    },
    'escena_3_5_1_vista': {
      'estella_conjunto_visitado',
      'viaje_a_estella_iniciado',
    },
    'escena_3_5_2_vista': {
      'reconstruccion_estella_producida',
    },
    'escena_3_5_3_vista': {
      'concilio_3_5_cerrado',
    },
    'escena_3_5_4_vista': {
      'arco_3_estacion_5_cerrada',
    },
    'escena_3_6_1_vista': {
      'isaura_presenta_brecha_1378',
      'carpeta_1378_recibida',
    },
    'escena_3_6_2_vista': {
      'fuentes_1378_estudiadas',
    },
    'escena_3_6_3_vista': {
      'viaje_tudela_juderia_iniciado',
    },
    'escena_3_6_4_vista': {
      'juderia_tudela_visitada',
    },
    'escena_3_6_5_vista': {
      'karim_afirmacion_silencio_validada',
    },
    'escena_3_6_6_vista': {
      'silencio_tres_semanas_documentado',
    },
    'escena_3_6_7_vista': {
      'reconstruccion_1378_producida',
    },
    'escena_3_6_8_vista': {
      'concilio_3_6_cerrado',
      'aprendiz_iii_anunciado',
      'met_tasio_concilio',
    },
    'escena_3_6_9_vista': {
      'tasio_afirmacion_cuatro_validada',
      'tasio_cuando_te_gradues',
    },
    'escena_3_6_10_vista': {
      'arco_3_estacion_6_cerrada',
      'maren_silencio_segundo_escrito',
    },
    'escena_m_3_entrega_vista': {
      'mosaico_arco_3_validado_por_andres',
    },
    'escena_3_z_vista': {
      'arco_3_cerrado_por_la_cronista',
      'aprendiz_iii_consagrado',
    },
  };

  /// 3.0.1 — *Apertura del arco*. Despacho de Isaura, primer día
  /// tras el descanso entre Arcos 2 y 3 (finales de febrero /
  /// principios de marzo). Isaura anuncia el calendario del arco
  /// (San Cernin → Tudela → Leyre → Roncesvalles → Estella) y, en el
  /// momento clave de la cinemática, le anticipa a Maren la Brecha
  /// del incendio de la judería de Tudela de 1378 — la que rompió
  /// la relación entre Tasio e Isaura. Le explica el porqué de
  /// elegirla a ella: porque es la persona del Archivo que puede
  /// llegar a una versión nueva sin estar atrapada en la suya o en
  /// la de Tasio. Doc 09 §3.0.1.
  static const EscenaCinematica aperturaDelArco = EscenaCinematica(
    id: '3.0.1',
    titulo: 'Apertura del arco',
    flagDeSalida: 'escena_3_0_1_vista',
    flagsRequeridos: {'arco_2_cerrado_por_la_cronista'},
    ambiente: AmbienteArchivo.despachoIsaura,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren entra al despacho. Isaura está terminando de '
            'revisar carpetas de varias Brechas pendientes.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Aprendiz II.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Bien.'),
      PlanoAmbiente(
        duracion: Duration(milliseconds: 1500),
        textoLectura: 'Isaura cierra la carpeta.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Este arco son tres meses. Vas a viajar mucho.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿A dónde?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'San Cernin para empezar — está aquí mismo. Después '
            'Tudela. Leyre. Roncesvalles. Estella.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Tudela?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Tarde o temprano.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Maren no insiste.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Y al final del arco hay una Brecha que vas a tener que '
            'trabajar.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Cuál?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'La del incendio de la judería de Tudela de 1378.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Silencio largo. Maren mira a Isaura.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿La que rompió a Tasio contigo?',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Esa.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Vale.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Te lo digo ahora para que lo lleves contigo. No vas a '
            'trabajarla hasta el final del arco. Pero quiero que '
            'sepas que viene.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Por qué me tocas a mí?',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Porque ahora mismo eres la persona del Archivo que puede '
            'llegar a una versión nueva sin estar atrapada en la mía '
            'o en la suya.',
        pausaPrevia: Duration(milliseconds: 1800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No estoy segura de poder.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Yo tampoco lo estoy. Pero tienes tres meses para '
            'prepararte.',
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Esta semana San Cernin. Cosas más sencillas. Vamos a '
            'empezar suave.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren asiente. Sale del despacho. La cámara se queda '
            'con Isaura, que mira la carpeta de la Brecha de 1378 '
            'sobre la mesa. La abre. Ve dos páginas. La cierra. La '
            'guarda en el cajón donde tiene su cuaderno marrón.',
      ),
    ],
  );

  /// 3.0.2 — *Eider y la distancia*. Sábado tarde. Banco en la
  /// plaza del Castillo. Eider le dice a Maren que se va a perder
  /// su partido importante de baloncesto. Maren está fuera ese
  /// día (Tudela). Eider responde corta — *"Otra vez fuera"* — y se
  /// va sin despedirse del todo. Maren se queda sola con el refresco
  /// a medio tomar. Voz del Cuaderno breve. Doc 09 §3.0.2.
  static const EscenaCinematica eiderYLaDistancia = EscenaCinematica(
    id: '3.0.2',
    titulo: 'Eider y la distancia',
    flagDeSalida: 'escena_3_0_2_vista',
    flagsRequeridos: {'escena_3_0_1_vista'},
    ambiente: AmbienteArchivo.plazaCastilloIruna,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Sábado tarde. Las dos sentadas en un banco con un '
            'refresco. Eider tiene que irse pronto al baloncesto.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: 'Tía. Te vas a perder mi partido importante.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Cuándo?'),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: 'El 12. Final de la liga juvenil.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Joder. Estoy fuera el 12. Tudela.',
      ),
      PlanoDialogo(voz: VozPersonaje.eider, texto: 'Otra vez fuera.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: 'Bueno.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Eider mira el reloj.',
      ),
      PlanoDialogo(voz: VozPersonaje.eider, texto: 'Me tengo que ir.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: '¿Sabes qué? Da igual.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No da igual.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: 'No me lo digas para que me sienta mejor.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren no contesta. Eider se va. Maren se queda sentada '
            'con el refresco a medio tomar.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Eider está enfadada. Tiene razón.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'No sé qué hacer.',
      ),
    ],
  );

  /// 3.1.1 — *San Cernin*. Iglesia de San Saturnino (San Cernin) en
  /// Iruña, plaza Consistorial cercana. Isaura le explica a Maren
  /// que la iglesia la fundaron los francos del Camino, y que el
  /// santo titular procede de Tolosa de Francia (Saturnino → Sernin
  /// → Cernin). Le presenta el modelo de los tres burgos medievales
  /// de Pamplona: Navarrería (vasco-romance), San Cernin (francos
  /// occitano-hablantes del Camino), San Nicolás (burgueses
  /// comerciantes). Cada uno con sus propios fueros, murallas y
  /// enemistades. Doc 09 §3.1.1.
  ///
  /// Material trazable: iglesia de San Saturnino real en Pamplona,
  /// fundación franca documentada, modelo de los tres burgos
  /// medievales con sus murallas separadas y conflictos resueltos
  /// por el Privilegio de la Unión de 1423.
  static const EscenaCinematica sanCernin = EscenaCinematica(
    id: '3.1.1',
    titulo: 'San Cernin',
    flagDeSalida: 'escena_3_1_1_vista',
    flagsRequeridos: {'escena_3_0_2_vista'},
    ambiente: AmbienteArchivo.iglesiaSanCernin,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren e Isaura caminan por el casco viejo de Iruña. '
            'Llegan a la iglesia de San Cernin. Iglesia gótica con '
            'dos torres asimétricas. Plaza pequeña delante.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Ésta es la iglesia. La fundaron los francos del Camino. '
            'Fíjate en el nombre.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'San Cernin. ¿De dónde es ese santo?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Tolosa de Francia. Saturnino, Sernin, Cernin — la misma '
            'palabra en distintas pronunciaciones.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Entonces la iglesia se llama como un santo francés.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Sí. Y el barrio entero, durante siglos, fue de gente que '
            'venía de fuera. Francos. Hablaban occitano gascón '
            'mayoritariamente. Tenían sus propios fueros, su propia '
            'administración. Iruña fue durante doscientos años tres '
            'ciudades en una.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Tres?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Navarrería — la antigua, vasco-romance. San Cernin — los '
            'francos del Camino. San Nicolás — los burgueses '
            'comerciantes que vinieron después. Cada una con sus '
            'murallas, sus fueros, sus enemistades.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Maren mira las torres asimétricas. Diferentes alturas.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Parece que cada una se hizo en una época distinta.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Lo está. Tu Brecha es esto.',
      ),
    ],
  );

  /// 3.1.2 — *Tres lenguas*. Mesa de Trabajo del Archivo. Maren
  /// trabaja con tres tipos de documentos plurilingües del Iruña
  /// medieval del s. XII-XIII: el Fuero de Pamplona-San Cernin
  /// (1129) en latín jurídico, una carta de queja del concejo de la
  /// Navarrería al rey Sancho VI en romance navarro (s. XII), y un
  /// fragmento de regla interna de los burgueses de San Cernin en
  /// occitano gascón (s. XIII). HF.07 (lectura en lengua original)
  /// extendida a tres lenguas. Doc 09 §3.1.2.
  ///
  /// Las afirmaciones que la Cronista produce (no jugables todavía
  /// — la Brecha 3.1 jugable llegará en un slice posterior; este
  /// slice cubre sólo la cinemática narrativa): plurilingüismo
  /// estructural del Iruña medieval (Probable, basado en evidencia
  /// indirecta para el uso oral cotidiano del euskera bajo el
  /// trilingüismo escrito), conflictos entre los tres burgos
  /// duraron casi dos siglos resueltos por el Privilegio de la
  /// Unión de 1423 (Sólido). Material trazable.
  static const EscenaCinematica tresLenguas = EscenaCinematica(
    id: '3.1.2',
    titulo: 'Tres lenguas',
    flagDeSalida: 'escena_3_1_2_vista',
    flagsRequeridos: {'escena_3_1_1_vista'},
    ambiente: AmbienteArchivo.mesaTrabajoArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Mesa de Trabajo del Archivo. Días siguientes. Maren con '
            'tres tipos de documentos delante: latín jurídico, romance '
            'navarro y occitano gascón.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            '1. Latín — el Fuero de Pamplona-San Cernin (1129), '
            'redactado en latín jurídico medieval.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            '2. Romance navarro — una carta de queja del concejo de '
            'la Navarrería al rey Sancho VI, del s. XII.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            '3. Occitano gascón — un fragmento de regla interna de '
            'los burgueses de San Cernin, del s. XIII.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'La interfaz le permite leer cada uno con apoyo del tutor. '
            'Las tres lenguas tienen aire familiar — comparten raíz '
            'romance — pero divergen en ortografía, vocabulario, '
            'sintaxis.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Tres lenguas para tres comunidades en la misma ciudad.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Esto es muy distinto de lo que yo pensaba que era una '
            'ciudad medieval. Yo pensaba que había una iglesia, un '
            'señor, un castillo, gente que servía. Pero aquí había '
            'tres comunidades distintas con sus propios fueros, '
            'peleadas entre sí, y tres lenguas escritas a la vez.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: '¿Por qué no sabía esto?',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'La Cronista produce 7 afirmaciones. La más interesante: '
            'que los conflictos entre los tres burgos duraron casi '
            'dos siglos y se resolvieron sólo por el Privilegio de la '
            'Unión de 1423 — Sólido. Y que el plurilingüismo del '
            'Iruña medieval es estructural, no accidental — Probable.',
      ),
    ],
  );

  /// 3.1.3 — *El barrio occitano*. Paseo por la calle de la
  /// Navarrería y zonas adyacentes. Isaura le señala a Maren las
  /// huellas occitanas en el callejero del casco viejo (*"Calle
  /// Mayor"* viene de *"Carrera Maior"* occitana, no del castellano).
  /// Maren pregunta por los topónimos vascos: Isaura le explica que
  /// el sustrato vasco se conservó en muchos nombres de barrios y
  /// montes pero no se escribió formalmente — los oficios institu-
  /// cionales del medievo eran en latín, romance y occitano; el
  /// euskera quedó como lengua del paisaje en glosas y formas
  /// castellanizadas. Maren conecta: *"Eso es Wamba otra vez."*
  /// Doc 09 §3.1.3.
  static const EscenaCinematica elBarrioOccitano = EscenaCinematica(
    id: '3.1.3',
    titulo: 'El barrio occitano',
    flagDeSalida: 'escena_3_1_3_vista',
    flagsRequeridos: {'escena_3_1_2_vista'},
    ambiente: AmbienteArchivo.calleNavarreria,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Caminan por el casco viejo. Isaura le va señalando '
            'placas, edificios, calles cuyos nombres tienen origen '
            'distinto.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Calle Mayor. Esa palabra es occitana, no castellana. '
            'Carrera Maior.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Y los topónimos vascos?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Sustrato. Muchos nombres de barrios y montes. Los oficios '
            'formales del medievo eran en latín, en romance, en '
            'occitano. Los nombres del paisaje siguieron siendo en '
            'euskera para mucha gente — pero no se escribieron salvo '
            'en glosas o en formas castellanizadas.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Eso es Wamba otra vez.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Una versión menos brutal pero estructural igual.',
      ),
    ],
  );

  /// 3.1.4 — *Concilio* de la Estación 3.1. Salón del Concilio.
  /// Aitor revisor + Karim. La Cronista presenta su reconstrucción.
  /// Aitor le hace preguntas técnicas. Karim le hace la pregunta
  /// pedagógica clave: por qué declaró Probable y no Sólido el
  /// plurilingüismo estructural del Iruña medieval. Maren responde
  /// articulando la diferencia metodológica — la documentación
  /// trilingüe es Sólida, pero la inferencia sobre la presencia
  /// hablada del euskera bajo todo se basa en evidencia indirecta
  /// (toponimia, glosas, menciones en otras fuentes); declararla
  /// Sólido sería afirmar como hecho lo que es altísimamente
  /// probable pero no documentado en uso oral cotidiano. Doc 09
  /// §3.1.4.
  static const EscenaCinematica concilioSanCernin = EscenaCinematica(
    id: '3.1.4',
    titulo: 'Concilio de San Cernin',
    flagDeSalida: 'escena_3_1_4_vista',
    // F2-28a: la Brecha 3.1 jugable se interpone entre la cinemática
    // 3.1.3 *El barrio occitano* y este Concilio formal — el doc 09
    // distingue dos Concilios distintos (la Mesa de Trabajo donde
    // Maren produce sus 7 afirmaciones jugables y el Concilio formal
    // con Aitor + Karim que revisa la reconstrucción ya producida).
    // Cambia la precondición de `escena_3_1_3_vista` a
    // `brecha_3_1_completada` para preservar esa separación.
    flagsRequeridos: {'brecha_3_1_completada'},
    ambiente: AmbienteArchivo.salonConcilio,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Salón del Concilio. Aitor (revisor) y Karim a la mesa. '
            'La Cronista presenta su reconstrucción. Aitor le hace '
            'preguntas técnicas sobre las fuentes.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Has declarado Probable que el plurilingüismo de Iruña '
            'medieval es estructural, no accidental. ¿Por qué Probable '
            'y no Sólido?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Porque la documentación trilingüe es Sólida, pero la '
            'inferencia sobre la presencia hablada del euskera bajo '
            'todo se basa en evidencia indirecta — toponimia, glosas, '
            'menciones en otras fuentes. Si declaro Sólido el '
            'plurilingüismo estructural, estoy afirmando como hecho lo '
            'que es altísimamente probable pero no documentado en su '
            'uso oral cotidiano.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(voz: VozPersonaje.karim, texto: 'Bien.'),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: 'Sellada.'),
    ],
  );

  /// 3.1.5 — *Iruña cosmopolita*. Esa noche, voz del Cuaderno.
  /// Cierre de la Estación 3.1 con la lección integradora — Iruña
  /// como tres ciudades superpuestas históricamente (Navarrería /
  /// San Cernin / San Nicolás en romance / occitano / latín
  /// jurídico, con el euskera del paisaje siempre debajo) y
  /// contemporáneamente (la que pisa Antonio en castellano, la que
  /// pisa Eider en euskera, la que pisan juntas Maren y Eider sin
  /// pensarlo). Doc 09 §3.1.5.
  static const EscenaCinematica irunaCosmopolita = EscenaCinematica(
    id: '3.1.5',
    titulo: 'Iruña cosmopolita',
    flagDeSalida: 'escena_3_1_5_vista',
    flagsRequeridos: {'escena_3_1_4_vista'},
    ambiente: AmbienteArchivo.cuartoCasaMaren,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Es de noche. Maren en su mesa, cuaderno abierto.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Iruña ha sido siempre tres ciudades, no una. La que pisa '
            'mi padre en castellano. La que pisa Eider en euskera. La '
            'que pisamos juntas las dos sin pensar.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Y antes había otra trinidad: Navarrería, San Cernin, San '
            'Nicolás. En romance, en occitano, en latín jurídico. Y '
            'debajo, siempre, el euskera del paisaje.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Esto cambia algo de cómo veo la calle Mayor cuando la '
            'cruzo.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
    ],
  );

  /// 3.A.1 — *Marina y los puentes*. Latente post-Estación 3.1.
  /// ~10 días después. Cocina del Archivo. Marina entra mientras
  /// Maren se hace un café. Le ofrece su consejo de hermana mayor
  /// para futuras Brechas plurilingües: *"no las trates como
  /// traducciones unas de otras. Cada lengua es un puente al
  /// pensamiento de quien la hablaba. Y el puente tiene su propia
  /// geografía."* Maren conecta el consejo con la lección de
  /// Quintiliano (Estación 2.2). Marina sonríe y apunta el patrón:
  /// *"las cosas que enseñan las hermanas mayores son las que ya se
  /// te están formando."* Doc 09 §3.A.1.
  static const EscenaCinematica marinaYLosPuentes = EscenaCinematica(
    id: '3.A.1',
    titulo: 'Marina y los puentes',
    flagDeSalida: 'escena_3_a_1_vista',
    flagsRequeridos: {'arco_3_estacion_1_cerrada'},
    ambiente: AmbienteArchivo.cocinaArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Maren se hace un café. Marina entra.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto: '¿Qué tal San Cernin?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Tres lenguas. Difícil pero bonito.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto: 'Mi consejo de hermana mayor.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto:
            'Cuando trabajes Brechas con varias lenguas, no las trates '
            'como traducciones unas de otras. Cada lengua es un puente '
            'al pensamiento de quien la hablaba. Y el puente tiene su '
            'propia geografía.',
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto:
            'Si traduces sin tener en cuenta la geografía del puente, '
            'te pierdes lo importante.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Eso es como Quintiliano.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(voz: VozPersonaje.marina, texto: 'Exacto.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Pasa mucho contigo, Marina. Dices algo y yo encuentro un '
            'eco con algo que ya pasó.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto:
            'Eso es porque las cosas que enseñan las hermanas mayores '
            'son las que ya se te están formando.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Marina sale.',
      ),
    ],
  );

  /// 3.2.1 — *Camino a Tudela*. Mediados de marzo. Aitor lleva a
  /// Maren a Tudela en su C4 (Isaura tiene tribunal ese día). Hora
  /// y media de viaje. Aitor le avisa explícitamente: *"Tasio está
  /// en Tudela. Es probable que te encuentre. Esto no es
  /// coincidencia accidental — él sabe que tú vas a venir aquí esta
  /// semana. Lo sabe porque alguien del Archivo se lo dice por
  /// costumbre."* Karim como informante honesto. Aitor declina ser
  /// mentor de la situación (*"yo no soy tu mentor en esto"*) pero
  /// le da el consejo metodológico clave: *"si hablas con él, no te
  /// tienes que defender. No te está atacando. Pero tampoco te está
  /// cuidando. Está examinándote. No hay nada malo en dejarse
  /// examinar — pero tienes que saber qué le enseñas tú."* Doc 09
  /// §3.2.1.
  static const EscenaCinematica caminoATudela = EscenaCinematica(
    id: '3.2.1',
    titulo: 'Camino a Tudela',
    flagDeSalida: 'escena_3_2_1_vista',
    flagsRequeridos: {'escena_3_a_1_vista'},
    ambiente: AmbienteArchivo.cocheAitor,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Aitor conduce un C4 más nuevo que el de Isaura. Maren '
            'va de copiloto. Hora y media de viaje hasta la Ribera.',
      ),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: 'Te aviso de algo.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Tasio está en Tudela. Lo sabes.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Lo sabía.'),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Es probable que te encuentre. Esto no es coincidencia '
            'accidental — él sabe que tú vas a venir aquí esta '
            'semana. Lo sabe porque alguien del Archivo se lo dice '
            'por costumbre.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Quién?'),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Karim. Pero Karim es honesto y te lo diría a la cara si '
            'se lo preguntas.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Tasio va a aparecer?',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Probable. Sólido tirando a Probable.',
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Qué hago?'),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Lo que decidas.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Eso no es respuesta.'),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Es la única que tengo. Yo no soy tu mentor en esto.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren mira el paisaje. La Ribera se abre — campos de '
            'regadío, el Ebro a lo lejos.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Pero te voy a decir una cosa.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Si hablas con él, no te tienes que defender. No te está '
            'atacando. Pero tampoco te está cuidando. Está '
            'examinándote. No hay nada malo en dejarse examinar — '
            'pero tienes que saber qué le enseñas tú.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Vale.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
    ],
  );

  /// 3.2.2 — *Tudela y los Banu Qasi*. Llegan a Tudela. Distinta al
  /// norte: calor más pronto en el año, ladrillo en lugar de piedra,
  /// casas con galería. Visitan la mezquita-catedral por fuera —
  /// edificio que es las dos cosas a la vez (mezquita aljama del s.
  /// IX al XII, catedral cristiana tras 1119). Capiteles que
  /// reutilizan piezas islámicas, inscripciones árabes parcialmente
  /// borradas en una sala lateral. Aitor le explica que la cuestión
  /// de qué se conservó y qué no es ya parte de su Brecha. Doc 09
  /// §3.2.2.
  ///
  /// Material trazable: Catedral de Santa María de Tudela real,
  /// construcción cristiana sobre la mezquita aljama tras la
  /// conquista de 1119, conservación parcial de elementos islámicos
  /// como hecho arqueológico documentado. BANU-QASI Prioridad 2 del
  /// comité provisional sin validar — registro en BLOQUEOS.
  static const EscenaCinematica tudelaYLosBanuQasi = EscenaCinematica(
    id: '3.2.2',
    titulo: 'Tudela y los Banu Qasi',
    flagDeSalida: 'escena_3_2_2_vista',
    flagsRequeridos: {'escena_3_2_1_vista'},
    ambiente: AmbienteArchivo.mezquitaCatedralTudela,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Tudela. Distinto al norte. Calor más pronto en el año. '
            'Ladrillo en lugar de piedra. Casas con galería. La '
            'mezquita-catedral por fuera — un edificio que es las dos '
            'cosas a la vez.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Esto fue mezquita aljama del s. IX al XII. Tras la '
            'conquista cristiana, catedral. Conserva elementos de las '
            'dos cosas dentro.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Entran. Las naves cristianas medievales tienen capiteles '
            'que reutilizan piezas islámicas. Inscripciones árabes '
            'parcialmente borradas en una sala lateral.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿La conservaron así a propósito?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'En parte sí, en parte no llegaron a destruir todo. La '
            'cuestión de qué se conservó y qué no es ya tu Brecha.',
      ),
    ],
  );

  /// 3.2.3 — *Las fuentes árabes*. Sala de trabajo cedida por el
  /// museo de Tudela con material árabe sobre los Banu Qasi. La
  /// conservadora del museo (sin nombre en el doc) le presenta el
  /// material: Ibn Hayyán *Muqtabis* (s. XI, fuente cordobesa
  /// hostil cuando los Banu Qasi se rebelan), Al-Razi (s. X,
  /// descripción geográfica de Tudela), crónica anónima del periodo,
  /// inscripciones árabes locales, *Crónica de Alfonso III* y otras
  /// cristianas que mencionan a los Banu Qasi como aliados o
  /// enemigos según conveniencia, material arqueológico (alcazaba,
  /// cerámica, monedas). Voz del Cuaderno articulando que los
  /// Banu Qasi eran muladíes — descendientes hispano-godos
  /// convertidos al islam — y que la pregunta moderna *"¿musulmanes
  /// o hispanos?"* presupone una dicotomía que en su época no
  /// funcionaba así. Doc 09 §3.2.3.
  static const EscenaCinematica lasFuentesArabes = EscenaCinematica(
    id: '3.2.3',
    titulo: 'Las fuentes árabes',
    flagDeSalida: 'escena_3_2_3_vista',
    flagsRequeridos: {'escena_3_2_2_vista'},
    ambiente: AmbienteArchivo.salaMuseoTudela,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Sala de trabajo cedida por el museo de Tudela. La '
            'conservadora le presenta el material a Maren. Las '
            'fuentes árabes principales para los Banu Qasi están '
            'sobre la mesa.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            '1. Ibn Hayyán (s. XI), Muqtabis — fuente cordobesa '
            'hostil a los Banu Qasi cuando se rebelan.\n'
            '2. Al-Razi (s. X) — descripción geográfica que '
            'menciona Tudela.\n'
            '3. Crónica anónima del periodo, fragmentos.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            '4. Inscripciones árabes locales conservadas, algunas '
            'datadas, otras no.\n'
            '5. Crónicas cristianas — la Crónica de Alfonso III y '
            'otras que mencionan a los Banu Qasi como aliados o '
            'enemigos según conveniencia.\n'
            '6. Material arqueológico — alcazaba, restos cerámicos, '
            'monedas.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren trabaja durante varias horas. La interfaz le '
            'permite leer fragmentos en árabe original con apoyo del '
            'tutor, comparar con versiones cristianas paralelas.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Los Banu Qasi son fascinantes. Eran muladíes — '
            'descendientes hispano-godos convertidos. Su nombre Qasi '
            'viene de Casio, el conde visigodo que se convirtió al '
            'islam tras la invasión.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Eran cristianos hace tres generaciones. Después fueron '
            'musulmanes plenos. Después se aliaron con vascones de '
            'Pamplona contra Córdoba. Después fueron derrotados por '
            'Córdoba y reabsorbidos.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'La cuestión de su identidad es difícil. ¿Eran '
            '"musulmanes pero hispanos"? ¿"Hispanos pero musulmanes"? '
            'Las dos cosas a la vez. La pregunta presupone una '
            'dicotomía que en su época no funcionaba así.',
      ),
    ],
  );

  /// 3.2.4 — *La cafetería*. 13:30, salen del museo. Aitor conoce
  /// un sitio en el casco viejo de Tudela: cafetería pequeña de
  /// cinco mesas y una barra. El dueño le saluda con la cabeza —
  /// Aitor es cliente habitual de otras visitas. Se sientan, piden,
  /// Aitor lee correo en el móvil, Maren bebe agua. **Tres minutos
  /// después, Tasio entra.** Doc 09 §3.2.4.
  static const EscenaCinematica laCafeteria = EscenaCinematica(
    id: '3.2.4',
    titulo: 'La cafetería',
    flagDeSalida: 'escena_3_2_4_vista',
    flagsRequeridos: {'escena_3_2_3_vista'},
    ambiente: AmbienteArchivo.cafeteriaCascoViejoTudela,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Salen del museo a las 13:30. Aitor conoce un sitio en '
            'el casco viejo.',
      ),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: 'Aquí. Comen bien.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Cafetería pequeña, cinco mesas, una barra. El dueño los '
            'conoce a Aitor de otras visitas — saluda con la cabeza.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Se sientan. Piden. Aitor lee un correo en el móvil. '
            'Maren bebe agua.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Tres minutos después, Tasio entra.',
      ),
    ],
  );

  /// 3.2.5 — *El encuentro con Tasio*. Misma cafetería. Primer
  /// encuentro narrativo con Tasio (32 años, camisa azul lavada,
  /// vaqueros, botas; cara abierta, ni sonrisa simpática ni mirada
  /// agresiva, sólo presencia). Tasio invita a Maren a un café —
  /// *"Esto no es soborno. Es protocolo."* La conversación que
  /// sigue es un examen pedagógico sin disfrazarse: Tasio le hace
  /// tres preguntas clave (*"¿Crees que el Archivo es reformable
  /// desde dentro?"* / *"¿Tú quieres ser Isaura?"* / *"¿Qué quieres
  /// ser?"*) y le deja una cuarta pregunta para mascar sola (sobre
  /// la asunción de que ser Isaura es el techo). Cierre con la
  /// petición clave: *"Cuando trabajes la Brecha del incendio de la
  /// judería de Tudela del 1378, recuérdame. Porque la Brecha tiene
  /// tres lecturas: la de Isaura, la mía, y la tercera. La tercera
  /// es la tuya, si la haces. No la fuerces. Pero no la evites
  /// tampoco."* Aitor se queda en su mesa sin intervenir. Doc 09
  /// §3.2.5.
  static const EscenaCinematica elEncuentroConTasio = EscenaCinematica(
    id: '3.2.5',
    titulo: 'El encuentro con Tasio',
    flagDeSalida: 'escena_3_2_5_vista',
    flagsRequeridos: {'escena_3_2_4_vista'},
    ambiente: AmbienteArchivo.cafeteriaCascoViejoTudela,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Tasio. 32 años. Camisa azul lavada, vaqueros, botas. '
            'Cara abierta — ni la sonrisa simpática ni la mirada '
            'agresiva. Sólo presencia.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Mira hacia la mesa de Aitor. Aitor levanta la vista del '
            'móvil.',
      ),
      PlanoDialogo(voz: VozPersonaje.tasio, texto: 'Aitor.'),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: 'Tasio.'),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: '¿Tú eres la nueva de Isaura?',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Maren tarda tres segundos.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Soy Maren.'),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto:
            'Lo sé. ¿Te puedo invitar a un café cuando termines la '
            'comida?',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Maren mira a Aitor. Aitor le hace un asentimiento '
            'mínimo: tú decides. Vuelve al móvil.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Vale.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: 'Quince minutos. Estoy en la barra.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Tasio se va a la barra. Pide un café. Lee un libro '
            'pequeño.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Aitor habla en voz muy baja sin mirar a Maren.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Yo me quedo aquí. Si necesitas que intervenga, mira '
            'hacia mí. Si no, no me meto.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Aitor sigue con el móvil. Maren come. Acaba en quince '
            'minutos. Va a la barra. Tasio cierra el libro. Le hace '
            'señas para que se siente en una mesa pequeña al fondo.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Café también.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'El camarero trae los cafés. Tasio paga los dos antes de '
            'que Maren pueda intervenir.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: 'Esto no es soborno. Es protocolo.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Ya.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Tasio bebe.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: '¿Cuánto llevas en el oficio?',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Ocho meses.'),
      PlanoDialogo(voz: VozPersonaje.tasio, texto: 'Y ya en Tudela.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Vine a trabajar los Banu Qasi.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: 'Buen lugar para empezar la Ribera.',
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(voz: VozPersonaje.tasio, texto: '¿Qué te parece la Brecha?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Difícil. Las fuentes árabes son riquísimas pero hay que '
            'aprender a leerlas. Las cristianas son hostiles y '
            'filtran lo importante. Y los restos arqueológicos están '
            'limitados — la alcazaba se ha estudiado pero el barrio '
            'musulmán fuera, menos.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: '¿Y eso te dice algo?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Que la mirada arqueológica también ha sido sesgada.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(voz: VozPersonaje.tasio, texto: 'Bien.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Tasio cambia de tono ligeramente. Más directo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: 'Maren. ¿Te puedo preguntar algo más directo?',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: '¿Crees que el Archivo es reformable desde dentro?',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Maren se queda. Aitor desde su mesa no levanta la vista.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No sé.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto:
            'Esa respuesta es buena. La gente que está segura de que '
            'sí está mintiendo. La gente que está segura de que no '
            'está vendiendo el oficio entero.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Pero tú decidiste que no.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: 'Yo decidí que para mí no. Eso no es lo mismo.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoAmbiente(duracion: Duration(seconds: 2)),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: 'Otra. ¿Tú quieres ser Isaura?',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Pausa muy larga.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'No.'),
      PlanoDialogo(voz: VozPersonaje.tasio, texto: '¿Qué quieres ser?'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Pausa más larga aún.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'No lo sé.'),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto:
            'Tampoco lo sabía yo a tu edad. Pero tenía la sensación '
            'de que ser Isaura era el techo. ¿La tienes tú?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No me la había hecho hasta ahora.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto:
            'La pregunta no es trampa. Te la dejo para que la masques '
            'sola.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Tasio termina su café. Mira a Maren con seriedad nueva.',
      ),
      PlanoDialogo(voz: VozPersonaje.tasio, texto: 'Una última.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto:
            'Cuando trabajes la Brecha del incendio de la judería de '
            'Tudela del 1378, recuérdame.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Por qué?',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto:
            'Porque la Brecha tiene tres lecturas: la de Isaura, la '
            'mía, y la tercera. La tercera es la tuya, si la haces. '
            'No la fuerces. Pero no la evites tampoco.',
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto:
            'Si llegas a una versión propia, defiéndela bien. Si no '
            'llegas, no te inventes una para complacer a nadie. Ni a '
            'Isaura, ni a mí.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Tasio se levanta. Le tiende la mano. Maren se la da. '
            'Apretón breve, firme.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: 'Vas a ser buena. Tú decide a qué.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Tasio sale. La puerta de la cafetería se cierra. Maren '
            'se queda sentada en la mesa con el café a medio terminar. '
            'Aitor desde su mesa la mira por primera vez. No comenta.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: '¿Volvemos al museo?',
        pausaPrevia: Duration(milliseconds: 2000),
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
    ],
  );

  /// 3.2.6 — *Vuelta al trabajo*. Esa tarde. Sala del museo de
  /// Tudela. Maren vuelve al trabajo durante tres horas más con las
  /// fuentes. Aitor lee en una silla cercana sin molestarla. Maren
  /// produce una reconstrucción inicial de los Banu Qasi. Termina a
  /// las seis y le pide a Aitor volver a Iruña. En el coche, Maren
  /// no habla durante una hora. Aitor pone música baja —
  /// instrumental, sin comentar. Cuarenta minutos antes de Iruña,
  /// Maren rompe el silencio: *"¿Tasio era así de directo de
  /// joven?"* / *"Más."* Maren decide no contarle a Isaura todavía
  /// — Aitor confirma con suavidad: *"Isaura no regaña por
  /// silencios necesarios."* Doc 09 §3.2.6.
  static const EscenaCinematica vueltaAlTrabajo = EscenaCinematica(
    id: '3.2.6',
    titulo: 'Vuelta al trabajo',
    flagDeSalida: 'escena_3_2_6_vista',
    flagsRequeridos: {'escena_3_2_5_vista'},
    ambiente: AmbienteArchivo.salaMuseoTudela,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren vuelve al trabajo. Tres horas más con las fuentes. '
            'Aitor lee en una silla cercana sin molestarla. Maren '
            'produce una reconstrucción inicial de los Banu Qasi. La '
            'afina. Termina a las seis. Le pide a Aitor volver a '
            'Iruña.',
      ),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: '¿Ya?'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Vuelven en el coche. Maren no habla durante una hora. '
            'Aitor pone música baja — algo instrumental, no comenta.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Cuarenta minutos antes de Iruña, Maren habla.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Aitor.'),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: '¿Sí?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Tasio era así de directo de joven?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Más.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No le voy a contar a Isaura todavía.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No me va a regañar por no contarlo, ¿no?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Isaura no regaña por silencios necesarios.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren asiente. La música sigue. Llegan a Iruña a las '
            'ocho. Aitor la deja en su portal.',
      ),
    ],
  );

  /// 3.2.7 — *Reconstrucción y Concilio* de la Estación 3.2. Una
  /// semana después. Salón del Concilio con Karim, Aitor, Joana y
  /// Maren. Maren presenta su reconstrucción de los Banu Qasi
  /// (~9 afirmaciones distribuidas: dinastía muladí Sólido,
  /// origen documentado en Casio Probable basado en Ibn Hayyán que
  /// cita fuentes anteriores perdidas, alianzas alternantes con
  /// Pamplona-vascones y Córdoba Sólido, rebelión del s. IX de Lubb
  /// ibn Muhammad y descendientes como proyecto de soberanía local
  /// fronteriza Probable, derrota tras 920 con reorganización
  /// administrativa Probable, identidad cultural plenamente
  /// musulmana en s. IX **Sólido como afirmación metodológica** —
  /// la dicotomía moderna *"musulmán vs hispano"* no aplica al
  /// periodo). Karim pregunta sobre conservación selectiva de
  /// fuentes. Concilio cierra. Sellada. Doc 09 §3.2.7.
  static const EscenaCinematica reconstruccionYConcilioBanuQasi =
      EscenaCinematica(
    id: '3.2.7',
    titulo: 'Reconstrucción y Concilio',
    flagDeSalida: 'escena_3_2_7_vista',
    flagsRequeridos: {'escena_3_2_6_vista'},
    ambiente: AmbienteArchivo.salonConcilio,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Una semana después. Salón del Concilio. Karim, Aitor y '
            'Joana a la mesa. Maren presenta su reconstrucción de '
            'los Banu Qasi. La presentación va bien — el material '
            'que ha trabajado es sólido.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 7),
        textoLectura:
            'Las afirmaciones más importantes:\n\n'
            '— Dinastía muladí que gobernó la Ribera del Ebro, '
            'especialmente Tudela, entre los s. VIII y X. Sólido.\n'
            '— Origen documentado en Casio, conde visigodo convertido '
            'al islam tras la invasión. Probable (Ibn Hayyán cita '
            'fuentes anteriores perdidas).',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 7),
        textoLectura:
            '— Alianzas alternantes con Pamplona-vascones y con '
            'Córdoba según conveniencia política. Sólido.\n'
            '— Rebelión contra Córdoba en el s. IX (Lubb ibn '
            'Muhammad y descendientes) como proyecto de soberanía '
            'local fronteriza, no movimiento religioso. Probable.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 7),
        textoLectura:
            '— Derrota tras 920 supuso reabsorción militar y '
            'reorganización administrativa que dejó a Tudela '
            'debilitada hasta la conquista cristiana de 1119. '
            'Probable.\n'
            '— Identidad cultural plenamente musulmana en el s. IX '
            'aunque su origen reciente fuera hispano-cristiano. La '
            'dicotomía moderna "musulmán vs hispano" no aplica al '
            'periodo. Sólido como afirmación metodológica.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Karim hace una pregunta sobre la conservación selectiva '
            'de fuentes — qué se conserva y qué se ha perdido, y por '
            'qué. Maren contesta con cuidado.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Concilio cierra. Sellada.',
      ),
    ],
  );

  /// 3.2.8 — *El silencio de Maren*. Esa noche. Habitación de
  /// Maren. **Maren no escribe en el cuaderno esta noche.** Lo
  /// abre. Mira la página en blanco. Lo cierra. Se acuesta. La
  /// cámara muestra la habitación oscura. El cuaderno cerrado en
  /// la mesa. Tres segundos. Negro. Doc 09 §3.2.8 — la única
  /// noche del MVP en que la voz del Cuaderno no aparece como
  /// reacción a una Estación cerrada. El silencio es el dato
  /// (eco metodológico de Karim en 2.4.5).
  static const EscenaCinematica elSilencioDeMaren = EscenaCinematica(
    id: '3.2.8',
    titulo: 'El silencio de Maren',
    flagDeSalida: 'escena_3_2_8_vista',
    flagsRequeridos: {'escena_3_2_7_vista'},
    ambiente: AmbienteArchivo.cuartoCasaMaren,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren no escribe en el cuaderno esta noche. Lo abre. '
            'Mira la página en blanco. Lo cierra. Se acuesta.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'La cámara muestra la habitación oscura. El cuaderno '
            'cerrado en la mesa. Tres segundos. Negro.',
      ),
    ],
  );

  /// 3.B.1 — *"¿Te trató bien?"*. Latente post-Estación 3.2. Dos
  /// días después. Despacho de Isaura. Maren entra con el pretexto
  /// de devolver un libro. Isaura la mira un segundo de más al
  /// entrar — Maren se da cuenta de que Isaura sabe (Aitor ya le ha
  /// dicho que comieron en la cafetería de Tudela, sin más
  /// detalles). Isaura no insiste; deja que Maren se siente sin
  /// invitarla. Maren confiesa el café con Tasio. La pregunta clave
  /// de Isaura — *"¿Te trató bien?"* — es la que Maren esperaba y
  /// no esperaba. Maren confirma con un Sí simple. Isaura no pide
  /// más. Antes de salir, Maren se gira en la puerta y le hace a
  /// Isaura una pregunta: *"¿Tú lo querías?"* — Isaura tarda mucho
  /// en contestar. *"Lo sigo queriendo."* La cámara se queda con
  /// Isaura mirando hacia la ventana norte. Doc 09 §3.B.1.
  static const EscenaCinematica teTratoBien = EscenaCinematica(
    id: '3.B.1',
    titulo: '¿Te trató bien?',
    flagDeSalida: 'escena_3_b_1_vista',
    flagsRequeridos: {'arco_3_estacion_2_cerrada'},
    ambiente: AmbienteArchivo.despachoIsaura,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren entra al despacho con el pretexto de devolver un '
            'libro. Isaura está en su silla, leyendo. Levanta la '
            'vista cuando Maren entra. La mira un segundo de más. '
            'Maren se da cuenta — Isaura sabe.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Hola.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Tomo. Ya lo terminé.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Aitor me dijo que estuvisteis comiendo en la cafetería '
            'de Tudela.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren no contesta. Isaura no insiste. Se queda mirándola. '
            'Maren se sienta en la silla de enfrente sin que la '
            'inviten.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Tasio me invitó un café.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Mm.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Hablamos veinte minutos.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: '¿Te trató bien?',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren tarda mucho en contestar. La pregunta es la que '
            'esperaba pero también la que no esperaba.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Pausa muy larga.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Bien.'),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: '¿Quieres contarme algo?',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Todavía no.'),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Vale.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Maren se levanta. En la puerta:',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Isaura.'),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: '¿Sí?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Tú lo querías?',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura: 'Pausa larguísima. Cinco segundos. Diez.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Lo sigo queriendo.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren asiente. Sale. La cámara se queda con Isaura. '
            'Coge el libro que Maren ha devuelto. No lo mira. Lo deja '
            'sobre la mesa con cuidado. Mira hacia la ventana norte.',
      ),
    ],
  );

  /// 3.3.1 — *Camino a Leyre*. Primeras semanas de abril. Esta vez
  /// Maren va con Marina en su Polo viejo: coche más pequeño,
  /// música pop española de fondo a volumen bajo. Marina conduce
  /// con una mano y come una galleta con la otra. Marina anticipa
  /// el monasterio (*"feo en plan que no tiene los lujos góticos.
  /// Pero por dentro la cripta es brutal"*) y le cuenta a Maren la
  /// leyenda del abad Virila — el abad que se preguntaba qué era
  /// la eternidad de Dios, salió a pasear por el bosque del
  /// monasterio, oyó cantar a un pájaro, se sentó a escucharlo y
  /// cuando volvió al monasterio habían pasado trescientos años.
  /// Maren responde *"Eso es bonito"* — Marina deja caer un
  /// *"Pero ya verás"* sin completar la frase. Doc 09 §3.3.1.
  static const EscenaCinematica caminoALeyre = EscenaCinematica(
    id: '3.3.1',
    titulo: 'Camino a Leyre',
    flagDeSalida: 'escena_3_3_1_vista',
    flagsRequeridos: {'escena_3_b_1_vista'},
    ambiente: AmbienteArchivo.cocheMarina,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Esta vez Maren va con Marina. Coche más pequeño, música '
            'pop española de fondo a volumen bajo. Marina conduce con '
            'una mano, comiendo una galleta con la otra.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto: '¿Has estado en Leyre?',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'No.'),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto:
            'Te va a gustar. Es feo en plan que no tiene los lujos '
            'góticos. Pero por dentro la cripta es brutal.',
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(voz: VozPersonaje.marina, texto: '¿Sabes la leyenda?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Algo. El abad y un pájaro.',
      ),
      PlanoDialogo(voz: VozPersonaje.marina, texto: 'El abad Virila.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Marina cuenta la leyenda mientras conduce.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto:
            'El abad Virila se preguntaba qué era la eternidad de '
            'Dios. Salió un día a pasear por el bosque del '
            'monasterio. Oyó un pájaro cantar. Se sentó a escucharlo. '
            'Cuando volvió al monasterio, habían pasado trescientos '
            'años. Nadie lo conocía. Se murió poco después.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Eso es bonito.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(voz: VozPersonaje.marina, texto: 'Es bonito.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Pero...?'),
      PlanoDialogo(voz: VozPersonaje.marina, texto: 'Pero ya verás.'),
    ],
  );

  /// 3.3.2 — *El monasterio*. Llegan a Leyre. El monasterio es
  /// modesto por fuera, sólido, encajado en el paisaje. Detrás la
  /// sierra; delante el embalse de Yesa. Entran. La cripta románica
  /// del s. XI es lo más antiguo conservado: capiteles tallados con
  /// escenas y figuras, columnas robustas. La iglesia superior es
  /// algo posterior. Marina le cuenta a Maren que aquí descansaron
  /// los reyes de Pamplona Sancho I, García Sánchez I, Sancho II y
  /// García Sánchez II — sus restos estuvieron aquí siglos. Maren
  /// mira la cripta dos minutos en silencio. Marina cierra: *"Tu
  /// Brecha es la leyenda. La oirás muchas veces si te quedas en el
  /// oficio. Cada vez con matices distintos."* Doc 09 §3.3.2.
  static const EscenaCinematica elMonasterio = EscenaCinematica(
    id: '3.3.2',
    titulo: 'El monasterio',
    flagDeSalida: 'escena_3_3_2_vista',
    flagsRequeridos: {'escena_3_3_1_vista'},
    ambiente: AmbienteArchivo.monasterioLeyre,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Llegan. El monasterio es modesto por fuera. Sólido. '
            'Encaja en el paisaje. Detrás, la sierra. Delante, el '
            'embalse de Yesa.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            'Entran. La cripta románica — del s. XI — es lo más '
            'antiguo conservado. Capiteles tallados con escenas y '
            'figuras, columnas robustas. La iglesia superior es algo '
            'posterior.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto: 'Aquí descansaron los reyes de Pamplona.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Cuáles?'),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto:
            'Sancho I, García Sánchez I, Sancho II, García Sánchez '
            'II. Sus restos estuvieron aquí siglos.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura: 'Maren mira la cripta. Dos minutos en silencio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.marina,
        texto:
            'Tu Brecha es la leyenda. La oirás muchas veces si te '
            'quedas en el oficio. Cada vez con matices distintos.',
      ),
    ],
  );

  /// 3.3.3 — *La leyenda de Virila*. Scriptorium reconstituido en
  /// una sala del monasterio (los códices originales están en
  /// archivos, pero hay reproducciones). Un monje mayor del
  /// monasterio actual les recibe y les enseña reproducciones de
  /// códices del s. XI-XIII. La revelación clave: la leyenda de
  /// Virila aparece por primera vez documentada en un códice del s.
  /// XIII — al menos cuatro siglos después del Virila histórico que
  /// aparece en listas de abades de Leyre del s. IX o principios
  /// del X. Hay menciones en documentación previa a 1200 de un
  /// abad llamado Virila, pero la leyenda tal como se conoce — los
  /// trescientos años, el pájaro, el regreso — es del XIII. El
  /// monje cierra con la pregunta: *"Entonces, ¿qué nos cuenta esta
  /// leyenda?" / "Esa es la pregunta para vosotras."* Doc 09 §3.3.3.
  static const EscenaCinematica laLeyendaDeVirila = EscenaCinematica(
    id: '3.3.3',
    titulo: 'La leyenda de Virila',
    flagDeSalida: 'escena_3_3_3_vista',
    flagsRequeridos: {'escena_3_3_2_vista'},
    ambiente: AmbienteArchivo.scriptoriumLeyre,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Un monje mayor las recibe. Les enseña reproducciones de '
            'códices del s. XI-XIII. La leyenda de Virila aparece por '
            'primera vez documentada en un códice del s. XIII.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.monjeLeyre,
        texto:
            'La leyenda dice que Virila fue abad aquí en el s. IX o '
            'principios del X. Los códices que la cuentan son del '
            'XIII y posteriores.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Cuatro siglos después?',
      ),
      PlanoDialogo(voz: VozPersonaje.monjeLeyre, texto: 'Al menos.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿No hay menciones anteriores?',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.monjeLeyre,
        texto:
            'En documentación previa a 1200, no. Hay listas de abades '
            'de Leyre del s. IX y X, y aparece un Virila en una de '
            'ellas. Pero la leyenda tal como se conoce — los '
            'trescientos años, el pájaro, el regreso — es del XIII.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Maren mira la reproducción del códice.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Entonces, ¿qué nos cuenta esta leyenda?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.monjeLeyre,
        texto: 'Esa es la pregunta para vosotras.',
      ),
    ],
  );

  /// 3.3.4 — *Cuándo se escribió*. Mesa de Trabajo en una sala del
  /// propio monasterio cedida. PH.10 (la leyenda como fuente
  /// histórica de su propia época, no de la que cuenta). Maren
  /// trabaja comparando versiones de la leyenda — la del s. XIII,
  /// una del s. XV, una del XVII — y estudiando el contexto
  /// monástico de cada momento de redacción. Voz del Cuaderno
  /// articulando la lección clave del PH.10: la leyenda no es
  /// sobre el s. IX, es sobre el s. XIII (Leyre en declive,
  /// reformas cluniacenses, memoria del esplendor pasado
  /// perdiéndose); los trescientos años no son los del milagro
  /// sino los que separan la fundación de Leyre del momento de
  /// redacción de la leyenda. La Cronista produce 6 afirmaciones
  /// (3 Sólido + 3 Probable). Doc 09 §3.3.4.
  static const EscenaCinematica cuandoSeEscribio = EscenaCinematica(
    id: '3.3.4',
    titulo: 'Cuándo se escribió',
    flagDeSalida: 'escena_3_3_4_vista',
    flagsRequeridos: {'escena_3_3_3_vista'},
    ambiente: AmbienteArchivo.monasterioLeyre,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren trabaja en una sala cedida del monasterio. Compara '
            'las distintas versiones de la leyenda — la del s. XIII, '
            'una del s. XV, una del XVII. Estudia el contexto '
            'monástico de cada momento de redacción.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'La leyenda se escribe en el s. XIII. ¿Por qué entonces?',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Leyre en el s. XIII estaba en declive. Había perdido su '
            'importancia política. Los reyes ya no se enterraban aquí. '
            'La nueva orden cluniacense había reformado la liturgia. '
            'La memoria del esplendor pasado se estaba perdiendo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'La leyenda, vista desde ahí, no es sobre el s. IX. Es '
            'sobre el s. XIII. Es un monasterio que mira hacia atrás '
            '300 años — los años desde su fundación — y cuenta una '
            'historia de un abad que se sentó a escuchar trescientos '
            'años de eternidad.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Esos trescientos años no son los del milagro. Son los '
            'que separan la fundación de Leyre del momento de '
            'redacción de la leyenda.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'La leyenda de Virila no cuenta lo que pasó en el s. IX. '
            'Cuenta cómo Leyre del s. XIII se sentía mirando al s. '
            'IX.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 8),
        textoLectura:
            'La Cronista produce 6 afirmaciones:\n\n'
            '1. La leyenda aparece documentada por primera vez en '
            'códice del s. XIII de Leyre. Sólido.\n'
            '2. Un abad llamado Virila aparece en listas de abades '
            'del s. IX de Leyre. Sólido.\n'
            '3. La conexión entre el Virila histórico y el legendario '
            'no puede establecerse con certeza. Sólido (la '
            'incertidumbre).',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 8),
        textoLectura:
            '4. La leyenda en su forma plenamente desarrollada es '
            'producto del contexto monástico del s. XIII en un Leyre '
            'en declive relativo. Probable.\n'
            '5. La cifra "trescientos años" coincide aproximadamente '
            'con el tiempo entre la fundación de Leyre y la redacción '
            'de la leyenda — probablemente significativo, no casual. '
            'Probable.\n'
            '6. La leyenda nos informa más sobre la espiritualidad y '
            'la auto-percepción del s. XIII que sobre el s. IX. '
            'Probable.',
      ),
    ],
  );

  /// 3.3.5 — *Concilio* de la Estación 3.3. Una semana después,
  /// vuelta a Iruña. Salón del Concilio. Aitor (revisor) + Joana +
  /// Maren. Joana cuestiona la afirmación 5 (coincidencia de
  /// "trescientos años" entre el milagro y la fundación de Leyre)
  /// — *"es interpretativa"*. Maren la mantiene como Probable.
  /// Joana le pide que busque paralelos en otras leyendas
  /// monásticas con cifras simbólicas vinculadas a fundaciones —
  /// *"Para Aprendiz III, sí"*. Aitor sella pero apunta que Joana
  /// tiene razón: dejar la afirmación 5 abierta para revisión
  /// cuando los paralelos lleguen. Doc 09 §3.3.5.
  /// F2-28b — la 3.3.5 cinemática *Concilio de Leyre* requiere ahora
  /// `brecha_3_3_completada` (la Brecha 3.3 jugable se interpone
  /// entre 3.3.4 *Cuándo se escribió* y 3.3.5). Antes de F2-28b
  /// requería `escena_3_3_4_vista`.
  static const EscenaCinematica concilioLeyre = EscenaCinematica(
    id: '3.3.5',
    titulo: 'Concilio de Leyre',
    flagDeSalida: 'escena_3_3_5_vista',
    flagsRequeridos: {'brecha_3_3_completada'},
    ambiente: AmbienteArchivo.salonConcilio,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Una semana después, vuelta a Iruña. Salón del Concilio. '
            'Aitor (revisor) y Joana a la mesa. Maren presenta su '
            'reconstrucción.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.joana,
        texto:
            'Tu afirmación 5 — la coincidencia de "trescientos años" '
            '— es interpretativa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Sí. La declaro Probable.',
      ),
      PlanoDialogo(voz: VozPersonaje.joana, texto: '¿Qué te haría Sólida?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Si encontrara explicitada la cifra en el códice como '
            'referencia a la fundación. O si otras leyendas paralelas '
            'usaran cifras simbólicas similares vinculadas a '
            'fundaciones.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.joana,
        texto: '¿Has buscado paralelos?',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'No.'),
      PlanoDialogo(voz: VozPersonaje.joana, texto: 'Para Aprendiz III, sí.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Vale.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Sellada. Pero Joana tiene razón — busca paralelos. '
            'Déjate la afirmación 5 abierta para revisión cuando los '
            'tengas.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
    ],
  );

  /// 3.3.6 — *La leyenda no miente, desplaza*. Esa noche. Voz del
  /// Cuaderno breve cerrando la Estación con la lección PH.10:
  /// *"Las leyendas no mienten. Desplazan. Cuentan otra cosa de la
  /// que parece. Quien las escucha sin entender el desplazamiento
  /// las toma literales. Quien las entiende ve dos historias a la
  /// vez: la que dicen y la que ocultan. El abad Virila escuchó un
  /// pájaro. Pero quien lo cuenta lleva trescientos años escuchando
  /// el silencio de la grandeza pasada."* Doc 09 §3.3.6.
  static const EscenaCinematica laLeyendaNoMienteDesplaza = EscenaCinematica(
    id: '3.3.6',
    titulo: 'La leyenda no miente, desplaza',
    flagDeSalida: 'escena_3_3_6_vista',
    flagsRequeridos: {'escena_3_3_5_vista'},
    ambiente: AmbienteArchivo.cuartoCasaMaren,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Es de noche. Maren en su mesa, cuaderno abierto.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Las leyendas no mienten. Desplazan.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Cuentan otra cosa de la que parece. Quien las escucha '
            'sin entender el desplazamiento las toma literales. Quien '
            'las entiende ve dos historias a la vez: la que dicen y '
            'la que ocultan.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'El abad Virila escuchó un pájaro. Pero quien lo cuenta '
            'lleva trescientos años escuchando el silencio de la '
            'grandeza pasada.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
    ],
  );

  /// 3.C.1 — *Naia pregunta otra vez*. Latente post-Estación 3.3.
  /// ~10 días después. Sábado tarde. Habitación de Maren. Naia (8
  /// años, hermana pequeña) entra sin llamar con un papel doblado
  /// — ha escrito una pregunta para Maren porque *"si la digo se
  /// me olvida hacerla bien"*. La pregunta, en letra grande de
  /// niña: *"Si las leyendas son sobre el momento en que se
  /// escriben, ¿qué pasa con las películas?"* Naia oyó por
  /// casualidad la conversación de Maren con Antonio sobre Leyre,
  /// contó lo del pájaro al cole, y cuando su profesora dijo *"qué
  /// historia más bonita"* Naia pensó en lo que había oído a su
  /// hermana. Maren confirma que sí — las películas también son
  /// sobre el momento en que se hacen, no sobre la época que
  /// cuentan, casi siempre. Naia agradece y sale. Maren guarda el
  /// papel dentro del cuaderno. Voz del Cuaderno cierra: *"Mi
  /// hermana de ocho años acaba de hacerme una pregunta de oficio.
  /// Voy a guardar el papel toda mi vida."* Doc 09 §3.C.1.
  static const EscenaCinematica naiaPreguntaOtraVez = EscenaCinematica(
    id: '3.C.1',
    titulo: 'Naia pregunta otra vez',
    flagDeSalida: 'escena_3_c_1_vista',
    flagsRequeridos: {'arco_3_estacion_3_cerrada'},
    ambiente: AmbienteArchivo.cuartoCasaMaren,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Sábado tarde. Maren está en su mesa estudiando para un '
            'examen del instituto. Naia entra sin llamar. Trae un '
            'papel doblado.',
      ),
      PlanoDialogo(voz: VozPersonaje.naia, texto: 'Hola.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Hola.'),
      PlanoDialogo(
        voz: VozPersonaje.naia,
        texto: 'Te he escrito una pregunta.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Por qué escrita?'),
      PlanoDialogo(
        voz: VozPersonaje.naia,
        texto: 'Porque si la digo se me olvida hacerla bien.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Le pasa el papel. Maren lo abre. Letra grande de niña '
            'de 8 años. La pregunta dice:',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Si las leyendas son sobre el momento en que se escriben, '
            '¿qué pasa con las películas?',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura: 'Maren se queda quieta. Quince segundos.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Naia. ¿De qué te has enterado tú?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.naia,
        texto:
            'Te oí ayer hablando con aita de Leyre. Conté lo del '
            'pájaro al cole. Mi profesora dijo "qué historia más '
            'bonita". Pero yo pensé en lo que te oí decir a ti.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Qué pensaste?',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.naia,
        texto:
            'Que las películas también son sobre el momento en que '
            'se hacen, ¿no? No sobre la época que cuentan.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Sí.',
        pausaPrevia: Duration(milliseconds: 1800),
      ),
      PlanoDialogo(voz: VozPersonaje.naia, texto: '¿Y eso pasa siempre?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Casi siempre.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.naia,
        texto: 'Vale. Gracias.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Naia sale. Maren se queda con el papel en la mano. Lo '
            'dobla con cuidado. Lo guarda dentro del cuaderno.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Mi hermana de ocho años acaba de hacerme una pregunta '
            'de oficio.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Voy a guardar el papel toda mi vida.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
    ],
  );

  /// 3.4.1 — *Camino a Roncesvalles*. Mediados de abril. Coche de
  /// Aitor subiendo al Pirineo entre bosques de hayas y niebla
  /// baja. Aitor le anticipa a Maren la doble lectura del 778: el
  /// relato de la *Chanson de Roland* (ejército de Carlomagno
  /// derrotado por sarracenos tras una traición) frente a la
  /// realidad documentada — *"la Chanson la escriben unos
  /// doscientos años después del hecho. Y los moros no aparecen
  /// en las fuentes del s. VIII que mencionan el suceso"*. Maren
  /// concluye preliminar: *"Entonces los moros son ficción"*.
  /// Aitor: *"Probablemente. Pero ya verás cómo y por qué"*. Doc
  /// 09 §3.4.1.
  static const EscenaCinematica caminoARoncesvalles = EscenaCinematica(
    id: '3.4.1',
    titulo: 'Camino a Roncesvalles',
    flagDeSalida: 'escena_3_4_1_vista',
    flagsRequeridos: {'escena_3_c_1_vista'},
    ambiente: AmbienteArchivo.cocheAitor,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Coche de Aitor. Sube hacia el Pirineo. Bosques de hayas. '
            'Niebla baja en algunos tramos.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: '¿Sabes la Chanson de Roland?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Algo. He leído resúmenes.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'El relato dice que un ejército de Carlomagno fue derrotado '
            'en Roncesvalles por sarracenos — moros — tras una '
            'traición de un noble cristiano.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Y la realidad?'),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'La realidad es lo que tienes que reconstruir tú.',
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Pero te avanzo: la Chanson la escriben unos doscientos '
            'años después del hecho. Y los moros no aparecen en las '
            'fuentes del s. VIII que mencionan el suceso.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Entonces los moros son ficción.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Probablemente. Pero ya verás cómo y por qué.',
      ),
    ],
  );

  /// 3.4.2 — *El paso*. Llegan a Roncesvalles. Paso pirenaico,
  /// niebla, la colegiata real (hospital histórico de peregrinos),
  /// la carretera por la que se baja a Francia. Maren mira al
  /// norte (Francia) y al sur (Navarra) — el paso es pequeño en
  /// términos geográficos pero importantísimo históricamente.
  /// Aitor le sitúa el episodio del 778: los carolingios habían
  /// cruzado al sur como aliados de Sulayman al-Arabi de Zaragoza,
  /// fracasaron, volvían frustrados al norte y la retaguardia
  /// fue emboscada por vascones. La emboscada sucedió
  /// probablemente algo más al norte, en territorio que hoy es
  /// Francia. Doc 09 §3.4.2.
  static const EscenaCinematica elPaso = EscenaCinematica(
    id: '3.4.2',
    titulo: 'El paso',
    flagDeSalida: 'escena_3_4_2_vista',
    flagsRequeridos: {'escena_3_4_1_vista'},
    ambiente: AmbienteArchivo.pasoRoncesvalles,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            'Roncesvalles. Paso de montaña, niebla. La colegiata real, '
            'hospital de peregrinos histórico. La carretera por la que '
            'se baja a Francia.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren mira hacia el norte — Francia. Hacia el sur — '
            'Navarra. El paso es pequeño en términos geográficos pero '
            'importantísimo históricamente.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Aquí pasaron carolingios en 778. Aquí pasaron peregrinos '
            'del Camino desde el s. XI. Aquí pasó casi todo lo que '
            'entró y salió de la península durante mil años.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Aquí mismo, este paso concreto?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Aquí o cerca. La emboscada del 778 sucedió probablemente '
            'algo más al norte, en territorio que hoy es Francia.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Y los carolingios qué hacían aquí?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Habían cruzado al sur como aliados de Sulayman al-Arabi '
            'de Zaragoza. Atacaron Zaragoza, fracasaron. Volvían '
            'frustrados al norte. La retaguardia atravesaba este paso '
            'cuando fue emboscada.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Por quién?'),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Vascones.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
    ],
  );

  /// 3.4.3 — *Las dos versiones*. Sala de trabajo cedida en la
  /// colegiata. Aitor le presenta a Maren las dos lecturas en
  /// paralelo: la histórica documentada por las fuentes
  /// carolingias del s. VIII-IX (*Vita Karoli* de Eginardo,
  /// *Annales Regni Francorum*) — emboscada vascona a la
  /// retaguardia carolingia que volvía de Zaragoza, muerte de
  /// Rolando conde de la Marca de Bretaña — frente a la legendaria
  /// (*Chanson de Roland* h. 1100) — sarracenos en lugar de
  /// vascones, traición de Ganelón como motor narrativo,
  /// estructura de combate cristiano-musulmán. La voz del
  /// Cuaderno articula los tres cambios y apunta a las Cruzadas
  /// como contexto de redacción. Doc 09 §3.4.3.
  static const EscenaCinematica lasDosVersiones = EscenaCinematica(
    id: '3.4.3',
    titulo: 'Las dos versiones',
    flagDeSalida: 'escena_3_4_3_vista',
    flagsRequeridos: {'escena_3_4_2_vista'},
    ambiente: AmbienteArchivo.colegiataRoncesvalles,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Sala de trabajo cedida en la colegiata. Aitor pone sobre '
            'la mesa el material de las dos lecturas en paralelo.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 7),
        textoLectura:
            'Versión histórica (fuentes del s. VIII y IX):\n'
            '• Vita Karoli de Eginardo (s. IX, biografía de Carlomagno).\n'
            '• Annales Regni Francorum (anales del reino franco, s. IX).\n'
            '• Mención breve en otras fuentes carolingias del periodo.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            'Las fuentes contemporáneas dicen: una emboscada vascona '
            'a la retaguardia carolingia que volvía frustrada de '
            'Zaragoza. Murieron varios nobles, entre ellos un tal '
            'Rolando, conde de la Marca de Bretaña. Los vascones se '
            'retiraron sin posibilidad de represalia carolingia '
            'inmediata.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 7),
        textoLectura:
            'Versión legendaria (Chanson de Roland, h. 1100):\n'
            '• Texto épico francés de finales del s. XI / principios '
            'del XII.\n'
            '• Atribuye la emboscada a sarracenos en lugar de a '
            'vascones.\n'
            '• Convierte a Rolando en héroe central, con espada '
            'Durendal y olifante.\n'
            '• Añade traición del cristiano Ganelón como motor '
            'narrativo.\n'
            '• Estructura la batalla como combate religioso '
            'cristiano-musulmán.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'La Chanson cambia tres cosas grandes:',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            '1. Vascones por moros.\n'
            '2. Emboscada por traición.\n'
            '3. Conflicto político por conflicto religioso.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Los tres cambios apuntan en la misma dirección. La '
            'Chanson reescribe Roncesvalles para que encaje con las '
            'Cruzadas — que están empezando precisamente cuando se '
            'escribe.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
    ],
  );

  /// 3.4.4 — *La Chanson*. Mesa de Trabajo en la colegiata.
  /// PH.10 ampliado a su forma más completa: la leyenda no sólo
  /// desplaza temporalmente — como Virila en la 3.3 — sino que
  /// **reescribe identidades enteras** para servir a una agenda
  /// contemporánea de su redacción. Las primeras Cruzadas se
  /// predican en 1095 y la *Chanson* se escribe en torno a 1100.
  /// Convierte un episodio menor de hace 320 años en epopeya
  /// cristiano-musulmana — exactamente lo que Europa quería oír
  /// en el momento. Voz del Cuaderno articulando: propaganda
  /// cruzada no manipulada deliberadamente, sino respirada por
  /// los redactores en el aire de su tiempo. Doc 09 §3.4.4.
  static const EscenaCinematica laChanson = EscenaCinematica(
    id: '3.4.4',
    titulo: 'La Chanson',
    flagDeSalida: 'escena_3_4_4_vista',
    flagsRequeridos: {'escena_3_4_3_vista'},
    ambiente: AmbienteArchivo.colegiataRoncesvalles,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            'Maren analiza la Chanson en su contexto. Las primeras '
            'Cruzadas se predican en 1095. La Chanson se escribe en '
            'torno a 1100. Su versión de Roncesvalles convierte un '
            'episodio menor de hace 320 años en epopeya de cristianos '
            'contra musulmanes — exactamente lo que Europa quería '
            'oír en el momento.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'La Chanson es propaganda cruzada. No de manera '
            'consciente, no como manipulación deliberada. Pero el '
            'aire que respiraban los redactores estaba lleno de '
            'cruzadas, y el episodio del 778 lo reescribieron en '
            'ese aire.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Los vascones no eran enemigo conveniente para los '
            'cruzados — eran cristianos. Los moros sí. Cambia el '
            'enemigo y el episodio sirve de arenga.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
    ],
  );

  /// 3.4.5 — *Reconstrucción*. Mesa de Trabajo. La Cronista
  /// produce 8 afirmaciones distinguiendo claramente entre los
  /// dos planos — el episodio del 778 documentado y la *Chanson*
  /// como obra literaria del s. XII. La afirmación 8 cierra con
  /// el matiz metodológico clave: *"Roncesvalles como evento es
  /// uno y la Chanson como obra literaria es otra: la honestidad
  /// histórica exige no confundirlos, aunque la cultura popular
  /// los haya fundido"* — Sólido como afirmación metodológica.
  /// Doc 09 §3.4.5.
  /// F2-28c — la 3.4.5 cinemática *Reconstrucción* requiere ahora
  /// `brecha_3_4_completada` (la Brecha 3.4 jugable se interpone
  /// entre 3.4.4 *La Chanson* y 3.4.5; la cinemática queda como
  /// puesta en limpio narrativa de las 8 afirmaciones que la jugable
  /// produce). Antes de F2-28c requería `escena_3_4_4_vista`.
  static const EscenaCinematica reconstruccionRoncesvalles = EscenaCinematica(
    id: '3.4.5',
    titulo: 'Reconstrucción',
    flagDeSalida: 'escena_3_4_5_vista',
    flagsRequeridos: {'brecha_3_4_completada'},
    ambiente: AmbienteArchivo.colegiataRoncesvalles,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Mesa de Trabajo. La Cronista produce 8 afirmaciones '
            'distinguiendo claramente entre los dos planos.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 9),
        textoLectura:
            '1. En 778, una emboscada vascona destruyó la retaguardia '
            'del ejército de Carlomagno en el Pirineo. Sólido.\n'
            '2. Las fuentes carolingias contemporáneas identifican a '
            'los atacantes como vascones. Sólido.\n'
            '3. La emboscada respondía probablemente a represalias '
            'por daños del ejército carolingio en su paso por '
            'territorio vascón. Probable.\n'
            '4. La Chanson de Roland (~1100) reescribe el episodio '
            'sustituyendo a los vascones por musulmanes. Sólido.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 9),
        textoLectura:
            '5. Esta sustitución refleja el contexto de las Cruzadas, '
            'no la realidad del 778. Probable.\n'
            '6. La Chanson añade el motor narrativo de la traición '
            'de Ganelón, ausente de las fuentes contemporáneas. '
            'Sólido.\n'
            '7. La popularidad de la Chanson medieval fijó la versión '
            'legendaria como "memoria popular" del episodio durante '
            'siglos. Probable.\n'
            '8. Roncesvalles como evento es uno y la Chanson como '
            'obra literaria es otra: la honestidad histórica exige '
            'no confundirlos, aunque la cultura popular los haya '
            'fundido. Sólido como afirmación metodológica.',
      ),
    ],
  );

  /// 3.4.6 — *Concilio*. Días después en Iruña, salón del
  /// Concilio. Aitor (acompañante), Karim, Joana revisores.
  /// Karim aprueba la afirmación 5 con énfasis — el reconocimiento
  /// explícito del contexto cruzado. Aitor le pregunta sobre la
  /// afirmación 7, si la "memoria popular" tiene también su
  /// propia historia que merece estudio; Maren admite que sí pero
  /// queda fuera de esta Brecha. Joana asiente sin comentar y
  /// cierra: *"Sellada"*. Doc 09 §3.4.6.
  static const EscenaCinematica concilioRoncesvalles = EscenaCinematica(
    id: '3.4.6',
    titulo: 'Concilio de Roncesvalles',
    flagDeSalida: 'escena_3_4_6_vista',
    flagsRequeridos: {'escena_3_4_5_vista'},
    ambiente: AmbienteArchivo.salonConcilio,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Días después en Iruña. Salón del Concilio. Aitor '
            'acompañante; Karim y Joana revisores. Maren presenta su '
            'reconstrucción.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Tu afirmación 5 — el reconocimiento explícito del '
            'contexto cruzado — la apruebo con énfasis. Es el corazón '
            'de la Brecha.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Tu afirmación 7 dice que la "memoria popular" fijó la '
            'versión legendaria durante siglos. ¿Esa memoria popular '
            'tiene también su propia historia que merece estudio?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Sí. Pero queda fuera de esta Brecha.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Joana asiente sin comentar.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.joana,
        texto: 'Sellada.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
    ],
  );

  /// 3.4.7 — *Lo bonito miente*. Esa noche, habitación de Maren.
  /// Voz del Cuaderno cierra la Estación 3.4 con la lección
  /// integradora del oficio frente a la épica: *"Lo bonito miente
  /// más que lo aburrido"*. La *Chanson* es bonita — tiene épica,
  /// traición, espadas, olifantes. La realidad es aburrida —
  /// una emboscada en un paso de montaña a un ejército que
  /// volvía frustrado. *"El oficio sirve para defender lo aburrido
  /// cuando es verdad. Eso me cuesta. Lo aburrido no se defiende
  /// solo. Pero si no lo defendemos nosotras, nadie lo va a
  /// defender"*. Doc 09 §3.4.7.
  static const EscenaCinematica loBonitoMiente = EscenaCinematica(
    id: '3.4.7',
    titulo: 'Lo bonito miente',
    flagDeSalida: 'escena_3_4_7_vista',
    flagsRequeridos: {'escena_3_4_6_vista'},
    ambiente: AmbienteArchivo.cuartoCasaMaren,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Es de noche. Maren en su mesa, cuaderno abierto.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Lo bonito miente más que lo aburrido.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'La Chanson es bonita. Tiene épica, traición, espadas, '
            'olifantes. La realidad — una emboscada en un paso de '
            'montaña a un ejército que volvía frustrado — es '
            'aburrida.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'El oficio sirve para defender lo aburrido cuando es '
            'verdad. Eso me cuesta. Lo aburrido no se defiende solo.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Pero si no lo defendemos nosotras, nadie lo va a '
            'defender.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
    ],
  );

  /// 3.D.1 — *Eider se va*. Latente, ~5 días después de la
  /// Estación 3.4. Portal del bloque de Eider. Maren ha pasado
  /// sin avisar; Eider baja en chándal, saliendo a entrenar al
  /// baloncesto. Maren pide perdón por no haber ido al partido
  /// importante. Eider responde con la frase clave: *"No estoy
  /// enfadada. Estoy cansada. Estoy cansada de tener una mejor
  /// amiga que tiene una vida que yo no entiendo"*. Maren: *"No
  /// es lo mismo que perderte"*. Eider: *"No"*. Eider se va a
  /// baloncesto sin cerrar nada. Maren camina a casa sin mirar
  /// el móvil, sin llorar — sólo camina. Voz del Cuaderno esa
  /// noche: *"Eider tiene razón. Yo no le he explicado nunca lo
  /// que hago. Y aunque se lo explicara, no es algo que se pueda
  /// explicar en cinco minutos. Hace falta haberlo vivido. No sé
  /// qué hacer"*. Doc 09 §3.D.1. Esta es la cinemática más
  /// emocionalmente cruda del Arco 3 hasta ahora — el coste
  /// personal del oficio articulado por una amiga adolescente
  /// que no entra en el oficio.
  static const EscenaCinematica eiderSeVa = EscenaCinematica(
    id: '3.D.1',
    titulo: 'Eider se va',
    flagDeSalida: 'escena_3_d_1_vista',
    flagsRequeridos: {'arco_3_estacion_4_cerrada'},
    ambiente: AmbienteArchivo.portalCasaEider,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren ha pasado por casa de Eider sin avisar. Eider '
            'baja al portal en chándal, saliendo a entrenar.',
      ),
      PlanoDialogo(voz: VozPersonaje.eider, texto: 'Hola.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Hola.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No vine al partido. Ya lo sabes.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(voz: VozPersonaje.eider, texto: 'Lo sé.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Quería pedir perdón.'),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: 'Vale.',
        pausaPrevia: Duration(milliseconds: 1800),
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: 'Maren. No estoy enfadada. Estoy cansada.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿De mí?'),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto:
            'No exactamente. Estoy cansada de tener una mejor amiga '
            'que tiene una vida que yo no entiendo.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No es lo mismo que perderte.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(voz: VozPersonaje.eider, texto: 'No.'),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.eider,
        texto: 'Voy al baloncesto. ¿Hablamos otro día?',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Eider se va. Maren se queda en el portal. Camina a casa. '
            'No mira el móvil. No llora. Camina.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Eider tiene razón.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Yo no le he explicado nunca lo que hago. Y aunque se lo '
            'explicara, no es algo que se pueda explicar en cinco '
            'minutos. Hace falta haberlo vivido.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'No sé qué hacer.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
    ],
  );

  /// 3.5.1 — *Llegada a Estella*. La Estación 3.5 es la única
  /// **Brecha de respiro** del Arco 3 (doc 09 §3.5: *"Brecha más
  /// serena, casi de respiro"*). Maren y Aitor llegan a Estella
  /// y recorren el conjunto románico — iglesia del Santo
  /// Sepulcro, San Pedro de la Rúa, palacio de los Reyes (uno
  /// de los pocos palacios civiles románicos conservados de
  /// Europa), San Miguel. Aitor le explica la lección de la
  /// Estación: las ciudades pueden fundarse, no siempre han
  /// estado donde están — Estella es proyecto político de
  /// Sancho Ramírez en 1090, **ciudad fundada para el Camino
  /// de Santiago** con privilegios concretos para atraer
  /// población franca, conviviendo con la población vasco-
  /// romance preexistente. Doc 09 §3.5.
  static const EscenaCinematica llegadaAEstella = EscenaCinematica(
    id: '3.5.1',
    titulo: 'Llegada a Estella',
    flagDeSalida: 'escena_3_5_1_vista',
    flagsRequeridos: {'escena_3_d_1_vista'},
    ambiente: AmbienteArchivo.estellaConjuntoRomanico,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Estella/Lizarra. Maren y Aitor llegan a media mañana. '
            'Conjunto románico: iglesia del Santo Sepulcro, San Pedro '
            'de la Rúa, palacio de los Reyes, San Miguel.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Estella es ciudad fundada. No estaba aquí antes de 1090. '
            'La fundó Sancho Ramírez con carta puebla — privilegios '
            'específicos para atraer población franca y servir al '
            'Camino de Santiago, que estaba en pleno auge.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Y antes de 1090?'),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Población vasco-romance dispersa en el valle. La fundación '
            'concentra a los recién llegados francos en un trazado '
            'urbano nuevo, con sus propios fueros. Los preexistentes '
            'siguen ahí, pero la villa-Camino es proyecto político.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Aitor le señala los cuatro monumentos como fuentes '
            'arquitectónicas. El palacio de los Reyes — uno de los '
            'pocos palacios civiles románicos conservados de Europa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Entonces una ciudad medieval no es siempre algo que ha '
            'crecido orgánicamente. A veces es proyecto.',
      ),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: 'A menudo lo es.'),
    ],
  );

  /// 3.5.2 — *Mesa de Trabajo y Reconstrucción*. Sala cedida en
  /// alguno de los edificios de Estella. Maren trabaja con la
  /// carta puebla de 1090 y la documentación municipal del s.
  /// XII, complementadas por los monumentos como fuentes
  /// arquitectónicas. Produce 6 afirmaciones todas Sólido o
  /// Probable — Brecha bien acotada, sin disputa metodológica
  /// grande. Doc 09 §3.5.
  /// F2-28d — la 3.5.2 cinemática *Mesa de Trabajo y Reconstrucción*
  /// requiere ahora `brecha_3_5_completada` (la Brecha 3.5 jugable
  /// se interpone entre 3.5.1 *Llegada a Estella* y 3.5.2; la
  /// cinemática queda como puesta en limpio narrativa de las 6
  /// afirmaciones que la jugable produce). Antes de F2-28d requería
  /// `escena_3_5_1_vista`.
  static const EscenaCinematica mesaYReconstruccionEstella = EscenaCinematica(
    id: '3.5.2',
    titulo: 'Mesa de Trabajo y Reconstrucción',
    flagDeSalida: 'escena_3_5_2_vista',
    flagsRequeridos: {'brecha_3_5_completada'},
    ambiente: AmbienteArchivo.estellaConjuntoRomanico,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Mesa de Trabajo. Carta puebla de Estella (1090), '
            'documentación municipal del s. XII, los monumentos como '
            'fuentes arquitectónicas. Brecha bien acotada — sin disputa '
            'metodológica grande.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 9),
        textoLectura:
            '1. Estella se funda en 1090 por carta puebla de Sancho '
            'Ramírez. Sólido.\n'
            '2. La fundación es proyecto político vinculado al auge '
            'del Camino de Santiago. Sólido.\n'
            '3. Los privilegios atraen población franca, '
            'principalmente occitano-hablante. Sólido.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 9),
        textoLectura:
            '4. La población vasco-romance preexistente del valle '
            'permanece, pero la villa-Camino es trazado urbano nuevo '
            'con sus propios fueros. Probable.\n'
            '5. La economía de Estella en el s. XII es economía de '
            'ciudad-paso — peregrinos, mercaderes, hospederías, '
            'cambistas. Sólido.\n'
            '6. El conjunto románico conservado (Santo Sepulcro, San '
            'Pedro de la Rúa, palacio de los Reyes, San Miguel) '
            'refleja el esplendor de la villa en su primer siglo. '
            'Probable.',
      ),
    ],
  );

  /// 3.5.3 — *Concilio de Estella*. Salón del Concilio en el
  /// Archivo de Iruña. El Concilio aprueba sin tensiones — la
  /// Brecha está bien acotada, las 6 afirmaciones bien
  /// calibradas, no hay disputa metodológica grande. Aitor
  /// cierra con la lección clave: *"Bien. Ya sabes que se pueden
  /// hacer Brechas que no acaban contigo"*. Doc 09 §3.5.
  static const EscenaCinematica concilioEstella = EscenaCinematica(
    id: '3.5.3',
    titulo: 'Concilio de Estella',
    flagDeSalida: 'escena_3_5_3_vista',
    flagsRequeridos: {'escena_3_5_2_vista'},
    ambiente: AmbienteArchivo.salonConcilio,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Salón del Concilio. Maren presenta su reconstrucción. '
            'Aprobada sin tensiones — Brecha bien acotada, calibración '
            'limpia, sin disputa metodológica grande.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Bien. Ya sabes que se pueden hacer Brechas que no '
            'acaban contigo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'No me había dado cuenta hasta ahora.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
    ],
  );

  /// 3.5.4 — *Calle de la Rúa al anochecer*. Cierre de la
  /// Estación 3.5. Maren y Aitor caminando por la calle de la
  /// Rúa de Estella al anochecer — la calle mayor del trazado
  /// urbano de la fundación de 1090, eje del Camino de Santiago
  /// a su paso por la villa. Un grupo de peregrinos pasando
  /// con guitarra, música del Camino. Aitor: *"Necesitabas una
  /// así. El oficio también incluye respirar"*. Voz del
  /// Cuaderno esa noche: *"Hoy no hay nada que decir. Por una
  /// vez la Brecha era simple. Ha sido un alivio"*. Doc 09 §3.5.
  static const EscenaCinematica calleRuaAlAnochecer = EscenaCinematica(
    id: '3.5.4',
    titulo: 'Calle de la Rúa al anochecer',
    flagDeSalida: 'escena_3_5_4_vista',
    flagsRequeridos: {'escena_3_5_3_vista'},
    ambiente: AmbienteArchivo.calleRuaEstella,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Calle de la Rúa, Estella, anochecer. Maren y Aitor '
            'caminando despacio. Un grupo de peregrinos pasa con una '
            'guitarra — música del Camino.',
      ),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: 'Necesitabas una así.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Sí.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'El oficio también incluye respirar.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura: 'La música de los peregrinos se aleja calle abajo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Hoy no hay nada que decir.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Por una vez la Brecha era simple.',
        pausaPrevia: Duration(milliseconds: 800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Ha sido un alivio.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
    ],
  );

  /// 3.6.1 — *Isaura presenta*. Principios de mayo. Despacho de
  /// Isaura. La carpeta gruesa de la Brecha del incendio de la
  /// judería de Tudela de 1378 sobre la mesa. Isaura le adelanta
  /// a Maren su versión publicada en 2017 y la de Tasio publicada
  /// en 2021, las dos lecturas que rompieron la relación entre
  /// ellos. Le pasa la carpeta y le da seis semanas. La cinemática
  /// articula el contraste central de la Brecha — Probable vs
  /// Sólido para la complicidad institucional, identificación
  /// nominativa de tres miembros del Concejo en la versión de
  /// Tasio, prudencia metodológica de Isaura, precio personal de
  /// la prudencia. Cierre con el anuncio de que el Concilio será
  /// amplio y que Karim ha pedido invitar a Tasio como observador.
  /// Doc 09 §3.6.1.
  ///
  /// **PENDIENTE DE VALIDACIÓN COMITÉ TUDELA-1378**: las cifras
  /// concretas de víctimas (al menos dieciocho personas, cuatro
  /// casas destruidas completas, otras siete dañadas) y la
  /// identificación nominal de tres miembros del Concejo del 1378
  /// como responsables son material que requiere validación del
  /// comité asesor histórico antes de exposición pública. Mientras
  /// tanto se mantiene la formulación literal del doc 09 v0.3
  /// porque el guion canónico ya la lleva — pero registrada en
  /// `BLOQUEOS-PENDIENTES.md`.
  static const EscenaCinematica isauraPresenta = EscenaCinematica(
    id: '3.6.1',
    titulo: 'Isaura presenta',
    flagDeSalida: 'escena_3_6_1_vista',
    flagsRequeridos: {'escena_3_5_4_vista'},
    ambiente: AmbienteArchivo.despachoIsaura,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Despacho de Isaura, principios de mayo. Una carpeta '
            'gruesa sobre la mesa — la carpeta de la Brecha. Maren '
            'entra. Isaura le señala una silla.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Es tu hora.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Ya.'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Antes de empezar, quiero contarte yo lo que pasó. Tú '
            'tendrás tu propia lectura. Pero conoce primero la mía '
            'y la suya.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Isaura abre la carpeta. Saca tres documentos antiguos '
            '— actas del Concejo de Tudela del 1378 y del 1379, '
            'fragmento de un padrón judío anterior, una carta '
            'posterior.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'En noviembre de 1378, el barrio judío de Tudela ardió '
            'en una noche. Murieron al menos dieciocho personas, '
            'según lo que se documenta. Cuatro casas destruidas '
            'completas, otras siete dañadas. La sinagoga sufrió '
            'daños menores.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Quién lo provocó?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Las actas del Concejo del día siguiente lo atribuyen '
            'a "personas no identificadas, ajenas a la comunidad '
            'cristiana de la villa". El padrón judío posterior — '
            'incompleto — registra las muertes. Una carta de un '
            'superviviente a un correligionario de Zaragoza, '
            'dieciocho meses después, habla de "los señores del '
            'Concejo que callaron tres semanas antes y no callaron '
            'tres semanas después".',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Entonces hubo complicidad institucional.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Esa es la pregunta. Yo digo: Probable. Hay indicios '
            'sólidos pero no documentación directa.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Y Tasio?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Sólido. E identifica por nombre a tres miembros del '
            'Concejo del 1378 como responsables de la complicidad '
            'activa.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Sobre qué evidencia?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Sobre la carta del superviviente, sobre correlación '
            'entre presencias documentadas en sesiones del Concejo '
            'previas, y sobre un fragmento de testimonio recogido '
            'por la Inquisición seis años después de un converso '
            'que mencionaba a uno de los tres.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Qué dijiste tú al respecto?',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Que la evidencia de Tasio era circunstancial. Que la '
            'correlación de presencias no es prueba. Que el '
            'testimonio inquisitorial es de fuente mediada y '
            'posiblemente extraído bajo presión. Que para identificar '
            'nominalmente a personas como responsables de un '
            'asesinato colectivo hace falta más.',
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Tasio pensó que yo era cobarde.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Lo eras?'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Pausa muy larga.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'No lo sé. Lo que sé es que prefiero quedarme en '
            'Probable que afirmar Sólido lo que es sólo Probable.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Lo que también sé es que mi prudencia tuvo precio: la '
            'versión de Resolutiva tomó tracción pública, fue citada '
            'por una asociación judía internacional para una demanda '
            'simbólica, y mi versión más cauta quedó como "la '
            'institución que no quería molestar".',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Eso te dolió?',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Y aún así mantienes tu versión?',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Sí.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Isaura empuja la carpeta hacia Maren.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Maren. Te paso la carpeta. Tienes seis semanas. '
            'Trabaja con todo el material. Habla con Karim si '
            'necesitas. Habla conmigo si quieres. Habla con Tasio '
            'si necesitas — yo no te lo pido, pero no te lo '
            'prohíbo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Vale.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Llega a tu propia versión. Sin imitar la mía, sin '
            'imitar la suya. Y defiéndela.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Y si no llego a una propia?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Entonces lo declaras. "He revisado el material. He '
            'visto los argumentos de las dos versiones. No tengo '
            'elementos para llegar a una tercera. Mi conclusión '
            'es que se mantiene la disputa."',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Eso es válido?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Sí. Pero raramente sucede que una Cronista joven con '
            'perspectiva fresca no encuentre nada nuevo.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Y otra cosa.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Sí?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'El Concilio de cierre va a ser amplio. Begoña, yo, '
            'Aitor, Joana, Karim, Marina como observadora. Y Karim '
            'ha pedido invitar a Tasio como observador externo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Aceptamos?',
        pausaPrevia: Duration(milliseconds: 1800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Begoña ha aceptado. Yo apoyé.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Por qué?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Porque tú tienes que defender tu versión ante todos '
            'los oídos que existen. Si no la sostienes con Tasio '
            'mirando, no la has sostenido del todo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Vale.',
        pausaPrevia: Duration(milliseconds: 2000),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren coge la carpeta. Pesa.',
      ),
    ],
  );

  /// 3.6.2 — *Las fuentes de 1378*. Las semanas siguientes en el
  /// Archivo, Mesa de Trabajo. Maren trabaja durante semanas con
  /// las ocho fuentes catalogadas: actas del Concejo, padrón
  /// parcial de la judería anterior al incendio, carta del
  /// superviviente a un correligionario de Zaragoza, fragmento de
  /// testimonio inquisitorial, correspondencia de la Corona del
  /// rey Carlos II, restos arqueológicos del barrio (excavación
  /// del s. XX, niveles de incendio identificados), comparación
  /// con casos análogos peninsulares (Sevilla 1391, Toledo) y las
  /// dos reconstrucciones publicadas previas (Isaura 2017,
  /// Tasio/Resolutiva 2021). Voz del Cuaderno articulando el
  /// descubrimiento del silencio de tres semanas en las actas
  /// posteriores como afirmación independiente. Doc 09 §3.6.2.
  static const EscenaCinematica lasFuentesDe1378 = EscenaCinematica(
    id: '3.6.2',
    titulo: 'Las fuentes de 1378',
    flagDeSalida: 'escena_3_6_2_vista',
    flagsRequeridos: {'escena_3_6_1_vista'},
    ambiente: AmbienteArchivo.mesaTrabajoArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Mesa de Trabajo del Archivo. Maren tiene la carpeta '
            'abierta y ocho montones de material distribuidos sobre '
            'la mesa: actas del Concejo del periodo, padrón parcial '
            'de la judería, carta del superviviente, fragmento de '
            'testimonio inquisitorial, correspondencia del rey '
            'Carlos II al Concejo, informes arqueológicos del '
            'barrio, comparación con casos peninsulares del s. XIV, '
            'y las dos reconstrucciones publicadas previas.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Pasa horas anotando. La interfaz le permite organizar, '
            'comparar, anotar. La Mesa guarda sus revisiones día a '
            'día.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Día cuatro. Tasio tiene razón en una cosa. La '
            'correlación de presencias en sesiones del Concejo '
            'previas al incendio NO es prueba — pero tampoco es '
            'nada. Las tres personas que él identifica estuvieron '
            'presentes en las tres sesiones donde se discutió "el '
            'problema judío" en el mes anterior. Eso no es probable '
            'que sea casual.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Maren cierra los ojos un segundo.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Día once. Pero también tiene razón Isaura. El '
            'testimonio inquisitorial de seis años después es '
            'problemático. El converso que lo da podría haber '
            'dicho lo que el inquisidor quería oír, podría tener '
            'motivos personales contra los acusados, podría '
            'confundir lo que vio.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Día dieciocho. Hay algo que ninguno de los dos dice. '
            'Las actas del Concejo posteriores al incendio. Isaura '
            'las usa. Tasio también. Pero ninguno comenta lo que '
            'llevan tres semanas sin tratar.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Maren se levanta. Camina por la sala. Vuelve a la '
            'mesa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Día veintidós. Las actas posteriores al incendio dejan '
            'de mencionar al barrio judío durante tres semanas '
            'completas. Cuando lo retoman, lo hacen en términos '
            'administrativos burocráticos. Eso es silencio anómalo. '
            'Las actas anteriores discutían "el problema judío" '
            'cada dos sesiones. Después del incendio: nada durante '
            'tres semanas.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'El silencio es información.',
        pausaPrevia: Duration(milliseconds: 1800),
      ),
    ],
  );

  /// 3.6.3 — *Viaje a Tudela*. Tras tres semanas de trabajo en el
  /// Archivo. Maren e Isaura van juntas esta vez al lugar de la
  /// Brecha. Conversación escasa en el coche — las dos saben qué
  /// van a ver. Isaura le da la opción de hablar con Tasio si
  /// aparece en la cafetería; Tasio no aparece. Doc 09 §3.6.3.
  static const EscenaCinematica viajeATudela = EscenaCinematica(
    id: '3.6.3',
    titulo: 'Viaje a Tudela',
    flagDeSalida: 'escena_3_6_3_vista',
    flagsRequeridos: {'escena_3_6_2_vista'},
    ambiente: AmbienteArchivo.cocheIsaura,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'El coche de Isaura camino a Tudela. Esta vez Maren '
            'no va con Aitor — va con Isaura. La conversación es '
            'escasa.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Ya conoces la cafetería.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Sí.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Si Tasio aparece, di lo que tengas que decir.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Tasio no aparece. Maren e Isaura visitan la antigua '
            'judería sin interrupciones.',
      ),
    ],
  );

  /// 3.6.4 — *El barrio*. Antigua judería de Tudela, calles del
  /// casco viejo. Maren e Isaura caminan por las calles que
  /// fueron la judería. Una placa moderna identifica la zona, la
  /// sinagoga ya no existe. Plaza pequeña que pudo haber sido
  /// espacio comunitario. Una piedra grabada con caracteres
  /// hebreos parcialmente borrados, reutilizada en una pared
  /// posterior. Maren formula la pregunta del peso de cerrar
  /// versión: *"si yo cierro mi versión, ¿lo sabrá más gente?"*.
  /// Doc 09 §3.6.4.
  static const EscenaCinematica elBarrioJuderia = EscenaCinematica(
    id: '3.6.4',
    titulo: 'El barrio',
    flagDeSalida: 'escena_3_6_4_vista',
    flagsRequeridos: {'escena_3_6_3_vista'},
    ambiente: AmbienteArchivo.juderiaTudela,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Antigua judería de Tudela. Calles estrechas del casco '
            'viejo. Una placa moderna identifica la zona — "Antiguo '
            'barrio judío de Tudela". La sinagoga histórica ya no '
            'existe. Hay una plaza pequeña que pudo haber sido un '
            'espacio comunitario.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren camina despacio. Mira los muros. Algunos '
            'fragmentos antiguos visibles. Una piedra grabada con '
            'caracteres hebreos parcialmente borrados, reutilizada '
            'en una pared posterior.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Aquí pasó.'),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Aquí pasó.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Pausa larga.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Hace seis siglos y medio.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'La gente que pasa por aquí no lo sabe.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'La mayoría no.'),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Si yo cierro mi versión, ¿lo sabrá más gente?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Algo más. No mucho. La Brecha es académica. Pero todo '
            'cierre tiene resonancia, aunque modesta.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Vale.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
    ],
  );

  /// 3.6.5 — *Conversación con Karim*. Días después en la
  /// cafetería del Archivo. Maren le pasa a Karim el avance de su
  /// reconstrucción. Karim lee con atención y se centra en la
  /// afirmación cuatro — el silencio de tres semanas en las
  /// actas posteriores como afirmación independiente, dato
  /// declarado en sí mismo. *"Esto no lo dice ni Isaura ni
  /// Tasio. Eso es lo que estaba esperando que alguien dijera
  /// desde 2021."* Karim le da el método para defender la
  /// solidez (recuento del patrón anterior + posterior). Avisa
  /// que Tasio asistirá al Concilio como observador, sentado al
  /// fondo, sin derecho a hablar. Doc 09 §3.6.5.
  static const EscenaCinematica conversacionConKarim = EscenaCinematica(
    id: '3.6.5',
    titulo: 'Conversación con Karim',
    flagDeSalida: 'escena_3_6_5_vista',
    flagsRequeridos: {'escena_3_6_4_vista'},
    ambiente: AmbienteArchivo.cafeteriaArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Cafetería del Archivo, días después. Maren ha pedido '
            'a Karim que la vea. Le pasa el avance de su '
            'reconstrucción. Karim lee.',
      ),
      PlanoDialogo(voz: VozPersonaje.karim, texto: 'Tu afirmación cuatro.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            '"El silencio de tres semanas en las actas posteriores '
            'al incendio es información sobre la complicidad '
            'institucional, declarado como dato en sí mismo."',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: 'Esto no lo dice ni Isaura ni Tasio.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'No.'),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: '¿Por qué crees que no lo dicen?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Porque los dos discuten sobre **qué pasó** en la '
            'noche del incendio y en los días previos. La pregunta '
            'de qué pasó después — institucionalmente — no la '
            'formulan ninguno como Brecha propia.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: 'Y tú la formulas como afirmación dentro de la tuya.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Eso es lo que estaba esperando que alguien dijera desde '
            '2021.',
        pausaPrevia: Duration(milliseconds: 2000),
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 2000)),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Maren. Esa afirmación cuatro va a ser tu escudo y tu '
            'blanco. Los Anclados te van a preguntar cómo argumentas '
            'que el silencio de tres semanas es Sólido y no '
            'Probable. Tasio se va a alegrar pero también va a '
            'querer empujarte más allá.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Cómo defiendo la solidez?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Comparas con el patrón anterior. ¿Cuántas veces en los '
            'seis meses anteriores el Concejo trató asuntos del '
            'barrio judío?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Lo cuento.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Y comparas con el patrón posterior. ¿Cuándo retoman? '
            '¿En qué términos?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Ya lo tengo.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoDialogo(voz: VozPersonaje.karim, texto: 'Entonces es Sólido.'),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(voz: VozPersonaje.karim, texto: 'Una cosa más.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: 'Tasio está invitado al Concilio. Lo sabes.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Le voy a recibir yo. Le voy a sentar al fondo. No va '
            'a poder hacer preguntas. Sólo escuchar.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Si en cualquier momento te incomoda su presencia, me '
            'avisas con la mirada y le pido salir.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'No va a hacer falta.'),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto: 'Eso espero. Pero te lo digo por si acaso.',
      ),
    ],
  );

  /// 3.6.6 — *La cuarta afirmación*. Mesa de Trabajo. Maren
  /// prepara el análisis comparativo del patrón. Recuento de
  /// menciones del barrio judío en actas del Concejo en los seis
  /// meses anteriores: cada dos sesiones, total 14 menciones.
  /// Recuento del periodo posterior al incendio: 0 menciones
  /// durante 21 días. Cuando retoman: una sola mención, en
  /// términos burocráticos sobre tasas pendientes, sin referencia
  /// al incendio. Voz del Cuaderno articulando la solidez del
  /// silencio. Doc 09 §3.6.6.
  static const EscenaCinematica laCuartaAfirmacion = EscenaCinematica(
    id: '3.6.6',
    titulo: 'La cuarta afirmación',
    flagDeSalida: 'escena_3_6_6_vista',
    flagsRequeridos: {'escena_3_6_5_vista'},
    ambiente: AmbienteArchivo.mesaTrabajoArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Mesa de Trabajo. Maren prepara el análisis comparativo '
            'del patrón. Recuento de menciones del barrio judío en '
            'las actas del Concejo en los seis meses anteriores: '
            'cada dos sesiones, total catorce menciones, sobre '
            'temas variados — impuestos, conflictos comerciales '
            'menores, "el problema" en términos retóricos.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Recuento del periodo posterior al incendio: cero '
            'menciones durante veintiún días. Cuando retoman: una '
            'sola mención, en términos burocráticos sobre tasas '
            'pendientes, sin referencia al incendio.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'El silencio es Sólido.',
        pausaPrevia: Duration(milliseconds: 1800),
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Lo que no sé es si el silencio refleja vergüenza, '
            'complicidad activa, o simplemente no sabían qué decir. '
            'Pero el silencio en sí mismo está documentado.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Tres semanas de no decir nada sobre algo de lo que '
            'llevaban seis meses hablando cada quince días.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
    ],
  );

  /// 3.6.7 — *Reconstrucción final*. Mesa de Trabajo. Maren
  /// produce las nueve afirmaciones canónicas de su versión:
  /// hecho del incendio (Sólido), carta del superviviente (Sólido
  /// como fuente, interpretativo Probable), correlación de
  /// presencias (Sólido como correlación, Probable como
  /// implicación), silencio de tres semanas como dato (Sólido
  /// — la afirmación nueva), complicidad institucional como
  /// categoría general (Sólido) con forma específica (Probable
  /// sin discriminar), identificación nominal de tres miembros
  /// (Disputado), testimonio inquisitorial como caracterización
  /// metodológica (Sólido), declaración de estado de la Brecha
  /// (Sólido), nombres de víctimas como tarea pendiente (Sólido).
  /// Añade nombres parciales conservados de cuatro víctimas. Voz
  /// del Cuaderno cerrando: *"No es lo que Tasio quería. No es
  /// exactamente lo que Isaura defendió. Es mío."* Doc 09 §3.6.7.
  static const EscenaCinematica reconstruccionFinal = EscenaCinematica(
    id: '3.6.7',
    titulo: 'Reconstrucción final',
    flagDeSalida: 'escena_3_6_7_vista',
    flagsRequeridos: {'brecha_3_6_completada'},
    ambiente: AmbienteArchivo.mesaTrabajoArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Mesa de Trabajo. La reconstrucción final de Maren tiene '
            'nueve afirmaciones articuladas con sus anclajes. Las '
            'va escribiendo a limpio.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Una. El incendio del barrio judío de Tudela en noviembre '
            'de 1378, con al menos dieciocho víctimas mortales '
            'documentadas. Sólido.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Dos. La carta del superviviente identifica un patrón de '
            '"callar antes y no callar después" entre algunos miembros '
            'del Concejo. Sólido la fuente; la interpretación '
            'específica de qué actores requiere otras fuentes '
            'corroboradoras.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Tres. La correlación de presencias en sesiones previas '
            'identifica a tres miembros con presencia continua. '
            'Sólido la correlación; Probable la implicación directa.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Cuatro. El silencio de tres semanas en las actas '
            'posteriores al incendio, en contraste con el patrón '
            'previo, es información sobre la postura institucional '
            'del Concejo y constituye dato en sí mismo. Sólido.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Cinco. La complicidad institucional como categoría '
            'general — Sólido. La forma específica (orden directa, '
            'pacto silencioso, omisión deliberada) — Probable sin '
            'posibilidad actual de discriminar.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Seis. La identificación nominal de los tres miembros '
            'señalados por Tasio — Disputado. La evidencia sostiene '
            'sospecha razonable pero no determinación nominativa con '
            'la confianza que el oficio requiere para nombrar a '
            'personas en relación a un asesinato colectivo.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Siete. El testimonio inquisitorial de seis años después '
            'es fuente mediada con sesgo del productor (inquisidor) '
            'y posibles motivaciones del declarante (converso). '
            'Sólido como caracterización metodológica.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Ocho. La Brecha sigue siendo, tras seiscientos cincuenta '
            'años, una herida histórica abierta. La identificación '
            'nominativa queda Disputada y reabierta. Sólido como '
            'declaración de estado.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Nueve. Las víctimas merecen ser reconocidas con nombre '
            'cuando sea posible. El padrón parcial conserva nombres '
            'incompletos. Maren añade los cuatro nombres parcialmente '
            'conservados — un Mosé ben con apellido fragmentado, una '
            'Dueña con apellido perdido, un niño Yosef con '
            'identificación parcial, una mujer Esther con casa '
            'identificada. Sólido como tarea pendiente.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'No he resuelto la Brecha.',
        pausaPrevia: Duration(milliseconds: 1800),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'He añadido lo que podía añadir.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Lo que añado es: el silencio posterior es dato. Y los '
            'nombres de las víctimas son tarea pendiente.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'No es lo que Tasio quería. No es exactamente lo que '
            'Isaura defendió. Es mío.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
    ],
  );

  /// 3.6.8 — *El Concilio del incendio*. Una semana después.
  /// Salón del Concilio del Archivo, sala más llena de lo
  /// habitual. Begoña preside. Isaura, Aitor, Joana, Karim,
  /// Marina como observadora, Maren. Tasio asiste como observador
  /// externo, sentado al fondo, sin derecho a hablar durante el
  /// Concilio formal. Maren presenta veinte minutos. Las nueve
  /// afirmaciones con sus anclajes. Joana cuestiona el Sólido
  /// de la cuatro; Aitor reconoce la metodología nueva en la
  /// cinco; Karim aprueba la nueve; Begoña pregunta al final
  /// si la reconstrucción está "haciendo encaje" entre las dos
  /// versiones, Maren responde con cinco segundos de pausa y
  /// argumenta sin concesiones. Sello unánime. Begoña anuncia
  /// "Aprendiz III". Doc 09 §3.6.8.
  static const EscenaCinematica elConcilioDelIncendio = EscenaCinematica(
    id: '3.6.8',
    titulo: 'El Concilio del incendio',
    flagDeSalida: 'escena_3_6_8_vista',
    flagsRequeridos: {'escena_3_6_7_vista'},
    ambiente: AmbienteArchivo.salonConcilio,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Salón del Concilio del Archivo, una semana después. '
            'Sala más llena de lo habitual. Begoña preside. Isaura, '
            'Aitor, Joana, Karim, Marina como observadora, Maren. '
            'Tasio al fondo, sentado en una silla que normalmente '
            'no se usa.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura:
            'Maren entra. Saluda con la cabeza. Le hace un '
            'asentimiento mínimo a Tasio cuando entra. Él le hace '
            'otro. Isaura está en su sitio habitual.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto:
            'Maren Lozano, Aprendiz II. Brecha del incendio de la '
            'judería de Tudela de 1378. Adelante.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren presenta. Veinte minutos. Las nueve afirmaciones, '
            'con anclajes y niveles de confianza. Cuando termina la '
            'afirmación cuatro — el silencio de tres semanas — '
            'Marina al fondo asiente sin querer. Karim cierra los '
            'ojos un segundo. Cuando termina la afirmación seis — '
            'el Disputado sobre la identificación nominativa — '
            'Tasio al fondo no se mueve.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Termina. Pausa. Begoña abre las preguntas.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.joana,
        texto:
            'Tu afirmación cuatro. La declaras Sólido. ¿Por qué '
            'Sólido y no Probable?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Porque la documentación es directa. Las actas existen, '
            'el silencio existe en ellas, el contraste con el patrón '
            'anterior es cuantificable. Lo que es interpretativo — '
            'qué significa el silencio — lo declaro Probable o '
            'Disputado en otras afirmaciones. La existencia del '
            'silencio en sí, declarable como dato, es Sólido.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(voz: VozPersonaje.joana, texto: 'Bien.'),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto:
            'Tu afirmación cinco — complicidad institucional como '
            'afirmación general Sólido. Haces algo que no se hacía '
            'antes: afirmar Sólido la categoría general y dejar '
            'Probable la forma específica. ¿Por qué crees que esa '
            'distinción es honesta?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Porque la evidencia disponible — silencio posterior + '
            'correlación de presencias + carta del superviviente + '
            'testimonio inquisitorial — converge en algo. Lo que '
            'converge — la categoría general "hubo complicidad '
            'institucional" — está mejor sostenido que cualquiera '
            'de las formas específicas. Cada forma específica tiene '
            'evidencia parcial. La categoría general tiene evidencia '
            'múltiple convergente.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.aitor,
        texto: 'Eso es nueva metodología.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'No es nueva. Es declarar honestamente lo que las '
            'fuentes permiten declarar.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.karim,
        texto:
            'Tu afirmación nueve — los nombres de las víctimas como '
            'tarea pendiente. ¿Por qué la incluyes?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Porque sin ella la Brecha trata el incendio como '
            'acontecimiento histórico abstracto. Las víctimas tenían '
            'nombres. Algunos los conservamos parcialmente. '
            'Reconocerlos es parte del oficio. Y declarar que los '
            'desconocidos son tarea pendiente es declarar que el '
            'oficio sigue.',
      ),
      PlanoDialogo(voz: VozPersonaje.karim, texto: 'Bien.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Pausa larga. Begoña no ha hablado todavía.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto: 'Una pregunta para terminar.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto:
            'Tu reconstrucción defiende posiciones más sólidas que '
            'las dos anteriores publicadas en algunos puntos, y '
            'posiciones más cautas en otros. ¿Cómo respondes a quien '
            'te diga que estás "haciendo encaje" entre las dos '
            'versiones para parecer original?',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren tarda mucho en responder. Cinco segundos. Tasio '
            'al fondo no se mueve.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Que cada afirmación tiene su anclaje propio. Que la '
            'afirmación cuatro — el silencio de tres semanas — no '
            'la contiene ninguna de las dos versiones anteriores. '
            'Que la afirmación cinco — la categoría general como '
            'Sólido — es un nivel intermedio que ni Isaura ni Tasio '
            'formularon. Que mi reconstrucción no encaja entre las '
            'dos: extiende el debate añadiendo un dato que ambas '
            'versiones tenían disponible y ninguna usó como '
            'afirmación independiente.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto: '¿Y si te dicen que estás siendo presuntuosa?',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto:
            'Que me lo demuestren mostrando que el silencio posterior '
            'no es dato.',
        pausaPrevia: Duration(milliseconds: 2200),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Pausa larga. Begoña la mira. Diez segundos. Después '
            'mira a los demás.',
      ),
      PlanoDialogo(voz: VozPersonaje.begona, texto: '¿Comentarios para sellar?'),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Sello.'),
      PlanoDialogo(voz: VozPersonaje.karim, texto: 'Sello.'),
      PlanoDialogo(voz: VozPersonaje.joana, texto: 'Sello.'),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: 'Sello.'),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto: 'Sellada.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.begona,
        texto: 'Aprendiz III.',
        pausaPrevia: Duration(milliseconds: 2000),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Maren no se mueve durante un segundo. Después asiente. '
            'Se le humedecen los ojos un poquito — no llora pero '
            'está cerca. Lo controla. Tasio al fondo asiente '
            'solemnemente. Karim lo ve, nadie más.',
      ),
      PlanoDialogo(voz: VozPersonaje.begona, texto: 'Cierre.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Empiezan a levantarse. Maren se queda quieta. Marina '
            'viene a darle un abrazo breve, no protocolario. Karim '
            'va al fondo a hablar con Tasio. Aitor se acerca a '
            'Maren.',
      ),
      PlanoDialogo(voz: VozPersonaje.aitor, texto: 'Bien.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Gracias.',
        pausaPrevia: Duration(milliseconds: 1000),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Aitor se va. Isaura no se acerca. La mira desde su '
            'sitio. Dos segundos. Asiente. Sale. Maren se queda en '
            'el salón vacío. Después sale al pasillo.',
      ),
    ],
  );

  /// 3.6.9 — *Tasio al salir*. Pasillo del Archivo cerca de la
  /// salida. Tasio se acerca a Maren. *"La afirmación cuatro
  /// está bien."* / *"Sigo pensando que las otras conclusiones
  /// se quedan cortas. Pero la cuatro la doy."* En la puerta del
  /// Archivo, antes de salir: *"Cuando te gradúes, hablamos."*
  /// Karim se acerca a Maren tras la salida de Tasio. Doc 09 §3.6.9.
  static const EscenaCinematica tasioAlSalir = EscenaCinematica(
    id: '3.6.9',
    titulo: 'Tasio al salir',
    flagDeSalida: 'escena_3_6_9_vista',
    flagsRequeridos: {'escena_3_6_8_vista'},
    ambiente: AmbienteArchivo.pasilloArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Pasillo del Archivo cerca de la salida. Maren camina '
            'hacia la puerta. Tasio está cerca, hablando con Karim '
            'en voz baja. Cuando ve a Maren, deja a Karim. Se '
            'acerca.',
      ),
      PlanoDialogo(voz: VozPersonaje.tasio, texto: 'Maren.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Sí.'),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: 'La afirmación cuatro está bien.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Gracias.',
        pausaPrevia: Duration(milliseconds: 1200),
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: 'No me des las gracias. La construiste tú.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto:
            'Sigo pensando que las otras conclusiones se quedan '
            'cortas.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Lo sé.'),
      PlanoDialogo(voz: VozPersonaje.tasio, texto: 'Pero la cuatro la doy.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Tasio asiente brevemente. Se gira para irse. En la '
            'puerta del Archivo, antes de salir, se vuelve.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.tasio,
        texto: 'Cuando te gradúes, hablamos.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Sale. Karim se acerca a Maren.',
      ),
      PlanoDialogo(voz: VozPersonaje.karim, texto: '¿Estás bien?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Sí.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(voz: VozPersonaje.karim, texto: 'Has estado.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Karim asiente y se aleja. Maren se queda en el pasillo. '
            'La cámara se queda con ella unos segundos. Después '
            'corta.',
      ),
    ],
  );

  /// 3.6.10 — *El silencio segundo*. Esa noche, casa de Maren.
  /// Maren se ducha durante mucho tiempo. Después en su
  /// habitación. Toalla en el pelo. Pijama. El cuaderno cerrado.
  /// Lo abre. Voz del Cuaderno escribiendo: *"Tasio dijo 'cuando
  /// te gradúes, hablamos.' No le he dicho nada a Isaura. Tampoco
  /// lo voy a decir esta noche. Lo que sí voy a decir es que Tasio
  /// me ha tratado bien las dos veces. Y Karim ha tenido razón al
  /// invitarlo. Begoña ha aceptado bien también. Algo de lo que
  /// pasó hoy va a estar en mi cabeza durante mucho tiempo. Y la
  /// frase de Tasio del primer día — 'no la fuerces pero no la
  /// evites' — la entiendo ahora."* Cierra el cuaderno. Apaga la
  /// luz. Negro. Doc 09 §3.6.10.
  static const EscenaCinematica elSilencioSegundo = EscenaCinematica(
    id: '3.6.10',
    titulo: 'El silencio segundo',
    flagDeSalida: 'escena_3_6_10_vista',
    flagsRequeridos: {'escena_3_6_9_vista'},
    ambiente: AmbienteArchivo.cuartoCasaMaren,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Casa de Maren, esa noche. Audio: agua corriendo durante '
            'un minuto largo. Después el agua se cierra.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren en su habitación. Toalla en el pelo. Pijama. Se '
            'sienta en la mesa. El cuaderno cerrado. Lo abre. Una '
            'página en blanco. Coge el bolígrafo. Empieza a escribir.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto: 'Tasio dijo "cuando te gradúes, hablamos."',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'No le he dicho nada a Isaura. Tampoco lo voy a decir '
            'esta noche.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Lo que sí voy a decir, aunque sea sólo a este cuaderno: '
            'Tasio me ha tratado bien las dos veces. Y Karim ha '
            'tenido razón al invitarlo. Begoña ha aceptado bien '
            'también.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Algo de lo que pasó hoy va a estar en mi cabeza durante '
            'mucho tiempo.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.vozDeFuente,
        texto:
            'Y la frase de Tasio del primer día — "no la fuerces '
            'pero no la evites" — la entiendo ahora.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Cierra el cuaderno. Apaga la luz. Negro.',
      ),
    ],
  );

  /// M3.entrega — *Andrés en el ático*. Maren entrega su Mosaico
  /// del Arco 3 (ficha de museo con cartela de la piedra grabada
  /// del barrio mudéjar de Tudela) a Andrés en el ático del
  /// Archivo. Andrés la archiva sin decir nada. Antes de que Maren
  /// se vaya, le pregunta sólo *"¿La piedra existe?"* — Maren
  /// confirma que está en el muro y que la fotografió. Andrés
  /// cierra: *"Bien. La gente que pase por allí ya sabe que hay
  /// alguien que la mira con respeto."* Reconocimiento por gesto
  /// pequeño paralelo al M1.entrega y M2.entrega. Doc 09 §M3.
  static const EscenaCinematica entregaDelMosaicoM3 = EscenaCinematica(
    id: 'M3.entrega',
    titulo: 'Andrés en el ático',
    flagDeSalida: 'escena_m_3_entrega_vista',
    flagsRequeridos: {'mosaico_arco_3_entregado'},
    ambiente: AmbienteArchivo.aticoArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Ático del Archivo. Mesa de trabajo de Andrés. Maren '
            'entra con la cartela impresa y una foto de la piedra '
            'del muro de Tudela.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Te traigo el Mosaico del arco.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Andrés coge la cartela. La lee despacio. La foto. La '
            'archiva en una carpeta sin decir nada. Antes de que '
            'Maren se vaya, levanta la cabeza.',
      ),
      PlanoDialogo(voz: VozPersonaje.andres, texto: '¿La piedra existe?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Está en el muro. Sigue ahí. La fotografié.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Andrés sonríe brevemente.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.andres,
        texto:
            'Bien. La gente que pase por allí ya sabe que hay '
            'alguien que la mira con respeto.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Maren asiente. Sale del ático. Andrés sigue trabajando '
            'en silencio.',
      ),
    ],
  );

  /// 3.Z — *Aprendiz III*. Días después de la entrega del Mosaico
  /// M3. Patio del Archivo, junto al brocal del pozo. Sábado por
  /// la tarde. Maren ha pasado a por unos libros. Isaura está en
  /// el banco. Maren se sienta a su lado. *"Aprendiz III." / "Sí."
  /// / "Has cerrado el arco más difícil del MVP. Lo que viene es
  /// más corto. Más reposado." / "¿Olite?" / "Olite. Y la antesala
  /// de 1512." / "Sin Brecha de la conquista." / "Sin Brecha de
  /// la conquista. Eso es para cuando seas mayor."* Maren cuenta
  /// a Isaura el "cuando te gradúes, hablamos" de Tasio; Isaura
  /// dice que lo sospechaba. *"¿Y si no decido bien?" / "No hay
  /// decidir bien o mal. Hay decidir con honestidad."* Cierre con
  /// el patio, el capitel del s. XII, el brocal, el sol oblicuo
  /// de mayo. APRENDIZ III flotante. Anuncio del Arco 4 *Una corte
  /// brillante en su crepúsculo*. Doc 09 §3.Z.
  static const EscenaCinematica aprendizIII = EscenaCinematica(
    id: '3.Z',
    titulo: 'Aprendiz III',
    flagDeSalida: 'escena_3_z_vista',
    flagsRequeridos: {'escena_m_3_entrega_vista'},
    ambiente: AmbienteArchivo.patioArchivo,
    planos: [
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Patio del Archivo, junto al brocal del pozo. Sábado '
            'por la tarde. Maren ha pasado por el Archivo a por '
            'unos libros. Isaura está en el banco. Maren se sienta '
            'a su lado.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Aprendiz III.'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Sí.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Has cerrado el arco más difícil del MVP. Lo que viene '
            'es más corto. Más reposado.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Olite?'),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: 'Olite. Y la antesala de 1512.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Sin Brecha de la conquista.',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'Sin Brecha de la conquista. Eso es para cuando seas '
            'mayor.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 3),
        textoLectura: 'Pausa larga.',
      ),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Isaura.'),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: '¿Sí?'),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Tasio dijo "cuando te gradúes, hablamos".',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura:
            'Pausa muy larga. Isaura no contesta inmediatamente.',
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Lo dijo.'),
      PlanoDialogo(voz: VozPersonaje.maren, texto: '¿Tú lo sabías?'),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Lo sospechaba.'),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Qué hago?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'No tienes que decidir ahora. Te queda un arco. Decides '
            'después de graduarte.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: '¿Y si no decido bien?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto:
            'No hay decidir bien o mal. Hay decidir con honestidad. '
            'Lo que sea con honestidad será bien.',
        pausaPrevia: Duration(milliseconds: 2000),
      ),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(voz: VozPersonaje.maren, texto: 'Vale.'),
      PlanoAmbiente(duracion: Duration(milliseconds: 1500)),
      PlanoDialogo(
        voz: VozPersonaje.isaura,
        texto: '¿Te trata bien Tasio?',
      ),
      PlanoDialogo(
        voz: VozPersonaje.maren,
        texto: 'Sí.',
        pausaPrevia: Duration(milliseconds: 1500),
      ),
      PlanoDialogo(voz: VozPersonaje.isaura, texto: 'Bien.'),
      PlanoAmbiente(
        duracion: Duration(seconds: 6),
        textoLectura:
            'Las dos se quedan sentadas. La cámara se aleja. El '
            'capitel del s. XII en el patio. El brocal del pozo. '
            'El sol de mayo entrando oblicuo. Tres segundos sin '
            'diálogo.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 4),
        textoLectura: 'Aparece flotante: APRENDIZ III.',
      ),
      PlanoAmbiente(
        duracion: Duration(seconds: 5),
        textoLectura:
            'Música breve. Negro extendido. Una línea de texto: '
            '"Continuará en Arco 4 — Una corte brillante en su '
            'crepúsculo."',
      ),
    ],
  );
}
