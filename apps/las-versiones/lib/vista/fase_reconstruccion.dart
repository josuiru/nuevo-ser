import 'package:flutter/material.dart';

import '../datos/repositorio_reconstruccion.dart';
import '../dominio/brecha.dart';
import '../nucleo/paleta_archivo.dart';

/// Pantalla jugable de la Fase 4 — Reconstrucción con declaración de
/// niveles de confianza (AH.03, perfil P4 Brier). Es el corazón
/// pedagógico del juego: la Cronista elige qué afirmaciones del
/// catálogo sostiene y, para cada una, declara el nivel de confianza
/// con que la sostiene —Sólido, Probable o Disputado.
///
/// El cálculo Brier no se evalúa aquí (eso pasa en la Fase 5
/// Concilio, que lee la reconstrucción persistida y devuelve
/// feedback). Aquí sólo se construye la versión.
class FaseReconstruccion extends StatefulWidget {
  /// Brecha cuya Fase 4 se está jugando.
  final Brecha brecha;

  /// Callback al que llamar cuando la Cronista pulsa "AL CONCILIO".
  final VoidCallback alAvanzarFase;

  /// Repositorio de persistencia. Inyectable para tests.
  final RepositorioReconstruccion repoReconstruccion;

  const FaseReconstruccion({
    super.key,
    required this.brecha,
    required this.alAvanzarFase,
    this.repoReconstruccion = const RepositorioReconstruccion(),
  });

  @override
  State<FaseReconstruccion> createState() => _FaseReconstruccionState();
}

class _FaseReconstruccionState extends State<FaseReconstruccion> {
  Map<String, NivelConfianza> _declaraciones = const {};
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarReconstruccion();
  }

  Future<void> _cargarReconstruccion() async {
    final mapa = await widget.repoReconstruccion.cargar(widget.brecha.id);
    if (!mounted) return;
    setState(() {
      _declaraciones = mapa;
      _cargando = false;
    });
  }

  Future<void> _alElegirNivel(String idAfirmacion, NivelConfianza nivel) async {
    final nuevas = {..._declaraciones, idAfirmacion: nivel};
    await widget.repoReconstruccion.guardar(widget.brecha.id, nuevas);
    if (!mounted) return;
    setState(() => _declaraciones = nuevas);
  }

  Future<void> _alQuitar(String idAfirmacion) async {
    final nuevas = {..._declaraciones}..remove(idAfirmacion);
    await widget.repoReconstruccion.guardar(widget.brecha.id, nuevas);
    if (!mounted) return;
    setState(() => _declaraciones = nuevas);
  }

  @override
  Widget build(BuildContext contexto) {
    if (_cargando) {
      return const SizedBox.expand();
    }
    final declaradas = _declaraciones.length;
    final minimoDeclaradas = widget.brecha.minimoAfirmacionesParaConcilio;
    final puedeAvanzar = declaradas >= minimoDeclaradas;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _IntroFase4(),
        const SizedBox(height: 6),
        _ContadorReconstruccion(
          declaradas: declaradas,
          minimo: minimoDeclaradas,
        ),
        const SizedBox(height: 14),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int indice = 0;
                    indice < widget.brecha.afirmacionesCanonicas.length;
                    indice++) ...[
                  if (indice > 0) const SizedBox(height: 12),
                  _TarjetaAfirmacion(
                    afirmacion: widget.brecha.afirmacionesCanonicas[indice],
                    nivelDeclarado: _declaraciones[widget.brecha
                        .afirmacionesCanonicas[indice].id],
                    alElegirNivel: (nivel) => _alElegirNivel(
                      widget.brecha.afirmacionesCanonicas[indice].id,
                      nivel,
                    ),
                    alQuitar: () => _alQuitar(
                      widget.brecha.afirmacionesCanonicas[indice].id,
                    ),
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
              'AL CONCILIO',
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

class _IntroFase4 extends StatelessWidget {
  const _IntroFase4();

  @override
  Widget build(BuildContext contexto) {
    return Text(
      'Construye tu versión. Marca cada afirmación que sostienes y '
      'declara con qué nivel de confianza: Sólido, Probable o '
      'Disputado. Lo que el oficio premia no es tener razón — es '
      'haber juzgado bien con lo que tenías.',
      style: TextStyle(
        fontSize: 14,
        color: PaletaArchivo.textoPrincipal.withOpacity(0.9),
        height: 1.55,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}

class _ContadorReconstruccion extends StatelessWidget {
  final int declaradas;
  final int minimo;

  const _ContadorReconstruccion({
    required this.declaradas,
    required this.minimo,
  });

  @override
  Widget build(BuildContext contexto) {
    final faltan = (minimo - declaradas).clamp(0, minimo);
    final mensaje = faltan == 0
        ? 'Sostienes $declaradas afirmaciones — listo para el Concilio.'
        : 'Sostienes $declaradas. El mínimo para ir al Concilio es $minimo '
            '(faltan $faltan).';
    return Text(
      mensaje,
      style: const TextStyle(
        fontSize: 11,
        letterSpacing: 2.5,
        color: PaletaArchivo.ambarLacre,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _TarjetaAfirmacion extends StatelessWidget {
  final AfirmacionCanonica afirmacion;
  final NivelConfianza? nivelDeclarado;
  final ValueChanged<NivelConfianza> alElegirNivel;
  final VoidCallback alQuitar;

  const _TarjetaAfirmacion({
    required this.afirmacion,
    required this.nivelDeclarado,
    required this.alElegirNivel,
    required this.alQuitar,
  });

  @override
  Widget build(BuildContext contexto) {
    final declarada = nivelDeclarado != null;
    final colorAcento = declarada
        ? PaletaArchivo.ambarLacre
        : PaletaArchivo.tintaTenue.withOpacity(0.4);
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
            afirmacion.texto,
            style: TextStyle(
              fontSize: 14,
              color: PaletaArchivo.textoPrincipal.withOpacity(0.92),
              height: 1.5,
              fontWeight: FontWeight.w300,
            ),
          ),
          if (afirmacion.idsFuentesAnclaje.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Anclada en: ${afirmacion.idsFuentesAnclaje.join(', ')}',
              style: TextStyle(
                fontSize: 11,
                color: PaletaArchivo.textoTenue.withOpacity(0.8),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              for (final nivel in NivelConfianza.values) ...[
                Expanded(
                  child: _BotonNivel(
                    nivel: nivel,
                    seleccionado: nivelDeclarado == nivel,
                    alPulsar: () => alElegirNivel(nivel),
                  ),
                ),
                if (nivel != NivelConfianza.values.last)
                  const SizedBox(width: 6),
              ],
            ],
          ),
          if (declarada)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: alQuitar,
                style: TextButton.styleFrom(
                  foregroundColor:
                      PaletaArchivo.textoTenue.withOpacity(0.85),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  minimumSize: const Size(0, 30),
                ),
                child: const Text(
                  'Quitar de mi versión',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BotonNivel extends StatelessWidget {
  final NivelConfianza nivel;
  final bool seleccionado;
  final VoidCallback alPulsar;

  const _BotonNivel({
    required this.nivel,
    required this.seleccionado,
    required this.alPulsar,
  });

  @override
  Widget build(BuildContext contexto) {
    return TextButton(
      onPressed: alPulsar,
      style: TextButton.styleFrom(
        backgroundColor: seleccionado
            ? PaletaArchivo.ambarLacre.withOpacity(0.22)
            : PaletaArchivo.fondoMedio.withOpacity(0.55),
        side: BorderSide(
          color: seleccionado
              ? PaletaArchivo.ambarLacre
              : PaletaArchivo.tintaTenue.withOpacity(0.5),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        foregroundColor: PaletaArchivo.textoPrincipal,
      ),
      child: Text(
        _etiquetaNivel(nivel),
        style: TextStyle(
          fontSize: 11,
          letterSpacing: 1.5,
          fontWeight: seleccionado ? FontWeight.w500 : FontWeight.w400,
          color: PaletaArchivo.textoPrincipal.withOpacity(0.95),
        ),
      ),
    );
  }

  String _etiquetaNivel(NivelConfianza nivel) {
    switch (nivel) {
      case NivelConfianza.solido:
        return 'Sólido';
      case NivelConfianza.probable:
        return 'Probable';
      case NivelConfianza.disputado:
        return 'Disputado';
    }
  }
}
