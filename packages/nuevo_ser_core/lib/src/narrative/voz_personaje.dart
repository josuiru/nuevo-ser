import 'package:flutter/material.dart';

/// Contrato genérico de "voz" para el sistema de cinemáticas
/// compartido por todos los juegos de la Colección.
///
/// Cada juego define sus propias voces (Sora/Kurz/Eco… en Uno Roto;
/// Maren/Isaura/Tasio/Begoña/Karim… en Las Versiones) implementando
/// este contrato. El player de cinemáticas no conoce las voces
/// concretas — sólo este contrato.
///
/// Es **clase abstracta**, no sealed: cada app extiende con sus voces
/// sin modificar la plataforma. Las voces típicas se modelan como
/// constantes estáticas en una `final class` que implementa este
/// contrato (ejemplo: `VozPersonaje.sora` en Uno Roto). El patrón
/// preserva la API estilo enum (`VozPersonaje.sora`, `voz.nombreVisible`)
/// permitiendo a la vez polimorfismo con la plataforma.
///
/// El contrato se llama `VozPersonajeContrato` (no `VozPersonaje`) para
/// dejar libre el nombre `VozPersonaje` a la implementación concreta de
/// cada juego — Uno Roto ya define `VozPersonaje.sora`, `VozPersonaje.kai`,
/// etc., y tener el contrato en el barrel con el mismo nombre rompería
/// los imports.
abstract class VozPersonajeContrato {
  const VozPersonajeContrato();

  /// Nombre legible para mostrar encima del bocadillo de diálogo. Vacío
  /// para narradores sin voz atribuida.
  String get nombreVisible;

  /// Color del nombre — del propio juego (cada paleta es distinta:
  /// neón violeta en Uno Roto, sepia/ámbar en Las Versiones).
  Color get colorNombre;

  /// `true` cuando la voz debe renderizarse con tipografía/estilo
  /// distinguidos del habla humana convencional. En Uno Roto lo usan
  /// los Fragmentos nombrados (Cormorant Garamond italic). En Las
  /// Versiones podría usarlo una "voz de fuente" — fragmentos en latín,
  /// citas medievales, lectura de un manuscrito.
  bool get esEnfasis;

  /// Estilo del cuerpo del texto del diálogo. Cada juego lo decide
  /// según su tipografía y tono. La plataforma no impone fuente.
  TextStyle estiloTextoCuerpo();
}
