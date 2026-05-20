import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'checker_actualizaciones.dart';

/// Banner sticky para anunciar una versión disponible. Pensado para
/// colocarse en la cabecera de las pantallas de inicio de cada app.
/// Sin auto-instalar: tap abre el URL del asset en el navegador y el
/// usuario decide (Android pide los permisos de instalación que toca).
class BannerActualizacionDisponible extends StatelessWidget {
  final ActualizacionDisponible actualizacion;

  /// Callback opcional al pulsar la X de descartar. Si está presente
  /// se muestra el botón.
  final VoidCallback? onDescartar;

  /// Estilo del banner. `compacto` cabe junto a un AppBar; `expandido`
  /// llena el ancho con padding generoso.
  final bool compacto;

  const BannerActualizacionDisponible({
    super.key,
    required this.actualizacion,
    this.onDescartar,
    this.compacto = false,
  });

  Future<void> _abrirDescarga() async {
    final url = Uri.tryParse(actualizacion.urlAsset);
    if (url == null) return;
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = compacto
        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
        : const EdgeInsets.all(14);
    return Material(
      color: theme.colorScheme.primary.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: _abrirDescarga,
        child: Padding(
          padding: padding,
          child: Row(
            children: [
              Icon(Icons.system_update,
                  size: compacto ? 18 : 22, color: theme.colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Versión ${actualizacion.versionDisponible} disponible',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: compacto ? 12 : 14,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    if (!compacto) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Tienes instalada la ${actualizacion.versionInstalada}. '
                        'Toca para descargar.',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.tonal(
                onPressed: _abrirDescarga,
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: compacto ? 10 : 14,
                    vertical: compacto ? 4 : 8,
                  ),
                ),
                child: Text(
                  'Descargar',
                  style: TextStyle(fontSize: compacto ? 12 : 13),
                ),
              ),
              if (onDescartar != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: onDescartar,
                  tooltip: 'Descartar por ahora',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
