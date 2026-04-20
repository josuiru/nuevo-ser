import 'package:flutter/material.dart';

import '../datos/catalogo_habilidades.dart';
import '../datos/repositorio_progreso.dart';
import '../dominio/habilidad.dart';
import '../nucleo/paleta.dart';

/// Panel que lista las 66 habilidades del mapa pedagógico y muestra
/// para cada una el nivel actual del niño y su precisión. Accesible
/// desde el mapa con long-press. Futuro dashboard de padres (doc 03 §7)
/// en forma rudimentaria.
class PantallaHabilidades extends StatefulWidget {
  final RepositorioProgreso repositorio;

  const PantallaHabilidades({super.key, required this.repositorio});

  @override
  State<PantallaHabilidades> createState() => _PantallaHabilidadesState();
}

class _PantallaHabilidadesState extends State<PantallaHabilidades> {
  CatalogoHabilidades? _catalogo;
  Map<String, EstadoHabilidad> _estados = {};
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final catalogo = await CatalogoHabilidades.cargar();
    final estados = <String, EstadoHabilidad>{};
    for (final h in catalogo.habilidades.values) {
      final estado = await widget.repositorio.cargarEstadoHabilidad(
        h.identificador,
      );
      if (estado != null) estados[h.identificador] = estado;
    }
    if (!mounted) return;
    setState(() {
      _catalogo = catalogo;
      _estados = estados;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      backgroundColor: PaletaNeon.fondoProfundo,
      appBar: AppBar(
        backgroundColor: PaletaNeon.fondoMedio,
        title: const Text(
          'habilidades',
          style: TextStyle(
            color: PaletaNeon.textoPrincipal,
            fontSize: 16,
            letterSpacing: 4,
            fontWeight: FontWeight.w300,
          ),
        ),
        iconTheme: const IconThemeData(color: PaletaNeon.textoTenue),
      ),
      body: _cargando
          ? const Center(
              child: CircularProgressIndicator(color: PaletaNeon.azulNeon),
            )
          : _listaPorDominio(),
    );
  }

  Widget _listaPorDominio() {
    final catalogo = _catalogo!;
    final dominiosOrdenados = catalogo.dominios.entries.toList();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dominiosOrdenados.length,
      itemBuilder: (_, indice) {
        final entrada = dominiosOrdenados[indice];
        final habilidadesDelDominio = catalogo
            .habilidades.values
            .where((h) => h.dominio == entrada.key)
            .toList();
        return _BloqueDominio(
          codigo: entrada.key,
          nombre: entrada.value,
          habilidades: habilidadesDelDominio,
          estados: _estados,
        );
      },
    );
  }
}

class _BloqueDominio extends StatelessWidget {
  final String codigo;
  final String nombre;
  final List<Habilidad> habilidades;
  final Map<String, EstadoHabilidad> estados;

  const _BloqueDominio({
    required this.codigo,
    required this.nombre,
    required this.habilidades,
    required this.estados,
  });

  @override
  Widget build(BuildContext contexto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '$codigo · ${nombre.toUpperCase()}',
              style: const TextStyle(
                color: PaletaNeon.azulNeon,
                fontSize: 12,
                letterSpacing: 3,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ...habilidades.map(
            (habilidad) => _FilaHabilidad(
              habilidad: habilidad,
              estado: estados[habilidad.identificador],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilaHabilidad extends StatelessWidget {
  final Habilidad habilidad;
  final EstadoHabilidad? estado;

  const _FilaHabilidad({required this.habilidad, this.estado});

  Color _colorPorNivel(NivelMaestria nivel) {
    switch (nivel) {
      case NivelMaestria.inexplorada:
        return PaletaNeon.textoTenue.withOpacity(0.3);
      case NivelMaestria.introducida:
        return PaletaNeon.rosaAcento.withOpacity(0.7);
      case NivelMaestria.enDesarrollo:
        return const Color(0xFFFFA552);
      case NivelMaestria.competente:
        return PaletaNeon.azulNeon;
      case NivelMaestria.maestria:
        return PaletaNeon.exitoSuave;
    }
  }

  @override
  Widget build(BuildContext contexto) {
    final nivel = estado?.nivel ?? NivelMaestria.inexplorada;
    final precision = estado?.precision ?? 0;
    final exposiciones = estado?.totalExposiciones ?? 0;
    final color = _colorPorNivel(nivel);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 32,
            color: color,
            margin: const EdgeInsets.only(right: 10),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      habilidad.identificador,
                      style: const TextStyle(
                        color: PaletaNeon.textoTenue,
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        habilidad.nombre,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: PaletaNeon.textoPrincipal,
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${nivel.nombreCastellano} '
                  '· precisión ${(precision * 100).toStringAsFixed(0)}% '
                  '· $exposiciones intentos',
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
