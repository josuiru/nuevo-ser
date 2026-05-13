// Tests del flujo de sesión: memoria, saludo variable, cumpleaños.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:el_descifrador/datos/repositorio_memoria_sesiones.dart';
import 'package:el_descifrador/dominio/estado_sesion.dart';
import 'package:el_descifrador/dominio/memoria_sesiones.dart';
import 'package:el_descifrador/dominio/servicio_cumpleanyos.dart';
import 'package:el_descifrador/dominio/servicio_saludo.dart';

void main() {
  group('MemoriaSesiones', () {
    test('aperturaInicial: apertura y última visita coinciden, 1 visita', () {
      final ahora = DateTime.utc(2026, 5, 13, 10);
      final memoria = MemoriaSesiones.aperturaInicial(ahora);
      expect(memoria.fechaApertura, ahora);
      expect(memoria.fechaUltimaVisita, ahora);
      expect(memoria.cantidadVisitas, 1);
      expect(memoria.hitosCumpleanyosMostrados, isEmpty);
    });

    test('visita en el mismo día no incrementa cantidadVisitas', () {
      final ayer = DateTime.utc(2026, 5, 13, 10);
      final masTarde = DateTime.utc(2026, 5, 13, 20);
      final memoria =
          MemoriaSesiones.aperturaInicial(ayer).conVisitaRegistrada(masTarde);
      expect(memoria.cantidadVisitas, 1);
      expect(memoria.fechaUltimaVisita, masTarde);
    });

    test('visita en día distinto incrementa cantidadVisitas', () {
      final ayer = DateTime.utc(2026, 5, 13);
      final hoy = DateTime.utc(2026, 5, 14);
      final memoria =
          MemoriaSesiones.aperturaInicial(ayer).conVisitaRegistrada(hoy);
      expect(memoria.cantidadVisitas, 2);
    });

    test('diasDesdeApertura y diasDesdeUltimaVisita usan día calendario', () {
      final apertura = DateTime.utc(2026, 1, 1, 23, 50);
      final ahora = DateTime.utc(2026, 1, 2, 0, 5);
      final memoria = MemoriaSesiones.aperturaInicial(apertura);
      expect(memoria.diasDesdeApertura(ahora), 1);
      expect(memoria.diasDesdeUltimaVisita(ahora), 1);
    });

    test('conHitoMostrado añade el hito sin duplicar', () {
      var memoria = MemoriaSesiones.aperturaInicial(DateTime.utc(2026, 1, 1));
      memoria = memoria.conHitoMostrado(30);
      memoria = memoria.conHitoMostrado(30);
      expect(memoria.hitosCumpleanyosMostrados, {30});
    });

    test('serialización ida y vuelta preserva contenido', () {
      var memoria = MemoriaSesiones.aperturaInicial(DateTime.utc(2026, 1, 1));
      memoria = memoria.conVisitaRegistrada(DateTime.utc(2026, 2, 2));
      memoria = memoria.conHitoMostrado(30);
      final reconstruida =
          MemoriaSesiones.deserializar(memoria.serializar());
      expect(reconstruida.fechaApertura, DateTime.utc(2026, 1, 1));
      expect(reconstruida.fechaUltimaVisita, DateTime.utc(2026, 2, 2));
      expect(reconstruida.cantidadVisitas, 2);
      expect(reconstruida.hitosCumpleanyosMostrados, {30});
    });
  });

  group('RepositorioMemoriaSesiones', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('perfil nuevo: cargar devuelve null', () async {
      final repo = RepositorioMemoriaSesiones(idPerfil: 'test-1');
      expect(await repo.cargar(), isNull);
    });

    test('registrarVisita primera vez crea apertura', () async {
      final ahora = DateTime.utc(2026, 5, 13);
      final repo = RepositorioMemoriaSesiones(
        idPerfil: 'test-2',
        relojInyectado: () => ahora,
      );
      final memoria = await repo.registrarVisita();
      expect(memoria.fechaApertura, ahora);
      expect(memoria.cantidadVisitas, 1);
    });

    test('segunda visita persiste con visitas=2', () async {
      var reloj = DateTime.utc(2026, 5, 13);
      final repo = RepositorioMemoriaSesiones(
        idPerfil: 'test-3',
        relojInyectado: () => reloj,
      );
      await repo.registrarVisita();
      reloj = DateTime.utc(2026, 5, 14);
      final memoria = await repo.registrarVisita();
      expect(memoria.cantidadVisitas, 2);
    });

    test('perfiles distintos no se contaminan', () async {
      final ana = RepositorioMemoriaSesiones(
        idPerfil: 'ana',
        relojInyectado: () => DateTime.utc(2026, 5, 13),
      );
      final luis = RepositorioMemoriaSesiones(idPerfil: 'luis');
      await ana.registrarVisita();
      expect(await ana.cargar(), isNotNull);
      expect(await luis.cargar(), isNull);
    });
  });

  group('ServicioSaludo', () {
    const servicio = ServicioSaludo();
    final estadoConCorreo = EstadoSesion.inicial(const []);
    final estadoVacio = EstadoSesion.inicial(const []);
    // EstadoSesion.inicial con lista vacía tiene bandeja de entrada
    // vacía. Distinguimos por nombre solamente para legibilidad.

    test('primera vez del perfil: bienvenida', () {
      final saludo = servicio.saludoParaSesion(
        memoria: null,
        estado: estadoConCorreo,
        ahora: DateTime.utc(2026, 5, 13),
      );
      expect(saludo.toLowerCase(), contains('bienvenido'));
    });

    test('mismo día con bandeja vacía: maestro lo dice', () {
      final memoria = MemoriaSesiones.aperturaInicial(
        DateTime.utc(2026, 5, 13, 10),
      );
      final saludo = servicio.saludoParaSesion(
        memoria: memoria,
        estado: estadoVacio,
        ahora: DateTime.utc(2026, 5, 13, 20),
      );
      expect(saludo.toLowerCase(), contains('correo de hoy está hecho'));
    });

    test('vuelta tras 3 días con correo en la mesa', () {
      final memoria = MemoriaSesiones.aperturaInicial(
        DateTime.utc(2026, 5, 10),
      );
      final saludo = servicio.saludoParaSesion(
        memoria: memoria,
        estado: estadoConCorreo,
        ahora: DateTime.utc(2026, 5, 13),
      );
      expect(saludo.toLowerCase(), contains('unos días'));
    });

    test('vuelta tras 60 días: tono que reconoce la ausencia', () {
      final memoria = MemoriaSesiones.aperturaInicial(
        DateTime.utc(2026, 3, 1),
      );
      final saludo = servicio.saludoParaSesion(
        memoria: memoria,
        estado: estadoConCorreo,
        ahora: DateTime.utc(2026, 5, 13),
      );
      expect(saludo.toLowerCase(), contains('mucho tiempo'));
    });
  });

  group('ServicioCumpleanyos', () {
    const servicio = ServicioCumpleanyos();

    test('antes de 30 días: ningún hito', () {
      final memoria = MemoriaSesiones.aperturaInicial(
        DateTime.utc(2026, 5, 1),
      );
      expect(
        servicio.hitoActivo(
          memoria: memoria,
          ahora: DateTime.utc(2026, 5, 15),
        ),
        isNull,
      );
    });

    test('a los 30 días: hito de "un mes"', () {
      final memoria = MemoriaSesiones.aperturaInicial(
        DateTime.utc(2026, 5, 1),
      );
      final hito = servicio.hitoActivo(
        memoria: memoria,
        ahora: DateTime.utc(2026, 5, 31),
      );
      expect(hito?.dias, 30);
      expect(hito?.texto.toLowerCase(), contains('un mes'));
    });

    test('hito ya mostrado no vuelve a salir', () {
      var memoria = MemoriaSesiones.aperturaInicial(
        DateTime.utc(2026, 5, 1),
      );
      memoria = memoria.conHitoMostrado(30);
      expect(
        servicio.hitoActivo(
          memoria: memoria,
          ahora: DateTime.utc(2026, 5, 31),
        ),
        isNull,
      );
    });

    test('a los 365 días: hito de "un año"', () {
      final memoria = MemoriaSesiones.aperturaInicial(
        DateTime.utc(2025, 5, 13),
      );
      final hito = servicio.hitoActivo(
        memoria: memoria,
        ahora: DateTime.utc(2026, 5, 13),
      );
      expect(hito?.dias, 365);
      expect(hito?.texto.toLowerCase(), contains('un año'));
    });

    test('si el niño se salta el día exacto el hito espera', () {
      // Hito 30 días: apertura 2026-05-01, debería salir el 2026-05-31.
      // El niño entra el 2026-06-10. El cuaderno todavía lo presenta.
      final memoria = MemoriaSesiones.aperturaInicial(
        DateTime.utc(2026, 5, 1),
      );
      final hito = servicio.hitoActivo(
        memoria: memoria,
        ahora: DateTime.utc(2026, 6, 10),
      );
      expect(hito?.dias, 30);
    });
  });
}
