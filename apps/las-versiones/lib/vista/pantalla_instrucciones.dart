import 'package:flutter/material.dart';

import '../nucleo/paleta_archivo.dart';

/// Página única de instrucciones del juego: tres secciones (de qué
/// trata, cómo se juega, para tutores y maestros). Hardcoded en
/// castellano — voz canónica del juego, igual que el resto de la
/// narrativa. Cuando entren euskera y catalán para los textos largos
/// se añade un selector por locale.
class PantallaInstrucciones extends StatelessWidget {
  const PantallaInstrucciones({super.key});

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      backgroundColor: PaletaArchivo.fondoProfundo,
      appBar: AppBar(
        backgroundColor: PaletaArchivo.fondoProfundo,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: PaletaArchivo.textoPrincipal,
          onPressed: () => Navigator.of(contexto).maybePop(),
        ),
        title: Text(
          'INSTRUCCIONES',
          style: TextStyle(
            fontSize: 13,
            letterSpacing: 5,
            color: PaletaArchivo.textoPrincipal,
            fontWeight: FontWeight.w400,
            shadows: [
              Shadow(
                color: PaletaArchivo.ambarLacre.withOpacity(0.35),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final seccion in _seccionesEs)
                _BloqueSeccion(seccion: seccion),
            ],
          ),
        ),
      ),
    );
  }
}

class _SeccionInstrucciones {
  final String titulo;
  final String cuerpo;
  const _SeccionInstrucciones({required this.titulo, required this.cuerpo});
}

class _BloqueSeccion extends StatelessWidget {
  final _SeccionInstrucciones seccion;
  const _BloqueSeccion({required this.seccion});

  @override
  Widget build(BuildContext contexto) {
    final parrafos = seccion.cuerpo.split('\n\n');
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: PaletaArchivo.ambarLacre.withOpacity(0.7),
                  width: 0.6,
                ),
              ),
            ),
            child: Text(
              seccion.titulo,
              style: const TextStyle(
                fontSize: 12,
                letterSpacing: 4,
                color: PaletaArchivo.ambarLacre,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          for (int indice = 0; indice < parrafos.length; indice++)
            Padding(
              padding: EdgeInsets.only(
                bottom: indice == parrafos.length - 1 ? 0 : 12,
              ),
              child: RichText(
                text: TextSpan(
                  children: _parsearEnfasis(
                    parrafos[indice],
                    const TextStyle(
                      color: PaletaArchivo.textoPrincipal,
                      fontSize: 15,
                      height: 1.55,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Mini parser de énfasis: `**negrita**` y `*cursiva*`. Tolera
/// marcadores no cerrados sin romper el render — los devuelve como
/// texto literal.
List<TextSpan> _parsearEnfasis(String texto, TextStyle estiloBase) {
  final List<TextSpan> hijos = [];
  final patron = RegExp(r'\*\*(.+?)\*\*|\*(.+?)\*');
  int cursor = 0;
  for (final coincidencia in patron.allMatches(texto)) {
    if (coincidencia.start > cursor) {
      hijos.add(TextSpan(
        text: texto.substring(cursor, coincidencia.start),
        style: estiloBase,
      ));
    }
    final negrita = coincidencia.group(1);
    final cursiva = coincidencia.group(2);
    if (negrita != null) {
      hijos.add(TextSpan(
        text: negrita,
        style: estiloBase.copyWith(fontWeight: FontWeight.w700),
      ));
    } else if (cursiva != null) {
      hijos.add(TextSpan(
        text: cursiva,
        style: estiloBase.copyWith(fontStyle: FontStyle.italic),
      ));
    }
    cursor = coincidencia.end;
  }
  if (cursor < texto.length) {
    hijos.add(TextSpan(text: texto.substring(cursor), style: estiloBase));
  }
  return hijos;
}

const List<_SeccionInstrucciones> _seccionesEs = [
  _SeccionInstrucciones(
    titulo: 'DE QUÉ TRATA',
    cuerpo:
        '**Maren** tiene trece años y acaba de entrar en el **Archivo de Iruña** como Aspirante a Cronista. El Archivo es un lugar antiguo donde se aprende un oficio raro: pensar en historia *bien*. No memorizar fechas. No tragarse la primera versión. Mirar las fuentes con honestidad y declarar lo que de verdad se sabe.\n\n'
        'A lo largo del juego, Maren recorre **cuatro arcos narrativos** — desde un dolmen de la sierra de Aralar hasta el umbral de la Conquista de 1512. En cada arco trabaja **Brechas**: investigaciones a un episodio histórico concreto. Y al final de cada arco entrega un **Mosaico**, que es lo que ha aprendido contado con sus palabras.\n\n'
        'No hay puntuación. No hay enemigos. Hay una manera de pensar.',
  ),
  _SeccionInstrucciones(
    titulo: 'CÓMO SE JUEGA',
    cuerpo:
        '**Cinemáticas.** La mayor parte del tiempo Maren conversa con su mentora Isaura, con sus pares (Aitor, Karim, Marina) o con su familia. Toca la pantalla para pasar de plano. Cuando hay opciones, elige la que sientas más honesta — no hay opciones malas, algunas dejan eco en el Cuaderno.\n\n'
        '**Brechas.** Cada Brecha tiene cinco fases:\n'
        '1. **Formular preguntas** — antes de buscar respuestas, Maren propone preguntas. Cada una es de un tipo: *DATO* (qué pasó), *CAUSA* (por qué pasó), *QUIÉN MIRA* (de quién es esta versión), *CÓMO LO SABEMOS* (qué evidencia tenemos). El botón "?" en la pantalla explica cada tipo con ejemplos.\n'
        '2. **Recoger fuentes** — visita el lugar y guarda lo que encuentras: textos antiguos, restos arqueológicos, mapas, cartas, testimonios.\n'
        '3. **Evaluar** — en la Mesa de Trabajo, cada fuente recibe dos marcas: si es *primaria* (de la época) o *secundaria* (escrita después), y qué *sesgo* tiene (oficialista, invisibilizador, difusionista, presentista). El botón "?" explica cada sesgo con ejemplos.\n'
        '4. **Reconstruir** — Maren declara afirmaciones sobre lo que pasó y junto a cada una elige un nivel de confianza: *Sólido* (la evidencia es clara), *Probable* (encaja, pero podría ser de otra manera) o *Disputado* (los expertos no se ponen de acuerdo). El botón "?" explica los tres niveles.\n'
        '5. **El Concilio** — la mentora y otras voces revisan el trabajo. **No premia tener razón**. Premia haber juzgado bien con lo que había.\n\n'
        '**El Cuaderno.** Lo que Maren va aprendiendo se anota en su Cuaderno personal — pensamientos, frases que se le quedan, cosas que oye en casa. **No se evalúa**. Es suyo. Se abre con el icono del libro.\n\n'
        '**Los Mosaicos.** Al cerrar cada arco, Maren entrega un Mosaico — un cómic, una audio-guía, una pieza propia — donde junta lo que ha visto. Tampoco se puntúa. Se ofrece a alguien (un padre, una hermana mayor) que lo recibe sin corregir.\n\n'
        '**Ajustes.** El icono de Ajustes en el esqueleto de la pantalla principal permite resetear el Archivo y empezar de cero, y ver los créditos de las imágenes de fondo.',
  ),
  _SeccionInstrucciones(
    titulo: 'PARA TUTORES Y MAESTROS',
    cuerpo:
        '**Qué entrena.** Las Versiones cubre **65 habilidades** del pensamiento histórico, agrupadas en siete dominios: formulación de preguntas, análisis de fuentes, cronología y causalidad, geografía histórica, perspectiva histórica, argumentación histórica y contenido factual del currículo. La habilidad central — donde el juego pone más cariño — es la **calibración epistémica**: aprender a declarar con honestidad cuánto sabes de lo que estás afirmando. Esa es la diferencia entre un niño que recita una versión oficial y un niño que entiende qué está debajo de esa versión.\n\n'
        '**No es un juego de tener razón.** El motor de evaluación pedagógica del juego (Brier multiclass) no premia que la afirmación sea correcta — premia que la confianza declarada esté calibrada con la evidencia disponible. Decir "Sólido" sobre algo que es realmente Probable se penaliza igual que decir "Probable" sobre algo Sólido. La meta es la honestidad, no el acierto.\n\n'
        '**Cómo se adapta.** El motor adaptativo elige qué Brechas reforzar según los aciertos y los errores de calibración. Las cuatro habilidades del primer arco se trabajan en una primera Brecha guiada; a partir del segundo arco entran las habilidades más exigentes (detección de omisiones, lectura de propaganda, manejo del silencio documental). Sin niveles, sin etiquetas, sin currículo declarado.\n\n'
        '**Privacidad por diseño.** El progreso vive en el aparato. Sin tracking, sin anuncios, sin compras integradas, sin dark patterns. La cuenta del adulto acompañante es opcional y sólo se usa para enviar los Mosaicos a un servidor familiar — el resto del juego funciona sin sesión iniciada. Cuando hay sesión, el niño se identifica por un id anónimo: el sistema separa hermanos pero no envía nombre real ni datos sensibles.\n\n'
        '**Validación histórica del comité.** Todo el contenido histórico concreto (fechas, atribuciones, fuentes citadas) está sometido a validación de un comité asesor. Mientras una pieza no esté validada, el juego usa formulación genérica que preserva la pedagogía sin afirmar lo que no se ha confirmado. Las fuentes ficticias de las Brechas se presentan **explícitamente como ficticias y diegéticas** — el niño aprende el oficio sobre material que no introduce errores en su mapa del pasado.\n\n'
        '**Cómo acompañar.** La mejor compañía es el silencio interesado. Pregúntele a Maren — al niño, en realidad — por la historia, por los personajes, por lo que le ha sorprendido de un Concilio. No por puntuaciones. Si una Brecha le frustra, ofrézcale parar. No hay nada que vencer. El juego entrena a un Cronista, y los Cronistas duermen y vuelven al día siguiente.\n\n'
        '**Sin sesiones cronometradas.** Que juegue cuando le apetezca. Que pare cuando quiera. La cadencia la pone el niño.\n\n'
        '**Idiomas.** El castellano es la voz canónica. Las pantallas de configuración inicial incluyen euskera y catalán; el contenido narrativo largo está pendiente de traducción humana revisada — el comité asesor de cada idioma decide cuándo abrirla.\n\n'
        '**Edad recomendada.** 10-14 años. Niños más mayores también, especialmente si el oficio les engancha y quieren llevarlo a otras lecturas.\n\n'
        '*Las Versiones* es uno de los juegos de la **Colección Nuevo Ser Kids**. Código abierto bajo AGPL-3.0; contenido bajo CC BY-SA 4.0.',
  ),
];
