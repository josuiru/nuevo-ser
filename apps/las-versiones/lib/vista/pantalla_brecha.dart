import 'package:flutter/material.dart';

import '../datos/repositorio_evaluacion_fuente.dart';
import '../datos/repositorio_preguntas_brecha.dart';
import '../datos/repositorio_recoleccion_fuentes.dart';
import '../datos/repositorio_reconstruccion.dart';
import '../dominio/brecha.dart';
import '../nucleo/paleta_archivo.dart';
import 'fase_evaluacion.dart';
import 'fase_formulacion_preguntas.dart';
import 'fase_recoleccion.dart';
import 'fase_reconstruccion.dart';

/// Pantalla principal de una Brecha. Recorre las cinco fases
/// pedagógicas con un header común que indica dónde está la
/// Cronista y un cuerpo que cambia según la fase.
///
/// Esta v0.1 es **esqueleto**: el cuerpo de cada fase es un
/// placeholder tipográfico con el nombre de la fase y un botón
/// "siguiente". F6.1 a F6.5 sustituyen cada placeholder por la
/// pantalla jugable real.
class PantallaBrecha extends StatelessWidget {
  /// La Brecha que se está jugando.
  final Brecha brecha;

  /// Fase activa — viene del `RepositorioEstadoBrecha`.
  final FaseBrecha faseActiva;

  /// Callback al pulsar "siguiente fase". El orquestador avanza la
  /// fase persistida y reabre la pantalla con la nueva.
  final VoidCallback alAvanzarFase;

  /// Callback al pulsar "completar Brecha" (sólo activo en la fase
  /// final, Concilio). El orquestador marca el flag de completado
  /// y libera la cinemática 1.1.7.
  final VoidCallback alCompletarBrecha;

  /// Callback opcional para abrir el Cuaderno mientras se trabaja
  /// la Brecha — la Cronista puede consultar entradas anteriores
  /// en cualquier momento.
  final VoidCallback? alAbrirCuaderno;

  /// Repositorio de preguntas inyectable. Lo usa la Fase 1 jugable
  /// para persistir lo que la Cronista escribe. Inyectable para tests.
  final RepositorioPreguntasBrecha repoPreguntas;

  /// Repositorio de fuentes recogidas. Lo usa la Fase 2 jugable.
  /// Inyectable para tests.
  final RepositorioRecoleccionFuentes repoRecoleccion;

  /// Repositorio de respuestas a la evaluación. Lo usa la Fase 3.
  /// Inyectable para tests.
  final RepositorioEvaluacionFuente repoEvaluacion;

  /// Repositorio de la reconstrucción. Lo usa la Fase 4 para
  /// persistir las afirmaciones declaradas y sus niveles de
  /// confianza. Inyectable para tests.
  final RepositorioReconstruccion repoReconstruccion;

  const PantallaBrecha({
    super.key,
    required this.brecha,
    required this.faseActiva,
    required this.alAvanzarFase,
    required this.alCompletarBrecha,
    this.alAbrirCuaderno,
    this.repoPreguntas = const RepositorioPreguntasBrecha(),
    this.repoRecoleccion = const RepositorioRecoleccionFuentes(),
    this.repoEvaluacion = const RepositorioEvaluacionFuente(),
    this.repoReconstruccion = const RepositorioReconstruccion(),
  });

  bool get _esFaseFinal => faseActiva == FaseBrecha.concilio;

  /// `true` si la fase activa tiene una pantalla jugable propia
  /// que ya gestiona su CTA de avance internamente. En ese caso
  /// el botón global del pie no aparece.
  bool get _faseTienePantallaPropia =>
      faseActiva == FaseBrecha.formulacionPreguntas ||
      faseActiva == FaseBrecha.recoleccion ||
      faseActiva == FaseBrecha.evaluacion ||
      faseActiva == FaseBrecha.reconstruccion;

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      backgroundColor: PaletaArchivo.fondoProfundo,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _HeaderBrecha(brecha: brecha, faseActiva: faseActiva),
                const SizedBox(height: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                    child: _CuerpoDeFase(
                      brecha: brecha,
                      faseActiva: faseActiva,
                      alAvanzarFase: alAvanzarFase,
                      repoPreguntas: repoPreguntas,
                      repoRecoleccion: repoRecoleccion,
                      repoEvaluacion: repoEvaluacion,
                      repoReconstruccion: repoReconstruccion,
                    ),
                  ),
                ),
                if (!_faseTienePantallaPropia)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                    child: _BotonSiguienteFase(
                      fase: faseActiva,
                      esFaseFinal: _esFaseFinal,
                      alAvanzar: alAvanzarFase,
                      alCompletar: alCompletarBrecha,
                    ),
                  )
                else
                  const SizedBox(height: 16),
              ],
            ),
            if (alAbrirCuaderno != null)
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  tooltip: 'Cuaderno',
                  icon: const Icon(Icons.menu_book_outlined,
                      color: PaletaArchivo.ambarLacre),
                  onPressed: alAbrirCuaderno,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Despacho entre fase jugable real y placeholder. A medida que cada
/// F6.x sustituya el placeholder por la pantalla jugable, esta clase
/// crece con un `case` más. Mantenerla aquí (en lugar de en main)
/// preserva que el orquestador no sepa nada del **interior** de las
/// fases — sólo de su transición.
class _CuerpoDeFase extends StatelessWidget {
  final Brecha brecha;
  final FaseBrecha faseActiva;
  final VoidCallback alAvanzarFase;
  final RepositorioPreguntasBrecha repoPreguntas;
  final RepositorioRecoleccionFuentes repoRecoleccion;
  final RepositorioEvaluacionFuente repoEvaluacion;
  final RepositorioReconstruccion repoReconstruccion;

  const _CuerpoDeFase({
    required this.brecha,
    required this.faseActiva,
    required this.alAvanzarFase,
    required this.repoPreguntas,
    required this.repoRecoleccion,
    required this.repoEvaluacion,
    required this.repoReconstruccion,
  });

  @override
  Widget build(BuildContext contexto) {
    switch (faseActiva) {
      case FaseBrecha.formulacionPreguntas:
        return FaseFormulacionPreguntas(
          brecha: brecha,
          alAvanzarFase: alAvanzarFase,
          repoPreguntas: repoPreguntas,
        );
      case FaseBrecha.recoleccion:
        return FaseRecoleccion(
          brecha: brecha,
          alAvanzarFase: alAvanzarFase,
          repoRecoleccion: repoRecoleccion,
        );
      case FaseBrecha.evaluacion:
        return FaseEvaluacion(
          brecha: brecha,
          alAvanzarFase: alAvanzarFase,
          repoRecoleccion: repoRecoleccion,
          repoEvaluacion: repoEvaluacion,
        );
      case FaseBrecha.reconstruccion:
        return FaseReconstruccion(
          brecha: brecha,
          alAvanzarFase: alAvanzarFase,
          repoReconstruccion: repoReconstruccion,
        );
      case FaseBrecha.concilio:
        return _PlaceholderFase(fase: faseActiva);
    }
  }
}

class _HeaderBrecha extends StatelessWidget {
  final Brecha brecha;
  final FaseBrecha faseActiva;

  const _HeaderBrecha({required this.brecha, required this.faseActiva});

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            brecha.ubicacionVisible,
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 4,
              color: PaletaArchivo.ambarLacre,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            brecha.titulo,
            style: const TextStyle(
              fontSize: 22,
              color: PaletaArchivo.textoPrincipal,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          _IndicadorFases(faseActiva: faseActiva),
        ],
      ),
    );
  }
}

class _IndicadorFases extends StatelessWidget {
  final FaseBrecha faseActiva;

  const _IndicadorFases({required this.faseActiva});

  @override
  Widget build(BuildContext contexto) {
    return Row(
      children: [
        for (final fase in FaseBrecha.values)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: _SegmentoFase(
                fase: fase,
                activa: fase == faseActiva,
                completada: fase.index < faseActiva.index,
              ),
            ),
          ),
      ],
    );
  }
}

class _SegmentoFase extends StatelessWidget {
  final FaseBrecha fase;
  final bool activa;
  final bool completada;

  const _SegmentoFase({
    required this.fase,
    required this.activa,
    required this.completada,
  });

  @override
  Widget build(BuildContext contexto) {
    final color = activa
        ? PaletaArchivo.ambarLacre
        : completada
            ? PaletaArchivo.ambarLacre.withOpacity(0.55)
            : PaletaArchivo.tintaTenue.withOpacity(0.35);
    return Container(
      height: 3,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _PlaceholderFase extends StatelessWidget {
  final FaseBrecha fase;

  const _PlaceholderFase({required this.fase});

  @override
  Widget build(BuildContext contexto) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _nombreVisible(fase).toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 5,
              color: PaletaArchivo.tintaTenue,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            _glosaPedagogica(fase),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: PaletaArchivo.textoPrincipal.withOpacity(0.85),
              height: 1.55,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  String _nombreVisible(FaseBrecha fase) {
    switch (fase) {
      case FaseBrecha.formulacionPreguntas:
        return 'Fase 1 — Formulación';
      case FaseBrecha.recoleccion:
        return 'Fase 2 — Recolección';
      case FaseBrecha.evaluacion:
        return 'Fase 3 — Evaluación';
      case FaseBrecha.reconstruccion:
        return 'Fase 4 — Reconstrucción';
      case FaseBrecha.concilio:
        return 'Fase 5 — Concilio';
    }
  }

  /// Glosa breve de cada fase — recordatorio pedagógico mientras la
  /// pantalla jugable real está en construcción. Cuando F6 sustituya
  /// cada placeholder, esta glosa se mueve al header de cada
  /// pantalla de fase como recordatorio del oficio.
  String _glosaPedagogica(FaseBrecha fase) {
    switch (fase) {
      case FaseBrecha.formulacionPreguntas:
        return 'Antes de tocar nada, formula tus preguntas. ¿Qué quieres '
            'saber? ¿Qué se puede saber? ¿Qué no se puede?';
      case FaseBrecha.recoleccion:
        return 'Recoge las fuentes que tienes a mano. Cada una llegará '
            'sola a la Mesa de Trabajo.';
      case FaseBrecha.evaluacion:
        return 'Por cada fuente, las seis preguntas del oficio: ¿quién?, '
            '¿cuándo?, ¿para qué público?, ¿qué intereses?, ¿qué se '
            'omite?, ¿corrobora o contradice?';
      case FaseBrecha.reconstruccion:
        return 'Construye tu versión. Ancla cada afirmación a evidencia. '
            'Declara confianza: Sólido, Probable, Disputado.';
      case FaseBrecha.concilio:
        return 'Presenta tu trabajo. No premia tener razón. Premia haber '
            'juzgado bien con lo disponible.';
    }
  }
}

class _BotonSiguienteFase extends StatelessWidget {
  final FaseBrecha fase;
  final bool esFaseFinal;
  final VoidCallback alAvanzar;
  final VoidCallback alCompletar;

  const _BotonSiguienteFase({
    required this.fase,
    required this.esFaseFinal,
    required this.alAvanzar,
    required this.alCompletar,
  });

  @override
  Widget build(BuildContext contexto) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: esFaseFinal ? alCompletar : alAvanzar,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          foregroundColor: PaletaArchivo.textoPrincipal,
          backgroundColor: PaletaArchivo.fondoMedio.withOpacity(0.5),
          side: BorderSide(
            color: PaletaArchivo.ambarLacre.withOpacity(0.55),
          ),
        ),
        child: Text(
          esFaseFinal ? 'CERRAR LA BRECHA' : 'SIGUIENTE FASE',
          style: const TextStyle(
            fontSize: 12,
            letterSpacing: 4,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
