import 'package:flutter/foundation.dart';

/// Señal global para que las pantallas de datos (Hoy, Fincas, Proyectos)
/// recarguen cuando algo cambia desde fuera de ellas — p. ej. al cargar los
/// datos de demostración desde Ajustes. Las pantallas escuchan este notifier
/// y vuelven a leer la BD cuando cambia.
final ValueNotifier<int> notificadorDatos = ValueNotifier<int>(0);

/// Avisa de que los datos han cambiado (incrementa el contador).
void avisarCambioDatos() => notificadorDatos.value++;
