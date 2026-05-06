import 'package:flutter/material.dart';

import '../nucleo/paleta_archivo.dart';

/// Pantalla in-app de créditos de las atmósferas fotográficas. Las
/// licencias CC-BY y CC-BY-SA exigen atribución visible al usuario;
/// esta pantalla cumple ese requisito sin enterrar la información en
/// un fichero externo.
///
/// El inventario completo y formal vive en
/// `assets/atmosferas/CREDITOS.md`. Aquí se reproduce con tono breve
/// y maquetación apta para móvil/tablet en la paleta del Archivo.
class PantallaCreditos extends StatelessWidget {
  const PantallaCreditos({super.key});

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
          'CRÉDITOS',
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
        child: ListView(
          padding: const EdgeInsets.fromLTRB(28, 18, 28, 36),
          children: [
            const _Seccion(
              encabezado: 'ATMÓSFERAS FOTOGRÁFICAS',
              parrafoIntroductorio:
                  'Las imágenes de fondo de las cinemáticas son fotografías '
                  'de licencia libre tomadas por personas que las publicaron '
                  'en Wikimedia Commons. El juego las usa como ambiente, '
                  'tenuemente, detrás del texto. Aquí se nombra a cada autor '
                  'y la licencia bajo la que se distribuye su trabajo.',
            ),
            for (final entrada in _inventario)
              _FichaCredito(entrada: entrada),
            const SizedBox(height: 28),
            Text(
              'Las licencias CC-BY y CC-BY-SA permiten reutilizar el '
              'trabajo de otros con atribución. Esta pantalla cumple ese '
              'requisito. Las fuentes completas (URL de la página de '
              'cada imagen en Wikimedia Commons) figuran en '
              'assets/atmosferas/CREDITOS.md del repositorio.',
              style: TextStyle(
                fontSize: 12,
                height: 1.55,
                color: PaletaArchivo.textoTenue.withOpacity(0.85),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Seccion extends StatelessWidget {
  final String encabezado;
  final String parrafoIntroductorio;

  const _Seccion({
    required this.encabezado,
    required this.parrafoIntroductorio,
  });

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            encabezado,
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 4,
              color: PaletaArchivo.textoTenue.withOpacity(0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            parrafoIntroductorio,
            style: const TextStyle(
              fontSize: 14,
              height: 1.55,
              color: PaletaArchivo.textoPrincipal,
            ),
          ),
        ],
      ),
    );
  }
}

class _FichaCredito extends StatelessWidget {
  final _EntradaCredito entrada;

  const _FichaCredito({required this.entrada});

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entrada.titulo,
            style: const TextStyle(
              fontSize: 14,
              color: PaletaArchivo.textoPrincipal,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Foto: ${entrada.autor} — ${entrada.licencia}',
            style: TextStyle(
              fontSize: 12,
              color: PaletaArchivo.ambarLacre.withOpacity(0.85),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            entrada.descripcion,
            style: TextStyle(
              fontSize: 12,
              color: PaletaArchivo.textoTenue.withOpacity(0.85),
              height: 1.55,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 0.6,
            color: PaletaArchivo.tintaTenue.withOpacity(0.35),
          ),
        ],
      ),
    );
  }
}

class _EntradaCredito {
  final String titulo;
  final String autor;
  final String licencia;
  final String descripcion;

  const _EntradaCredito({
    required this.titulo,
    required this.autor,
    required this.licencia,
    required this.descripcion,
  });
}

/// Inventario que la pantalla muestra. Mantenerlo sincronizado con
/// `assets/atmosferas/CREDITOS.md` cuando se añadan o quiten fotos.
const List<_EntradaCredito> _inventario = [
  _EntradaCredito(
    titulo: 'Selva de Irati',
    autor: 'Quique (Darclon)',
    licencia: 'CC-BY-SA 4.0',
    descripcion:
        'Camino entre hayas con luz cálida — fondo de las escenas de '
        'bosque pirenaico (Brecha 1.3 y otras).',
  ),
  _EntradaCredito(
    titulo: 'Calle Mayor de Pamplona',
    autor: 'Miguillen',
    licencia: 'CC-BY 3.0',
    descripcion:
        'Eje del casco viejo en perspectiva — fondo de la calle '
        'Navarrería y los recorridos urbanos de Iruña.',
  ),
  _EntradaCredito(
    titulo: 'Real Colegiata de Roncesvalles',
    autor: 'Jialxv',
    licencia: 'CC-BY-SA 4.0',
    descripcion:
        'Vista desde el alto de Ibañeta con bosque pirenaico — fondo '
        'del paso y la colegiata en la Estación 3.4.',
  ),
  _EntradaCredito(
    titulo: 'Dolmen Albia (Sierra de Aralar)',
    autor: 'Jrpvaldi',
    licencia: 'CC-BY-SA 3.0',
    descripcion:
        'Megalito sobre praderío — fondo de las dos Brechas de Aralar '
        '(dolmen y crómlech).',
  ),
  _EntradaCredito(
    titulo: 'San Pedro de la Rúa, Estella-Lizarra',
    autor: 'Krzysztof Golik (Tournasol7)',
    licencia: 'CC-BY-SA 4.0',
    descripcion:
        'Iglesia románica con escalinata — fondo del conjunto románico '
        'de Estella y de la calle de la Rúa (Estación 3.5).',
  ),
  _EntradaCredito(
    titulo: 'Plaza Consistorial de Pamplona',
    autor: 'Michael Newman (panoramio)',
    licencia: 'CC-BY 3.0',
    descripcion:
        'Plaza contigua a la iglesia de San Saturnino, captura el aire '
        'del barrio franco del Camino — fondo de la iglesia de San '
        'Cernin (Estación 3.1).',
  ),
  _EntradaCredito(
    titulo: 'Catedral de Santa María de Tudela',
    autor: 'José Luis Filpo Cabana',
    licencia: 'CC-BY-SA 4.0',
    descripcion:
        'Fachada meridional de la antigua mezquita aljama — fondo de '
        'la mezquita-catedral en la Estación 3.2 (Banu Qasi).',
  ),
  _EntradaCredito(
    titulo: 'Cripta románica de Leyre',
    autor: 'Ángel M. Felicísimo (alepheli)',
    licencia: 'CC-BY-SA 4.0',
    descripcion:
        'Wiki Loves Monuments 2014. Bosque de columnas con capiteles '
        'del s. XI — fondo del Monasterio de Leyre (Estación 3.3).',
  ),
  _EntradaCredito(
    titulo: 'Mosaico romano del Museo de Navarra',
    autor: 'Sergio Geijo',
    licencia: 'CC-BY-SA 2.0',
    descripcion:
        'Mosaico hispanorromano — fondo del Museo de Navarra y, como '
        'sustitución honesta, de Pompelo subterránea y de Calagurris/'
        'Calahorra (sin restos in situ con cobertura libre).',
  ),
  _EntradaCredito(
    titulo: 'Plaza del Castillo de Pamplona',
    autor: 'Krzysztof Golik (Tournasol7)',
    licencia: 'CC-BY-SA 4.0',
    descripcion:
        'Kiosco + edificios del casco viejo — fondo de la Plaza del '
        'Castillo en las escenas urbanas de Iruña.',
  ),
  _EntradaCredito(
    titulo: 'Poblado vascón de Irulegi',
    autor: 'Garaolaza',
    licencia: 'CC-BY-SA 4.0',
    descripcion:
        'Vista general del yacimiento con el castillo medieval encima '
        '— fondo de Irulegi (Brecha 1.4).',
  ),
  // Fotos genéricas para espacios ficticios del juego — no retratan
  // un sitio concreto, sólo evocan el tipo de espacio.
  _EntradaCredito(
    titulo: 'Sala de lectura del Monasterio de Corias',
    autor: 'Adolfobrigido',
    licencia: 'CC-BY-SA 4.0',
    descripcion:
        'Biblioteca abovedada con estanterías de madera. Atmósfera de '
        'archivo histórico — fondo del Archivo nocturno, la sala de '
        'evaluación y otros espacios institucionales del juego.',
  ),
  _EntradaCredito(
    titulo: 'Casa-Museo de Manuel de Falla, sala con piano',
    autor: 'Palickap',
    licencia: 'CC-BY-SA 4.0',
    descripcion:
        'Sala interior con piano vertical y muebles antiguos. Atmósfera '
        'de estudio intelectual — fondo del despacho de Isaura y del '
        'estudio de Antonio.',
  ),
  _EntradaCredito(
    titulo: 'Sala romana del Museo Arqueológico de Alicante',
    autor: 'Joanbanjo',
    licencia: 'CC-BY-SA 3.0',
    descripcion:
        'Sala con vitrinas iluminadas. Atmósfera de museo arqueológico '
        '— fondo del ático del Archivo y de las salas de trabajo en '
        'museos provinciales.',
  ),
  _EntradaCredito(
    titulo: 'Cocina del Museo Etnológico Casa Fabián, Alquézar',
    autor: 'Enric',
    licencia: 'CC-BY-SA 4.0',
    descripcion:
        'Cocina pirenaica con hogar de piedra, mesa de madera, '
        'utensilios colgados — fondo de la cocina familiar de Maren y '
        'de las cafeterías del juego.',
  ),
  _EntradaCredito(
    titulo: 'Casa-Museo de Manuel de Falla, dormitorio',
    autor: 'Palickap',
    licencia: 'CC-BY-SA 4.0',
    descripcion:
        'Habitación íntima con muebles antiguos — fondo del cuarto de '
        'Maren.',
  ),
  _EntradaCredito(
    titulo: 'Claustro del Monasterio de la Oliva (Navarra)',
    autor: 'Diego Delso',
    licencia: 'CC-BY-SA 4.0',
    descripcion:
        'Claustro cisterciense gótico con galería de arcos — fondo del '
        'patio del Archivo y del portal de Eider.',
  ),
  _EntradaCredito(
    titulo: 'Interior de la Cueva del Pindal',
    autor: 'Falconaumanni',
    licencia: 'CC-BY 3.0 / GFDL 1.2+',
    descripcion:
        'Cueva con arte parietal paleolítico — fondo de la cueva del '
        'Pirineo y de la sala con grabados (Brecha 1.3). Imagen '
        'doble-licenciada por su autor: cumple bajo cualquiera de '
        'las dos licencias.',
  ),
  _EntradaCredito(
    titulo: 'Retratos ilustrados de personajes',
    autor: 'Generados por el equipo del juego con OpenAI ChatGPT '
        '(DALL-E 3) bajo prompts coherentes con la PaletaArchivo del '
        'Archivo de Iruña — acuarela sepia con halo ámbar',
    licencia: 'CC-BY-SA 4.0 (output bajo Términos de OpenAI; el equipo '
        'lo relicencia como contenido del juego)',
    descripcion:
        'Retratos en busto de los personajes del Archivo y del entorno '
        'de Maren — estilo acuarela sepia con halo ámbar. Sustituyen '
        'progresivamente al avatar procedural (CustomPaint con inicial '
        '+ borde por estamento) en la cabecera de los diálogos. Cada '
        'voz sin retrato sigue cayendo al modo procedural sin romper '
        'nada. La rejilla maestra y los PNG originales sin '
        'redimensionar viven en `assets/personajes/master/` y NO '
        'entran al bundle.',
  ),
];
