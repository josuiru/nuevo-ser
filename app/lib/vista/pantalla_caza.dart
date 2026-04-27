import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../datos/catalogo_habilidades.dart';
import '../datos/repositorio_progreso.dart';
import '../dominio/distrito.dart';
import '../dominio/fragmento_en_tejado.dart';
import '../dominio/generador_caza.dart';
import '../dominio/mapeo_habilidades_puzzle.dart';
import '../dominio/motor_maestria.dart';
import '../dominio/rango_narrativo.dart';
import '../dominio/problema_comparacion_decimal.dart';
import '../dominio/problema_comparacion_distinta.dart';
import '../dominio/problema_ordenar_decimales.dart';
import '../dominio/problema_comparacion_unidad.dart';
import '../dominio/problema_decimal.dart';
import '../dominio/problema_divisibilidad.dart';
import '../dominio/problema_divisores.dart';
import '../dominio/problema_fraccion_de_cantidad.dart';
import '../dominio/problema_ordenar_fracciones.dart';
import '../dominio/problema_razon.dart';
import '../dominio/problema_espejo.dart' show Fraccion;
import '../dominio/problema_lectura_decimal.dart';
import '../dominio/problema_lectura_fraccion.dart';
import '../dominio/problema_jerarquia.dart';
import '../dominio/problema_longitud.dart';
import '../dominio/problema_masa_capacidad.dart';
import '../dominio/problema_porcentaje_de.dart';
import '../dominio/problema_aumento_descuento.dart';
import '../dominio/problema_angulo.dart';
import '../dominio/problema_media.dart';
import '../dominio/problema_moda_mediana.dart';
import '../dominio/problema_probabilidad.dart';
import '../dominio/problema_probabilidad_porcentaje.dart';
import '../dominio/problema_escala.dart';
import '../dominio/problema_jerarquia_fracciones.dart';
import '../dominio/problema_operacion_mixta.dart';
import '../dominio/problema_poligono.dart';
import '../dominio/problema_perimetro.dart';
import '../dominio/problema_area_rectangulo.dart';
import '../dominio/problema_area_triangulo.dart';
import '../dominio/problema_superficie.dart';
import '../dominio/problema_tiempo.dart';
import '../dominio/problema_mcm_mcd.dart';
import '../dominio/problema_regla_de_tres.dart';
import '../dominio/problema_primo.dart';
import '../dominio/problema_comparacion_media.dart';
import '../dominio/problema_porcentaje_cantidad.dart';
import '../dominio/problema_mixto_a_impropio.dart'
    show ProblemaMixtoAImpropio;
import '../dominio/problema_redondeo_decimal.dart';
import '../dominio/problema_porcentaje.dart';
import '../dominio/selector_habilidades.dart';
import '../nucleo/paleta.dart';
import '../sonido/capa_audio.dart';
import '../sonido/catalogo_sonidos.dart';
import '../sonido/servicio_sonoro.dart';
import 'escenario.dart';
import 'pantalla_combate_enfoque.dart';
import 'pantalla_comparacion.dart';
import 'pantalla_comparacion_distinta.dart';
import 'pantalla_ordenar_decimales.dart';
import 'pantalla_comparacion_unidad.dart';
import 'pantalla_decimal.dart';
import 'pantalla_dual.dart';
import 'pantalla_espejo.dart';
import 'pantalla_impropio.dart';
import 'pantalla_operacion_decimal.dart';
import 'pantalla_amplificar.dart';
import 'pantalla_comparacion_decimal.dart';
import 'pantalla_divisibilidad.dart';
import 'pantalla_divisores.dart';
import 'pantalla_fraccion_de_cantidad.dart';
import 'pantalla_ordenar_fracciones.dart';
import 'pantalla_razon.dart';
import 'pantalla_lectura_decimal.dart';
import 'pantalla_lectura_fraccion.dart';
import 'pantalla_jerarquia.dart';
import 'pantalla_longitud.dart';
import 'pantalla_masa_capacidad.dart';
import 'pantalla_porcentaje_de.dart';
import 'pantalla_aumento_descuento.dart';
import 'pantalla_angulo.dart';
import 'pantalla_media.dart';
import 'pantalla_moda_mediana.dart';
import 'pantalla_probabilidad.dart';
import 'pantalla_probabilidad_porcentaje.dart';
import 'pantalla_operacion_mixta.dart';
import 'pantalla_poligono.dart';
import 'pantalla_perimetro.dart';
import 'pantalla_area_rectangulo.dart';
import 'pantalla_area_triangulo.dart';
import 'pantalla_escala.dart';
import 'pantalla_jerarquia_fracciones.dart';
import 'pantalla_superficie.dart';
import 'pantalla_tiempo.dart';
import 'pantalla_mcm_mcd.dart';
import 'pantalla_regla_de_tres.dart';
import 'pantalla_primo.dart';
import 'pantalla_comparacion_media.dart';
import 'pantalla_porcentaje_cantidad.dart';
import 'pantalla_mixto_a_impropio.dart';
import 'pantalla_redondeo_decimal.dart';
import 'pantalla_porcentaje.dart';
import 'pantalla_proporcional.dart';
import 'pantalla_simplificar.dart';
import 'pintor_fragmento_tejado.dart';
import 'sora_presencia.dart';

/// El nuevo bucle: un trozo del tejado donde los Fragmentos van
/// apareciendo. El niño decide cuál cazar, cuándo y en qué orden.
/// Si tarda demasiado, el Fragmento se escapa hacia la Montaña. Cada
/// captura deja una esquirla que engorda el contador arriba a la
/// derecha.
class PantallaCaza extends StatefulWidget {
  final RepositorioProgreso repositorio;
  final Distrito distrito;

  const PantallaCaza({
    super.key,
    required this.repositorio,
    required this.distrito,
  });

  @override
  State<PantallaCaza> createState() => _PantallaCazaState();
}

class _PantallaCazaState extends State<PantallaCaza>
    with TickerProviderStateMixin {
  static const int _maxFragmentosEnTejado = 3;
  static const Duration _tickPeriodo = Duration(milliseconds: 120);

  late final GeneradorCaza _generador;
  MotorMaestria? _motorMaestria;
  SelectorHabilidades? _selectorHabilidades;
  final List<FragmentoEnTejado> _activos = [];
  final Map<String, DateTime> _instanteAperturaPuzzle = {};

  int _esquirlasTotal = 0;
  int _esquirlasEstaSesion = 0;
  String? _lineaAmbienteSora;
  Timer? _temporizadorSpawn;
  Timer? _temporizadorTick;
  Timer? _temporizadorLineaSora;
  DateTime _ahoraRef = DateTime.now();

  late final AnimationController _controladorCielo;

  @override
  void initState() {
    super.initState();
    _generador = GeneradorCaza(distrito: widget.distrito);
    _controladorCielo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _cargarEstadoInicial();
    _inicializarMotorMaestria();
  }

  Future<void> _inicializarMotorMaestria() async {
    final catalogo = await CatalogoHabilidades.cargar();
    if (!mounted) return;
    _motorMaestria = MotorMaestria(
      catalogo: catalogo,
      cargarEstado: widget.repositorio.cargarEstadoHabilidad,
      guardarEstado: widget.repositorio.guardarEstadoHabilidad,
      alSubirNivel: (idHabilidad, nivel) {
        widget.repositorio.activarFlagNarrativo(
          MotorMaestria.flagDeMaestria(idHabilidad, nivel),
        );
      },
    );
    _selectorHabilidades = SelectorHabilidades(
      catalogo: catalogo,
      cargarEstado: widget.repositorio.cargarEstadoHabilidad,
    );
  }

  Future<void> _cargarEstadoInicial() async {
    final total = await widget.repositorio.cargarEsquirlas();
    final yaVisitado = await widget.repositorio
        .distritoVisitado(widget.distrito.identificador);
    if (!mounted) return;
    setState(() => _esquirlasTotal = total);
    _programarSiguienteSpawn();
    _arrancarTickDeEscapes();
    final saludo = yaVisitado
        ? 'Vamos.'
        : widget.distrito.saludoPrimeraVisita;
    _mostrarLineaAmbienteSora(saludo);
    if (!yaVisitado) {
      await widget.repositorio
          .marcarDistritoComoVisitado(widget.distrito.identificador);
    }
    _arrancarAmbientYMusicaDeDistrito();
  }

  void _arrancarAmbientYMusicaDeDistrito() {
    final idDistrito = widget.distrito.identificador;
    final ambient = CatalogoSonidos.ambientDeDistrito(idDistrito);
    final musica = CatalogoSonidos.musicaDeDistrito(idDistrito);
    if (ambient != null) {
      ServicioSonoro.instancia.reproducirLoop(ambient, msFade: 1500);
    }
    if (musica != null) {
      ServicioSonoro.instancia.reproducirLoop(musica, msFade: 1800);
    }
  }

  @override
  void dispose() {
    _controladorCielo.dispose();
    _temporizadorSpawn?.cancel();
    _temporizadorTick?.cancel();
    _temporizadorLineaSora?.cancel();
    // Dejamos el ambient sonando pero paramos la música del distrito
    // al volver al mapa — hace que la transición se sienta.
    ServicioSonoro.instancia.detenerCapa(CapaAudio.musica, msFade: 700);
    ServicioSonoro.instancia.detenerCapa(CapaAudio.ambient, msFade: 900);
    super.dispose();
  }

  void _programarSiguienteSpawn() {
    _temporizadorSpawn?.cancel();
    final esperaMs = 2400 + math.Random().nextInt(3000);
    _temporizadorSpawn = Timer(Duration(milliseconds: esperaMs), _intentarSpawn);
  }

  Future<void> _intentarSpawn() async {
    if (!mounted) return;
    if (_activos.length < _maxFragmentosEnTejado) {
      final esquirlas = _esquirlasTotal + _esquirlasEstaSesion;
      final ahora = DateTime.now();
      // Cada varios spawns dejamos que el selector pida una habilidad;
      // el resto del tiempo usamos el reparto del distrito para que
      // aparezcan también los tipos sin skill implementada todavía
      // (unitarios simples, proporcionales).
      final usarSelector = _selectorHabilidades != null &&
          math.Random().nextDouble() < 0.6;
      final nuevo = usarSelector
          ? await _generarDesdeSelector(esquirlas: esquirlas, ahora: ahora)
          : _generador.siguiente(
              esquirlasAcumuladas: esquirlas,
              ahora: ahora,
            );
      if (!mounted) return;
      setState(() => _activos.add(nuevo));
    }
    _programarSiguienteSpawn();
  }

  Future<FragmentoEnTejado> _generarDesdeSelector({
    required int esquirlas,
    required DateTime ahora,
  }) async {
    final selector = _selectorHabilidades!;
    final idHabilidad = await selector.elegirSiguienteHabilidad(
      distrito: widget.distrito,
    );
    if (idHabilidad == null) {
      return _generador.siguiente(
        esquirlasAcumuladas: esquirlas,
        ahora: ahora,
      );
    }
    return _generador.siguienteParaSkill(
      idHabilidad: idHabilidad,
      esquirlasAcumuladas: esquirlas,
      ahora: ahora,
    );
  }

  void _arrancarTickDeEscapes() {
    _temporizadorTick?.cancel();
    _temporizadorTick = Timer.periodic(_tickPeriodo, (_) {
      if (!mounted) return;
      final ahora = DateTime.now();
      final seEscapanAhora = _activos
          .where((f) => f.seHaEscapado(ahora))
          .toList(growable: false);
      if (seEscapanAhora.isNotEmpty) {
        setState(() {
          for (final f in seEscapanAhora) {
            _activos.remove(f);
          }
          _ahoraRef = ahora;
        });
        _comentarTrasEscape(seEscapanAhora.length);
      } else {
        setState(() => _ahoraRef = ahora);
      }
    });
  }

  Future<void> _alTocarFragmento(FragmentoEnTejado fragmento) async {
    HapticFeedback.selectionClick();
    _instanteAperturaPuzzle[fragmento.identificador] = DateTime.now();
    final capturado = await _abrirPuzzleSegunTipo(fragmento);
    if (!mounted) return;
    _registrarResultadoMaestria(fragmento, capturado == true);
    setState(() => _activos.remove(fragmento));
    if (capturado == true) {
      final esquirlasGanadas = switch (fragmento.tipo) {
        TipoFragmentoEnTejado.espejo => 2,
        TipoFragmentoEnTejado.decimal => 2,
        TipoFragmentoEnTejado.porcentaje => 2,
        TipoFragmentoEnTejado.comparacion => 2,
        TipoFragmentoEnTejado.simplificar => 3,
        TipoFragmentoEnTejado.amplificar => 3,
        TipoFragmentoEnTejado.divisibilidad => 1,
        TipoFragmentoEnTejado.multiplos => 1,
        TipoFragmentoEnTejado.comparacionDecimal => 2,
        TipoFragmentoEnTejado.lecturaDecimal => 2,
        TipoFragmentoEnTejado.comparacionUnidad => 2,
        TipoFragmentoEnTejado.lecturaFraccion => 2,
        TipoFragmentoEnTejado.mixtoAImpropio => 3,
        TipoFragmentoEnTejado.redondeoDecimal => 2,
        TipoFragmentoEnTejado.comparacionDistinta => 3,
        TipoFragmentoEnTejado.primo => 1,
        TipoFragmentoEnTejado.reglaDeTres => 3,
        TipoFragmentoEnTejado.ordenarDecimales => 2,
        TipoFragmentoEnTejado.mcmMcd => 3,
        TipoFragmentoEnTejado.jerarquia => 3,
        TipoFragmentoEnTejado.comparacionMedia => 2,
        TipoFragmentoEnTejado.porcentajeCantidad => 3,
        TipoFragmentoEnTejado.divisores => 2,
        TipoFragmentoEnTejado.fraccionDeCantidad => 3,
        TipoFragmentoEnTejado.ordenarFracciones => 3,
        TipoFragmentoEnTejado.razon => 2,
        TipoFragmentoEnTejado.longitud => 2,
        TipoFragmentoEnTejado.masaCapacidad => 2,
        TipoFragmentoEnTejado.porcentajeDe => 3,
        TipoFragmentoEnTejado.tiempo => 2,
        TipoFragmentoEnTejado.aumentoDescuento => 3,
        TipoFragmentoEnTejado.superficie => 3,
        TipoFragmentoEnTejado.jerarquiaFracciones => 4,
        TipoFragmentoEnTejado.escala => 3,
        TipoFragmentoEnTejado.angulo => 1,
        TipoFragmentoEnTejado.media => 2,
        TipoFragmentoEnTejado.modaMediana => 2,
        TipoFragmentoEnTejado.probabilidad => 3,
        TipoFragmentoEnTejado.probabilidadPorcentaje => 3,
        TipoFragmentoEnTejado.operacionMixta => 4,
        TipoFragmentoEnTejado.poligono => 1,
        TipoFragmentoEnTejado.perimetro => 2,
        TipoFragmentoEnTejado.areaRectangulo => 2,
        TipoFragmentoEnTejado.areaTriangulo => 2,
        TipoFragmentoEnTejado.impropio => 3,
        TipoFragmentoEnTejado.proporcional => 3,
        TipoFragmentoEnTejado.dual => 4,
        TipoFragmentoEnTejado.operacionDecimal => 4,
        TipoFragmentoEnTejado.unitario => fragmento.numerador,
      };
      setState(() {
        _esquirlasEstaSesion += esquirlasGanadas;
        _esquirlasTotal += esquirlasGanadas;
      });
      await widget.repositorio.guardarEsquirlas(_esquirlasTotal);
      await _verificarSubidaDeRango();
      _comentarTrasCaptura();
    } else {
      _mostrarLineaAmbienteSora('Ya volverá otro.');
    }
  }

  Future<bool?> _abrirPuzzleSegunTipo(FragmentoEnTejado fragmento) {
    switch (fragmento.tipo) {
      case TipoFragmentoEnTejado.espejo:
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaEspejo(
              numerador: fragmento.numerador,
              denominador: fragmento.denominador,
            ),
          ),
        );
      case TipoFragmentoEnTejado.decimal:
        final decimalObjetivo = _buscarDecimalConocido(
          fragmento.etiquetaDecimal,
        );
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) =>
                PantallaDecimal(decimalObjetivo: decimalObjetivo),
          ),
        );
      case TipoFragmentoEnTejado.porcentaje:
        final porcentajeObjetivo = _buscarPorcentajeConocido(
          fragmento.etiquetaDecimal,
        );
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) =>
                PantallaPorcentaje(porcentajeObjetivo: porcentajeObjetivo),
          ),
        );
      case TipoFragmentoEnTejado.impropio:
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaImpropio(
              numerador: fragmento.numerador,
              denominador: fragmento.denominador,
            ),
          ),
        );
      case TipoFragmentoEnTejado.proporcional:
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaProporcional(
              a: fragmento.numerador,
              b: fragmento.denominador,
            ),
          ),
        );
      case TipoFragmentoEnTejado.dual:
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaDual(
              numeradorA: fragmento.numerador,
              denominadorA: fragmento.denominador,
              numeradorB: fragmento.numeradorB ?? 1,
              denominadorB: fragmento.denominadorB ?? 2,
              operador: fragmento.operador ?? OperadorAritmetico.suma,
            ),
          ),
        );
      case TipoFragmentoEnTejado.operacionDecimal:
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaOperacionDecimal(
              etiquetaA: fragmento.decimalA ?? '0,5',
              etiquetaB: fragmento.decimalB ?? '0,5',
              operador: fragmento.operador ?? OperadorAritmetico.suma,
            ),
          ),
        );
      case TipoFragmentoEnTejado.unitario:
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaCombateEnfoque(
              numerador: fragmento.numerador,
              denominador: fragmento.denominador,
            ),
          ),
        );
      case TipoFragmentoEnTejado.comparacion:
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaComparacion(
              a: Fraccion(fragmento.numerador, fragmento.denominador),
              b: Fraccion(
                fragmento.numeradorB ?? fragmento.numerador,
                fragmento.denominadorB ?? fragmento.denominador,
              ),
              modo: fragmento.modoComparacion ??
                  ModoComparacion.mismoDenominador,
            ),
          ),
        );
      case TipoFragmentoEnTejado.simplificar:
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaSimplificar(
              numerador: fragmento.numerador,
              denominador: fragmento.denominador,
            ),
          ),
        );
      case TipoFragmentoEnTejado.amplificar:
        // Usamos `denominadorB` como denominador objetivo si vino
        // calculado por el generador; si no, fabricamos uno multiplicando
        // la base por 3 — tolerante a Fragmentos manuales.
        final objetivo = fragmento.denominadorB ?? fragmento.denominador * 3;
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaAmplificar(
              numeradorBase: fragmento.numerador,
              denominadorBase: fragmento.denominador,
              denominadorObjetivo: objetivo,
            ),
          ),
        );
      case TipoFragmentoEnTejado.divisibilidad:
        // numerador → número candidato; denominador → divisor.
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaDivisibilidad(
              problemaPredeterminado: ProblemaDivisibilidad(
                numero: fragmento.numerador,
                divisor: fragmento.denominador,
              ),
              modo: ModoFraseoDivisibilidad.divisible,
            ),
          ),
        );
      case TipoFragmentoEnTejado.multiplos:
        // Misma estructura, fraseado distinto: "¿es múltiplo de M?".
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaDivisibilidad(
              problemaPredeterminado: ProblemaDivisibilidad(
                numero: fragmento.numerador,
                divisor: fragmento.denominador,
              ),
              modo: ModoFraseoDivisibilidad.multiplo,
            ),
          ),
        );
      case TipoFragmentoEnTejado.lecturaDecimal:
        // El texto del decimal viaja en etiquetaDecimal — la pantalla
        // reconstruye el problema con sus distractores curados.
        final textoEnPalabras = fragmento.etiquetaDecimal ?? 'tres décimas';
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaLecturaDecimal(
              problemaPredeterminado:
                  GeneradorLecturaDecimal().generarDesdeTexto(textoEnPalabras),
            ),
          ),
        );
      case TipoFragmentoEnTejado.comparacionDecimal:
        // decimalA/decimalB llevan las dos etiquetas tal cual; si el
        // Fragmento se construyó manualmente sin ellas, fabricamos un
        // par fácil para no dejar al niño en blanco.
        final etiquetaA = fragmento.decimalA ?? '0,3';
        final etiquetaB = fragmento.decimalB ?? '0,7';
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaComparacionDecimal(
              problemaPredeterminado: ProblemaComparacionDecimal(
                etiquetaA: etiquetaA,
                etiquetaB: etiquetaB,
                valorA:
                    double.parse(etiquetaA.replaceAll(',', '.')),
                valorB:
                    double.parse(etiquetaB.replaceAll(',', '.')),
              ),
            ),
          ),
        );
      case TipoFragmentoEnTejado.comparacionUnidad:
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaComparacionUnidad(
              problemaPredeterminado: ProblemaComparacionUnidad(
                fraccion: Fraccion(
                  fragmento.numerador,
                  fragmento.denominador,
                ),
              ),
            ),
          ),
        );
      case TipoFragmentoEnTejado.lecturaFraccion:
        // El texto viaja en etiquetaDecimal — la pantalla reconstruye
        // el problema con sus distractores curados.
        final textoEnPalabras =
            fragmento.etiquetaDecimal ?? 'tres quintos';
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaLecturaFraccion(
              problemaPredeterminado: GeneradorLecturaFraccion()
                  .generarDesdeTexto(textoEnPalabras),
            ),
          ),
        );
      case TipoFragmentoEnTejado.mixtoAImpropio:
        // numeradorB lleva el entero; numerador/denominador llevan la
        // impropia ya calculada — al reconstruir el mixto, tomamos
        // num original = numerador − entero × denominador.
        final entero = fragmento.numeradorB ?? 1;
        final denominador = fragmento.denominador;
        final numeradorMixto = fragmento.numerador - entero * denominador;
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaMixtoAImpropio(
              problemaPredeterminado: _construirMixtoAImpropio(
                entero: entero,
                numerador: numeradorMixto,
                denominador: denominador,
              ),
            ),
          ),
        );
      case TipoFragmentoEnTejado.redondeoDecimal:
        final etiquetaOriginal = fragmento.etiquetaDecimal ?? '2,37';
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaRedondeoDecimal(
              problemaPredeterminado: GeneradorRedondeoDecimal()
                  .generarDesdeEtiqueta(etiquetaOriginal),
            ),
          ),
        );
      case TipoFragmentoEnTejado.comparacionDistinta:
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaComparacionDistinta(
              problemaPredeterminado: ProblemaComparacionDistinta(
                a: Fraccion(fragmento.numerador, fragmento.denominador),
                b: Fraccion(
                  fragmento.numeradorB ?? fragmento.numerador,
                  fragmento.denominadorB ?? fragmento.denominador,
                ),
              ),
            ),
          ),
        );
      case TipoFragmentoEnTejado.primo:
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaPrimo(
              problemaPredeterminado:
                  ProblemaPrimo(numero: fragmento.numerador),
            ),
          ),
        );
      case TipoFragmentoEnTejado.reglaDeTres:
        // numerador → a, denominador → b, numeradorB → c.
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaReglaDeTres(
              problemaPredeterminado: GeneradorReglaDeTres()
                  .generarDesdeTerminos(
                a: fragmento.numerador,
                b: fragmento.denominador,
                c: fragmento.numeradorB ?? 1,
              ),
            ),
          ),
        );
      case TipoFragmentoEnTejado.ordenarDecimales:
        // decimalA, decimalB y etiquetaDecimal recomponen los tres
        // decimales presentados (la etiqueta carga los tres
        // separados por '|').
        final partes = (fragmento.etiquetaDecimal ?? '').split('|');
        final trio = partes.length == 3
            ? partes
            : <String>[
                fragmento.decimalA ?? '0,5',
                fragmento.decimalB ?? '0,3',
                '0,8',
              ];
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaOrdenarDecimales(
              problemaPredeterminado: GeneradorOrdenarDecimales()
                  .generarDesdeTrio(trio),
            ),
          ),
        );
      case TipoFragmentoEnTejado.mcmMcd:
        // numerador/denominador → los dos números a calcular.
        // etiquetaDecimal → 'mcm' o 'mcd'.
        final modo = fragmento.etiquetaDecimal == 'mcd'
            ? ModoMcmMcd.mcd
            : ModoMcmMcd.mcm;
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaMcmMcd(
              problemaPredeterminado: GeneradorMcmMcd().generarDesdeTerminos(
                a: fragmento.numerador,
                b: fragmento.denominador,
                modo: modo,
              ),
            ),
          ),
        );
      case TipoFragmentoEnTejado.jerarquia:
        // numerador → a, denominador → b, numeradorB → c.
        // operador → op2, decimalA → name del op1.
        final op1 = OperadorAritmetico.values.firstWhere(
          (o) => o.name == fragmento.decimalA,
          orElse: () => OperadorAritmetico.suma,
        );
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaJerarquia(
              problemaPredeterminado:
                  GeneradorJerarquia().generarDesdeTerminos(
                a: fragmento.numerador,
                b: fragmento.denominador,
                c: fragmento.numeradorB ?? 1,
                op1: op1,
                op2: fragmento.operador ?? OperadorAritmetico.suma,
              ),
            ),
          ),
        );
      case TipoFragmentoEnTejado.comparacionMedia:
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaComparacionMedia(
              problemaPredeterminado: GeneradorComparacionMedia()
                  .generarDesdeFraccion(
                Fraccion(fragmento.numerador, fragmento.denominador),
              ),
            ),
          ),
        );
      case TipoFragmentoEnTejado.porcentajeCantidad:
        // numerador → porcentaje, denominador → cantidad.
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaPorcentajeCantidad(
              problemaPredeterminado: GeneradorPorcentajeCantidad()
                  .generarDesdePar(fragmento.numerador, fragmento.denominador),
            ),
          ),
        );
      case TipoFragmentoEnTejado.divisores:
        // numerador → número objetivo.
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaDivisores(
              problemaPredeterminado: GeneradorDivisores()
                  .generarDesdeNumero(fragmento.numerador),
            ),
          ),
        );
      case TipoFragmentoEnTejado.fraccionDeCantidad:
        // numerador → numerador, denominador → denominador, numeradorB → cantidad.
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaFraccionDeCantidad(
              problemaPredeterminado: GeneradorFraccionDeCantidad()
                  .generarDesdeTerminos(
                numerador: fragmento.numerador,
                denominador: fragmento.denominador,
                cantidad: fragmento.numeradorB ?? 1,
              ),
            ),
          ),
        );
      case TipoFragmentoEnTejado.razon:
        // numerador/denominador → primero/segundo, decimalA/decimalB →
        // etiquetas del contexto.
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaRazon(
              problemaPredeterminado: GeneradorRazon().generarDesdePar(
                primero: fragmento.numerador,
                segundo: fragmento.denominador,
                etiquetaPrimero: fragmento.decimalA ?? 'rojas',
                etiquetaSegundo: fragmento.decimalB ?? 'azules',
              ),
            ),
          ),
        );
      case TipoFragmentoEnTejado.longitud:
        // numerador → valorOrigen, decimalA/decimalB → símbolos.
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaLongitud(
              problemaPredeterminado:
                  GeneradorLongitud().generarDesdeTerminos(
                valorOrigen: fragmento.numerador,
                unidadOrigen:
                    unidadDesdeSimbolo(fragmento.decimalA ?? 'm'),
                unidadDestino:
                    unidadDesdeSimbolo(fragmento.decimalB ?? 'cm'),
              ),
            ),
          ),
        );
      case TipoFragmentoEnTejado.probabilidadPorcentaje:
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaProbabilidadPorcentaje(
              problemaPredeterminado:
                  GeneradorProbabilidadPorcentaje().generarPorIndice(
                fragmento.numerador,
              ),
            ),
          ),
        );
      case TipoFragmentoEnTejado.operacionMixta:
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaOperacionMixta(
              problemaPredeterminado:
                  GeneradorOperacionMixta().generarPorIndice(
                fragmento.numerador,
              ),
            ),
          ),
        );
      case TipoFragmentoEnTejado.poligono:
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaPoligono(
              problemaPredeterminado:
                  GeneradorPoligono().generarDesdeLados(
                fragmento.numerador,
              ),
            ),
          ),
        );
      case TipoFragmentoEnTejado.perimetro:
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaPerimetro(
              problemaPredeterminado: GeneradorPerimetro()
                  .generarPorIndice(fragmento.numerador),
            ),
          ),
        );
      case TipoFragmentoEnTejado.areaRectangulo:
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaAreaRectangulo(
              problemaPredeterminado: GeneradorAreaRectangulo()
                  .generarPorIndice(fragmento.numerador),
            ),
          ),
        );
      case TipoFragmentoEnTejado.areaTriangulo:
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaAreaTriangulo(
              problemaPredeterminado: GeneradorAreaTriangulo()
                  .generarPorIndice(fragmento.numerador),
            ),
          ),
        );
      case TipoFragmentoEnTejado.probabilidad:
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaProbabilidad(
              problemaPredeterminado: GeneradorProbabilidad()
                  .generarPorIndice(fragmento.numerador),
            ),
          ),
        );
      case TipoFragmentoEnTejado.modaMediana:
        // numerador → índice; denominador → 1 moda, 2 mediana.
        final modoEst = fragmento.denominador == 2
            ? ModoEstadistico.mediana
            : ModoEstadistico.moda;
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaModaMediana(
              problemaPredeterminado: GeneradorModaMediana()
                  .generarPorIndice(modoEst, fragmento.numerador),
            ),
          ),
        );
      case TipoFragmentoEnTejado.media:
        // numerador → índice del conjunto curado.
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaMedia(
              problemaPredeterminado:
                  GeneradorMedia().generarPorIndice(fragmento.numerador),
            ),
          ),
        );
      case TipoFragmentoEnTejado.angulo:
        // numerador → grados.
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaAngulo(
              problemaPredeterminado:
                  GeneradorAngulo().generarDesdeGrados(fragmento.numerador),
            ),
          ),
        );
      case TipoFragmentoEnTejado.escala:
        // numerador → denominadorEscala, denominador → valorPlanoCm.
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaEscala(
              problemaPredeterminado: GeneradorEscala().generarDesdeTerminos(
                denominadorEscala: fragmento.numerador,
                valorPlanoCm: fragmento.denominador,
              ),
            ),
          ),
        );
      case TipoFragmentoEnTejado.jerarquiaFracciones:
        // numerador → índice del caso curado.
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaJerarquiaFracciones(
              problemaPredeterminado: GeneradorJerarquiaFracciones()
                  .generarPorIndice(fragmento.numerador),
            ),
          ),
        );
      case TipoFragmentoEnTejado.superficie:
        // numerador → valorOrigen, decimalA/decimalB → símbolos.
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaSuperficie(
              problemaPredeterminado:
                  GeneradorSuperficie().generarDesdeTerminos(
                valorOrigen: fragmento.numerador,
                unidadOrigen: unidadSuperficieDesdeSimbolo(
                    fragmento.decimalA ?? 'm²'),
                unidadDestino: unidadSuperficieDesdeSimbolo(
                    fragmento.decimalB ?? 'cm²'),
              ),
            ),
          ),
        );
      case TipoFragmentoEnTejado.aumentoDescuento:
        // numerador → porcentaje, denominador → cantidad,
        // decimalA → 'A' (aumento) o 'D' (descuento).
        final tipoVariacion = (fragmento.decimalA ?? 'A') == 'A'
            ? TipoVariacionPorcentual.aumento
            : TipoVariacionPorcentual.descuento;
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaAumentoDescuento(
              problemaPredeterminado:
                  GeneradorAumentoDescuento().generarDesdeTerminos(
                tipo: tipoVariacion,
                porcentaje: fragmento.numerador,
                cantidad: fragmento.denominador,
              ),
            ),
          ),
        );
      case TipoFragmentoEnTejado.tiempo:
        // numeradorB > 0 → compuesto (h y min → min). null → simple.
        final problemaTiempo = fragmento.numeradorB != null
            ? GeneradorTiempo().generarCompuestoDesdeTerminos(
                horas: fragmento.numerador,
                minutos: fragmento.numeradorB!,
              )
            : GeneradorTiempo().generarSimpleDesdeTerminos(
                valor: fragmento.numerador,
                origen: unidadTiempoDesdeSimbolo(
                    fragmento.decimalA ?? 'h'),
                destino: unidadTiempoDesdeSimbolo(
                    fragmento.decimalB ?? 'min'),
              );
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaTiempo(
              problemaPredeterminado: problemaTiempo,
            ),
          ),
        );
      case TipoFragmentoEnTejado.porcentajeDe:
        // numerador → parte, denominador → total.
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaPorcentajeDe(
              problemaPredeterminado: GeneradorPorcentajeDe()
                  .generarDesdeTerminos(
                parte: fragmento.numerador,
                total: fragmento.denominador,
              ),
            ),
          ),
        );
      case TipoFragmentoEnTejado.masaCapacidad:
        // numerador → valorOrigen, decimalA/decimalB → símbolos. La
        // familia se infiere parseando el símbolo de origen.
        final origen = unidadDesdeSimboloMetrica(fragmento.decimalA ?? 'g');
        final destino = unidadDesdeSimboloMetrica(fragmento.decimalB ?? 'mg');
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaMasaCapacidad(
              problemaPredeterminado:
                  GeneradorMasaCapacidad().generarDesdeTerminos(
                familia: origen.familia,
                valorOrigen: fragmento.numerador,
                posicionOrigen: origen.posicion,
                posicionDestino: destino.posicion,
              ),
            ),
          ),
        );
      case TipoFragmentoEnTejado.ordenarFracciones:
        // etiquetaDecimal lleva las tres fracciones separadas por '|'
        // ('3/5|2/3|1/2'). Reconstruimos el trío.
        final partes = (fragmento.etiquetaDecimal ?? '').split('|');
        final fallback = [
          const Fraccion(1, 2),
          const Fraccion(1, 3),
          const Fraccion(1, 4),
        ];
        final trio = partes.length == 3
            ? partes.map((p) {
                final ab = p.split('/');
                return Fraccion(int.parse(ab[0]), int.parse(ab[1]));
              }).toList()
            : fallback;
        return Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PantallaOrdenarFracciones(
              problemaPredeterminado: GeneradorOrdenarFracciones()
                  .generarDesdeTrio(trio),
            ),
          ),
        );
    }
  }

  ProblemaMixtoAImpropio _construirMixtoAImpropio({
    required int entero,
    required int numerador,
    required int denominador,
  }) {
    // Reconstruye el problema FR.13 con los distractores pedagógicos
    // canónicos a partir de un mixto concreto. Los cuatro candidatos
    // siempre incluyen el correcto, la suma errónea, la fracción sola
    // y el producto sin sumar.
    final correcto = Fraccion(entero * denominador + numerador, denominador);
    final propuestos = <Fraccion>[correcto];
    bool yaEsta(Fraccion f) =>
        propuestos.any((p) =>
            p.numerador == f.numerador && p.denominador == f.denominador);
    void anyadirSiNuevo(Fraccion f) {
      if (f.numerador > 0 && !yaEsta(f)) propuestos.add(f);
    }

    anyadirSiNuevo(Fraccion(entero + numerador, denominador));
    anyadirSiNuevo(Fraccion(numerador, denominador));
    anyadirSiNuevo(Fraccion(entero * numerador, denominador));

    var paso = 1;
    while (propuestos.length < 4) {
      anyadirSiNuevo(Fraccion(correcto.numerador + paso, denominador));
      if (propuestos.length < 4) {
        anyadirSiNuevo(Fraccion(correcto.numerador - paso, denominador));
      }
      paso++;
    }

    final indice = propuestos.indexWhere(
      (f) =>
          f.numerador == correcto.numerador &&
          f.denominador == correcto.denominador,
    );
    return ProblemaMixtoAImpropio(
      entero: entero,
      numerador: numerador,
      denominador: denominador,
      candidatos: propuestos,
      indiceCorrecto: indice,
    );
  }

  DecimalConocido? _buscarDecimalConocido(String? etiqueta) {
    if (etiqueta == null) return null;
    for (final d in decimalesConocidos) {
      if (d.etiqueta == etiqueta) return d;
    }
    return null;
  }

  PorcentajeConocido? _buscarPorcentajeConocido(String? etiqueta) {
    if (etiqueta == null) return null;
    for (final p in porcentajesConocidos) {
      if (p.etiqueta == etiqueta) return p;
    }
    return null;
  }

  /// Comprueba si el total acumulado de esquirlas implica subir de
  /// rango y, si es así, lo persiste y activa el flag narrativo
  /// correspondiente para que las escenas reaccionen.
  Future<void> _verificarSubidaDeRango() async {
    final actual = await widget.repositorio.cargarRango();
    final segunEsquirlas = rangoSegunEsquirlas(_esquirlasTotal);
    if (segunEsquirlas.valor > actual.valor) {
      await widget.repositorio.guardarRango(segunEsquirlas);
      await widget.repositorio
          .activarFlagNarrativo(segunEsquirlas.flagAlcanzado);
    }
  }

  /// Registra el intento contra el motor de maestría. Silencioso: si
  /// el motor aún no se ha cargado (carga asíncrona), simplemente no
  /// registra; la siguiente partida lo hará.
  Future<void> _registrarResultadoMaestria(
    FragmentoEnTejado fragmento,
    bool acertado,
  ) async {
    final motor = _motorMaestria;
    if (motor == null) return;
    final instanteAbierto =
        _instanteAperturaPuzzle.remove(fragmento.identificador);
    final duracionSeg = instanteAbierto == null
        ? 15
        : DateTime.now().difference(instanteAbierto).inSeconds.clamp(1, 600);
    await motor.registrarResultado(
      idHabilidad: idHabilidadPrincipal(fragmento),
      acierto: acertado,
      dificultad: dificultadEstimadaDelPuzzle(fragmento),
      duracionSegundos: duracionSeg,
    );
  }

  void _comentarTrasCaptura() {
    final hitos = {
      1: 'Bien. El primero ya es tuyo.',
      5: 'Cinco. Te estás haciendo a esto.',
      10: 'Diez en una noche. Mira el barrio.',
      20: 'Veinte. A ver si te atreves con los primos.',
    };
    final mensajeHito = hitos[_esquirlasEstaSesion];
    if (mensajeHito != null) {
      _mostrarLineaAmbienteSora(mensajeHito);
      return;
    }
    if (_esquirlasEstaSesion % 3 == 0) {
      const variedad = [
        'Otro menos.',
        'Así.',
        'Bien visto.',
        'Sigue.',
      ];
      _mostrarLineaAmbienteSora(
          variedad[math.Random().nextInt(variedad.length)]);
    }
  }

  void _comentarTrasEscape(int cantidad) {
    if (cantidad == 1) {
      _mostrarLineaAmbienteSora('Se te ha ido. No pasa nada.');
    } else {
      _mostrarLineaAmbienteSora('Se han escapado varios. Atento.');
    }
  }

  void _mostrarLineaAmbienteSora(String texto) {
    _temporizadorLineaSora?.cancel();
    setState(() => _lineaAmbienteSora = texto);
    _temporizadorLineaSora = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      setState(() => _lineaAmbienteSora = null);
    });
  }

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controladorCielo,
        builder: (_, __) {
          return Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(
                painter: PintorEscenario(
                  fasePulso: _controladorCielo.value,
                  nivelRestauracion:
                      (_esquirlasTotal / 30).clamp(0.0, 1.0),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    _BarraSuperior(
                      nombreDistrito: widget.distrito.nombre,
                      esquirlas: _esquirlasTotal,
                      esquirlasNuevasDestello: _esquirlasEstaSesion,
                      alVolverAlMapa: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (_, constraints) {
                          return Stack(
                            children: [
                              for (final fragmento in _activos)
                                _FragmentoEnMapa(
                                  key: ValueKey(fragmento.identificador),
                                  fragmento: fragmento,
                                  tamanoContenedor: constraints.biggest,
                                  ahora: _ahoraRef,
                                  fasePulso: _controladorCielo.value,
                                  alTocar: () => _alTocarFragmento(fragmento),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                    SoraPresencia(textoActivo: _lineaAmbienteSora),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BarraSuperior extends StatelessWidget {
  final String nombreDistrito;
  final int esquirlas;
  final int esquirlasNuevasDestello;
  final VoidCallback alVolverAlMapa;

  const _BarraSuperior({
    required this.nombreDistrito,
    required this.esquirlas,
    required this.esquirlasNuevasDestello,
    required this.alVolverAlMapa,
  });

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 20, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: alVolverAlMapa,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(
                  color: PaletaNeon.violetaBase,
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '‹ mapa',
                style: TextStyle(
                  color: PaletaNeon.textoTenue,
                  fontSize: 12,
                  letterSpacing: 1.4,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              nombreDistrito.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                letterSpacing: 3,
                color: PaletaNeon.textoTenue,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          _ContadorEsquirlas(
            total: esquirlas,
            pulso: esquirlasNuevasDestello,
          ),
        ],
      ),
    );
  }
}

class _ContadorEsquirlas extends StatelessWidget {
  final int total;
  final int pulso;

  const _ContadorEsquirlas({required this.total, required this.pulso});

  @override
  Widget build(BuildContext contexto) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: PaletaNeon.fondoMedio.withOpacity(0.6),
        border: Border.all(
          color: PaletaNeon.azulNeon.withOpacity(0.6),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: pulso > 0
            ? [
                BoxShadow(
                  color: PaletaNeon.azulNeon.withOpacity(0.35),
                  blurRadius: 10,
                ),
              ]
            : const [],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: PaletaNeon.azulNeon,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: PaletaNeon.azulNeon.withOpacity(0.6),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          Text(
            '$total esquirlas',
            style: const TextStyle(
              color: PaletaNeon.textoPrincipal,
              fontSize: 13,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _FragmentoEnMapa extends StatelessWidget {
  final FragmentoEnTejado fragmento;
  final Size tamanoContenedor;
  final DateTime ahora;
  final double fasePulso;
  final VoidCallback alTocar;

  const _FragmentoEnMapa({
    super.key,
    required this.fragmento,
    required this.tamanoContenedor,
    required this.ahora,
    required this.fasePulso,
    required this.alTocar,
  });

  @override
  Widget build(BuildContext contexto) {
    final fraccionVida = fragmento.fraccionVidaConsumida(ahora);
    final x = fragmento.xNormalizado * tamanoContenedor.width;
    final y = fragmento.yNormalizado * tamanoContenedor.height;
    final desplazaY = fraccionVida > 0.75
        ? -(fraccionVida - 0.75) / 0.25 * 80
        : 0.0;
    const diametro = 78.0;
    return Positioned(
      left: x - diametro / 2,
      top: y - diametro / 2 + desplazaY,
      child: GestureDetector(
        onTap: alTocar,
        child: SizedBox(
          width: diametro,
          height: diametro,
          child: CustomPaint(
            painter: PintorFragmentoTejado(
              fragmento: fragmento,
              fraccionVida: fraccionVida,
              fasePulso: fasePulso,
            ),
          ),
        ),
      ),
    );
  }
}
