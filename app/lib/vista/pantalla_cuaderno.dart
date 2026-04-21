import 'package:flutter/material.dart';

import '../datos/repositorio_progreso.dart';
import '../dominio/cuaderno.dart';
import '../nucleo/paleta.dart';

/// Cuaderno de Irune: lectura opcional de entradas que el niño
/// desbloquea jugando. Sin gameplay extra, sin notificaciones
/// estridentes. Agrupa por categoría y marca entradas como leídas
/// al abrirlas.
class PantallaCuaderno extends StatefulWidget {
  final RepositorioProgreso repositorio;

  const PantallaCuaderno({super.key, required this.repositorio});

  @override
  State<PantallaCuaderno> createState() => _PantallaCuadernoState();
}

class _PantallaCuadernoState extends State<PantallaCuaderno> {
  List<EntradaCuaderno> _disponibles = [];
  Set<String> _leidas = {};
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final disponibles = await CatalogoCuaderno.disponibles(
      widget.repositorio.flagNarrativoActivo,
    );
    final leidas = <String>{};
    for (final entrada in disponibles) {
      if (await widget.repositorio.entradaCuadernoLeida(entrada.id)) {
        leidas.add(entrada.id);
      }
    }
    if (!mounted) return;
    setState(() {
      _disponibles = disponibles;
      _leidas = leidas;
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
          'cuaderno',
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
          : _contenido(),
    );
  }

  Widget _contenido() {
    if (_disponibles.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text(
            'Aún no has desbloqueado entradas.\n'
            'Sigue jugando — cada persona o lugar que conozcas abre una página.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: PaletaNeon.textoTenue.withOpacity(0.7),
              fontSize: 14,
              letterSpacing: 0.5,
              height: 1.6,
            ),
          ),
        ),
      );
    }

    final porCategoria = <CategoriaCuaderno, List<EntradaCuaderno>>{};
    for (final e in _disponibles) {
      porCategoria.putIfAbsent(e.categoria, () => []).add(e);
    }
    final categorias = CategoriaCuaderno.values
        .where((c) => porCategoria.containsKey(c))
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: categorias.length + 1,
      itemBuilder: (_, indice) {
        if (indice == 0) return _resumenLeidas();
        final categoria = categorias[indice - 1];
        return _seccionCategoria(categoria, porCategoria[categoria]!);
      },
    );
  }

  Widget _resumenLeidas() {
    final leidas = _leidas.length;
    final total = _disponibles.length;
    final totalPosible = CatalogoCuaderno.totalEntradas;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 20),
      child: Text(
        '$leidas leídas · $total de $totalPosible desbloqueadas',
        style: TextStyle(
          fontSize: 11,
          letterSpacing: 2,
          color: PaletaNeon.textoTenue.withOpacity(0.65),
        ),
      ),
    );
  }

  Widget _seccionCategoria(
    CategoriaCuaderno categoria,
    List<EntradaCuaderno> entradas,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 10, left: 4),
          child: Text(
            categoria.nombreVisible.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 4,
              color: PaletaNeon.violetaNeon.withOpacity(0.75),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        for (final entrada in entradas) _tarjetaEntrada(entrada),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _tarjetaEntrada(EntradaCuaderno entrada) {
    final leida = _leidas.contains(entrada.id);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _abrirEntrada(entrada),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: PaletaNeon.fondoMedio.withOpacity(0.55),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: (leida
                      ? PaletaNeon.textoTenue
                      : PaletaNeon.azulNeon)
                  .withOpacity(0.28),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: leida
                      ? PaletaNeon.textoTenue.withOpacity(0.35)
                      : PaletaNeon.azulNeon,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  entrada.titulo,
                  style: TextStyle(
                    fontSize: 14,
                    color: leida
                        ? PaletaNeon.textoTenue
                        : PaletaNeon.textoPrincipal,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: PaletaNeon.textoTenue.withOpacity(0.45),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _abrirEntrada(EntradaCuaderno entrada) async {
    await widget.repositorio.marcarEntradaCuadernoLeida(entrada.id);
    if (!mounted) return;
    setState(() => _leidas.add(entrada.id));
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _LecturaEntrada(entrada: entrada),
      ),
    );
  }
}

class _LecturaEntrada extends StatelessWidget {
  final EntradaCuaderno entrada;

  const _LecturaEntrada({required this.entrada});

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      backgroundColor: PaletaNeon.fondoProfundo,
      appBar: AppBar(
        backgroundColor: PaletaNeon.fondoMedio,
        iconTheme: const IconThemeData(color: PaletaNeon.textoTenue),
        title: Text(
          entrada.categoria.nombreVisible.toLowerCase(),
          style: const TextStyle(
            color: PaletaNeon.textoTenue,
            fontSize: 12,
            letterSpacing: 3,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entrada.titulo,
              style: const TextStyle(
                fontSize: 26,
                color: PaletaNeon.textoPrincipal,
                fontWeight: FontWeight.w300,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              entrada.texto,
              style: const TextStyle(
                fontSize: 16,
                color: PaletaNeon.textoPrincipal,
                letterSpacing: 0.2,
                height: 1.6,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
