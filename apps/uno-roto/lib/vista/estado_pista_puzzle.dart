import 'dart:async';

import 'package:flutter/material.dart';

/// Encapsula la pista visual escalonada en puzzles con candidatos: tras
/// 2 fallos consecutivos en el mismo problema, el candidato correcto se
/// ilumina con un halo tenue durante 1,5s. Anterior a la oferta de Eco
/// (que llega a los 3 fallos en el cazadero) — ayuda al niño antes de
/// que la frustración cuaje.
///
/// Cada pantalla de puzzle crea uno en `initState`, lo libera en
/// `dispose`, y llama [registrarAcierto] / [registrarFallo] /
/// [mostrarSiToca] desde su lógica de elección. La pintura consulta
/// [activa] para decidir si dibujar el halo en la tarjeta correcta.
class EstadoPistaPuzzle {
  EstadoPistaPuzzle({required this.alCambiar});

  /// Callback que la pantalla cablea a `() => setState(() {})` para que
  /// los cambios de estado de pista provoquen un repintado.
  final VoidCallback alCambiar;

  int _fallosConsecutivos = 0;
  bool _activa = false;
  Timer? _temporizador;

  bool get activa => _activa;

  void registrarAcierto() {
    _fallosConsecutivos = 0;
    _apagarSiActiva();
  }

  void registrarFallo() {
    _fallosConsecutivos++;
    _apagarSiActiva();
  }

  /// Activa la pista si hay 2 o más fallos. Pensado para llamarse tras
  /// el flash de error, no inmediatamente al fallar — así el niño ve
  /// primero "te has equivocado" y después la pista visual.
  void mostrarSiToca() {
    if (_fallosConsecutivos < 2) return;
    _activa = true;
    alCambiar();
    _temporizador = Timer(const Duration(milliseconds: 1500), () {
      _activa = false;
      alCambiar();
    });
  }

  void dispose() {
    _temporizador?.cancel();
  }

  void _apagarSiActiva() {
    _temporizador?.cancel();
    if (_activa) {
      _activa = false;
      alCambiar();
    }
  }
}
