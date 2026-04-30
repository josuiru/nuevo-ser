import 'package:flutter/material.dart';

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
  });

  final RepositorioLocal repositorio;

  /// Inyectable para tests (semana exacta a agregar). En producción
  /// se deja null y se usa `DateTime.now()`.
  final DateTime? semanaPivote;

  @override
  State<PantallaCuidador> createState() => _EstadoPantallaCuidador();
}

class _EstadoPantallaCuidador extends State<PantallaCuidador> {
  AgregadoSemanal? _agregado;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final observaciones = await widget.repositorio.obtenerObservaciones();
    if (!mounted) return;
    setState(() {
      _agregado = computarAgregadoSemanal(
        observaciones,
        semanaPivote: widget.semanaPivote,
      );
      _cargando = false;
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
            : _Contenido(agregado: _agregado!, textos: textos, esquema: esquema),
      ),
    );
  }
}

class _Contenido extends StatelessWidget {
  const _Contenido({
    required this.agregado,
    required this.textos,
    required this.esquema,
  });

  final AgregadoSemanal agregado;
  final TextosApp textos;
  final ColorScheme esquema;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        _Aviso(textos: textos, esquema: esquema),
        const SizedBox(height: 24),
        _SemanaActual(textos: textos, agregado: agregado, esquema: esquema),
        const SizedBox(height: 16),
        _Pregunta(textos: textos, agregado: agregado, esquema: esquema),
        const SizedBox(height: 24),
        _Metricas(textos: textos, agregado: agregado, esquema: esquema),
      ],
    );
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
          textos.cuidadorPreguntaCabecera,
          style: TipografiaCuaderno.sans(
            color: esquema.tertiary,
            tamano: TipografiaCuaderno.tamano12,
            peso: TipografiaCuaderno.pesoMedio,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          preguntaParaLaCenaOffline(agregado),
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
