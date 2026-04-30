import 'package:flutter/material.dart';

import '../datos/repositorio_preguntas_brecha.dart';
import '../dominio/brecha.dart';
import '../dominio/evaluador_preguntas.dart';
import '../nucleo/paleta_archivo.dart';

/// Pantalla jugable de la Fase 1 de una Brecha — formulación de
/// preguntas por la Cronista (PR.01, PR.04 del doc 02). Sustituye
/// al placeholder genérico de `PantallaBrecha` para esta fase.
///
/// El validador es algorítmico (`EvaluadorPreguntas`), no usa LLM,
/// y NO afirma nada sobre contenido histórico — sólo sobre forma:
/// longitud, signo interrogativo, partícula. La política de cierre
/// (`PoliticaCierreFormulacion`) exige mínimo 3 preguntas válidas
/// **de al menos dos categorías distintas**, para que la Cronista
/// practique variedad y no repita la misma estructura.
class FaseFormulacionPreguntas extends StatefulWidget {
  /// Brecha cuya Fase 1 se está jugando. La pantalla persiste las
  /// preguntas bajo `nuevoser.lasversiones.brecha.<id>.preguntas`.
  final Brecha brecha;

  /// Callback al que llamar cuando la Cronista considera la Fase 1
  /// terminada y la política de cierre dice que sí. El orquestador
  /// avanza la fase persistida y reabre la pantalla en Recolección.
  final VoidCallback alAvanzarFase;

  /// Repositorio de persistencia. Se inyecta para que los tests
  /// puedan usar `SharedPreferences.setMockInitialValues`.
  final RepositorioPreguntasBrecha repoPreguntas;

  /// Evaluador puro inyectado para tests. La instancia por defecto
  /// no necesita configuración.
  final EvaluadorPreguntas evaluador;

  /// Política de cierre — separable del evaluador porque puede
  /// querer endurecerse o relajarse por Brecha en el futuro.
  final PoliticaCierreFormulacion politicaCierre;

  const FaseFormulacionPreguntas({
    super.key,
    required this.brecha,
    required this.alAvanzarFase,
    this.repoPreguntas = const RepositorioPreguntasBrecha(),
    this.evaluador = const EvaluadorPreguntas(),
    this.politicaCierre = const PoliticaCierreFormulacion(),
  });

  @override
  State<FaseFormulacionPreguntas> createState() =>
      _FaseFormulacionPreguntasState();
}

class _FaseFormulacionPreguntasState extends State<FaseFormulacionPreguntas> {
  final TextEditingController _controlador = TextEditingController();
  final FocusNode _focoEntrada = FocusNode();
  List<EvaluacionPregunta> _evaluaciones = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarPreguntasPersistidas();
  }

  @override
  void dispose() {
    _controlador.dispose();
    _focoEntrada.dispose();
    super.dispose();
  }

  Future<void> _cargarPreguntasPersistidas() async {
    final crudas = await widget.repoPreguntas.cargar(widget.brecha.id);
    if (!mounted) return;
    setState(() {
      _evaluaciones = crudas
          .map(widget.evaluador.evaluar)
          .toList(growable: true);
      _cargando = false;
    });
  }

  Future<void> _persistir() async {
    final textos = _evaluaciones
        .map((e) => e.textoNormalizado)
        .toList(growable: false);
    await widget.repoPreguntas.guardar(widget.brecha.id, textos);
  }

  void _alAnadir() {
    final crudo = _controlador.text;
    if (crudo.trim().isEmpty) return;
    final evaluacion = widget.evaluador.evaluar(crudo);
    setState(() {
      _evaluaciones = [..._evaluaciones, evaluacion];
      _controlador.clear();
    });
    _persistir();
    _focoEntrada.requestFocus();
  }

  void _alEliminar(int indice) {
    setState(() {
      final copia = [..._evaluaciones];
      copia.removeAt(indice);
      _evaluaciones = copia;
    });
    _persistir();
  }

  @override
  Widget build(BuildContext contexto) {
    if (_cargando) {
      return const SizedBox.expand();
    }
    final razonBloqueo =
        widget.politicaCierre.razonParaNoAvanzar(_evaluaciones);
    final puedeAvanzar = razonBloqueo == null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _IntroFase1(),
        const SizedBox(height: 16),
        _CajaEntrada(
          controlador: _controlador,
          foco: _focoEntrada,
          alEnviar: _alAnadir,
        ),
        const SizedBox(height: 18),
        Expanded(
          child: _evaluaciones.isEmpty
              ? const _ListaPreguntasVacia()
              : ListView.separated(
                  padding: const EdgeInsets.only(bottom: 12),
                  itemCount: _evaluaciones.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, indice) => _TarjetaPregunta(
                    indice: indice,
                    evaluacion: _evaluaciones[indice],
                    alEliminar: () => _alEliminar(indice),
                  ),
                ),
        ),
        if (razonBloqueo != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              razonBloqueo,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: PaletaArchivo.textoTenue.withOpacity(0.85),
                fontStyle: FontStyle.italic,
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
              'IR A LA RECOLECCIÓN',
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

class _IntroFase1 extends StatelessWidget {
  const _IntroFase1();

  @override
  Widget build(BuildContext contexto) {
    return Text(
      'Antes de tocar nada, formula tus preguntas. ¿Qué quieres saber? '
      '¿Qué se puede saber? Mínimo tres preguntas, y conviene que sean '
      'de tipos distintos (factual, causal, perspectiva, metodológica).',
      style: TextStyle(
        fontSize: 14,
        color: PaletaArchivo.textoPrincipal.withOpacity(0.9),
        height: 1.55,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}

class _CajaEntrada extends StatelessWidget {
  final TextEditingController controlador;
  final FocusNode foco;
  final VoidCallback alEnviar;

  const _CajaEntrada({
    required this.controlador,
    required this.foco,
    required this.alEnviar,
  });

  @override
  Widget build(BuildContext contexto) {
    return Container(
      decoration: BoxDecoration(
        color: PaletaArchivo.fondoMedio.withOpacity(0.55),
        border: Border.all(
          color: PaletaArchivo.ambarLacre.withOpacity(0.45),
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controlador,
              focusNode: foco,
              maxLines: 3,
              minLines: 1,
              style: TextStyle(
                fontSize: 15,
                color: PaletaArchivo.textoPrincipal.withOpacity(0.95),
                height: 1.4,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Escribe una pregunta…',
                hintStyle: TextStyle(
                  color: PaletaArchivo.textoTenue.withOpacity(0.7),
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => alEnviar(),
            ),
          ),
          IconButton(
            tooltip: 'Añadir',
            icon: const Icon(
              Icons.add_circle_outline,
              color: PaletaArchivo.ambarLacre,
            ),
            onPressed: alEnviar,
          ),
        ],
      ),
    );
  }
}

class _TarjetaPregunta extends StatelessWidget {
  final int indice;
  final EvaluacionPregunta evaluacion;
  final VoidCallback alEliminar;

  const _TarjetaPregunta({
    required this.indice,
    required this.evaluacion,
    required this.alEliminar,
  });

  @override
  Widget build(BuildContext contexto) {
    final colorAcento = evaluacion.esValida
        ? PaletaArchivo.ambarLacre
        : PaletaArchivo.tintaTenue.withOpacity(0.55);
    return Container(
      decoration: BoxDecoration(
        color: PaletaArchivo.fondoMedio.withOpacity(0.4),
        border: Border(
          left: BorderSide(color: colorAcento, width: 2),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${indice + 1}.',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 2,
                        color: PaletaArchivo.ambarLacre,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _etiquetaTipo(evaluacion.tipo, evaluacion.esValida)
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 2,
                        color: colorAcento,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  evaluacion.textoNormalizado,
                  style: TextStyle(
                    fontSize: 15,
                    color: PaletaArchivo.textoPrincipal.withOpacity(0.95),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  evaluacion.mensajePedagogico,
                  style: TextStyle(
                    fontSize: 12,
                    color: PaletaArchivo.textoTenue.withOpacity(0.85),
                    fontStyle: FontStyle.italic,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Eliminar',
            icon: Icon(
              Icons.close,
              size: 18,
              color: PaletaArchivo.textoTenue.withOpacity(0.7),
            ),
            onPressed: alEliminar,
          ),
        ],
      ),
    );
  }

  String _etiquetaTipo(TipoPregunta tipo, bool esValida) {
    if (!esValida) return 'no admitida';
    switch (tipo) {
      case TipoPregunta.factual:
        return 'Factual';
      case TipoPregunta.causal:
        return 'Causal';
      case TipoPregunta.perspectiva:
        return 'Perspectiva';
      case TipoPregunta.metodologica:
        return 'Método';
      case TipoPregunta.indeterminada:
        return 'Aceptada';
    }
  }
}

class _ListaPreguntasVacia extends StatelessWidget {
  const _ListaPreguntasVacia();

  @override
  Widget build(BuildContext contexto) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          'Aún no has formulado ninguna pregunta. Empieza por la que '
          'más te tira: probablemente sea factual, y está bien.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: PaletaArchivo.textoTenue.withOpacity(0.8),
            fontStyle: FontStyle.italic,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
