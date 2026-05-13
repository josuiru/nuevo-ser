// Orquestador de localizaciones del puerto de La Estafeta.
//
// Decide qué pantalla mostrar según la localización actual:
//   - oficina → PantallaMesa (la mesa del aprendiz, donde se trabajan los papeles)
//   - resto   → PantallaLocalizacion (placeholder con render del lugar)
//
// El botón "Mapa" abre un modal con los destinos accesibles desde la
// localización actual según `conexionesPuerto`.

import 'package:flutter/material.dart';

import '../datos/repositorio_localizacion.dart';
import '../dominio/localizacion.dart';
import 'paleta_estafeta.dart';
import 'pantalla_localizacion.dart';
import 'pantalla_mesa.dart';

class PantallaPuerto extends StatefulWidget {
  const PantallaPuerto({
    super.key,
    this.idPerfil = 'principal',
    this.repositorioLocalizacionInyectado,
  });

  final String idPerfil;
  final RepositorioLocalizacion? repositorioLocalizacionInyectado;

  @override
  State<PantallaPuerto> createState() => _EstadoPantallaPuerto();
}

class _EstadoPantallaPuerto extends State<PantallaPuerto> {
  late final RepositorioLocalizacion _repositorio;
  Localizacion _actual = Localizacion.oficina;

  @override
  void initState() {
    super.initState();
    _repositorio = widget.repositorioLocalizacionInyectado ??
        RepositorioLocalizacion(idPerfil: widget.idPerfil);
    _cargar();
  }

  Future<void> _cargar() async {
    final loc = await _repositorio.cargar();
    if (!mounted) return;
    setState(() => _actual = loc);
  }

  Future<void> _irA(Localizacion destino) async {
    if (destino == _actual) return;
    await _repositorio.guardar(destino);
    if (!mounted) return;
    setState(() => _actual = destino);
  }

  void _abrirMapa() {
    final destinos = destinosDesde(_actual);
    showDialog<void>(
      context: context,
      builder: (contexto) => _DialogoMapa(
        actual: _actual,
        destinosAccesibles: destinos,
        alElegir: (destino) {
          Navigator.of(contexto).pop();
          _irA(destino);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext contexto) {
    if (_actual == Localizacion.oficina) {
      return PantallaMesa(
        idPerfil: widget.idPerfil,
        alAbrirMapa: _abrirMapa,
      );
    }
    return PantallaLocalizacion(
      localizacion: _actual,
      alAbrirMapa: _abrirMapa,
      alVolverAOficina: () => _irA(Localizacion.oficina),
    );
  }
}

class _DialogoMapa extends StatelessWidget {
  const _DialogoMapa({
    required this.actual,
    required this.destinosAccesibles,
    required this.alElegir,
  });

  final Localizacion actual;
  final Set<Localizacion> destinosAccesibles;
  final ValueChanged<Localizacion> alElegir;

  @override
  Widget build(BuildContext contexto) {
    return Dialog(
      backgroundColor: PaletaEstafeta.papel,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Estás en ${actual.nombreCanonico.toLowerCase()}',
                style: TextStyle(
                  color: PaletaEstafeta.sepia.withValues(alpha: 0.9),
                  fontSize: 12,
                  fontFamily: 'serif',
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '¿A dónde vas?',
                style: TextStyle(
                  color: PaletaEstafeta.tinta,
                  fontSize: 20,
                  fontFamily: 'serif',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              if (destinosAccesibles.isEmpty)
                Text(
                  'No hay salida directa desde aquí.',
                  style: TextStyle(
                    color: PaletaEstafeta.tinta.withValues(alpha: 0.6),
                    fontSize: 14,
                    fontFamily: 'serif',
                    fontStyle: FontStyle.italic,
                  ),
                )
              else
                for (final destino in destinosAccesibles)
                  _EnlaceDestino(
                    destino: destino,
                    alPulsar: () => alElegir(destino),
                  ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(contexto).pop(),
                  child: const Text(
                    'Quedarme aquí',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 13,
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

class _EnlaceDestino extends StatelessWidget {
  const _EnlaceDestino({required this.destino, required this.alPulsar});

  final Localizacion destino;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext contexto) {
    return InkWell(
      onTap: alPulsar,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          children: [
            const Icon(
              Icons.arrow_forward,
              color: PaletaEstafeta.sepia,
              size: 16,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destino.nombreCanonico,
                    style: const TextStyle(
                      color: PaletaEstafeta.tinta,
                      fontSize: 15,
                      fontFamily: 'serif',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    destino.descripcionBreve,
                    style: TextStyle(
                      color: PaletaEstafeta.tinta.withValues(alpha: 0.6),
                      fontSize: 12,
                      fontFamily: 'serif',
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
