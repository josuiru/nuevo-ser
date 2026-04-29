import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Imports por path explícito hasta que F1.3 cierre la migración de
// uno-roto y el barrel pueda re-exportar narrative/ sin colisión.
import 'package:nuevo_ser_core/src/narrative/ambiente_escena.dart';
import 'package:nuevo_ser_core/src/narrative/escena_cinematica.dart';
import 'package:nuevo_ser_core/src/narrative/opcion_eleccion.dart';
import 'package:nuevo_ser_core/src/narrative/plano_escena.dart';
import 'package:nuevo_ser_core/src/narrative/voz_personaje.dart';

/// Voz de prueba — implementa el contrato VozPersonaje sin atarse a
/// ninguna paleta concreta. El test NO debe instalar Flutter ni
/// renderizar nada; es caracterización de la API.
class _VozMock extends VozPersonaje {
  @override
  final String nombreVisible;
  @override
  final Color colorNombre;
  @override
  final bool esEnfasis;

  const _VozMock({
    required this.nombreVisible,
    this.colorNombre = const Color(0xFF000000),
    this.esEnfasis = false,
  });

  @override
  TextStyle estiloTextoCuerpo() => const TextStyle(fontSize: 16);
}

/// Ambiente de prueba — implementa AmbienteEscena sin transportar
/// estado. Un juego real lleva campos pictóricos aquí.
class _AmbienteMock extends AmbienteEscena {
  final String etiqueta;
  const _AmbienteMock(this.etiqueta);
}

void main() {
  group('VozPersonaje (contrato)', () {
    test('expone nombreVisible, colorNombre, esEnfasis y estiloTextoCuerpo',
        () {
      const voz = _VozMock(
        nombreVisible: 'Maren',
        colorNombre: Color(0xFF112233),
        esEnfasis: false,
      );
      expect(voz.nombreVisible, 'Maren');
      expect(voz.colorNombre, const Color(0xFF112233));
      expect(voz.esEnfasis, isFalse);
      expect(voz.estiloTextoCuerpo().fontSize, 16);
    });

    test('una voz con esEnfasis=true es válida (Fragmentos en Uno Roto, '
        'voces de fuente en Las Versiones)', () {
      const voz = _VozMock(nombreVisible: 'Kurz', esEnfasis: true);
      expect(voz.esEnfasis, isTrue);
    });
  });

  group('AmbienteEscena', () {
    test('AmbienteEscenaNeutro instanciable como const', () {
      const ambiente = AmbienteEscenaNeutro();
      expect(ambiente, isA<AmbienteEscena>());
    });

    test('los juegos pueden definir sus propios ambientes implementando '
        'la abstract class', () {
      const ambiente = _AmbienteMock('niebla');
      expect(ambiente, isA<AmbienteEscena>());
      expect(ambiente.etiqueta, 'niebla');
    });
  });

  group('OpcionEleccion', () {
    test('por defecto sin respuesta y sin flags', () {
      const opcion = OpcionEleccion(textoJugador: 'Vengo a entrenar.');
      expect(opcion.textoJugador, 'Vengo a entrenar.');
      expect(opcion.textoRespuesta, isNull);
      expect(opcion.vozRespuesta, isNull);
      expect(opcion.flagsAEstablecer, isEmpty);
    });

    test('puede transportar respuesta + voz + flags', () {
      const voz = _VozMock(nombreVisible: 'Isaura');
      const opcion = OpcionEleccion(
        textoJugador: 'Sí.',
        textoRespuesta: 'Bien.',
        vozRespuesta: voz,
        flagsAEstablecer: {'evaluation_passed', 'accepted_aspirante'},
      );
      expect(opcion.textoRespuesta, 'Bien.');
      expect(opcion.vozRespuesta?.nombreVisible, 'Isaura');
      expect(opcion.flagsAEstablecer, hasLength(2));
      expect(opcion.flagsAEstablecer.contains('evaluation_passed'), isTrue);
    });
  });

  group('PlanoEscena (jerarquía)', () {
    test('PlanoAmbiente con duración y texto opcional', () {
      const plano = PlanoAmbiente(
        duracion: Duration(seconds: 2),
        textoLectura: 'Iruña, lunes 8 de septiembre, 10:30.',
      );
      expect(plano, isA<PlanoEscena>());
      expect(plano.duracion, const Duration(seconds: 2));
      expect(plano.textoLectura, contains('Iruña'));
    });

    test('PlanoDialogo lleva voz, texto y pausaPrevia', () {
      const voz = _VozMock(nombreVisible: 'Begoña');
      const plano = PlanoDialogo(
        voz: voz,
        texto: 'Maren Lozano.',
        pausaPrevia: Duration(milliseconds: 300),
      );
      expect(plano, isA<PlanoEscena>());
      expect(plano.voz.nombreVisible, 'Begoña');
      expect(plano.pausaPrevia.inMilliseconds, 300);
    });

    test('PlanoEleccion lleva voz, prompt y opciones', () {
      const voz = _VozMock(nombreVisible: 'Tasio');
      const plano = PlanoEleccion(
        voz: voz,
        textoPrompt: '¿Por qué estás aquí?',
        opciones: [
          OpcionEleccion(textoJugador: 'Quiero saber.'),
          OpcionEleccion(textoJugador: 'No lo sé bien.'),
        ],
      );
      expect(plano, isA<PlanoEscena>());
      expect(plano.opciones, hasLength(2));
      expect(plano.textoPrompt, contains('aquí'));
    });

    test('PlanoCierreAmable usa "HASTA MAÑANA" por defecto', () {
      const plano = PlanoCierreAmable();
      expect(plano.textoBoton, 'HASTA MAÑANA');
      expect(plano.pausaPrevia, const Duration(milliseconds: 500));
    });

    test('PlanoCierreAmable acepta texto personalizado (HASTA ENTONCES)',
        () {
      const plano = PlanoCierreAmable(textoBoton: 'HASTA ENTONCES');
      expect(plano.textoBoton, 'HASTA ENTONCES');
    });

    test('los juegos pueden añadir planos específicos extendiendo '
        'PlanoEscena (no es sealed)', () {
      // Un juego define su propio plano específico (PlanoInteractivo
      // en Uno Roto, PlanoMesaTrabajo en Las Versiones cuando llegue).
      const plano = _PlanoEspecificoDePrueba(payload: 'mesa-trabajo');
      expect(plano, isA<PlanoEscena>());
      expect(plano.payload, 'mesa-trabajo');
    });
  });

  group('EscenaCinematica', () {
    test('valores por defecto sensatos: sin flags requeridos, sin cierre '
        'amable, sin sonido, ambiente neutro', () {
      const escena = EscenaCinematica(
        id: '1.0.1',
        titulo: 'La evaluación',
        planos: [PlanoAmbiente(duracion: Duration(seconds: 1))],
        flagDeSalida: 'evaluation_passed',
      );
      expect(escena.flagsRequeridos, isEmpty);
      expect(escena.esCierreAmable, isFalse);
      expect(escena.sonidoDeEntrada, isNull);
      expect(escena.loopDeFondo, isNull);
      expect(escena.ambiente, isA<AmbienteEscenaNeutro>());
    });

    test('puede declarar dependencias narrativas vía flagsRequeridos', () {
      const escena = EscenaCinematica(
        id: '1.1',
        titulo: 'El primer dolmen',
        planos: [PlanoAmbiente(duracion: Duration(seconds: 1))],
        flagDeSalida: 'escena_1_1_vista',
        flagsRequeridos: {'evaluation_passed', 'met_isaura'},
      );
      expect(escena.flagsRequeridos, hasLength(2));
      expect(escena.flagsRequeridos.contains('met_isaura'), isTrue);
    });

    test('una escena de cierre amable se marca con esCierreAmable=true',
        () {
      const escena = EscenaCinematica(
        id: '1.7',
        titulo: 'Kai visto de lejos',
        planos: [PlanoCierreAmable()],
        flagDeSalida: 'escena_1_7_vista',
        esCierreAmable: true,
      );
      expect(escena.esCierreAmable, isTrue);
    });

    test('puede llevar sonido de entrada y loop de fondo', () {
      const escena = EscenaCinematica(
        id: '2.7',
        titulo: 'Dual + MCM',
        planos: [PlanoAmbiente(duracion: Duration(seconds: 1))],
        flagDeSalida: 'escena_2_7_vista',
        sonidoDeEntrada: 'motivo_zafran',
        loopDeFondo: 'musica_tutela_dual',
      );
      expect(escena.sonidoDeEntrada, 'motivo_zafran');
      expect(escena.loopDeFondo, 'musica_tutela_dual');
    });

    test('el ambiente lo decide cada juego implementando AmbienteEscena',
        () {
      const escena = EscenaCinematica(
        id: '1.8a',
        titulo: 'Variante despejada',
        planos: [PlanoAmbiente(duracion: Duration(seconds: 1))],
        flagDeSalida: 'variante_a_vista',
        ambiente: _AmbienteMock('noche-despejada'),
      );
      expect(escena.ambiente, isA<_AmbienteMock>());
      expect((escena.ambiente as _AmbienteMock).etiqueta, 'noche-despejada');
    });
  });
}

class _PlanoEspecificoDePrueba extends PlanoEscena {
  final String payload;
  const _PlanoEspecificoDePrueba({required this.payload});
}
