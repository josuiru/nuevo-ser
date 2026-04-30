import 'package:flutter/material.dart';

import '../datos/repositorio_mosaico.dart';
import '../dominio/mosaico_arco_1.dart';
import '../nucleo/paleta_archivo.dart';

/// Pantalla del Mosaico del Arco 1. Lectura+escritura libre: tres
/// prompts con un campo de texto multilinea por debajo. La Cronista
/// escribe lo que quiera; al pulsar "ENTREGAR EL MOSAICO" se persiste
/// y se activa el flag de mosaico entregado, devolviéndola al
/// esqueleto.
///
/// El Mosaico **no se evalúa**. No hay mínimos, no hay máximos. La
/// única condición para entregar es que la Cronista haya escrito
/// algo en al menos uno de los tres campos — entregar un mosaico
/// totalmente vacío sería un click sin oficio.
class PantallaMosaicoArco1 extends StatefulWidget {
  /// Callback al que llamar cuando la Cronista entrega el Mosaico.
  /// El orquestador activa el flag de entregado y vuelve al
  /// esqueleto.
  final Future<void> Function() alEntregar;

  /// Repositorio de persistencia. Inyectable para tests.
  final RepositorioMosaico repoMosaico;

  const PantallaMosaicoArco1({
    super.key,
    required this.alEntregar,
    this.repoMosaico = const RepositorioMosaico(),
  });

  @override
  State<PantallaMosaicoArco1> createState() => _PantallaMosaicoArco1State();
}

class _PantallaMosaicoArco1State extends State<PantallaMosaicoArco1> {
  final Map<String, TextEditingController> _controladores = {};
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    for (final prompt in MosaicoArco1.prompts) {
      _controladores[prompt.id] = TextEditingController();
    }
    _cargarRespuestasPersistidas();
  }

  @override
  void dispose() {
    for (final controlador in _controladores.values) {
      controlador.dispose();
    }
    super.dispose();
  }

  Future<void> _cargarRespuestasPersistidas() async {
    final mapa = await widget.repoMosaico.cargar(MosaicoArco1.idArco);
    if (!mounted) return;
    for (final entrada in mapa.entries) {
      final controlador = _controladores[entrada.key];
      if (controlador != null) {
        controlador.text = entrada.value;
      }
    }
    setState(() => _cargando = false);
  }

  Future<void> _alPulsarEntregar() async {
    final respuestas = <String, String>{};
    var hayContenido = false;
    for (final prompt in MosaicoArco1.prompts) {
      final texto = _controladores[prompt.id]!.text.trim();
      if (texto.isNotEmpty) {
        respuestas[prompt.id] = texto;
        hayContenido = true;
      }
    }
    if (!hayContenido) return;
    await widget.repoMosaico.guardar(MosaicoArco1.idArco, respuestas);
    await widget.alEntregar();
  }

  @override
  Widget build(BuildContext contexto) {
    if (_cargando) {
      return const Scaffold(
        backgroundColor: PaletaArchivo.fondoProfundo,
        body: SizedBox.expand(),
      );
    }
    final puedeEntregar = _controladores.values
        .any((controlador) => controlador.text.trim().isNotEmpty);
    return Scaffold(
      backgroundColor: PaletaArchivo.fondoProfundo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                MosaicoArco1.titulo.toUpperCase(),
                style: const TextStyle(
                  fontSize: 13,
                  letterSpacing: 4,
                  color: PaletaArchivo.ambarLacre,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                MosaicoArco1.glosa,
                style: TextStyle(
                  fontSize: 14,
                  color: PaletaArchivo.textoPrincipal.withOpacity(0.9),
                  height: 1.55,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (int indice = 0;
                          indice < MosaicoArco1.prompts.length;
                          indice++) ...[
                        if (indice > 0) const SizedBox(height: 18),
                        _CampoPrompt(
                          prompt: MosaicoArco1.prompts[indice],
                          controlador:
                              _controladores[MosaicoArco1.prompts[indice].id]!,
                          alCambiar: () => setState(() {}),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: puedeEntregar ? _alPulsarEntregar : null,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    foregroundColor: PaletaArchivo.textoPrincipal,
                    backgroundColor: PaletaArchivo.fondoMedio
                        .withOpacity(puedeEntregar ? 0.6 : 0.3),
                    side: BorderSide(
                      color: PaletaArchivo.ambarLacre.withOpacity(
                        puedeEntregar ? 0.7 : 0.3,
                      ),
                    ),
                  ),
                  child: const Text(
                    'ENTREGAR EL MOSAICO',
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CampoPrompt extends StatelessWidget {
  final PromptMosaico prompt;
  final TextEditingController controlador;
  final VoidCallback alCambiar;

  const _CampoPrompt({
    required this.prompt,
    required this.controlador,
    required this.alCambiar,
  });

  @override
  Widget build(BuildContext contexto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          prompt.texto,
          style: TextStyle(
            fontSize: 14,
            color: PaletaArchivo.textoPrincipal.withOpacity(0.92),
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: PaletaArchivo.fondoMedio.withOpacity(0.5),
            border: Border.all(
              color: PaletaArchivo.ambarLacre.withOpacity(0.45),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: TextField(
            controller: controlador,
            maxLines: 6,
            minLines: 3,
            onChanged: (_) => alCambiar(),
            style: TextStyle(
              fontSize: 14,
              color: PaletaArchivo.textoPrincipal.withOpacity(0.95),
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Escribe lo que quieras…',
              hintStyle: TextStyle(
                color: PaletaArchivo.textoTenue.withOpacity(0.6),
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
