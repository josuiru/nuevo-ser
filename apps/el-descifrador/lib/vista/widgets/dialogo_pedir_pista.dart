// Diálogo para pedir pista al maestro sobre una palabra. Mecánica
// nuclear §3.5. Tres niveles: tono / comparación / traducción.
//
// El maestro responde sobrio (doc 09 §1): tres frases, sin aplauso.
// Las pistas ya pedidas para esta palabra quedan marcadas para que
// el niño vea cuáles probó.

import 'package:flutter/material.dart';

import '../../dominio/pistas_pedidas.dart';
import '../../dominio/servicio_pistas.dart';
import '../paleta_estafeta.dart';

/// Lo que el diálogo devuelve al cerrar: nivel que el niño pidió
/// (para que el llamador lo registre) y respuesta del maestro.
/// null si el niño cerró sin pedir nada.
class PistaSeleccionada {
  const PistaSeleccionada({required this.nivel, required this.respuesta});

  final NivelPista nivel;
  final RespuestaPista respuesta;
}

/// Abre el diálogo. `respuestasGeneradas` se invoca al pedir cada pista
/// — devuelve la respuesta del maestro. Esto permite que el llamador
/// registre la pista en el repositorio antes de mostrar el texto.
Future<PistaSeleccionada?> mostrarDialogoPedirPista({
  required BuildContext contexto,
  required String palabraOriginal,
  required Set<NivelPista> nivelesYaPedidos,
  required RespuestaPista Function(NivelPista) responder,
}) {
  return showDialog<PistaSeleccionada>(
    context: contexto,
    builder: (contexto) => _DialogoPedirPista(
      palabraOriginal: palabraOriginal,
      nivelesYaPedidos: nivelesYaPedidos,
      responder: responder,
    ),
  );
}

class _DialogoPedirPista extends StatefulWidget {
  const _DialogoPedirPista({
    required this.palabraOriginal,
    required this.nivelesYaPedidos,
    required this.responder,
  });

  final String palabraOriginal;
  final Set<NivelPista> nivelesYaPedidos;
  final RespuestaPista Function(NivelPista) responder;

  @override
  State<_DialogoPedirPista> createState() => _EstadoDialogo();
}

class _EstadoDialogo extends State<_DialogoPedirPista> {
  RespuestaPista? _ultimaRespuesta;

  void _pedirPista(NivelPista nivel) {
    final respuesta = widget.responder(nivel);
    setState(() => _ultimaRespuesta = respuesta);
  }

  String _etiquetaNivel(NivelPista nivel) {
    switch (nivel) {
      case NivelPista.tono:
        return 'Que me suene';
      case NivelPista.comparacion:
        return 'Otra carta parecida';
      case NivelPista.traduccion:
        return 'Qué significa';
    }
  }

  String _descripcionNivel(NivelPista nivel) {
    switch (nivel) {
      case NivelPista.tono:
        return 'El maestro te dirá si ya la has visto antes.';
      case NivelPista.comparacion:
        return 'El maestro buscará otra pieza tuya donde aparezca.';
      case NivelPista.traduccion:
        return 'El maestro te dirá qué significa exactamente.';
    }
  }

  @override
  Widget build(BuildContext contexto) {
    final respuesta = _ultimaRespuesta;
    return Dialog(
      backgroundColor: PaletaEstafeta.papel,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pedir pista al maestro',
                style: TextStyle(
                  color: PaletaEstafeta.sepia.withValues(alpha: 0.9),
                  fontSize: 13,
                  fontFamily: 'serif',
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.palabraOriginal,
                style: const TextStyle(
                  color: PaletaEstafeta.tinta,
                  fontSize: 22,
                  fontFamily: 'serif',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              for (final nivel in NivelPista.values)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _BotonNivel(
                    etiqueta: _etiquetaNivel(nivel),
                    descripcion: _descripcionNivel(nivel),
                    yaPedido: widget.nivelesYaPedidos.contains(nivel),
                    alPulsar: () => _pedirPista(nivel),
                  ),
                ),
              if (respuesta != null) ...[
                const SizedBox(height: 12),
                Divider(color: PaletaEstafeta.sepia.withValues(alpha: 0.3)),
                const SizedBox(height: 12),
                _RespuestaDelMaestro(respuesta: respuesta),
              ],
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    final ultima = _ultimaRespuesta;
                    Navigator.of(context).pop(
                      ultima == null
                          ? null
                          : PistaSeleccionada(
                              nivel: ultima.nivel,
                              respuesta: ultima,
                            ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: PaletaEstafeta.tinta,
                  ),
                  child: Text(
                    respuesta == null ? 'Cerrar' : 'Volver al documento',
                    style: const TextStyle(
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

class _BotonNivel extends StatelessWidget {
  const _BotonNivel({
    required this.etiqueta,
    required this.descripcion,
    required this.yaPedido,
    required this.alPulsar,
  });

  final String etiqueta;
  final String descripcion;
  final bool yaPedido;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext contexto) {
    return InkWell(
      onTap: alPulsar,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: yaPedido
                ? PaletaEstafeta.sepia
                : PaletaEstafeta.sepia.withValues(alpha: 0.4),
            width: yaPedido ? 1.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    etiqueta,
                    style: TextStyle(
                      color: PaletaEstafeta.tinta,
                      fontSize: 14,
                      fontFamily: 'serif',
                      fontWeight:
                          yaPedido ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    descripcion,
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
            if (yaPedido)
              Text(
                'pedida',
                style: TextStyle(
                  color: PaletaEstafeta.sepia.withValues(alpha: 0.8),
                  fontSize: 11,
                  fontFamily: 'serif',
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RespuestaDelMaestro extends StatelessWidget {
  const _RespuestaDelMaestro({required this.respuesta});

  final RespuestaPista respuesta;

  @override
  Widget build(BuildContext contexto) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PaletaEstafeta.madera.withValues(alpha: 0.06),
        border: Border(
          left: BorderSide(
            color: PaletaEstafeta.sepia.withValues(alpha: 0.6),
            width: 2,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'El maestro:',
            style: TextStyle(
              color: PaletaEstafeta.sepia.withValues(alpha: 0.9),
              fontSize: 11,
              fontFamily: 'serif',
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            respuesta.texto,
            style: const TextStyle(
              color: PaletaEstafeta.tinta,
              fontSize: 14,
              fontFamily: 'serif',
              height: 1.4,
            ),
          ),
          if (respuesta.piezaParalela != null) ...[
            const SizedBox(height: 8),
            Text(
              '— ${respuesta.piezaParalela!.remitenteTextoLibre.replaceAll('_', ' ')}, '
              '${respuesta.piezaParalela!.lenguaPrincipal.nombreCanonico}',
              style: TextStyle(
                color: PaletaEstafeta.sepia.withValues(alpha: 0.8),
                fontSize: 12,
                fontFamily: 'serif',
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
