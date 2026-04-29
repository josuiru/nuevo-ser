import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_ser_core/nuevo_ser_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Caracteriza el GestorPerfiles con el namespace `uroto` (el que usa
/// Uno Roto en producción). Estos tests son red de seguridad para la
/// extracción del subsistema de perfiles desde RepositorioProgreso —
/// cualquier cambio aquí cambia cómo se identifica al niño y dónde
/// vive su progreso.
void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  GestorPerfiles construirGestor() {
    return GestorPerfiles(
      namespace: 'uroto',
      sufijoNombreVisible: 'nombre_jugador',
      clavesGlobalesNoMigrables: const {
        'uroto.token_backend',
        'uroto.email_backend',
        'uroto.audio.version_local',
        'uroto.audio.sugerencia_vista',
        'uroto.idioma_app',
      },
    );
  }

  test('idPerfilActivo en almacén limpio devuelve "principal"', () async {
    final gestor = construirGestor();
    expect(await gestor.idPerfilActivo(), 'principal');
  });

  test('listarPerfiles en almacén limpio devuelve ["principal"]', () async {
    final gestor = construirGestor();
    expect(await gestor.listarPerfiles(), ['principal']);
  });

  test('prefijoActivo construye "<ns>.perfil.<id>."', () async {
    final gestor = construirGestor();
    expect(await gestor.prefijoActivo(), 'uroto.perfil.principal.');
  });

  test('crear perfil produce slug, lo añade a la lista y guarda nombre',
      () async {
    final gestor = construirGestor();
    final id = await gestor.crearPerfil('Niko Aitor');
    expect(id, 'niko_aitor');
    expect(await gestor.listarPerfiles(), ['principal', 'niko_aitor']);
    final infos = await gestor.listarPerfilesConInfo();
    final niko = infos.firstWhere((p) => p.id == 'niko_aitor');
    expect(niko.nombreVisible, 'Niko Aitor');
    expect(niko.esActivo, false);
  });

  test('crear perfil con tildes y ñ produce ASCII', () async {
    final gestor = construirGestor();
    expect(await gestor.crearPerfil('Iñaki Ñoño'), 'inaki_nono');
    expect(await gestor.crearPerfil('María José'), 'maria_jose');
  });

  test('crear perfil con nombre que colisiona añade sufijo numérico',
      () async {
    final gestor = construirGestor();
    expect(await gestor.crearPerfil('Ana'), 'ana');
    expect(await gestor.crearPerfil('Ana'), 'ana2');
    expect(await gestor.crearPerfil('Ana'), 'ana3');
  });

  test('crear perfil con nombre sólo símbolos cae a "perfil" + sufijo',
      () async {
    final gestor = construirGestor();
    expect(await gestor.crearPerfil('!!!'), 'perfil');
    expect(await gestor.crearPerfil('???'), 'perfil2');
  });

  test('cambiarAPerfil a id existente lo activa', () async {
    final gestor = construirGestor();
    await gestor.crearPerfil('Niko');
    await gestor.cambiarAPerfil('niko');
    expect(await gestor.idPerfilActivo(), 'niko');
  });

  test('cambiarAPerfil a id inexistente es no-op', () async {
    final gestor = construirGestor();
    await gestor.cambiarAPerfil('fantasma');
    expect(await gestor.idPerfilActivo(), 'principal');
  });

  test('borrarPerfil quita las claves del perfil pero deja otras',
      () async {
    final gestor = construirGestor();
    await gestor.crearPerfil('Ana');
    final prefs = await gestor.prefsInicializadas();
    await prefs.setInt('uroto.perfil.ana.esquirlas_total', 42);
    await prefs.setInt('uroto.perfil.principal.esquirlas_total', 17);

    await gestor.borrarPerfil('ana');

    expect(prefs.getInt('uroto.perfil.ana.esquirlas_total'), isNull);
    expect(prefs.getInt('uroto.perfil.principal.esquirlas_total'), 17);
    expect(await gestor.listarPerfiles(), ['principal']);
  });

  test('borrar perfil activo cambia al primer restante', () async {
    final gestor = construirGestor();
    await gestor.crearPerfil('Ana');
    await gestor.crearPerfil('Beto');
    await gestor.cambiarAPerfil('ana');
    await gestor.borrarPerfil('ana');
    final activoTrasBorrar = await gestor.idPerfilActivo();
    // El primer restante: principal (estaba antes que beto en la lista).
    expect(activoTrasBorrar, 'principal');
    expect(await gestor.listarPerfiles(), ['principal', 'beto']);
  });

  test('borrar el último perfil restante recrea principal', () async {
    final gestor = construirGestor();
    // Estado inicial: solo "principal". Lo borramos.
    await gestor.borrarPerfil('principal');
    expect(await gestor.listarPerfiles(), ['principal']);
    expect(await gestor.idPerfilActivo(), 'principal');
  });

  test('migración legada: claves uroto.X se mueven a uroto.perfil.principal.X',
      () async {
    SharedPreferences.setMockInitialValues({
      'uroto.esquirlas_total': 42,
      'uroto.nombre_jugador': 'Niko',
      'uroto.flag.escena_1_1_vista': true,
    });

    final gestor = construirGestor();
    // Forzar migración leyendo cualquier cosa.
    expect(await gestor.idPerfilActivo(), 'principal');
    final prefs = await gestor.prefsInicializadas();

    // Las legadas se han movido al perfil.
    expect(prefs.getInt('uroto.perfil.principal.esquirlas_total'), 42);
    expect(
      prefs.getString('uroto.perfil.principal.nombre_jugador'),
      'Niko',
    );
    expect(
      prefs.getBool('uroto.perfil.principal.flag.escena_1_1_vista'),
      true,
    );
    // Y se han borrado de las legadas.
    expect(prefs.getInt('uroto.esquirlas_total'), isNull);
    expect(prefs.getString('uroto.nombre_jugador'), isNull);
    expect(prefs.getBool('uroto.flag.escena_1_1_vista'), isNull);
  });

  test('migración legada respeta whitelist global (token, idioma, audio)',
      () async {
    SharedPreferences.setMockInitialValues({
      'uroto.token_backend': 'jwt-de-niko',
      'uroto.idioma_app': 'eu',
      'uroto.audio.version_local': 3,
      'uroto.esquirlas_total': 42,
    });

    final gestor = construirGestor();
    final prefs = await gestor.prefsInicializadas();

    // Globales intactas.
    expect(prefs.getString('uroto.token_backend'), 'jwt-de-niko');
    expect(prefs.getString('uroto.idioma_app'), 'eu');
    expect(prefs.getInt('uroto.audio.version_local'), 3);
    // Solo lo no-global migra.
    expect(prefs.getInt('uroto.perfil.principal.esquirlas_total'), 42);
    expect(prefs.getInt('uroto.esquirlas_total'), isNull);
  });

  test('migración no se vuelve a disparar si ya hay perfil activo',
      () async {
    SharedPreferences.setMockInitialValues({
      'uroto.perfil_activo_id': 'beto',
      'uroto.perfiles_lista': ['principal', 'beto'],
      // Una clave legada que NO debería migrar (porque ya migramos antes).
      'uroto.esquirlas_total': 999,
    });

    final gestor = construirGestor();
    expect(await gestor.idPerfilActivo(), 'beto');
    final prefs = await gestor.prefsInicializadas();
    // La clave legada queda como estaba — el gestor no toca nada.
    expect(prefs.getInt('uroto.esquirlas_total'), 999);
    expect(prefs.getInt('uroto.perfil.principal.esquirlas_total'), isNull);
  });

  test('claves de OTRO juego (otra ns) no se tocan en migración',
      () async {
    SharedPreferences.setMockInitialValues({
      'lasversiones.esquirlas_total': 5,
      'uroto.esquirlas_total': 42,
    });

    final gestor = construirGestor();
    final prefs = await gestor.prefsInicializadas();

    // El otro namespace queda intacto.
    expect(prefs.getInt('lasversiones.esquirlas_total'), 5);
    // El propio sí migra.
    expect(prefs.getInt('uroto.perfil.principal.esquirlas_total'), 42);
    expect(prefs.getInt('uroto.esquirlas_total'), isNull);
  });

  test('listarPerfilesConInfo cae al id si no hay nombre guardado',
      () async {
    final gestor = construirGestor();
    final prefs = await gestor.prefsInicializadas();
    // Estado: solo principal, sin nombre guardado.
    final infos = await gestor.listarPerfilesConInfo();
    expect(infos, hasLength(1));
    expect(infos.single.id, 'principal');
    expect(infos.single.nombreVisible, 'principal');
    expect(infos.single.esActivo, true);
    // Forzamos vacío explícito → mismo resultado.
    await prefs.setString(
      'uroto.perfil.principal.nombre_jugador',
      '   ',
    );
    final infos2 = await gestor.listarPerfilesConInfo();
    expect(infos2.single.nombreVisible, 'principal');
  });
}
