import 'package:flutter/material.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import '../dominio/ambiente_archivo.dart';
import '../nucleo/paleta_archivo.dart';

/// Fondo procedural que pinta el ambiente de una escena cinematográfica
/// como motivo geométrico tenue detrás del texto. Sin assets externos
/// — todo CustomPainter.
///
/// Cada ambiente del juego se mapea a una de cinco categorías visuales
/// según el tipo de espacio que evoca. Cada categoría dibuja un motivo
/// distinto: estanterías para los espacios institucionales del Archivo,
/// ventana cálida para los íntimos, silueta de cumbre para el paisaje,
/// arco con punto de luz para el subterráneo, arco apuntado para los
/// monumentos. Los espacios sin mapear (coches, transiciones, ambiente
/// neutro del core) reciben un gradiente radial muy tenue que da algo
/// de aire al `fondoProfundo` plano.
///
/// El motivo se mantiene **siempre tenue** — opacidades 0.08-0.20 — para
/// no competir con el texto del diálogo, que es lo que el jugador lee.
/// La función del fondo es atmosférica, no informativa.
///
/// Cuando el doc 11 cierre la guía visual, este pintor se reescribirá
/// con la paleta y motivos definitivos. Mientras, da identidad espacial
/// a cada escena sin esperar la fase de assets.
class FondoAmbiente extends StatelessWidget {
  final AmbienteEscenaContrato ambiente;

  const FondoAmbiente({super.key, required this.ambiente});

  @override
  Widget build(BuildContext contexto) {
    final rutaFoto = _rutaFoto;
    return ExcludeSemantics(
      child: SizedBox.expand(
        child: rutaFoto != null
            ? _construirCapasFoto(rutaFoto)
            : CustomPaint(painter: _PintorFondo(categoria: _categoria)),
      ),
    );
  }

  Widget _construirCapasFoto(String rutaFoto) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: PaletaArchivo.fondoProfundo),
        Image.asset(
          rutaFoto,
          fit: BoxFit.cover,
          opacity: const AlwaysStoppedAnimation(0.45),
          // Si el asset falla (no existe, formato inválido…) caemos al
          // motivo procedural en lugar de romper la cinemática.
          errorBuilder: (contexto, error, stack) =>
              CustomPaint(painter: _PintorFondo(categoria: _categoria)),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                PaletaArchivo.fondoProfundo.withOpacity(0.20),
                PaletaArchivo.fondoProfundo.withOpacity(0.78),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _CategoriaVisual get _categoria {
    final ambienteActual = ambiente;
    if (ambienteActual is AmbienteArchivo) {
      return _mapaCategorias[ambienteActual.identificador] ??
          _CategoriaVisual.neutro;
    }
    return _CategoriaVisual.neutro;
  }

  String? get _rutaFoto {
    final ambienteActual = ambiente;
    if (ambienteActual is AmbienteArchivo) {
      return _mapaFotosPorIdentificador[ambienteActual.identificador];
    }
    return null;
  }
}

/// Mapa id → ruta del asset cuando hay foto curada para ese ambiente.
/// Cada entrada está respaldada por una ficha de atribución en
/// `assets/atmosferas/CREDITOS.md` y por la pantalla in-app
/// `PantallaCreditos` (CC-BY/CC-BY-SA exigen atribución visible al
/// usuario).
///
/// Algunos ids comparten asset cuando la diégesis lo permite y la
/// candidata es escasa o pedagógicamente equivalente:
/// - `colegiata_roncesvalles` y `paso_roncesvalles` comparten foto
///   (la colegiata vista desde el alto del puerto cubre los dos
///   espacios de la Estación 3.4).
/// - `museo_navarra`, `pompelo_subterranea` y `yacimiento_calahorra`
///   comparten un mosaico romano del Museo de Navarra como
///   sustitución honesta — Pompelo y Calagurris no tienen restos
///   in situ documentados con cobertura libre.
/// - `estella_conjunto_romanico` y `calle_rua_estella` comparten
///   San Pedro de la Rúa, que está literalmente en la calle.
/// - `dolmen_aralar` y `cromlech_aralar` comparten el dolmen Albia
///   (los dos son megalitos de la misma sierra).
///
/// Si un id no figura aquí, `FondoAmbiente` cae al motivo procedural.
const Map<String, String> _mapaFotosPorIdentificador = <String, String>{
  // Lugares reales del juego — fotos de los sitios concretos.
  'monasterio_leyre': 'assets/atmosferas/monasterio_leyre.jpg',
  'scriptorium_leyre': 'assets/atmosferas/monasterio_leyre.jpg',
  'colegiata_roncesvalles': 'assets/atmosferas/colegiata_roncesvalles.jpg',
  'paso_roncesvalles': 'assets/atmosferas/colegiata_roncesvalles.jpg',
  'mezquita_catedral_tudela': 'assets/atmosferas/mezquita_catedral_tudela.jpg',
  'yacimiento_irulegi': 'assets/atmosferas/yacimiento_irulegi.jpg',
  'museo_navarra': 'assets/atmosferas/museo_navarra.jpg',
  'pompelo_subterranea': 'assets/atmosferas/museo_navarra.jpg',
  'yacimiento_calahorra': 'assets/atmosferas/museo_navarra.jpg',
  'domus_mosaicos_subterranea': 'assets/atmosferas/museo_navarra.jpg',
  'plaza_castillo_iruna': 'assets/atmosferas/plaza_castillo_iruna.jpg',
  'estella_conjunto_romanico':
      'assets/atmosferas/estella_conjunto_romanico.jpg',
  'calle_rua_estella': 'assets/atmosferas/estella_conjunto_romanico.jpg',
  'bosque_hayas': 'assets/atmosferas/bosque_hayas.jpg',
  'sierra_amanecer': 'assets/atmosferas/bosque_hayas.jpg',
  'dolmen_aralar': 'assets/atmosferas/dolmen_aralar.jpg',
  'cromlech_aralar': 'assets/atmosferas/dolmen_aralar.jpg',
  'calle_navarreria': 'assets/atmosferas/calle_navarreria.jpg',
  'iglesia_san_cernin': 'assets/atmosferas/iglesia_san_cernin.jpg',

  // Espacios ficticios del Archivo y casa familiar — fotos
  // genéricas que evocan el TIPO de espacio sin ser sitios
  // identificables. Curadas para que bajo el velo al ~55% de
  // opacidad lean como atmósfera, no como lugar concreto.
  'archivo_nocturno': 'assets/atmosferas/biblioteca_corias.jpg',
  'biblioteca_archivo': 'assets/atmosferas/biblioteca_corias.jpg',
  'mesa_trabajo_archivo': 'assets/atmosferas/biblioteca_corias.jpg',
  'salon_concilio': 'assets/atmosferas/biblioteca_corias.jpg',
  'sala_evaluacion': 'assets/atmosferas/biblioteca_corias.jpg',
  'recorrido_archivo': 'assets/atmosferas/biblioteca_corias.jpg',
  'despacho_isaura': 'assets/atmosferas/estudio_falla.jpg',
  'estudio_antonio': 'assets/atmosferas/estudio_falla.jpg',
  'atico_archivo': 'assets/atmosferas/vitrina_museo.jpg',
  'sala_trabajo_museo_calahorra': 'assets/atmosferas/vitrina_museo.jpg',
  'sala_museo_tudela': 'assets/atmosferas/vitrina_museo.jpg',
  'cocina_casa_maren': 'assets/atmosferas/cocina_rustica.jpg',
  'cocina_archivo': 'assets/atmosferas/cocina_rustica.jpg',
  'casa_maren': 'assets/atmosferas/cocina_rustica.jpg',
  'cafeteria_casco_viejo': 'assets/atmosferas/cocina_rustica.jpg',
  'cafeteria_casco_viejo_tudela': 'assets/atmosferas/cocina_rustica.jpg',
  'cuarto_casa_maren': 'assets/atmosferas/cuarto_falla.jpg',
  'patio_archivo': 'assets/atmosferas/claustro_oliva.jpg',
  'portal_casa_eider': 'assets/atmosferas/claustro_oliva.jpg',
  'cueva_interior': 'assets/atmosferas/cueva_pindal.jpg',
  'sala_grabados_parietales': 'assets/atmosferas/cueva_pindal.jpg',
};

enum _CategoriaVisual {
  /// Espacios institucionales del Archivo — estanterías horizontales
  /// tenues a la izquierda, punto de luz cálido a la derecha (lámpara
  /// de mesa). Cubre salas de trabajo, museos y bibliotecas: el lugar
  /// donde se hace el oficio.
  interiorInstitucional,

  /// Espacios íntimos — ventana cálida con cuarterones. Cubre la casa
  /// familiar, la cocina del Archivo, las cafeterías y la plaza con
  /// terraza. El cobijo, el sitio donde se respira.
  interiorIntimo,

  /// Paisaje exterior natural — silueta de cumbres tenues sobre la
  /// mitad inferior. Cubre sierras, dólmenes, bosques, pasos de
  /// montaña y yacimientos al raso.
  paisajeMontana,

  /// Espacio subterráneo — arco oscuro con un punto de luz lejano
  /// arriba (la salida o la luz oblicua). Cubre cuevas, salas
  /// parietales, Pompelo y la domus subterránea.
  subterraneo,

  /// Edificio histórico/monumento — silueta de arco apuntado central
  /// tenue. Cubre iglesias, monasterios, colegiatas y calles
  /// medievales (donde el monumento estructura el espacio).
  monumento,

  /// Interior de coche en viaje — ventanilla lateral derecha con
  /// horizonte tenue y silueta de cumbres lejanas, postes verticales
  /// muy tenues sugiriendo el paisaje desplazándose. Cubre los tres
  /// coches del juego (Isaura, Aitor, Marina) — viajes a Aralar,
  /// Tudela, Leyre, Roncesvalles, Estella. Sugiere tránsito sin
  /// destino fijado: el coche es el espacio del diálogo en
  /// movimiento.
  interiorCoche,

  /// Sin motivo específico — sólo gradiente radial sutil desde el
  /// centro. Cubre el ambiente neutro del core y cualquier id sin
  /// mapear.
  neutro,
}

const Map<String, _CategoriaVisual> _mapaCategorias = {
  'sala_evaluacion': _CategoriaVisual.interiorInstitucional,
  'archivo_nocturno': _CategoriaVisual.interiorInstitucional,
  'salon_concilio': _CategoriaVisual.interiorInstitucional,
  'despacho_isaura': _CategoriaVisual.interiorInstitucional,
  'biblioteca_archivo': _CategoriaVisual.interiorInstitucional,
  'mesa_trabajo_archivo': _CategoriaVisual.interiorInstitucional,
  'scriptorium_leyre': _CategoriaVisual.interiorInstitucional,
  'sala_trabajo_museo_calahorra': _CategoriaVisual.interiorInstitucional,
  'sala_museo_tudela': _CategoriaVisual.interiorInstitucional,
  'museo_navarra': _CategoriaVisual.interiorInstitucional,
  'atico_archivo': _CategoriaVisual.interiorInstitucional,
  'recorrido_archivo': _CategoriaVisual.interiorInstitucional,
  'cocina_archivo': _CategoriaVisual.interiorIntimo,
  'patio_archivo': _CategoriaVisual.interiorIntimo,
  'cocina_casa_maren': _CategoriaVisual.interiorIntimo,
  'cuarto_casa_maren': _CategoriaVisual.interiorIntimo,
  'casa_maren': _CategoriaVisual.interiorIntimo,
  'estudio_antonio': _CategoriaVisual.interiorIntimo,
  'cafeteria_casco_viejo': _CategoriaVisual.interiorIntimo,
  'cafeteria_casco_viejo_tudela': _CategoriaVisual.interiorIntimo,
  'plaza_castillo_iruna': _CategoriaVisual.interiorIntimo,
  'sierra_amanecer': _CategoriaVisual.paisajeMontana,
  'dolmen_aralar': _CategoriaVisual.paisajeMontana,
  'cromlech_aralar': _CategoriaVisual.paisajeMontana,
  'bosque_hayas': _CategoriaVisual.paisajeMontana,
  'paso_roncesvalles': _CategoriaVisual.paisajeMontana,
  'yacimiento_vascon_norte': _CategoriaVisual.paisajeMontana,
  'yacimiento_calahorra': _CategoriaVisual.paisajeMontana,
  'yacimiento_irulegi': _CategoriaVisual.paisajeMontana,
  'cueva_interior': _CategoriaVisual.subterraneo,
  'sala_grabados_parietales': _CategoriaVisual.subterraneo,
  'pompelo_subterranea': _CategoriaVisual.subterraneo,
  'domus_mosaicos_subterranea': _CategoriaVisual.subterraneo,
  'iglesia_san_cernin': _CategoriaVisual.monumento,
  'mezquita_catedral_tudela': _CategoriaVisual.monumento,
  'monasterio_leyre': _CategoriaVisual.monumento,
  'colegiata_roncesvalles': _CategoriaVisual.monumento,
  'estella_conjunto_romanico': _CategoriaVisual.monumento,
  'calle_navarreria': _CategoriaVisual.monumento,
  'calle_rua_estella': _CategoriaVisual.monumento,
  'coche_isaura': _CategoriaVisual.interiorCoche,
  'coche_aitor': _CategoriaVisual.interiorCoche,
  'coche_marina': _CategoriaVisual.interiorCoche,
};

class _PintorFondo extends CustomPainter {
  final _CategoriaVisual categoria;

  _PintorFondo({required this.categoria});

  @override
  void paint(Canvas canvas, Size size) {
    _pintarBaseRadial(canvas, size);
    switch (categoria) {
      case _CategoriaVisual.interiorInstitucional:
        _pintarEstanterias(canvas, size);
        _pintarLamparaCalida(canvas, size);
        break;
      case _CategoriaVisual.interiorIntimo:
        _pintarVentanaCalida(canvas, size);
        break;
      case _CategoriaVisual.paisajeMontana:
        _pintarCumbres(canvas, size);
        break;
      case _CategoriaVisual.subterraneo:
        _pintarBoveda(canvas, size);
        break;
      case _CategoriaVisual.monumento:
        _pintarArcoApuntado(canvas, size);
        break;
      case _CategoriaVisual.interiorCoche:
        _pintarVentanillaCoche(canvas, size);
        break;
      case _CategoriaVisual.neutro:
        break;
    }
  }

  void _pintarBaseRadial(Canvas canvas, Size size) {
    final pintura = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.9,
        colors: [
          PaletaArchivo.fondoMedio.withOpacity(0.55),
          PaletaArchivo.fondoProfundo,
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, pintura);
  }

  void _pintarEstanterias(Canvas canvas, Size size) {
    final pinturaLinea = Paint()
      ..color = PaletaArchivo.tintaTenue.withOpacity(0.32)
      ..strokeWidth = 1.4;
    final inicioX = size.width * 0.04;
    final finX = size.width * 0.34;
    const numLineas = 6;
    for (var indice = 0; indice < numLineas; indice++) {
      final y = size.height * (0.16 + indice * 0.07);
      canvas.drawLine(Offset(inicioX, y), Offset(finX, y), pinturaLinea);
    }
    // Línea vertical tenue al final del bloque, como cierre de
    // estantería — da más presencia espacial.
    final pinturaCierre = Paint()
      ..color = PaletaArchivo.tintaTenue.withOpacity(0.22)
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(finX, size.height * 0.16),
      Offset(finX, size.height * 0.51),
      pinturaCierre,
    );
    // Línea horizontal sugiriendo suelo para que la composición no
    // quede flotando — muy tenue.
    final pinturaSuelo = Paint()
      ..color = PaletaArchivo.tintaTenue.withOpacity(0.18)
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(0, size.height * 0.82),
      Offset(size.width, size.height * 0.82),
      pinturaSuelo,
    );
  }

  void _pintarLamparaCalida(Canvas canvas, Size size) {
    final centro = Offset(size.width * 0.82, size.height * 0.32);
    final pintura = Paint()
      ..shader = RadialGradient(
        colors: [
          PaletaArchivo.ambarLacre.withOpacity(0.36),
          PaletaArchivo.ambarLacre.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(
        center: centro,
        radius: size.width * 0.26,
      ));
    canvas.drawCircle(centro, size.width * 0.26, pintura);
  }

  void _pintarVentanaCalida(Canvas canvas, Size size) {
    final ancho = size.width * 0.26;
    final alto = size.height * 0.32;
    final esquinaSuperior = Offset(size.width * 0.66, size.height * 0.14);
    final rectVentana = esquinaSuperior & Size(ancho, alto);

    final pinturaLuz = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.1,
        colors: [
          PaletaArchivo.ambarLacre.withOpacity(0.18),
          PaletaArchivo.ambarLacre.withOpacity(0.04),
        ],
      ).createShader(rectVentana);
    canvas.drawRect(rectVentana, pinturaLuz);

    final pinturaCuarteron = Paint()
      ..color = PaletaArchivo.tintaTenue.withOpacity(0.32)
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(esquinaSuperior.dx + ancho / 2, esquinaSuperior.dy),
      Offset(esquinaSuperior.dx + ancho / 2, esquinaSuperior.dy + alto),
      pinturaCuarteron,
    );
    canvas.drawLine(
      Offset(esquinaSuperior.dx, esquinaSuperior.dy + alto / 2),
      Offset(esquinaSuperior.dx + ancho, esquinaSuperior.dy + alto / 2),
      pinturaCuarteron,
    );

    final pinturaMarco = Paint()
      ..style = PaintingStyle.stroke
      ..color = PaletaArchivo.tintaTenue.withOpacity(0.48)
      ..strokeWidth = 1.4;
    canvas.drawRect(rectVentana, pinturaMarco);
  }

  void _pintarCumbres(Canvas canvas, Size size) {
    final pinturaCumbre = Paint()
      ..style = PaintingStyle.fill
      ..color = PaletaArchivo.tintaTenue.withOpacity(0.20);
    final basesY = size.height * 0.78;
    final caminoMontana = Path()
      ..moveTo(0, basesY)
      ..lineTo(size.width * 0.18, size.height * 0.55)
      ..lineTo(size.width * 0.30, size.height * 0.62)
      ..lineTo(size.width * 0.46, size.height * 0.46)
      ..lineTo(size.width * 0.62, size.height * 0.58)
      ..lineTo(size.width * 0.80, size.height * 0.50)
      ..lineTo(size.width, size.height * 0.60)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(caminoMontana, pinturaCumbre);
  }

  void _pintarBoveda(Canvas canvas, Size size) {
    final pinturaArco = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black.withOpacity(0.40);
    final centroArco = Offset(size.width / 2, size.height * 1.05);
    final radio = size.width * 0.78;
    final caminoArco = Path()
      ..moveTo(centroArco.dx - radio, size.height)
      ..arcToPoint(
        Offset(centroArco.dx + radio, size.height),
        radius: Radius.circular(radio),
        clockwise: false,
      )
      ..lineTo(centroArco.dx + radio, size.height)
      ..lineTo(centroArco.dx - radio, size.height)
      ..close();
    canvas.drawPath(caminoArco, pinturaArco);

    final centroLuz = Offset(size.width * 0.76, size.height * 0.22);
    final pinturaLuz = Paint()
      ..shader = RadialGradient(
        colors: [
          PaletaArchivo.ambarLacre.withOpacity(0.28),
          PaletaArchivo.ambarLacre.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: centroLuz, radius: size.width * 0.14));
    canvas.drawCircle(centroLuz, size.width * 0.14, pinturaLuz);
  }

  void _pintarArcoApuntado(Canvas canvas, Size size) {
    final centroX = size.width / 2;
    final base = size.height * 0.95;
    final cima = size.height * 0.18;
    final mitadAncho = size.width * 0.18;
    final pinturaSilueta = Paint()
      ..style = PaintingStyle.fill
      ..color = PaletaArchivo.ambarLacre.withOpacity(0.10);

    final hombro = size.height * 0.55;
    final caminoArco = Path()
      ..moveTo(centroX - mitadAncho, base)
      ..lineTo(centroX - mitadAncho, hombro)
      ..quadraticBezierTo(centroX - mitadAncho * 0.4, hombro - (hombro - cima) * 0.35,
          centroX - mitadAncho * 0.15, cima + (hombro - cima) * 0.05)
      ..quadraticBezierTo(centroX, cima, centroX + mitadAncho * 0.15,
          cima + (hombro - cima) * 0.05)
      ..quadraticBezierTo(centroX + mitadAncho * 0.4,
          hombro - (hombro - cima) * 0.35, centroX + mitadAncho, hombro)
      ..lineTo(centroX + mitadAncho, base)
      ..close();
    canvas.drawPath(caminoArco, pinturaSilueta);

    final pinturaContorno = Paint()
      ..style = PaintingStyle.stroke
      ..color = PaletaArchivo.ambarLacre.withOpacity(0.32)
      ..strokeWidth = 1.2;
    canvas.drawPath(caminoArco, pinturaContorno);
  }

  void _pintarVentanillaCoche(Canvas canvas, Size size) {
    // Ventanilla lateral derecha (perspectiva del copiloto). El marco
    // recorta una banda vertical en el lado derecho del lienzo, dentro
    // de la cual se ve el paisaje exterior: horizonte bajo + tres
    // cumbres lejanas + 4 postes/árboles tenues sugiriendo movimiento.
    // El interior del coche (mitad izquierda) queda en el gradiente
    // base, sólo apenas teñido para sugerir penumbra de habitáculo.
    final esquinaSuperior = Offset(size.width * 0.58, size.height * 0.18);
    final ancho = size.width * 0.36;
    final alto = size.height * 0.56;
    final rectVentanilla = esquinaSuperior & Size(ancho, alto);

    // Cielo dentro de la ventanilla — cálido tenue, lectura de día
    // avanzado o anochecer, coherente con los viajes del Arco 3 que
    // suelen ser de tarde (3.2.1 + 3.3.1 + 3.4.1).
    final pinturaCielo = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          PaletaArchivo.ambarLacre.withOpacity(0.16),
          PaletaArchivo.fondoMedio.withOpacity(0.30),
        ],
      ).createShader(rectVentanilla);
    canvas.drawRect(rectVentanilla, pinturaCielo);

    // Tres cumbres lejanas dentro del recuadro — silueta muy tenue,
    // recortadas al rectángulo de la ventanilla.
    canvas.save();
    canvas.clipRect(rectVentanilla);
    final pinturaCumbres = Paint()
      ..style = PaintingStyle.fill
      ..color = PaletaArchivo.tintaTenue.withOpacity(0.22);
    final yHorizonte = esquinaSuperior.dy + alto * 0.62;
    final caminoCumbres = Path()
      ..moveTo(esquinaSuperior.dx, yHorizonte)
      ..lineTo(esquinaSuperior.dx + ancho * 0.20,
          yHorizonte - alto * 0.18)
      ..lineTo(esquinaSuperior.dx + ancho * 0.42,
          yHorizonte - alto * 0.08)
      ..lineTo(esquinaSuperior.dx + ancho * 0.62,
          yHorizonte - alto * 0.22)
      ..lineTo(esquinaSuperior.dx + ancho * 0.84,
          yHorizonte - alto * 0.10)
      ..lineTo(esquinaSuperior.dx + ancho, yHorizonte - alto * 0.14)
      ..lineTo(esquinaSuperior.dx + ancho, esquinaSuperior.dy + alto)
      ..lineTo(esquinaSuperior.dx, esquinaSuperior.dy + alto)
      ..close();
    canvas.drawPath(caminoCumbres, pinturaCumbres);

    // Cuatro postes/árboles verticales muy tenues sugiriendo el
    // paisaje desplazándose — sin animación (el motivo es un fondo
    // estático), pero la repetición vertical lee como tránsito.
    final pinturaPostes = Paint()
      ..color = PaletaArchivo.tintaTenue.withOpacity(0.18)
      ..strokeWidth = 1.0;
    for (var indice = 0; indice < 4; indice++) {
      final fraccion = 0.18 + indice * 0.22;
      final xPoste = esquinaSuperior.dx + ancho * fraccion;
      canvas.drawLine(
        Offset(xPoste, yHorizonte - alto * 0.04),
        Offset(xPoste, yHorizonte + alto * 0.10),
        pinturaPostes,
      );
    }
    canvas.restore();

    // Marco de la ventanilla — borde rectangular ámbar tenue, con
    // travesaño horizontal en el tercio inferior (la línea de la
    // puerta donde acaba el cristal).
    final pinturaMarco = Paint()
      ..style = PaintingStyle.stroke
      ..color = PaletaArchivo.ambarLacre.withOpacity(0.32)
      ..strokeWidth = 1.4;
    canvas.drawRect(rectVentanilla, pinturaMarco);
    final pinturaTravesano = Paint()
      ..color = PaletaArchivo.ambarLacre.withOpacity(0.22)
      ..strokeWidth = 1.0;
    final yTravesano = esquinaSuperior.dy + alto * 0.84;
    canvas.drawLine(
      Offset(esquinaSuperior.dx, yTravesano),
      Offset(esquinaSuperior.dx + ancho, yTravesano),
      pinturaTravesano,
    );
  }

  @override
  bool shouldRepaint(_PintorFondo otro) => otro.categoria != categoria;
}
