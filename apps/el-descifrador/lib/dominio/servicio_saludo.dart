// Servicio que produce el texto del saludo del maestro en función del
// estado del niño. Doc 03 §1, doc 09 §1.
//
// Voz del maestro: sobria, una o dos frases, sin aplauso, sin
// exclamaciones formularias. Cuando el niño no abre la app en días,
// no se le reprocha — solo se le reconoce que ha vuelto.

import 'estado_sesion.dart';
import 'memoria_sesiones.dart';

class ServicioSaludo {
  const ServicioSaludo();

  /// Devuelve el texto que se muestra como saludo del maestro al
  /// entrar a la mesa.
  String saludoParaSesion({
    required MemoriaSesiones? memoria,
    required EstadoSesion estado,
    required DateTime ahora,
  }) {
    // Caso primer encuentro: el niño abre la app por primera vez.
    if (memoria == null) {
      return 'Bienvenido a la oficina, aprendiz. Hay correo en la mesa.';
    }

    // ¿Cuántos días desde la última visita anterior?
    // Si la última visita ya fue ahora (mismo objeto registrado al
    // entrar), nos interesa cuántos días antes fue la previa real.
    // El llamador debe pasarnos la memoria ANTES de registrar la
    // visita actual. Esto es responsabilidad de PantallaMesa.
    final dias = memoria.diasDesdeUltimaVisita(ahora);
    final vacia = estado.bandejaDeEntradaVacia;

    if (dias == 0) {
      // Mismo día — el niño ha cerrado y vuelto, o estuvo dos veces.
      return vacia
          ? 'El correo de hoy está hecho. Puedes parar cuando quieras.'
          : 'Sigue habiendo correo en la mesa.';
    }

    if (dias == 1) {
      return vacia
          ? 'Hoy no ha llegado nada nuevo. El día está tranquilo.'
          : 'Buenos días, aprendiz. Hay correo en la mesa.';
    }

    if (dias <= 6) {
      return vacia
          ? 'Vuelves después de unos días. Hoy la mesa está vacía.'
          : 'Vuelves después de unos días. Hay correo esperándote.';
    }

    if (dias <= 30) {
      return vacia
          ? 'Llevabas tiempo sin pasar por la oficina. Hoy no hay correo.'
          : 'Llevabas tiempo sin pasar por la oficina. Hay correo en la mesa.';
    }

    return vacia
        ? 'Mucho tiempo. El cuaderno te ha esperado. Hoy no hay correo nuevo.'
        : 'Mucho tiempo. El cuaderno te ha esperado. Hay correo en la mesa.';
  }
}
