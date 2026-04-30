import 'package:flutter/material.dart';

import '../datos/repositorio_evaluacion_fuente.dart';
import '../datos/repositorio_recoleccion_fuentes.dart';
import '../dominio/brecha.dart';
import '../dominio/evaluacion_fuente.dart';
import '../nucleo/paleta_archivo.dart';

/// Pantalla jugable de la Fase 3 — Evaluación en la Mesa de Trabajo.
///
/// Para cada fuente recogida en la Fase 2, la Cronista responde **dos
/// preguntas cerradas**: tipo (primaria/secundaria) y sesgo (5
/// opciones). Las otras seis propiedades canónicas del oficio (autor,
/// fecha, público, intereses, omisiones, corrobora/contradice) se
/// presentan como **lectura del oficio** —respuesta modelo del
/// cronista experto— sin pedirle que las escriba ni elija. Esa
/// decisión está apuntada en `BLOQUEOS-PENDIENTES.md` (Mecánicas
/// pedagógicas F6.3): un sistema de elección múltiple textual con
/// distractores requeriría validación del comité asesor antes de
/// afirmar contenido histórico concreto.
///
/// La política de cierre exige sólo que **todas las fuentes recogidas
/// hayan recibido al menos una evaluación completa** — no exigimos
/// acierto, igual que el oficio real: equivocarse al diagnosticar
/// el sesgo de una fuente y aprenderlo es parte de la tarea.
class FaseEvaluacion extends StatefulWidget {
  /// Brecha cuya Fase 3 se está jugando.
  final Brecha brecha;

  /// Callback al que llamar cuando la Cronista pulsa "IR A LA
  /// RECONSTRUCCIÓN" y todas las fuentes están evaluadas.
  final VoidCallback alAvanzarFase;

  /// Repositorio de fuentes recogidas en Fase 2 — la Cronista sólo
  /// evalúa lo que tiene en la Mesa.
  final RepositorioRecoleccionFuentes repoRecoleccion;

  /// Repositorio de respuestas. Inyectable para tests.
  final RepositorioEvaluacionFuente repoEvaluacion;

  /// Evaluador puro inyectable.
  final EvaluadorFuente evaluador;

  const FaseEvaluacion({
    super.key,
    required this.brecha,
    required this.alAvanzarFase,
    this.repoRecoleccion = const RepositorioRecoleccionFuentes(),
    this.repoEvaluacion = const RepositorioEvaluacionFuente(),
    this.evaluador = const EvaluadorFuente(),
  });

  @override
  State<FaseEvaluacion> createState() => _FaseEvaluacionState();
}

class _FaseEvaluacionState extends State<FaseEvaluacion> {
  Set<String> _idsRecogidas = const {};
  Map<String, RespuestaEvaluacionFuente> _respuestas = const {};
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarEstadoInicial();
  }

  Future<void> _cargarEstadoInicial() async {
    final ids = await widget.repoRecoleccion.idsFuentesRecogidas(
      widget.brecha.id,
    );
    final respuestas = await widget.repoEvaluacion.cargarTodasDeBrecha(
      widget.brecha.id,
    );
    if (!mounted) return;
    setState(() {
      _idsRecogidas = ids;
      _respuestas = respuestas;
      _cargando = false;
    });
  }

  Future<void> _alElegirTipo(String idFuente, TipoFuente tipo) async {
    final actual = _respuestas[idFuente] ?? const RespuestaEvaluacionFuente();
    final nueva = actual.copiarCon(tipoElegido: tipo);
    await widget.repoEvaluacion.guardar(widget.brecha.id, idFuente, nueva);
    if (!mounted) return;
    setState(() {
      _respuestas = {..._respuestas, idFuente: nueva};
    });
  }

  Future<void> _alElegirSesgo(String idFuente, SesgoFuente sesgo) async {
    final actual = _respuestas[idFuente] ?? const RespuestaEvaluacionFuente();
    final nueva = actual.copiarCon(sesgoElegido: sesgo);
    await widget.repoEvaluacion.guardar(widget.brecha.id, idFuente, nueva);
    if (!mounted) return;
    setState(() {
      _respuestas = {..._respuestas, idFuente: nueva};
    });
  }

  @override
  Widget build(BuildContext contexto) {
    if (_cargando) {
      return const SizedBox.expand();
    }
    final fuentesEnMesa = widget.brecha.fuentes
        .where((fuente) => _idsRecogidas.contains(fuente.id))
        .toList(growable: false);
    final completas = fuentesEnMesa.where((fuente) {
      final respuesta = _respuestas[fuente.id];
      return respuesta != null && respuesta.estaCompleta;
    }).length;
    final puedeAvanzar =
        completas == fuentesEnMesa.length && fuentesEnMesa.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _IntroFase3(),
        const SizedBox(height: 6),
        _ContadorEvaluacion(completas: completas, total: fuentesEnMesa.length),
        const SizedBox(height: 14),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int indice = 0;
                    indice < fuentesEnMesa.length;
                    indice++) ...[
                  if (indice > 0) const SizedBox(height: 14),
                  _TarjetaEvaluacionFuente(
                    fuente: fuentesEnMesa[indice],
                    respuesta: _respuestas[fuentesEnMesa[indice].id] ??
                        const RespuestaEvaluacionFuente(),
                    evaluador: widget.evaluador,
                    alElegirTipo: (tipo) =>
                        _alElegirTipo(fuentesEnMesa[indice].id, tipo),
                    alElegirSesgo: (sesgo) =>
                        _alElegirSesgo(fuentesEnMesa[indice].id, sesgo),
                  ),
                ],
              ],
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: puedeAvanzar ? widget.alAvanzarFase : null,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              foregroundColor: PaletaArchivo.textoPrincipal,
              backgroundColor:
                  PaletaArchivo.fondoMedio.withOpacity(puedeAvanzar ? 0.6 : 0.3),
              side: BorderSide(
                color: PaletaArchivo.ambarLacre.withOpacity(
                  puedeAvanzar ? 0.7 : 0.3,
                ),
              ),
            ),
            child: const Text(
              'IR A LA RECONSTRUCCIÓN',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _IntroFase3 extends StatelessWidget {
  const _IntroFase3();

  @override
  Widget build(BuildContext contexto) {
    return Text(
      'Cada fuente, cuestionada. Por cada una decides si es primaria '
      'o secundaria, y qué sesgo lleva — luego puedes leer la nota del '
      'oficio (autor, fecha, público, intereses, omisiones, corrobora '
      'o contradice). Equivocarte al diagnosticar también es oficio.',
      style: TextStyle(
        fontSize: 14,
        color: PaletaArchivo.textoPrincipal.withOpacity(0.9),
        height: 1.55,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}

class _ContadorEvaluacion extends StatelessWidget {
  final int completas;
  final int total;

  const _ContadorEvaluacion({required this.completas, required this.total});

  @override
  Widget build(BuildContext contexto) {
    return Text(
      'Evaluadas: $completas / $total',
      style: const TextStyle(
        fontSize: 11,
        letterSpacing: 3,
        color: PaletaArchivo.ambarLacre,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _TarjetaEvaluacionFuente extends StatelessWidget {
  final Fuente fuente;
  final RespuestaEvaluacionFuente respuesta;
  final EvaluadorFuente evaluador;
  final ValueChanged<TipoFuente> alElegirTipo;
  final ValueChanged<SesgoFuente> alElegirSesgo;

  const _TarjetaEvaluacionFuente({
    required this.fuente,
    required this.respuesta,
    required this.evaluador,
    required this.alElegirTipo,
    required this.alElegirSesgo,
  });

  @override
  Widget build(BuildContext contexto) {
    final completa = respuesta.estaCompleta;
    final colorAcento = completa
        ? PaletaArchivo.ambarLacre
        : PaletaArchivo.tintaTenue.withOpacity(0.5);
    final resultado = completa
        ? evaluador.comparar(
            respuesta: respuesta,
            canonicas: fuente.propiedadesCanonicas,
          )
        : null;
    return Container(
      decoration: BoxDecoration(
        color: PaletaArchivo.fondoMedio.withOpacity(0.4),
        border: Border(
          left: BorderSide(color: colorAcento, width: 2),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fuente.tipoVisible.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 3,
              color: PaletaArchivo.ambarLacre,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            fuente.descripcion,
            style: TextStyle(
              fontSize: 13,
              color: PaletaArchivo.textoPrincipal.withOpacity(0.9),
              height: 1.5,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 14),
          _PreguntaTipo(
            tipoElegido: respuesta.tipoElegido,
            alElegir: alElegirTipo,
          ),
          const SizedBox(height: 12),
          _PreguntaSesgo(
            sesgoElegido: respuesta.sesgoElegido,
            alElegir: alElegirSesgo,
          ),
          if (resultado != null) ...[
            const SizedBox(height: 14),
            _Resultado(resultado: resultado),
            const SizedBox(height: 10),
            _NotaDelOficio(propiedades: fuente.propiedadesCanonicas),
          ],
        ],
      ),
    );
  }
}

class _PreguntaTipo extends StatelessWidget {
  final TipoFuente? tipoElegido;
  final ValueChanged<TipoFuente> alElegir;

  const _PreguntaTipo({required this.tipoElegido, required this.alElegir});

  @override
  Widget build(BuildContext contexto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Etiqueta(texto: '¿Tipo de fuente?'),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _BotonOpcion(
                etiqueta: 'Primaria',
                seleccionada: tipoElegido == TipoFuente.primaria,
                alPulsar: () => alElegir(TipoFuente.primaria),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _BotonOpcion(
                etiqueta: 'Secundaria',
                seleccionada: tipoElegido == TipoFuente.secundaria,
                alPulsar: () => alElegir(TipoFuente.secundaria),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PreguntaSesgo extends StatelessWidget {
  static const Map<SesgoFuente, String> _etiquetas = {
    SesgoFuente.ninguno: 'Ninguno',
    SesgoFuente.difusionista: 'Difusionista',
    SesgoFuente.oficialista: 'Oficialista',
    SesgoFuente.presentista: 'Presentista',
    SesgoFuente.invisibilizador: 'Invisibilizador',
  };

  final SesgoFuente? sesgoElegido;
  final ValueChanged<SesgoFuente> alElegir;

  const _PreguntaSesgo({required this.sesgoElegido, required this.alElegir});

  @override
  Widget build(BuildContext contexto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Etiqueta(texto: '¿Qué sesgo lleva?'),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final entrada in _etiquetas.entries)
              _BotonOpcion(
                etiqueta: entrada.value,
                seleccionada: sesgoElegido == entrada.key,
                alPulsar: () => alElegir(entrada.key),
              ),
          ],
        ),
      ],
    );
  }
}

class _Etiqueta extends StatelessWidget {
  final String texto;

  const _Etiqueta({required this.texto});

  @override
  Widget build(BuildContext contexto) {
    return Text(
      texto,
      style: TextStyle(
        fontSize: 12,
        color: PaletaArchivo.textoTenue.withOpacity(0.95),
        fontStyle: FontStyle.italic,
      ),
    );
  }
}

class _BotonOpcion extends StatelessWidget {
  final String etiqueta;
  final bool seleccionada;
  final VoidCallback alPulsar;

  const _BotonOpcion({
    required this.etiqueta,
    required this.seleccionada,
    required this.alPulsar,
  });

  @override
  Widget build(BuildContext contexto) {
    return TextButton(
      onPressed: alPulsar,
      style: TextButton.styleFrom(
        backgroundColor: seleccionada
            ? PaletaArchivo.ambarLacre.withOpacity(0.22)
            : PaletaArchivo.fondoMedio.withOpacity(0.55),
        side: BorderSide(
          color: seleccionada
              ? PaletaArchivo.ambarLacre
              : PaletaArchivo.tintaTenue.withOpacity(0.5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        foregroundColor: PaletaArchivo.textoPrincipal,
      ),
      child: Text(
        etiqueta,
        style: TextStyle(
          fontSize: 11,
          letterSpacing: 1.5,
          fontWeight: seleccionada ? FontWeight.w500 : FontWeight.w400,
          color: PaletaArchivo.textoPrincipal.withOpacity(0.95),
        ),
      ),
    );
  }
}

class _Resultado extends StatelessWidget {
  final ResultadoEvaluacionFuente resultado;

  const _Resultado({required this.resultado});

  @override
  Widget build(BuildContext contexto) {
    return Row(
      children: [
        Icon(
          resultado.aciertos == resultado.total
              ? Icons.check_circle_outline
              : Icons.error_outline,
          size: 16,
          color: PaletaArchivo.ambarLacre,
        ),
        const SizedBox(width: 6),
        Text(
          'Aciertos en esta fuente: ${resultado.aciertos} / ${resultado.total}',
          style: const TextStyle(
            fontSize: 11,
            letterSpacing: 2,
            color: PaletaArchivo.ambarLacre,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _NotaDelOficio extends StatelessWidget {
  final PropiedadesFuente propiedades;

  const _NotaDelOficio({required this.propiedades});

  @override
  Widget build(BuildContext contexto) {
    return Container(
      decoration: BoxDecoration(
        color: PaletaArchivo.fondoProfundo.withOpacity(0.55),
        border: Border.all(
          color: PaletaArchivo.tintaTenue.withOpacity(0.35),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NOTA DEL OFICIO',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 3,
              color: PaletaArchivo.ambarLacre,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          _LineaCampo(etiqueta: 'Autor', valor: propiedades.autor),
          _LineaCampo(etiqueta: 'Fecha', valor: propiedades.fecha),
          _LineaCampo(etiqueta: 'Público', valor: propiedades.publico),
          _LineaCampo(etiqueta: 'Intereses', valor: propiedades.intereses),
          _LineaCampo(etiqueta: 'Omite', valor: propiedades.omisiones),
          _LineaCampo(
            etiqueta: 'Corrobora o contradice',
            valor: propiedades.corroboraOContradice,
          ),
        ],
      ),
    );
  }
}

class _LineaCampo extends StatelessWidget {
  final String etiqueta;
  final String valor;

  const _LineaCampo({required this.etiqueta, required this.valor});

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 12,
            height: 1.4,
            color: PaletaArchivo.textoPrincipal.withOpacity(0.85),
          ),
          children: [
            TextSpan(
              text: '$etiqueta: ',
              style: TextStyle(
                color: PaletaArchivo.textoTenue,
                fontStyle: FontStyle.italic,
              ),
            ),
            TextSpan(text: valor),
          ],
        ),
      ),
    );
  }
}
