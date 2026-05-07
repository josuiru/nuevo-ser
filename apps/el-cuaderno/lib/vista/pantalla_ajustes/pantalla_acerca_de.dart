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
/// **i18n**: todos los strings vivos viajan por ARB. Las
/// traducciones eu/ca son fallback de experto pendiente de B2.
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
            _Cabecera(esquema: esquema, textos: textos),
            const SizedBox(height: 28),

            _Seccion(
              titulo: textos.acercaQueEsTitulo,
              cuerpo: textos.acercaQueEsCuerpo,
            ),
            _Seccion(
              titulo: textos.acercaPestanasTitulo,
              cuerpo: textos.acercaPestanasCuerpo,
            ),
            _Seccion(
              titulo: textos.acercaAnotarTitulo,
              cuerpo: textos.acercaAnotarCuerpo,
            ),
            _Seccion(
              titulo: textos.acercaSitSpotTitulo,
              cuerpo: textos.acercaSitSpotCuerpo,
            ),
            _Seccion(
              titulo: textos.acercaMisteriosTitulo,
              cuerpo: textos.acercaMisteriosCuerpo,
            ),
            _Seccion(
              titulo: textos.acercaNoHaceTitulo,
              cuerpo: textos.acercaNoHaceCuerpo,
            ),

            const SizedBox(height: 12),
            const _SeparadorSuave(),
            const SizedBox(height: 12),

            // Las cuatro secciones siguientes son densas — viven en
            // ExpansionTile para que la niña no las vea al desplegar
            // a no ser que pulse. La persona adulta las desplegará
            // si las necesita.
            _SeccionDesplegable(
              titulo: textos.acercaPrivacidadTitulo,
              cuerpo: textos.acercaPrivacidadCuerpo,
            ),
            const SizedBox(height: 8),
            _SeccionDesplegable(
              titulo: textos.acercaAcompanarTitulo,
              cuerpo: textos.acercaAcompanarCuerpo,
            ),
            const SizedBox(height: 8),
            _SeccionDesplegable(
              titulo: textos.acercaTutorTitulo,
              cuerpo: textos.acercaTutorCuerpo,
            ),
            const SizedBox(height: 8),
            _SeccionDesplegable(
              titulo: textos.acercaAulaTitulo,
              cuerpo: textos.acercaAulaCuerpo,
            ),

            const SizedBox(height: 24),
            const _SeparadorSuave(),
            const SizedBox(height: 24),

            _Seccion(
              titulo: textos.acercaIdiomasTitulo,
              cuerpo: textos.acercaIdiomasCuerpo,
            ),
            _Seccion(
              titulo: textos.acercaLicenciaTitulo,
              cuerpo: textos.acercaLicenciaCuerpo,
            ),

            const SizedBox(height: 24),
            Center(
              child: Text(
                textos.acercaCierre,
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
  const _Cabecera({required this.esquema, required this.textos});

  final ColorScheme esquema;
  final TextosApp textos;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textos.acercaCabeceraNombre,
          style: TipografiaCuaderno.serif(
            color: esquema.onSurface,
            tamano: TipografiaCuaderno.tamano17,
            peso: TipografiaCuaderno.pesoMedio,
          ).copyWith(fontSize: 28, height: 1.0),
        ),
        const SizedBox(height: 6),
        Text(
          textos.acercaCabeceraSubtitulo,
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
