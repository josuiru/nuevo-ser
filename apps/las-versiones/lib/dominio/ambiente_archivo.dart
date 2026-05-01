import 'package:nuevo_ser_core/nuevo_ser_core.dart';

/// Ambiente atmosférico de una escena de Las Versiones. Implementa el
/// contrato genérico [AmbienteEscenaContrato] del core para que el
/// player de cinemáticas lo transporte sin conocer su pintura — el
/// `CustomPainter` específico del juego lo recibe y decide cómo
/// renderizarlo.
///
/// **Provisional**: por ahora cada ambiente lleva sólo una etiqueta
/// estable (`identificador`) que el pintor puede consumir como `switch`.
/// Cuando se aborde la fase visual del juego (doc 11 + 13), esta clase
/// crecerá con campos pictóricos concretos (densidad de polvo, tono de
/// luz, intensidad de viento, ruido de papel…) — el patrón ya está
/// validado por `AmbienteCielo` en Uno Roto.
///
/// Los ambientes catalogados aquí cubren los espacios principales
/// previstos por la worldbuilding (doc 05): la sala de evaluación
/// donde Maren defiende sus reconstrucciones, el Archivo nocturno
/// donde trabaja con manuscritos, una sierra al amanecer (paisaje
/// recurrente del valle), el interior de una cueva (Brecha
/// arqueológica de la capa Cueva-Pirineo). Los juegos pueden añadir
/// más instancias `static const` sin tocar este archivo.
class AmbienteArchivo implements AmbienteEscenaContrato {
  /// Etiqueta estable que el pintor del juego usará como discriminador.
  /// Castellano, snake_case (`sala_evaluacion`, `archivo_nocturno`).
  final String identificador;

  const AmbienteArchivo._(this.identificador);

  /// Sala de evaluación del Archivo — mesa larga, luz cenital,
  /// sillas. El espacio del Concilio y de la primera entrevista de
  /// Maren con Isaura (doc 07 §1.0).
  static const AmbienteArchivo salaEvaluacion =
      AmbienteArchivo._('sala_evaluacion');

  /// Archivo nocturno — estanterías, polvo, velas. Donde Maren pasa
  /// las horas con manuscritos cuando nadie la mira.
  static const AmbienteArchivo archivoNocturno =
      AmbienteArchivo._('archivo_nocturno');

  /// Sierra al amanecer — paisaje exterior del valle, luz horizontal,
  /// niebla de mañana. Recurrente en transiciones entre Brechas.
  static const AmbienteArchivo sierraAmanecer =
      AmbienteArchivo._('sierra_amanecer');

  /// Interior de cueva — primera Brecha del MVP (capa Cueva-Pirineo,
  /// ya validada por el comité asesor histórico). Roca, humedad,
  /// hueco de luz lejano.
  static const AmbienteArchivo cuevaInterior =
      AmbienteArchivo._('cueva_interior');

  /// Patio interior del Archivo — capiteles antiguos, brocal de un
  /// pozo, cielo abierto sobre el claustro. Espacio de transición
  /// entre estancias durante el recorrido del primer día (1.0.2).
  static const AmbienteArchivo patioArchivo =
      AmbienteArchivo._('patio_archivo');

  /// Ático del Archivo — vitrinas con piezas, mesa de trabajo de
  /// Andrés Vidaurre. Donde se guardan los objetos físicos.
  static const AmbienteArchivo aticoArchivo =
      AmbienteArchivo._('atico_archivo');

  /// Salón del Concilio — mesa larga, tres sillones de orejas en
  /// cabecera. Lugar de presentación del trabajo final de cada
  /// arco. Maren se queda en la puerta sin entrar la primera vez.
  static const AmbienteArchivo salonConcilio =
      AmbienteArchivo._('salon_concilio');

  /// Cocina del Archivo — té, café, sillas de madera. Espacio
  /// informal donde Isaura prepara dos tés a Maren al final del
  /// recorrido. Más cálido que las salas formales.
  static const AmbienteArchivo cocinaArchivo =
      AmbienteArchivo._('cocina_archivo');

  /// Cocina-comedor de la casa familiar de Maren, Casco Viejo de
  /// Iruña. Donde Iratxe prepara la comida y Naia hace las
  /// preguntas que abren el oficio para Maren (1.0.3).
  static const AmbienteArchivo cocinaCasaMaren =
      AmbienteArchivo._('cocina_casa_maren');

  /// Habitación de Maren — escritorio, libros, ventana al patio
  /// interior con un castaño. Donde escribe la primera entrada del
  /// Cuaderno la tarde antes de su primera Brecha.
  static const AmbienteArchivo cuartoCasaMaren =
      AmbienteArchivo._('cuarto_casa_maren');

  /// Ambiente-paraguas para escenas que recorren varios espacios del
  /// Archivo en una sola pieza narrativa (típico de 1.0.2 "El
  /// recorrido"). El `CustomPainter` lo usará como base sobre la que
  /// el texto de lectura de cada plano matiza ("bajan al sótano",
  /// "suben al ático") sin necesidad de un ambiente por subespacio.
  static const AmbienteArchivo recorridoArchivo =
      AmbienteArchivo._('recorrido_archivo');

  /// Ambiente-paraguas para escenas que ocurren en la casa familiar
  /// de Maren cubriendo varios espacios (cocina, salón, cuarto) sin
  /// transición clara entre ellos. El texto de lectura matiza cada
  /// subespacio cuando hace falta. Caso típico: 1.0.3 "La primera
  /// tarde en casa".
  static const AmbienteArchivo casaMaren =
      AmbienteArchivo._('casa_maren');

  /// Interior del coche viejo de Isaura — Citroën C3, asientos de
  /// tela gastados, ventanas con paisaje en movimiento. Lugar
  /// recurrente para conversaciones largas de viaje a las Brechas.
  static const AmbienteArchivo cocheIsaura =
      AmbienteArchivo._('coche_isaura');

  /// Campo de dólmenes de Aralar — calizas blancas en lo alto,
  /// hayedos abajo, hierba alta, viento, alguna oveja muy lejos.
  /// Lugar de la primera Brecha: el dolmen mediano marcado con
  /// poste y código de catálogo. Aralar y sus megalitos están
  /// validados como entrada en el doc 17.
  static const AmbienteArchivo dolmenAralar =
      AmbienteArchivo._('dolmen_aralar');

  /// Cafetería pequeña del Casco Viejo de Iruña — barra de
  /// formica, taburetes altos, cruasanes en una vitrina, voces de
  /// fondo, máquina de café que silba a ratos. Lugar de la
  /// merienda con Eider (1.A). Es el primer espacio neutro fuera
  /// de la órbita Archivo + casa familiar — Maren puede contar lo
  /// que quiera, sin protocolos.
  static const AmbienteArchivo cafeteriaCascoViejo =
      AmbienteArchivo._('cafeteria_casco_viejo');

  /// Crómlech vecino del campo de dólmenes de Aralar — círculo de
  /// pequeñas piedras hincadas, restos cerámicos en superficie,
  /// hierba tupida alrededor. Lugar de la Brecha 1.2 (segunda
  /// visita a Aralar, esta vez con Sira). Atmosférica simétrica al
  /// dolmen pero con una densidad arqueológica más fragmentaria —
  /// sin enterramiento óseo claro.
  static const AmbienteArchivo cromlechAralar =
      AmbienteArchivo._('cromlech_aralar');

  /// Bosque de hayas en la entrada al sistema de cuevas del
  /// Pirineo navarro — hojarasca, niebla baja, sendero de tierra
  /// húmeda, una verja oxidada en la ladera. Lugar de la 1.3.2 (la
  /// boca de la cueva).
  static const AmbienteArchivo bosqueHayas =
      AmbienteArchivo._('bosque_hayas');

  /// Sala con grabados parietales — cueva profunda, sala de techos
  /// altos, sin luz natural, sonido resonante, pared con bisonte,
  /// ciervo y caballo grabados que sólo aparecen cuando la luz da
  /// oblicua. Lugar de la 1.3.4 (la pared). El nombre interno se
  /// mantiene `sala_grabados_parietales` (no `alkerdi_*`) porque
  /// el contenido es modelo literario verosímil basado en lo real,
  /// no afirmación arqueológica directa de Alkerdi I.
  static const AmbienteArchivo salaGrabadosParietales =
      AmbienteArchivo._('sala_grabados_parietales');

  /// Yacimiento de Irulegi — monte sobre el valle de Aranguren,
  /// estructuras de piedra del poblado fortificado parcialmente
  /// excavadas, viviendas con paredes y peldaños conservados,
  /// material de la última jornada congelado en su sitio. Lugar
  /// de la 1.4.1 y parte de la 1.4.2.
  static const AmbienteArchivo yacimientoIrulegi =
      AmbienteArchivo._('yacimiento_irulegi');

  /// Sala de Prehistoria del Museo de Navarra — vitrinas, cartelas
  /// con transcripciones epigráficas, paneles de contexto. Lugar
  /// de la segunda parte de la 1.4.2 (la Mano de Irulegi vista en
  /// vitrina, lectura inicial vs lectura corregida).
  static const AmbienteArchivo museoNavarra =
      AmbienteArchivo._('museo_navarra');

  /// Pompelo subterránea — galería técnica baja con bóveda romana
  /// parcial, plataforma con luces dirigidas, restos de pavimento y
  /// fragmentos de muro. Vive bajo la calle Curia del casco viejo
  /// de Iruña; sólo accesible por puerta lateral del sótano del
  /// Archivo. Lugar de la 2.1.1 y 2.1.2 (descubrimiento de la
  /// inscripción romana).
  static const AmbienteArchivo pompeloSubterranea =
      AmbienteArchivo._('pompelo_subterranea');

  /// Mesa de Trabajo del Archivo — escritorio amplio, lupa de
  /// brazo, libretas, herramientas técnicas. Espacio donde Maren
  /// trabaja inscripciones, fuentes textuales o cualquier
  /// manipulación que requiera mesa firme. Lugar de la 2.1.3 y
  /// 2.1.4 (Karim enseña epigrafía).
  static const AmbienteArchivo mesaTrabajoArchivo =
      AmbienteArchivo._('mesa_trabajo_archivo');

  /// Estudio de Antonio en la casa familiar — sillón de lectura,
  /// estanterías de libros antiguos, lámpara de pie. Lugar de la
  /// 2.A.1 (Maren pide a su padre algo de Quintiliano antes de ir
  /// a Calahorra). Sub-ambiente íntimo de la casa que merece su
  /// propia entrada porque visualmente es distinto del cuarto de
  /// Maren o de la cocina.
  static const AmbienteArchivo estudioAntonio =
      AmbienteArchivo._('estudio_antonio');

  /// Yacimiento romano de Calahorra — foro parcialmente conservado,
  /// restos de termas, cimientos a vista, calles modernas alrededor.
  /// Calahorra construida encima de Calagurris en una arqueología
  /// que recuerda a Iruña sobre Pompelo. Lugar de la 2.2.2 (visita
  /// guiada por la arqueóloga local).
  static const AmbienteArchivo yacimientoCalahorra =
      AmbienteArchivo._('yacimiento_calahorra');

  /// Sala de trabajo del museo de Calahorra — mesa amplia con
  /// volúmenes y fotocopias, ventanas hacia el patio interior,
  /// banco lateral donde se queda Isaura observando. Lugar de la
  /// 2.2.3 (lectura crítica de los pasajes de Quintiliano), 2.2.4
  /// (diálogo sobre las omisiones) y 2.2.5 (Concilio especial con
  /// Aitor por videollamada).
  static const AmbienteArchivo salaTrabajoMuseoCalahorra =
      AmbienteArchivo._('sala_trabajo_museo_calahorra');

  /// Despacho de Isaura — primera planta del Archivo, mesa de
  /// madera oscura, ventana al patio del claustro, una estantería
  /// con cuadernos viejos y un cajón cerrado del que la mentora
  /// no habla. Lugar de la 2.B.1 (Maren descubre que Isaura tiene
  /// su propio cuaderno de la Cronista — treinta años, "preguntas,
  /// sólo").
  static const AmbienteArchivo despachoIsaura =
      AmbienteArchivo._('despacho_isaura');

  /// Domus romana parcialmente conservada bajo el casco viejo de
  /// Iruña — casa privada (no foro), accesible vía galería técnica
  /// desde el sótano del Archivo. Suelo de mosaico parcial (teselas
  /// blancas, negras, rojas, azules; diseños geométricos), restos
  /// de muros pintados, un horno, una cisterna. Doscientos años
  /// de habitación con capas dentro de la propia casa. Lugar de
  /// la 2.3.1 (visita inicial) y 2.3.2 (Mesa de Trabajo sobre las
  /// fuentes documentadas y las personas que no aparecen en ellas).
  static const AmbienteArchivo domusMosaicosSubterranea =
      AmbienteArchivo._('domus_mosaicos_subterranea');

  /// Plaza del Castillo de Iruña — terraza de café al sol con
  /// mesas pequeñas, soportales al fondo, frío de febrero. Lugar
  /// de la 2.C.1 (Eider y el cambio) — segundo encuentro con
  /// Eider tras la cafetería del Casco Viejo (1.A) que la coloca
  /// como amiga ajena al Archivo capaz de marcarle a Maren los
  /// cambios que ella misma no ve.
  static const AmbienteArchivo plazaCastilloIruna =
      AmbienteArchivo._('plaza_castillo_iruna');

  /// Biblioteca del Archivo — primera planta, salón largo con
  /// estanterías de roble del suelo al techo, mesas largas con
  /// flexos antiguos, ventanales al patio. Espacio donde Maren
  /// trabaja con fuentes textuales largas (crónicas, recopilaciones,
  /// ediciones críticas). Lugar de la 2.4.2 (Maren lee la *Historia
  /// Wambae regis* de Julián de Toledo y otras fuentes visigodas
  /// con un café junto al codo).
  static const AmbienteArchivo bibliotecaArchivo =
      AmbienteArchivo._('biblioteca_archivo');

  /// Yacimiento vascón al norte — asentamiento documentado del
  /// periodo bajoimperial/altomedieval, restos modestos: estructuras
  /// de habitación de piedra seca, fragmentos cerámicos hechos a
  /// mano (sin torno, lo cual es información), herramientas, sin
  /// epigrafía propia. Lugar de la 2.4.3 (el silencio vascón).
  ///
  /// **Sin nombre histórico concreto en código**: el doc 08 §2.4.3
  /// dice explícitamente "yacimiento al norte de Iruña — un
  /// asentamiento vascón documentado del periodo (a definir con
  /// asesoría — candidatos: zona de Aralar, Pirineo navarro, valle
  /// de Baztán)". Hasta que el comité asesor elija entre los tres
  /// candidatos del doc 5 §3.2, el ambiente queda etiquetado
  /// genéricamente. Registrado en BLOQUEOS-PENDIENTES.md.
  static const AmbienteArchivo yacimientoVasconNorte =
      AmbienteArchivo._('yacimiento_vascon_norte');

  /// Iglesia de San Saturnino (San Cernin) en Iruña — iglesia gótica
  /// con dos torres asimétricas, plaza Consistorial cercana. Templo
  /// real de Pamplona, fundado por los francos del Camino de
  /// Santiago en el s. XII; el santo titular procede de Tolosa de
  /// Francia (Saturnino → Sernin → Cernin). Lugar de apertura de la
  /// Estación 3.1 (doc 09 §3.1.1).
  static const AmbienteArchivo iglesiaSanCernin =
      AmbienteArchivo._('iglesia_san_cernin');

  /// Calle de la Navarrería en Iruña — antigua espina dorsal del
  /// burgo histórico de la Navarrería (vasco-romance), uno de los
  /// tres burgos medievales de Pamplona junto con San Cernin (los
  /// francos occitano-hablantes del Camino) y San Nicolás (los
  /// burgueses comerciantes). Cada burgo tuvo sus propias murallas,
  /// fueros y enemistades durante doscientos años hasta el
  /// Privilegio de la Unión de 1423. Lugar del paseo de la 3.1.3
  /// donde Isaura señala los topónimos occitanos en las calles.
  static const AmbienteArchivo calleNavarreria =
      AmbienteArchivo._('calle_navarreria');

  /// Coche de Aitor — un C4 más nuevo que el de Isaura, según el
  /// doc 09 §3.2.1. Aitor lleva a Maren en este coche al viaje a
  /// Tudela porque Isaura tiene tribunal ese día. Ambiente
  /// específico para distinguirlo de `cocheIsaura` — los dos coches
  /// implican dos modos de viaje distintos del Archivo.
  static const AmbienteArchivo cocheAitor =
      AmbienteArchivo._('coche_aitor');

  /// Mezquita-catedral de Tudela — la actual catedral de Santa
  /// María, construida en el s. XII sobre la mezquita aljama
  /// musulmana del s. IX-XII tras la conquista cristiana de 1119.
  /// Conserva elementos de las dos cosas dentro: capiteles que
  /// reutilizan piezas islámicas, inscripciones árabes parcialmente
  /// borradas en una sala lateral. Lugar de la 3.2.2 donde Aitor
  /// le presenta a Maren el material físico del periodo de los
  /// Banu Qasi.
  static const AmbienteArchivo mezquitaCatedralTudela =
      AmbienteArchivo._('mezquita_catedral_tudela');

  /// Sala de trabajo del museo de Tudela con material de los Banu
  /// Qasi — fuentes árabes (Ibn Hayyán *Muqtabis*, Al-Razi,
  /// crónicas anónimas, inscripciones), fuentes cristianas (la
  /// *Crónica de Alfonso III* y otras), material arqueológico
  /// (alcazaba, cerámica, monedas). Espacio donde Maren trabaja la
  /// reconstrucción de la dinastía muladí en la 3.2.3 y la 3.2.6.
  static const AmbienteArchivo salaMuseoTudela =
      AmbienteArchivo._('sala_museo_tudela');

  /// Cafetería pequeña del casco viejo de Tudela — cinco mesas, una
  /// barra. Aitor es cliente habitual: el dueño le saluda con la
  /// cabeza al entrar. Lugar del primer encuentro narrativo con
  /// Tasio (3.2.5) — diferente de `cafeteriaCascoViejo` (que es la
  /// cafetería del casco viejo de Iruña ya en uso desde el Arco 1).
  static const AmbienteArchivo cafeteriaCascoViejoTudela =
      AmbienteArchivo._('cafeteria_casco_viejo_tudela');

  /// Coche de Marina — su Polo viejo, más pequeño que el C4 de
  /// Aitor o el coche de Isaura. Marina conduce con una mano,
  /// música pop española de fondo a volumen bajo. Lugar de la
  /// 3.3.1 (camino a Leyre con Marina contando la leyenda de
  /// Virila mientras conduce).
  static const AmbienteArchivo cocheMarina =
      AmbienteArchivo._('coche_marina');

  /// Monasterio de San Salvador de Leyre — al pie de la sierra de
  /// Leyre, frente al embalse de Yesa. Modesto por fuera, sólido,
  /// encajado en el paisaje. Cripta románica del s. XI con
  /// capiteles tallados y columnas robustas — lo más antiguo
  /// conservado. Iglesia superior algo posterior. Aquí
  /// descansaron los restos de los reyes de Pamplona Sancho I,
  /// García Sánchez I, Sancho II y García Sánchez II durante
  /// siglos. Lugar de la 3.3.2 (entrada al monasterio) y de la
  /// 3.3.4 (sala cedida para la Mesa de Trabajo).
  static const AmbienteArchivo monasterioLeyre =
      AmbienteArchivo._('monasterio_leyre');

  /// Scriptorium reconstituido en una sala del monasterio de
  /// Leyre — los códices originales están en archivos, pero hay
  /// reproducciones de los manuscritos del s. XI-XIII donde
  /// aparece por primera vez documentada la leyenda del abad
  /// Virila (en un códice del s. XIII). Lugar de la 3.3.3, donde
  /// un monje del monasterio actual les enseña las
  /// reproducciones a Maren y a Marina.
  static const AmbienteArchivo scriptoriumLeyre =
      AmbienteArchivo._('scriptorium_leyre');

  /// Paso pirenaico de Roncesvalles — montaña, niebla baja,
  /// bosque de hayas. Pequeño en términos geográficos pero
  /// importantísimo históricamente: por aquí cruzaron carolingios
  /// en 778 (la emboscada vascona que la *Chanson de Roland*
  /// reescribiría siglos después como combate cristiano-musulmán)
  /// y desde el s. XI los peregrinos del Camino. Lugar exterior
  /// de la 3.4.2, donde Maren mira hacia Francia al norte y
  /// Navarra al sur.
  static const AmbienteArchivo pasoRoncesvalles =
      AmbienteArchivo._('paso_roncesvalles');

  /// Colegiata real de Santa María de Roncesvalles — hospital
  /// histórico de peregrinos del Camino, conjunto monumental
  /// medieval. La 3.4.3 sucede en una sala de trabajo cedida
  /// dentro de la colegiata, donde Aitor le presenta a Maren las
  /// dos lecturas del 778: la histórica documentada por las
  /// fuentes carolingias del s. VIII-IX (*Vita Karoli* de
  /// Eginardo, *Annales Regni Francorum*) y la legendaria de la
  /// *Chanson de Roland* (h. 1100).
  static const AmbienteArchivo colegiataRoncesvalles =
      AmbienteArchivo._('colegiata_roncesvalles');

  /// Portal del bloque donde vive Eider — escalera de un edificio
  /// urbano de Iruña. Espacio de paso, no de intimidad. Lugar de
  /// la 3.D.1 latente *"Eider se va"*, donde Maren pasa sin avisar
  /// y Eider baja en chándal saliendo a entrenar al baloncesto.
  /// El portal como espacio físico marca la distancia que la
  /// escena articula: ni casa de Eider ni espacio íntimo de
  /// Maren — un umbral.
  static const AmbienteArchivo portalCasaEider =
      AmbienteArchivo._('portal_casa_eider');

  /// Conjunto románico de Estella/Lizarra — iglesia del Santo
  /// Sepulcro, San Pedro de la Rúa, palacio de los Reyes (uno de
  /// los pocos palacios civiles románicos conservados de
  /// Europa), San Miguel. Estella es la **ciudad-Camino**
  /// fundada en 1090 por Sancho Ramírez con privilegios
  /// específicos para atraer población franca y servir al
  /// Camino de Santiago en pleno auge. Lugar de la 3.5.1 (paseo
  /// guiado por Aitor mostrando los cuatro monumentos como
  /// fuentes arquitectónicas) y de la 3.5.2 (sala cedida en
  /// alguno de los edificios para Mesa de Trabajo).
  static const AmbienteArchivo estellaConjuntoRomanico =
      AmbienteArchivo._('estella_conjunto_romanico');

  /// Calle de la Rúa de Estella al anochecer — la calle mayor
  /// del trazado urbano de la fundación de 1090, eje del Camino
  /// de Santiago a su paso por la villa. Lugar del cierre
  /// 3.5.4 con Maren y Aitor paseando, un grupo de peregrinos
  /// pasando con guitarra. Cierra la única Estación de respiro
  /// del Arco 3 con el aforismo de Aitor *"el oficio también
  /// incluye respirar"*.
  static const AmbienteArchivo calleRuaEstella =
      AmbienteArchivo._('calle_rua_estella');
}
