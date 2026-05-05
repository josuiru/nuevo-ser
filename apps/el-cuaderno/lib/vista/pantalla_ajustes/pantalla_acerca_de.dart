import 'package:flutter/material.dart';

import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';

/// Pantalla "Cómo se usa este cuaderno". Documento vivo accesible
/// desde Ajustes para tres lectores distintos a la vez: la niña que
/// abre por primera vez y no sabe qué hacer, la persona adulta que
/// la acompaña, y la maestra que la prueba en clase.
///
/// **Diseño**: una sola pantalla con bloques en orden de utilidad.
/// Las primeras secciones las puede leer la niña sola (frases
/// cortas, voz adulta amable doc 04 §2.3); las dos del final
/// (privacidad detallada y notas para la persona adulta) viven en
/// `ExpansionTile` para no abrumar — el adulto las despliega cuando
/// necesita.
///
/// **i18n**: el contenido largo está en castellano hardcoded por
/// ahora. Los títulos del AppBar y del bloque de Ajustes sí pasan
/// por ARB. Cuando entre B2 (asesoría de traducción) el contenido
/// se mueve a claves ARB. Mismo patrón que las guías cualitativas
/// del resto del cuaderno — equivalente al TODO_EU / TODO_CA por
/// string del resto del proyecto.
class PantallaAcercaDe extends StatelessWidget {
  const PantallaAcercaDe({super.key});

  @override
  Widget build(BuildContext context) {
    final textos = TextosApp.of(context);
    final esquema = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(textos.acercaTitulo)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          children: [
            _Cabecera(esquema: esquema),
            const SizedBox(height: 28),

            const _Seccion(
              titulo: 'qué es esto',
              cuerpo:
                  'Un cuaderno de campo. Es tuyo. Lo que escribas aquí no '
                  'se borra solo y nadie lo lee a tus espaldas.\n\n'
                  'No es un juego para ganar. No tiene puntos, ni rachas, '
                  'ni nada que celebre nada. Es un sitio donde dejar lo '
                  'que ves cuando sales a mirar.',
            ),

            const _Seccion(
              titulo: 'las cuatro pestañas',
              cuerpo:
                  '**Cuaderno** — el saludo, el sit spot, los Misterios '
                  'abiertos y la última página.\n\n'
                  '**Mapa** — sólo si la persona adulta lo enciende en '
                  'Ajustes.\n\n'
                  '**Misterios** — tus preguntas y los Misterios del '
                  'cuaderno. Aquí formulas las tuyas con el botón '
                  '*"formular pregunta"*.\n\n'
                  '**Tutor** — alguien con quien hablar cuando no '
                  'entiendes algo. No es un buscador de internet y no '
                  'da la respuesta hecha.',
            ),

            const _Seccion(
              titulo: 'anotar una observación',
              cuerpo:
                  'Cuando ves algo que merece la pena, lo anotas. Una '
                  'página tiene tres campos importantes:\n\n'
                  '**Qué viste** — lo que vieron tus ojos. *"Una '
                  'mariposa blanca con manchas marrones"* es mejor que '
                  '*"una pieris"*. La identificación viene después.\n\n'
                  '**Crees que es** — si crees que sabes qué era. Si '
                  'no, lo dejas vacío. Decir *"no sé"* es información: '
                  'significa que volverás a mirar.\n\n'
                  '**Nivel de confianza** — tres opciones: '
                  '*consenso* (estás seguro), *hipótesis activa* '
                  '(crees que sabes pero te haría falta volver a '
                  'mirar), *no segura* (viste algo, no sabes qué).',
            ),

            const _Seccion(
              titulo: 'tu sit spot',
              cuerpo:
                  'El lugar al que vuelves muchas veces. No tiene que '
                  'ser bonito. Tiene que ser tuyo: un banco del parque, '
                  'una piedra junto al río, una rama gruesa de un árbol '
                  'del patio.\n\n'
                  'Si vas siempre a sitios distintos, ves cosas '
                  'distintas. Si vuelves al mismo sitio, ves **cómo '
                  'cambia**.\n\n'
                  'No tienes prisa por elegirlo. La presentación del '
                  'cuaderno deja explícito que se puede dejar para '
                  'después.',
            ),

            const _Seccion(
              titulo: 'misterios y preguntas',
              cuerpo:
                  'Hay dos tipos de preguntas en la pestaña Misterios:\n\n'
                  'Los **Misterios del cuaderno** los propone el '
                  'cuaderno, contextualizados a tu zona y a la estación. '
                  'No tienes que resolverlos todos.\n\n'
                  '**Tus preguntas** las formulas tú. Si no se te ocurre '
                  'cómo empezar, hay un *"necesito ideas"* con cinco '
                  'maneras posibles.\n\n'
                  'Cuando creas que tienes tu respuesta — no la '
                  'respuesta correcta del libro de ciencias, **tu '
                  'respuesta** — la guardas. Aquí no hay respuesta '
                  'correcta: hay tu respuesta.',
            ),

            const _Seccion(
              titulo: 'lo que este cuaderno NO hace',
              cuerpo:
                  'No tiene puntos, niveles, rachas, premios.\n\n'
                  'No envía notificaciones. Cuando te apetezca, '
                  'abres tú.\n\n'
                  'No celebra cuando anotas algo. Tu observación es '
                  'la celebración.\n\n'
                  'No te compara con otros niños. No hay rankings.\n\n'
                  'No te dice si algo está bien o mal. Lo que ves '
                  'está bien por ser visto.',
            ),

            const SizedBox(height: 12),
            const _SeparadorSuave(),
            const SizedBox(height: 12),

            // Las dos secciones siguientes son densas — viven en
            // ExpansionTile para que la niña no las vea al desplegar
            // a no ser que pulse. La persona adulta las desplegará
            // si las necesita.
            const _SeccionDesplegable(
              titulo: 'para tu adulto: privacidad',
              cuerpo:
                  'Esto es un hard limit no negociable: el cuaderno es '
                  'del niño.\n\n'
                  '**Sólo se queda en el dispositivo, nunca cruza red:**\n'
                  '· el texto libre de las observaciones\n'
                  '· las fotos\n'
                  '· los dibujos del lienzo\n'
                  '· las coordenadas precisas\n'
                  '· las preguntas que formula\n'
                  '· las respuestas al cerrar Misterios\n'
                  '· el nombre que ha elegido\n\n'
                  '**Sólo viaja al servidor con sincronización opt-in:**\n'
                  '· un *hash* de la observación (no el texto)\n'
                  '· el código de región provincial (no la posición)\n'
                  '· un agregado semanal con conteos por tipo, sin '
                  'contenido\n'
                  '· las preguntas al Tutor IA, si está activado, con '
                  'cuota diaria + ZDR + lista negra\n\n'
                  '**Lo que la persona adulta puede ver:**\n'
                  '· un párrafo cualitativo resumiendo la semana, sin '
                  'texto literal\n'
                  '· una pregunta sugerida para la cena\n\n'
                  '**Lo que la persona adulta no puede ver:** ninguna '
                  'observación literal, ninguna foto, ningún dibujo, '
                  'ninguna coordenada, ninguna conversación con el '
                  'Tutor.',
            ),

            const SizedBox(height: 8),

            const _SeccionDesplegable(
              titulo: 'para tu adulto: cómo acompañar',
              cuerpo:
                  'El sit spot es lo más importante. Si la niña no se '
                  'lo ha apropiado, no volverá. Que lo elija ella. Si '
                  'todavía no encuentra ninguno, no tiene prisa.\n\n'
                  'Una observación a la semana es buen ritmo. Hay '
                  'semanas con cero observaciones — eso también está '
                  'bien. La biblia del proyecto: *cierre amable y '
                  'ritmo respetuoso.*\n\n'
                  'Si activas el resumen semanal en Ajustes, recibirás '
                  'una pregunta sugerida para la cena. Está pensada '
                  'para que sea más fácil empezar conversación, no '
                  'para auditar.\n\n'
                  '**Lo que es mejor no hacer:**\n'
                  '· leer su cuaderno por encima del hombro\n'
                  '· pedir que demuestre lo que ha aprendido\n'
                  '· corregir si identifica mal — la próxima vez '
                  'comparará y se corregirá sola\n'
                  '· felicitar efusivamente cuando anota — convierte '
                  'el oficio en performance',
            ),

            const SizedBox(height: 8),

            const _SeccionDesplegable(
              titulo: 'para tu adulto: el Tutor',
              cuerpo:
                  'Asistente conversacional limitado por reglas. La '
                  'biblia del proyecto le pone cinco bumpers:\n\n'
                  '**ZDR** — el proveedor del modelo no entrena con '
                  'las conversaciones ni las retiene.\n\n'
                  '**Sin memoria entre conversaciones.** Cada apertura '
                  'empieza limpia.\n\n'
                  '**Lista negra de temas.** Hay temas (sexualidad, '
                  'violencia, drogas, autolesión, datos personales) que '
                  'el Tutor no continúa. Redirige amable y al cabo de '
                  'pocos turnos cierra.\n\n'
                  '**Cuota de 30 turnos al día.** Cuando se llega, el '
                  'Tutor responde *"hablamos mañana"*. Bumper '
                  'deliberado contra el efecto adictivo.\n\n'
                  '**No da respuestas hechas.** Está prompted para '
                  'devolver la pregunta al lugar.',
            ),

            const SizedBox(height: 8),

            const _SeccionDesplegable(
              titulo: 'para el aula: vista del docente',
              cuerpo:
                  'Cuando este cuaderno se usa en clase, la persona '
                  'docente accede a un panel agregado desde Ajustes → '
                  '*"Acceder como profesor"*. Lo que ve:\n\n'
                  '· recuento agregado de la actividad de su aula\n'
                  '· distribución por dominios (presencia, observación, '
                  'registro, identificación, relaciones, ciclos, '
                  'hábitats, hipótesis, tejido)\n\n'
                  '**Nunca el contenido literal de las observaciones de '
                  'ningún niño.**\n\n'
                  'Umbral mínimo: **k≥5**. Si en un dominio hay menos '
                  'de 5 alumnas con datos, ese dato se oculta para que '
                  'no sea posible deducir el comportamiento de una '
                  'niña concreta.\n\n'
                  'Esta parte está pendiente de cerrar la policy '
                  'escolar definitiva con la regulación europea para '
                  'menores en aulas.',
            ),

            const SizedBox(height: 24),
            const _SeparadorSuave(),
            const SizedBox(height: 24),

            const _Seccion(
              titulo: 'idiomas',
              cuerpo:
                  'Castellano, euskera y catalán desde el primer '
                  'arranque. La traducción de euskera y catalán está '
                  'pendiente de revisión por hablantes nativas con '
                  'criterio terminológico naturalista.',
            ),

            const _Seccion(
              titulo: 'licencia',
              cuerpo:
                  'Código AGPL-3.0. Contenido (textos, ilustraciones, '
                  'catálogo de Misterios) CC-BY-SA 4.0. Sin tracking, '
                  'sin anuncios, sin monetización. Privacidad por '
                  'diseño.',
            ),

            const SizedBox(height: 24),
            Center(
              child: Text(
                'el monte espera',
                style: TipografiaCuaderno.serif(
                  color: PaletaCuaderno.tintaTenue,
                  tamano: TipografiaCuaderno.tamano14,
                  altoLinea: 1.5,
                ).copyWith(fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Cabecera extends StatelessWidget {
  const _Cabecera({required this.esquema});

  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'El Cuaderno',
          style: TipografiaCuaderno.serif(
            color: esquema.onSurface,
            tamano: TipografiaCuaderno.tamano17,
            peso: TipografiaCuaderno.pesoMedio,
          ).copyWith(fontSize: 28, height: 1.0),
        ),
        const SizedBox(height: 6),
        Text(
          'un cuaderno de campo digital — para 9-13 años',
          style: TipografiaCuaderno.serif(
            color: PaletaCuaderno.tintaTenue,
            tamano: TipografiaCuaderno.tamano14,
            altoLinea: 1.4,
          ).copyWith(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}

class _Seccion extends StatelessWidget {
  const _Seccion({required this.titulo, required this.cuerpo});

  final String titulo;
  final String cuerpo;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TipografiaCuaderno.sans(
              color: esquema.tertiary,
              tamano: TipografiaCuaderno.tamano12,
              peso: TipografiaCuaderno.pesoMedio,
            ),
          ),
          const SizedBox(height: 8),
          _CuerpoConNegrita(texto: cuerpo, color: esquema.onSurface),
        ],
      ),
    );
  }
}

/// Bloque desplegable para secciones densas (privacidad detallada,
/// notas para el adulto). El niño que abre la pantalla las ve
/// cerradas — no le abruman. La persona adulta las despliega.
class _SeccionDesplegable extends StatelessWidget {
  const _SeccionDesplegable({required this.titulo, required this.cuerpo});

  final String titulo;
  final String cuerpo;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 16),
        iconColor: PaletaCuaderno.tintaTenue,
        collapsedIconColor: PaletaCuaderno.tintaTenue,
        title: Text(
          titulo,
          style: TipografiaCuaderno.sans(
            color: esquema.tertiary,
            tamano: TipografiaCuaderno.tamano12,
            peso: TipografiaCuaderno.pesoMedio,
          ),
        ),
        children: [
          _CuerpoConNegrita(texto: cuerpo, color: esquema.onSurface),
        ],
      ),
    );
  }
}

class _SeparadorSuave extends StatelessWidget {
  const _SeparadorSuave();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '※',
        style: TipografiaCuaderno.serif(
          color: PaletaCuaderno.tintaTenue,
          tamano: TipografiaCuaderno.tamano17,
        ),
      ),
    );
  }
}

/// Renderiza texto serif con `**negrita**` simple. Mismo patrón
/// que `pantalla_acerca_de.dart` de uno-roto y que el parser del
/// Faro de Azula — extraído aquí porque la pantalla es estática y
/// no quiero tirar de un parser markdown completo.
class _CuerpoConNegrita extends StatelessWidget {
  const _CuerpoConNegrita({required this.texto, required this.color});

  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final partes = <TextSpan>[];
    final regex = RegExp(r'\*\*(.+?)\*\*|\*(.+?)\*');
    var indice = 0;
    for (final match in regex.allMatches(texto)) {
      if (match.start > indice) {
        partes.add(TextSpan(text: texto.substring(indice, match.start)));
      }
      if (match.group(1) != null) {
        // **negrita**
        partes.add(
          TextSpan(
            text: match.group(1),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        );
      } else if (match.group(2) != null) {
        // *cursiva*
        partes.add(
          TextSpan(
            text: match.group(2),
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        );
      }
      indice = match.end;
    }
    if (indice < texto.length) {
      partes.add(TextSpan(text: texto.substring(indice)));
    }
    return RichText(
      text: TextSpan(
        style: TipografiaCuaderno.serif(
          color: color,
          tamano: TipografiaCuaderno.tamano14,
          altoLinea: 1.55,
        ),
        children: partes,
      ),
    );
  }
}
