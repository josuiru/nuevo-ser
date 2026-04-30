import 'package:flutter/material.dart';
import 'package:nuevo_ser_companion/nuevo_ser_companion.dart' as companion;

import '../../datos/repositorio_historico_resumenes.dart';
import '../../datos/sincronizador_agregados.dart';
import '../../dominio/agregado_semanal.dart';
import '../../dominio/repositorio_local.dart';
import '../../nucleo/i18n/generado/textos_app.dart';
import '../tema/colores.dart';
import '../tema/tipografia.dart';

/// Vista del cuidador (doc 15 §1) — la única superficie del juego que
/// el niño comparte con un adulto que le acompaña. **No verá las
/// observaciones ni los textos del niño**: solo un párrafo agregado y
/// una pregunta para hablar.
///
/// En el MVP la pregunta se genera offline con `preguntaParaLaCenaOffline`
/// (plantillas hardcoded en castellano). Cuando se integre con
/// `/companion/aggregates/weekly` el `summary_text` y la
/// `conversation_prompt` del LLM sustituirán a este fallback sin que
/// la pantalla cambie.
class PantallaCuidador extends StatefulWidget {
  const PantallaCuidador({
    super.key,
    required this.repositorio,
    this.semanaPivote,
    this.sincronizador,
    this.repoHistorico,
    this.proveedorAhora,
  });

  final RepositorioLocal repositorio;

  /// Inyectable para tests (semana exacta a agregar). En producción
  /// se deja null y se usa `DateTime.now()`.
  final DateTime? semanaPivote;

  /// Si llega, la pantalla muestra el botón "Compartir resumen con el
  /// adulto" — opt-in puro, lo dispara la persona adulta presente. Si
  /// es null, la pantalla queda en modo offline (la pregunta para la
  /// cena se genera con plantillas locales). Permite que la pantalla
  /// se monte en tests/demo sin red sin tener que mockear el cliente.
  final SincronizadorAgregadosCuaderno? sincronizador;

  /// Persistencia del histórico de resúmenes anteriores. Si llega no
  /// nulo, la pantalla carga las entradas archivadas y las muestra
  /// bajo el resumen actual; cada sincronización exitosa nueva se
  /// archiva. Si es null, el histórico no aparece — modo S1 / tests
  /// que no quieren tocar prefs.
  final RepositorioHistoricoResumenes? repoHistorico;

  /// Reloj inyectable para etiquetar el `archivedAt` de las entradas
  /// archivadas. En producción es `DateTime.now`. Tests con tiempo
  /// fijo lo sobrescriben.
  final DateTime Function()? proveedorAhora;

  @override
  State<PantallaCuidador> createState() => _EstadoPantallaCuidador();
}

class _EstadoPantallaCuidador extends State<PantallaCuidador> {
  AgregadoSemanal? _agregado;
  bool _cargando = true;
  bool _sincronizando = false;
  companion.AgregadoSemanal? _agregadoBackend;
  String? _avisoSincronizacion;
  List<EntradaHistoricoResumen> _historico = const [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final observaciones = await widget.repositorio.obtenerObservaciones();
    final historico = widget.repoHistorico == null
        ? const <EntradaHistoricoResumen>[]
        : await widget.repoHistorico!.cargar();
    if (!mounted) return;
    setState(() {
      _agregado = computarAgregadoSemanal(
        observaciones,
        semanaPivote: widget.semanaPivote,
      );
      _historico = historico;
      _cargando = false;
    });
  }

  Future<void> _sincronizar() async {
    final sincronizador = widget.sincronizador;
    if (sincronizador == null || _sincronizando) return;
    final textos = TextosApp.of(context);
    setState(() {
      _sincronizando = true;
      _avisoSincronizacion = null;
    });
    final resultado = await sincronizador.sincronizarSemana(
      semanaPivote: widget.semanaPivote,
    );
    if (!mounted) return;
    // Archivar (fuera del setState porque toca prefs).
    List<EntradaHistoricoResumen> historicoNuevo = _historico;
    if (resultado is SyncExito && resultado.agregadoBackend.summaryText.isNotEmpty) {
      final repo = widget.repoHistorico;
      if (repo != null) {
        final ahora = (widget.proveedorAhora ?? DateTime.now)();
        await repo.archivar(EntradaHistoricoResumen(
          isoWeek: resultado.agregadoBackend.isoWeek,
          summaryText: resultado.agregadoBackend.summaryText,
          conversationPrompt: resultado.agregadoBackend.conversationPrompt,
          archivedAt: ahora,
        ));
        historicoNuevo = await repo.cargar();
      }
    }
    if (!mounted) return;
    setState(() {
      _sincronizando = false;
      _historico = historicoNuevo;
      switch (resultado) {
        case SyncSinToken():
          _avisoSincronizacion = textos.cuidadorSincronizarSinToken;
        case SyncError():
          _avisoSincronizacion = textos.cuidadorSincronizarErrorRed;
        case SyncExito(:final agregadoBackend):
          _agregadoBackend = agregadoBackend;
          if (agregadoBackend.summaryText.isEmpty) {
            _avisoSincronizacion = textos.cuidadorSincronizarSinResumen;
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textos = TextosApp.of(context);
    final esquema = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(textos.cuidadorTitulo)),
      body: SafeArea(
        child: _cargando || _agregado == null
            ? const Center(child: CircularProgressIndicator.adaptive())
            : _Contenido(
                agregado: _agregado!,
                agregadoBackend: _agregadoBackend,
                avisoSincronizacion: _avisoSincronizacion,
                sincronizando: _sincronizando,
                puedeSincronizar: widget.sincronizador != null,
                alSincronizar: _sincronizar,
                historico: _historico,
                textos: textos,
                esquema: esquema,
              ),
      ),
    );
  }
}

class _Contenido extends StatelessWidget {
  const _Contenido({
    required this.agregado,
    required this.agregadoBackend,
    required this.avisoSincronizacion,
    required this.sincronizando,
    required this.puedeSincronizar,
    required this.alSincronizar,
    required this.historico,
    required this.textos,
    required this.esquema,
  });

  final AgregadoSemanal agregado;
  final companion.AgregadoSemanal? agregadoBackend;
  final String? avisoSincronizacion;
  final bool sincronizando;
  final bool puedeSincronizar;
  final VoidCallback alSincronizar;
  final List<EntradaHistoricoResumen> historico;
  final TextosApp textos;
  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    final summaryBackend = agregadoBackend?.summaryText ?? '';
    final promptBackend = agregadoBackend?.conversationPrompt ?? '';
    // El histórico que se muestra es el de semanas anteriores — la
    // semana del agregadoBackend actual ya se ve en _ResumenBackend,
    // así que la filtramos aquí para no duplicar.
    final historicoAnterior = agregadoBackend == null
        ? historico
        : historico
            .where((e) => e.isoWeek != agregadoBackend!.isoWeek)
            .toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        _Aviso(textos: textos, esquema: esquema),
        const SizedBox(height: 24),
        _SemanaActual(textos: textos, agregado: agregado, esquema: esquema),
        const SizedBox(height: 16),
        if (summaryBackend.isNotEmpty) ...[
          _ResumenBackend(
            textos: textos,
            esquema: esquema,
            texto: summaryBackend,
          ),
          const SizedBox(height: 16),
        ],
        _Pregunta(
          textos: textos,
          agregado: agregado,
          promptBackend: promptBackend,
          esquema: esquema,
        ),
        const SizedBox(height: 24),
        _Metricas(textos: textos, agregado: agregado, esquema: esquema),
        if (historicoAnterior.isNotEmpty) ...[
          const SizedBox(height: 24),
          _BloqueHistorico(
            entradas: historicoAnterior,
            esquema: esquema,
          ),
        ],
        if (puedeSincronizar) ...[
          const SizedBox(height: 24),
          _BloqueSincronizar(
            textos: textos,
            esquema: esquema,
            sincronizando: sincronizando,
            avisoSincronizacion: avisoSincronizacion,
            alPulsar: alSincronizar,
          ),
        ],
      ],
    );
  }
}

class _BloqueHistorico extends StatelessWidget {
  const _BloqueHistorico({
    required this.entradas,
    required this.esquema,
  });

  final List<EntradaHistoricoResumen> entradas;
  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resúmenes anteriores',
          style: TipografiaCuaderno.sans(
            color: esquema.tertiary,
            tamano: TipografiaCuaderno.tamano12,
            peso: TipografiaCuaderno.pesoMedio,
          ),
        ),
        const SizedBox(height: 8),
        for (final entrada in entradas)
          _TarjetaHistorico(entrada: entrada, esquema: esquema),
      ],
    );
  }
}

class _TarjetaHistorico extends StatelessWidget {
  const _TarjetaHistorico({required this.entrada, required this.esquema});

  final EntradaHistoricoResumen entrada;
  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: esquema.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _etiquetaSemana(entrada.isoWeek),
              style: TipografiaCuaderno.sans(
                color: esquema.tertiary,
                tamano: TipografiaCuaderno.tamano11,
                peso: TipografiaCuaderno.pesoMedio,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              entrada.summaryText,
              style: TipografiaCuaderno.serif(
                color: PaletaCuaderno.tinta,
                tamano: TipografiaCuaderno.tamano13,
                altoLinea: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Convierte `2026-W17` en `Semana 17 de 2026` — formato simple, sin
  /// reglas de localización que requieran la fecha real del lunes (la
  /// pantalla la lee el adulto, que se orienta bien con el número de
  /// semana).
  static String _etiquetaSemana(String isoWeek) {
    final partes = isoWeek.split('-W');
    if (partes.length != 2) return isoWeek;
    return 'Semana ${partes[1]} de ${partes[0]}';
  }
}

class _Aviso extends StatelessWidget {
  const _Aviso({required this.textos, required this.esquema});

  final TextosApp textos;
  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: esquema.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        textos.cuidadorAviso,
        style: TipografiaCuaderno.serif(
          color: PaletaCuaderno.tintaTenue,
          tamano: TipografiaCuaderno.tamano13,
          altoLinea: 1.5,
        ),
      ),
    );
  }
}

class _SemanaActual extends StatelessWidget {
  const _SemanaActual({
    required this.textos,
    required this.agregado,
    required this.esquema,
  });

  final TextosApp textos;
  final AgregadoSemanal agregado;
  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    return Text(
      textos.cuidadorSemanaActual(agregado.isoWeek),
      style: TipografiaCuaderno.sans(
        color: esquema.tertiary,
        tamano: TipografiaCuaderno.tamano12,
        peso: TipografiaCuaderno.pesoMedio,
      ),
    );
  }
}

class _Pregunta extends StatelessWidget {
  const _Pregunta({
    required this.textos,
    required this.agregado,
    required this.promptBackend,
    required this.esquema,
  });

  final TextosApp textos;
  final AgregadoSemanal agregado;

  /// Si el LLM server-side devolvió `conversation_prompt` no vacío,
  /// sustituye al fallback offline. Misma frontera de la pantalla — la
  /// API es idéntica para el adulto que la lee.
  final String promptBackend;
  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    final pregunta = promptBackend.isNotEmpty
        ? promptBackend
        : preguntaParaLaCenaOffline(agregado);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textos.cuidadorPreguntaCabecera,
          style: TipografiaCuaderno.sans(
            color: esquema.tertiary,
            tamano: TipografiaCuaderno.tamano12,
            peso: TipografiaCuaderno.pesoMedio,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          pregunta,
          style: TipografiaCuaderno.serif(
            color: esquema.onSurface,
            tamano: TipografiaCuaderno.tamano17,
            altoLinea: 1.5,
          ),
        ),
      ],
    );
  }
}

class _ResumenBackend extends StatelessWidget {
  const _ResumenBackend({
    required this.textos,
    required this.esquema,
    required this.texto,
  });

  final TextosApp textos;
  final ColorScheme esquema;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textos.cuidadorResumenCabecera,
          style: TipografiaCuaderno.sans(
            color: esquema.tertiary,
            tamano: TipografiaCuaderno.tamano12,
            peso: TipografiaCuaderno.pesoMedio,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          texto,
          style: TipografiaCuaderno.serif(
            color: esquema.onSurface,
            tamano: TipografiaCuaderno.tamano14,
            altoLinea: 1.5,
          ),
        ),
      ],
    );
  }
}

class _BloqueSincronizar extends StatelessWidget {
  const _BloqueSincronizar({
    required this.textos,
    required this.esquema,
    required this.sincronizando,
    required this.avisoSincronizacion,
    required this.alPulsar,
  });

  final TextosApp textos;
  final ColorScheme esquema;
  final bool sincronizando;
  final String? avisoSincronizacion;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilledButton.icon(
          onPressed: sincronizando ? null : alPulsar,
          icon: sincronizando
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                )
              : const Icon(Icons.cloud_upload_outlined),
          label: Text(
            sincronizando
                ? textos.cuidadorSincronizarEnVuelo
                : textos.cuidadorSincronizarBoton,
          ),
        ),
        if (avisoSincronizacion != null) ...[
          const SizedBox(height: 8),
          Text(
            avisoSincronizacion!,
            style: TipografiaCuaderno.serif(
              color: PaletaCuaderno.tintaTenue,
              tamano: TipografiaCuaderno.tamano13,
              altoLinea: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}

class _Metricas extends StatelessWidget {
  const _Metricas({
    required this.textos,
    required this.agregado,
    required this.esquema,
  });

  final TextosApp textos;
  final AgregadoSemanal agregado;
  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textos.cuidadorMetricasCabecera,
          style: TipografiaCuaderno.sans(
            color: esquema.tertiary,
            tamano: TipografiaCuaderno.tamano12,
            peso: TipografiaCuaderno.pesoMedio,
          ),
        ),
        const SizedBox(height: 8),
        _LineaMetrica(
          texto: textos.cuidadorMetricaObservaciones(agregado.observacionesTotal),
        ),
        _LineaMetrica(
          texto: textos.cuidadorMetricaMisterios(agregado.misteriosDistintos),
        ),
        _LineaMetrica(
          texto: textos.cuidadorMetricaSitSpot(agregado.sitSpotVisitas),
        ),
      ],
    );
  }
}

class _LineaMetrica extends StatelessWidget {
  const _LineaMetrica({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        texto,
        style: TipografiaCuaderno.serif(
          color: PaletaCuaderno.tinta,
          tamano: TipografiaCuaderno.tamano14,
        ),
      ),
    );
  }
}
