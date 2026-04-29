import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../datos/catalogo_habilidades.dart';
import '../datos/repositorio_progreso.dart';
import '../dominio/catalogo_distritos.dart';
import '../l10n/app_localizations.dart';
import '../nucleo/paleta.dart';
import 'pantalla_caza.dart';

/// Selector de dominio para el modo entrenamiento. El niño elige a qué
/// rama de las matemáticas dedicarle la sesión y entra al cazadero
/// filtrado por ese dominio. Es opcional: el cazadero "libre" desde
/// el mapa sigue funcionando como siempre.
///
/// Cumple el principio "el niño es la medida": no hay barra de
/// progreso ni objetivos cuantitativos. Solo botones grandes con el
/// nombre del dominio. Si el niño no se siente con un dominio, vuelve
/// al mapa y entra a un distrito normal.
class PantallaEntrenamiento extends StatefulWidget {
  final RepositorioProgreso repositorio;

  const PantallaEntrenamiento({super.key, required this.repositorio});

  @override
  State<PantallaEntrenamiento> createState() => _PantallaEntrenamientoState();
}

class _PantallaEntrenamientoState extends State<PantallaEntrenamiento> {
  Map<String, String>? _dominios;

  @override
  void initState() {
    super.initState();
    _cargarDominios();
  }

  Future<void> _cargarDominios() async {
    final catalogo = await CatalogoHabilidades.cargar();
    if (!mounted) return;
    setState(() => _dominios = Map<String, String>.from(catalogo.dominios));
  }

  void _entrarADominio(String idDominio, String nombreDominio) {
    HapticFeedback.selectionClick();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => PantallaCaza(
          repositorio: widget.repositorio,
          // Reutilizamos los tejados como fondo del entrenamiento: es
          // el escenario que el niño ya conoce desde el principio y
          // no introduce ruido visual nuevo.
          distrito: CatalogoDistritos.tejados,
          dominioFiltrado: idDominio,
          nombreDominio: nombreDominio,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext contexto) {
    final dominios = _dominios;
    final textos = AppLocalizations.of(contexto);
    return Scaffold(
      backgroundColor: PaletaNeon.fondoProfundo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: PaletaNeon.violetaBase,
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        textos.cazaBotonMapa,
                        style: const TextStyle(
                          color: PaletaNeon.textoTenue,
                          fontSize: 12,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                textos.entrenamientoTitulo,
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 5,
                  color: PaletaNeon.violetaNeon.withOpacity(0.9),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                textos.entrenamientoPregunta,
                style: TextStyle(
                  fontSize: 16,
                  color: PaletaNeon.textoPrincipal.withOpacity(0.9),
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: dominios == null
                    ? const SizedBox.shrink()
                    : ListView(
                        children: [
                          for (final entrada in dominios.entries)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _BotonDominio(
                                idDominio: entrada.key,
                                nombre: entrada.value,
                                alPulsar: _entrarADominio,
                              ),
                            ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BotonDominio extends StatelessWidget {
  final String idDominio;
  final String nombre;
  final void Function(String idDominio, String nombreDominio) alPulsar;

  const _BotonDominio({
    required this.idDominio,
    required this.nombre,
    required this.alPulsar,
  });

  @override
  Widget build(BuildContext contexto) {
    return InkWell(
      onTap: () => alPulsar(idDominio, nombre),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: PaletaNeon.fondoMedio.withOpacity(0.6),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: PaletaNeon.violetaNeon.withOpacity(0.55),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              alignment: Alignment.center,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(
                  color: PaletaNeon.azulNeon.withOpacity(0.7),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                idDominio,
                style: const TextStyle(
                  color: PaletaNeon.textoPrincipal,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.4,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                nombre,
                style: const TextStyle(
                  color: PaletaNeon.textoPrincipal,
                  fontSize: 15,
                  letterSpacing: 0.6,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: PaletaNeon.textoTenue.withOpacity(0.6),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
