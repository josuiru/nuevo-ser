// Re-export del modelo genérico de escena cinematográfica del core. El
// archivo se mantiene como punto de import estable para los call-sites
// del juego (catálogo, variantes, player); la implementación vive en
// el paquete nuevo_ser_core, submódulo narrative/.
export 'package:nuevo_ser_core/nuevo_ser_core.dart' show EscenaCinematica;
