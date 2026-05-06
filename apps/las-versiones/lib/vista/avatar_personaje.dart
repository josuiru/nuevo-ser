import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

import '../nucleo/paleta_archivo.dart';

/// Avatar identificativo del hablante de un `PlanoDialogo`. Tiene dos
/// modos según haya retrato ilustrado disponible para la voz:
///
/// - **Modo ilustrado**: `Image.asset` con la ruta resuelta por
///   `_avataresIlustrados` indexado por `nombreVisible`, recortado con
///   `ClipOval`, con el borde por estamento institucional pintado por
///   encima. Migración progresiva — cada voz a la que se le añada PNG
///   en `assets/personajes/` + entrada en el mapping pasa al modo
///   ilustrado sin tocar nada del call-site.
/// - **Modo procedural** (fallback): `CustomPaint` con disco
///   translúcido del `colorNombre` + inicial + borde por estamento.
///   Sigue siendo el modo activo para todas las voces sin retrato
///   asignado todavía.
///
/// Estilo de borde según rol institucional inferido del color:
/// - `ambarLacre` → doble, "sello" del Archivo (autoridad).
/// - `textoPrincipal` → simple, par de la Cronista.
/// - cualquier otro (incluido `tintaTenue`) → discontinuo, voz externa
///   o íntima no institucional.
///
/// El avatar es decorativo: `ExcludeSemantics` lo oculta a lectores de
/// pantalla porque el nombre del hablante ya aparece como `Text`
/// adyacente con su rótulo accesible.
class AvatarPersonaje extends StatelessWidget {
  final VozPersonajeContrato voz;
  final double tamano;

  const AvatarPersonaje({
    super.key,
    required this.voz,
    this.tamano = 64,
  });

  @override
  Widget build(BuildContext contexto) {
    final nombre = voz.nombreVisible;
    if (nombre.isEmpty) {
      return SizedBox(width: tamano, height: tamano);
    }
    final rutaIlustrada = _avataresIlustrados[nombre];
    if (rutaIlustrada != null) {
      return ExcludeSemantics(
        child: SizedBox(
          width: tamano,
          height: tamano,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipOval(
                child: Image.asset(
                  rutaIlustrada,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => CustomPaint(
                    painter: _PintorAvatar(
                      inicial: nombre.characters.first.toUpperCase(),
                      colorVoz: voz.colorNombre,
                    ),
                  ),
                ),
              ),
              CustomPaint(
                painter: _PintorBorde(colorVoz: voz.colorNombre),
              ),
            ],
          ),
        ),
      );
    }
    return ExcludeSemantics(
      child: SizedBox(
        width: tamano,
        height: tamano,
        child: CustomPaint(
          painter: _PintorAvatar(
            inicial: nombre.characters.first.toUpperCase(),
            colorVoz: voz.colorNombre,
          ),
        ),
      ),
    );
  }
}

/// Mapping `nombreVisible → ruta del retrato ilustrado`. Indexado por
/// nombre visible (no por instancia de `VozPersonaje`) para mantener
/// `AvatarPersonaje` agnóstico al elenco concreto del juego. Añadir
/// un retrato nuevo es una sola línea aquí + el PNG/JPEG redimensionado
/// en `assets/personajes/`.
///
/// Convención: `assets/personajes/<nombre_minusculas>.jpg` a 512×512
/// con calidad 90, JPEG (las acuarelas comprimen bien y el tamaño
/// importa para el bundle Android).
///
/// Generados con OpenAI ChatGPT (DALL-E 3); atribución y licencia en
/// `PantallaCreditos`.
const Map<String, String> _avataresIlustrados = {
  'Maren': 'assets/personajes/maren.jpg',
  'Isaura': 'assets/personajes/isaura.jpg',
  'Aitor': 'assets/personajes/aitor.jpg',
  'Karim': 'assets/personajes/karim.jpg',
  'Marina': 'assets/personajes/marina.jpg',
  'Andrés': 'assets/personajes/andres.jpg',
  'Begoña': 'assets/personajes/begona.jpg',
  'Tasio': 'assets/personajes/tasio.jpg',
  'Iratxe': 'assets/personajes/iratxe.jpg',
  'Antonio': 'assets/personajes/antonio.jpg',
  'Naia': 'assets/personajes/naia.jpg',
  'Eider': 'assets/personajes/eider.jpg',
  'Sira': 'assets/personajes/sira.jpg',
  'Joana': 'assets/personajes/joana.jpg',
  'Arqueólogo': 'assets/personajes/arqueologo.jpg',
  'Arqueóloga': 'assets/personajes/arqueologa.jpg',
  'Monje': 'assets/personajes/monje.jpg',
};

enum _EstiloBorde { dobleSello, simple, discontinuo }

class _PintorAvatar extends CustomPainter {
  final String inicial;
  final Color colorVoz;

  _PintorAvatar({required this.inicial, required this.colorVoz});

  _EstiloBorde get _estiloBorde {
    if (colorVoz == PaletaArchivo.ambarLacre) return _EstiloBorde.dobleSello;
    if (colorVoz == PaletaArchivo.textoPrincipal) return _EstiloBorde.simple;
    return _EstiloBorde.discontinuo;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final centro = Offset(size.width / 2, size.height / 2);
    final radio = size.width / 2 - 1.5;

    final pinturaFondo = Paint()
      ..style = PaintingStyle.fill
      ..color = colorVoz.withOpacity(0.14);
    canvas.drawCircle(centro, radio, pinturaFondo);

    switch (_estiloBorde) {
      case _EstiloBorde.dobleSello:
        final pinturaBordeExterior = Paint()
          ..style = PaintingStyle.stroke
          ..color = colorVoz.withOpacity(0.85)
          ..strokeWidth = 1.2;
        canvas.drawCircle(centro, radio, pinturaBordeExterior);
        final pinturaBordeInterior = Paint()
          ..style = PaintingStyle.stroke
          ..color = colorVoz.withOpacity(0.55)
          ..strokeWidth = 0.7;
        canvas.drawCircle(centro, radio - 3.5, pinturaBordeInterior);
        break;
      case _EstiloBorde.simple:
        final pinturaBorde = Paint()
          ..style = PaintingStyle.stroke
          ..color = colorVoz.withOpacity(0.85)
          ..strokeWidth = 1.2;
        canvas.drawCircle(centro, radio, pinturaBorde);
        break;
      case _EstiloBorde.discontinuo:
        final pinturaBorde = Paint()
          ..style = PaintingStyle.stroke
          ..color = colorVoz.withOpacity(0.85)
          ..strokeWidth = 1.2;
        const numDashes = 11;
        const arcoBarrido = pi / numDashes;
        final caja = Rect.fromCircle(center: centro, radius: radio);
        for (var indice = 0; indice < numDashes; indice++) {
          final anguloInicio = (indice * 2 * pi) / numDashes;
          canvas.drawArc(caja, anguloInicio, arcoBarrido, false, pinturaBorde);
        }
        break;
    }

    final pintorTexto = TextPainter(
      text: TextSpan(
        text: inicial,
        style: TextStyle(
          color: colorVoz,
          fontSize: size.width * 0.48,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    pintorTexto.layout();
    pintorTexto.paint(
      canvas,
      Offset(
        centro.dx - pintorTexto.width / 2,
        centro.dy - pintorTexto.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(_PintorAvatar otro) {
    return otro.inicial != inicial || otro.colorVoz != colorVoz;
  }
}

/// Sólo dibuja el borde por estamento institucional, para superponerse
/// sobre `Image.asset` recortada con `ClipOval` en el modo ilustrado.
/// Replica la lógica de borde de `_PintorAvatar` sin el disco fondo ni
/// la inicial.
class _PintorBorde extends CustomPainter {
  final Color colorVoz;

  _PintorBorde({required this.colorVoz});

  _EstiloBorde get _estiloBorde {
    if (colorVoz == PaletaArchivo.ambarLacre) return _EstiloBorde.dobleSello;
    if (colorVoz == PaletaArchivo.textoPrincipal) return _EstiloBorde.simple;
    return _EstiloBorde.discontinuo;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final centro = Offset(size.width / 2, size.height / 2);
    final radio = size.width / 2 - 1.5;

    switch (_estiloBorde) {
      case _EstiloBorde.dobleSello:
        final pinturaBordeExterior = Paint()
          ..style = PaintingStyle.stroke
          ..color = colorVoz.withOpacity(0.85)
          ..strokeWidth = 1.2;
        canvas.drawCircle(centro, radio, pinturaBordeExterior);
        final pinturaBordeInterior = Paint()
          ..style = PaintingStyle.stroke
          ..color = colorVoz.withOpacity(0.55)
          ..strokeWidth = 0.7;
        canvas.drawCircle(centro, radio - 3.5, pinturaBordeInterior);
        break;
      case _EstiloBorde.simple:
        final pinturaBorde = Paint()
          ..style = PaintingStyle.stroke
          ..color = colorVoz.withOpacity(0.85)
          ..strokeWidth = 1.2;
        canvas.drawCircle(centro, radio, pinturaBorde);
        break;
      case _EstiloBorde.discontinuo:
        final pinturaBorde = Paint()
          ..style = PaintingStyle.stroke
          ..color = colorVoz.withOpacity(0.85)
          ..strokeWidth = 1.2;
        const numDashes = 11;
        const arcoBarrido = pi / numDashes;
        final caja = Rect.fromCircle(center: centro, radius: radio);
        for (var indice = 0; indice < numDashes; indice++) {
          final anguloInicio = (indice * 2 * pi) / numDashes;
          canvas.drawArc(caja, anguloInicio, arcoBarrido, false, pinturaBorde);
        }
        break;
    }
  }

  @override
  bool shouldRepaint(_PintorBorde otro) => otro.colorVoz != colorVoz;
}
