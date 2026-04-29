import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:las_versiones/dominio/voz_personaje.dart';
import 'package:las_versiones/nucleo/paleta_archivo.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';

void main() {
  group('VozPersonaje (Las Versiones)', () {
    test('implementa el contrato genérico VozPersonajeContrato', () {
      expect(VozPersonaje.maren, isA<VozPersonajeContrato>());
      expect(VozPersonaje.isaura, isA<VozPersonajeContrato>());
      expect(VozPersonaje.tasio, isA<VozPersonajeContrato>());
      expect(VozPersonaje.begona, isA<VozPersonajeContrato>());
      expect(VozPersonaje.karim, isA<VozPersonajeContrato>());
      expect(VozPersonaje.narrador, isA<VozPersonajeContrato>());
    });

    test('cada personaje del elenco tiene su nombre visible', () {
      expect(VozPersonaje.maren.nombreVisible, 'Maren');
      expect(VozPersonaje.isaura.nombreVisible, 'Isaura');
      expect(VozPersonaje.tasio.nombreVisible, 'Tasio');
      expect(VozPersonaje.begona.nombreVisible, 'Begoña');
      expect(VozPersonaje.karim.nombreVisible, 'Karim');
    });

    test('el narrador no tiene nombre visible (acotación sin atribución)',
        () {
      expect(VozPersonaje.narrador.nombreVisible, '');
    });

    test('Isaura y Begoña llevan el ámbar lacre — autoridad del Archivo',
        () {
      expect(VozPersonaje.isaura.colorNombre, PaletaArchivo.ambarLacre);
      expect(VozPersonaje.begona.colorNombre, PaletaArchivo.ambarLacre);
    });

    test('los tres aspirantes (Maren, Tasio, Karim) llevan tinta principal',
        () {
      expect(VozPersonaje.maren.colorNombre, PaletaArchivo.textoPrincipal);
      expect(VozPersonaje.tasio.colorNombre, PaletaArchivo.textoPrincipal);
      expect(VozPersonaje.karim.colorNombre, PaletaArchivo.textoPrincipal);
    });

    test('los personajes del elenco no llevan esEnfasis — el énfasis '
        'está reservado a las voces de fuente', () {
      const elenco = [
        VozPersonaje.narrador,
        VozPersonaje.maren,
        VozPersonaje.isaura,
        VozPersonaje.tasio,
        VozPersonaje.begona,
        VozPersonaje.karim,
        VozPersonaje.andres,
        VozPersonaje.marina,
        VozPersonaje.aitor,
        VozPersonaje.iratxe,
        VozPersonaje.antonio,
        VozPersonaje.naia,
      ];
      for (final voz in elenco) {
        expect(voz.esEnfasis, isFalse, reason: voz.nombreVisible);
      }
    });

    test('vozDeFuente lleva esEnfasis=true (cita en latín, fuero '
        'medieval, colofón sin atribución personal)', () {
      expect(VozPersonaje.vozDeFuente.esEnfasis, isTrue);
      expect(VozPersonaje.vozDeFuente.nombreVisible, '');
    });

    test('elenco ampliado de 1.0.2-1.0.3 — Andrés, Marina, Aitor + '
        'familia (Iratxe, Antonio, Naia)', () {
      expect(VozPersonaje.andres.nombreVisible, 'Andrés');
      expect(VozPersonaje.marina.nombreVisible, 'Marina');
      expect(VozPersonaje.aitor.nombreVisible, 'Aitor');
      expect(VozPersonaje.iratxe.nombreVisible, 'Iratxe');
      expect(VozPersonaje.antonio.nombreVisible, 'Antonio');
      expect(VozPersonaje.naia.nombreVisible, 'Naia');
    });

    test('Aitor (Constructor mayor) lleva ámbar como autoridad del '
        'Archivo, igual que Isaura y Begoña', () {
      expect(VozPersonaje.aitor.colorNombre, PaletaArchivo.ambarLacre);
    });

    test('la familia (Iratxe, Antonio, Naia) y Andrés llevan tinta '
        'tenue — voces íntimas/cercanas, no institucionales', () {
      expect(VozPersonaje.iratxe.colorNombre, PaletaArchivo.tintaTenue);
      expect(VozPersonaje.antonio.colorNombre, PaletaArchivo.tintaTenue);
      expect(VozPersonaje.naia.colorNombre, PaletaArchivo.tintaTenue);
      expect(VozPersonaje.andres.colorNombre, PaletaArchivo.tintaTenue);
    });

    test('estiloTextoCuerpo con énfasis usa itálica — distingue la voz '
        'de fuente del habla humana', () {
      final estilo = VozPersonaje.vozDeFuente.estiloTextoCuerpo();
      expect(estilo.fontStyle, FontStyle.italic);
      expect(estilo.fontSize, 21);
    });

    test('estiloTextoCuerpo sin énfasis usa sans con peso ligero', () {
      final estilo = VozPersonaje.maren.estiloTextoCuerpo();
      expect(estilo.fontSize, 19);
      expect(estilo.fontWeight, FontWeight.w300);
      expect(estilo.fontStyle, isNot(FontStyle.italic));
      expect(estilo.color, PaletaArchivo.textoPrincipal);
    });

    test('las constantes static const son idénticas por identidad — '
        'soporta uso como clave de Map', () {
      const map = <VozPersonajeContrato, String>{
        VozPersonaje.maren: 'protagonista',
        VozPersonaje.isaura: 'mentora',
      };
      expect(map[VozPersonaje.maren], 'protagonista');
      expect(map[VozPersonaje.isaura], 'mentora');
    });
  });
}
