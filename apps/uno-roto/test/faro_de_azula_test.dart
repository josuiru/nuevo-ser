import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uno_roto/datos/repositorio_faro.dart';
import 'package:uno_roto/dominio/faro_de_azula.dart';

/// Tests del Faro de Azula:
///
/// - Cálculo puro de la edición actual (semana 1, semana N, capping
///   al final del banco, primera vista nula, reloj retrocedido).
/// - Persistencia idempotente de la primera vista.
/// - Aislamiento por perfil (Niko y Mara mantienen sus respuestas
///   sin pisarse).
/// - Forma del modelo de dominio (defaults, getters básicos).
void main() {
  group('calcularNumeroSemanaActual', () {
    final viernes = DateTime(2026, 5, 1, 18, 0);

    test('sin primera vista todavía → semana 1', () {
      final semana = calcularNumeroSemanaActual(
        ahora: viernes,
        primeraVistaMs: null,
        totalEdiciones: 10,
      );
      expect(semana, 1);
    });

    test('mismo día de la primera vista → semana 1', () {
      final semana = calcularNumeroSemanaActual(
        ahora: viernes.add(const Duration(hours: 3)),
        primeraVistaMs: viernes.millisecondsSinceEpoch,
        totalEdiciones: 10,
      );
      expect(semana, 1);
    });

    test('día 6 desde la primera vista → sigue en semana 1', () {
      final semana = calcularNumeroSemanaActual(
        ahora: viernes.add(const Duration(days: 6, hours: 23)),
        primeraVistaMs: viernes.millisecondsSinceEpoch,
        totalEdiciones: 10,
      );
      expect(semana, 1);
    });

    test('día 7 → semana 2 (siguiente viernes)', () {
      final semana = calcularNumeroSemanaActual(
        ahora: viernes.add(const Duration(days: 7)),
        primeraVistaMs: viernes.millisecondsSinceEpoch,
        totalEdiciones: 10,
      );
      expect(semana, 2);
    });

    test('día 35 → semana 6', () {
      final semana = calcularNumeroSemanaActual(
        ahora: viernes.add(const Duration(days: 35)),
        primeraVistaMs: viernes.millisecondsSinceEpoch,
        totalEdiciones: 10,
      );
      expect(semana, 6);
    });

    test('semana 100 con banco de 10 → cap a 10', () {
      final semana = calcularNumeroSemanaActual(
        ahora: viernes.add(const Duration(days: 700)),
        primeraVistaMs: viernes.millisecondsSinceEpoch,
        totalEdiciones: 10,
      );
      expect(semana, 10,
          reason:
              'Si pasaron 100 semanas y solo hay 10 ediciones, el niño se queda en la 10 hasta que el equipo cargue ediciones nuevas.');
    });

    test('reloj retrocedido (ahora < primera vista) → semana 1', () {
      // Caso real: el dispositivo cambió de zona horaria, o el niño
      // adelantó el reloj para "ver el siguiente Faro" y luego lo
      // restauró. No queremos que la semana se vaya a -3.
      final semana = calcularNumeroSemanaActual(
        ahora: viernes.subtract(const Duration(days: 30)),
        primeraVistaMs: viernes.millisecondsSinceEpoch,
        totalEdiciones: 10,
      );
      expect(semana, 1);
    });
  });

  group('tieneEdicionFaroNoLeida', () {
    test('sin primera vista → true (siempre)', () {
      expect(
        tieneEdicionFaroNoLeida(
          primeraVistaMs: null,
          ultimaEdicionVista: null,
          semanaActual: 1,
        ),
        isTrue,
      );
      expect(
        tieneEdicionFaroNoLeida(
          primeraVistaMs: null,
          ultimaEdicionVista: 5,
          semanaActual: 5,
        ),
        isTrue,
        reason:
            'Aunque hubiera ultimaEdicionVista, sin primera vista no '
            'tiene sentido — el Faro nunca se abrió. Mejor que el badge '
            'invite a abrir.',
      );
    });

    test('primera vista pero ultima vista null → true', () {
      expect(
        tieneEdicionFaroNoLeida(
          primeraVistaMs: 1000,
          ultimaEdicionVista: null,
          semanaActual: 1,
        ),
        isTrue,
      );
    });

    test('al día (semanaActual == ultimaVista) → false', () {
      expect(
        tieneEdicionFaroNoLeida(
          primeraVistaMs: 1000,
          ultimaEdicionVista: 3,
          semanaActual: 3,
        ),
        isFalse,
      );
    });

    test('hay edición nueva (semanaActual > ultimaVista) → true', () {
      expect(
        tieneEdicionFaroNoLeida(
          primeraVistaMs: 1000,
          ultimaEdicionVista: 2,
          semanaActual: 3,
        ),
        isTrue,
      );
    });
  });

  group('RepositorioFaro', () {
    late GestorPerfiles gestor;
    late RepositorioFaro repo;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      gestor = GestorPerfiles(
        namespace: 'uroto',
        sufijoNombreVisible: 'nombre_jugador',
      );
      repo = RepositorioFaro(gestor: gestor);
    });

    test('estado inicial: todo nulo', () async {
      expect(await repo.cargarPrimeraVistaMs(), isNull);
      expect(await repo.cargarUltimaEdicionVista(), isNull);
      expect(await repo.cargarRespuestaAcertijo(1), isNull);
    });

    test('marcarPrimeraVistaSiEsNueva fija el origen una sola vez',
        () async {
      final primerViernes = DateTime(2026, 5, 1, 18, 0);
      await repo.marcarPrimeraVistaSiEsNueva(primerViernes);
      expect(
        await repo.cargarPrimeraVistaMs(),
        primerViernes.millisecondsSinceEpoch,
      );

      // Segundo intento un mes después: NO debe sobrescribir.
      final mesDespues = primerViernes.add(const Duration(days: 30));
      await repo.marcarPrimeraVistaSiEsNueva(mesDespues);
      expect(
        await repo.cargarPrimeraVistaMs(),
        primerViernes.millisecondsSinceEpoch,
        reason:
            'La primera vista fija la cadencia para siempre: no se puede recalibrar.',
      );
    });

    test('respuesta vacía o solo espacios se trata como null', () async {
      await repo.guardarRespuestaAcertijo(1, '');
      expect(await repo.cargarRespuestaAcertijo(1), isNull);

      await repo.guardarRespuestaAcertijo(1, '   ');
      expect(await repo.cargarRespuestaAcertijo(1), isNull);
    });

    test('guardar respuesta del niño y volverla a leer', () async {
      await repo.guardarRespuestaAcertijo(1, '20 naranjas');
      expect(await repo.cargarRespuestaAcertijo(1), '20 naranjas');
      expect(await repo.cargarRespuestaAcertijo(2), isNull,
          reason: 'cada edición tiene su respuesta separada');
    });

    test('borrarTodo solo afecta al perfil activo', () async {
      await gestor.crearPerfil('Niko');
      await gestor.crearPerfil('Mara');
      final perfiles = await gestor.listarPerfiles();
      final idNiko = perfiles.firstWhere((id) => id.contains('niko'));
      final idMara = perfiles.firstWhere((id) => id.contains('mara'));

      await gestor.cambiarAPerfil(idNiko);
      await repo.guardarRespuestaAcertijo(1, '20');
      await repo.guardarPrimeraVistaMs(1000);

      await gestor.cambiarAPerfil(idMara);
      await repo.guardarRespuestaAcertijo(1, '12 manzanas');
      await repo.guardarPrimeraVistaMs(2000);

      await repo.borrarTodo();
      expect(await repo.cargarRespuestaAcertijo(1), isNull);
      expect(await repo.cargarPrimeraVistaMs(), isNull);

      await gestor.cambiarAPerfil(idNiko);
      expect(await repo.cargarRespuestaAcertijo(1), '20',
          reason: 'borrar el Faro de Mara no toca el de Niko');
      expect(await repo.cargarPrimeraVistaMs(), 1000);
    });

    test('aislamiento por perfil: Niko y Mara no se pisan', () async {
      await gestor.crearPerfil('Niko');
      await gestor.crearPerfil('Mara');
      final perfiles = await gestor.listarPerfiles();
      final idNiko = perfiles.firstWhere((id) => id.contains('niko'));
      final idMara = perfiles.firstWhere((id) => id.contains('mara'));

      await gestor.cambiarAPerfil(idNiko);
      await repo.guardarRespuestaAcertijo(1, 'la de Niko');
      await repo.guardarUltimaEdicionVista(3);

      await gestor.cambiarAPerfil(idMara);
      expect(await repo.cargarRespuestaAcertijo(1), isNull,
          reason: 'Mara no debería ver lo de Niko');
      expect(await repo.cargarUltimaEdicionVista(), isNull);

      await repo.guardarRespuestaAcertijo(1, 'la de Mara');
      await repo.guardarUltimaEdicionVista(1);

      await gestor.cambiarAPerfil(idNiko);
      expect(await repo.cargarRespuestaAcertijo(1), 'la de Niko');
      expect(await repo.cargarUltimaEdicionVista(), 3);

      await gestor.cambiarAPerfil(idMara);
      expect(await repo.cargarRespuestaAcertijo(1), 'la de Mara');
      expect(await repo.cargarUltimaEdicionVista(), 1);
    });

    test('clave de prefs sigue el namespace uroto.perfil.<id>.faro.*',
        () async {
      await repo.guardarPrimeraVistaMs(42);
      await repo.guardarRespuestaAcertijo(7, 'siete');

      final prefs = await SharedPreferences.getInstance();
      final claves = prefs.getKeys();
      expect(
        claves.any((k) =>
            k.startsWith('uroto.perfil.') && k.endsWith('.faro.primera_vista_ms')),
        isTrue,
        reason:
            'la clave debe vivir bajo uroto.perfil.<id>.faro.* (no en uroto.faro.* a secas)',
      );
      expect(
        claves.any((k) =>
            k.startsWith('uroto.perfil.') && k.endsWith('.faro.respuesta.7')),
        isTrue,
      );
    });
  });

  group('modelo de dominio', () {
    test('EdicionFaro guarda sus campos sin tocarlos', () {
      const edicion = EdicionFaro(
        numeroSemana: 1,
        anioOrden: 412,
        numeroEdicion: 1234,
        portada: [
          NoticiaPortada(
            titulo: 'Tres lunas previstas para el equinoccio',
            firma: 'Por la redacción.',
            cuerpo: 'Los astrónomos del observatorio…',
          ),
        ],
        cronica: Cronica(
          titulo: 'Estampas de mi mostrador',
          firma: 'por Liana Verde',
          introduccion: 'Liana Verde es vendedora de fruta…',
          cuerpo: 'Treinta años en el mismo sitio…',
        ),
        cartas: [
          CartaAlDirector(
            pregunta: 'Vivo en los Canales y oigo música…',
            firmante: 'D. de Canales',
            respuesta: 'Hemos consultado con el Maestro Rexán…',
          ),
        ],
        acertijo: Acertijo(
          titulo: 'El reparto de las naranjas',
          enunciado: 'Naini ha vendido la mitad…',
          solucionCanonica: '20',
          dificultad: NivelDificultadAcertijo.aprendizI,
        ),
      );

      expect(edicion.numeroSemana, 1);
      expect(edicion.numeroEdicion, 1234);
      expect(edicion.portada.first.firma, 'Por la redacción.');
      expect(edicion.acertijo.solucionCanonica, '20');
      expect(edicion.acertijo.pista, isNull);
    });
  });
}
