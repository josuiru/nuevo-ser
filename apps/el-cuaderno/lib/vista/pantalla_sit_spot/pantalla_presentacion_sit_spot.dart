import 'package:flutter/material.dart';

import '../tema/colores.dart';
import '../tema/tipografia.dart';

/// Tercer paso del primer arranque (tras elegir idioma y escribir el
/// nombre): presenta el concepto pedagógico del sit spot — el corazón
/// del oficio "habitar un lugar" (biblia §3.5).
///
/// Hasta este punto el niño aterrizaba en la pantalla principal con una
/// tarjeta-invitación "todavía no tienes sit spot" sin contexto. La
/// invitación es perfectamente pulsable, pero la palabra *sit spot*
/// llega sin presentación y el niño no sabe que es el corazón
/// pedagógico del juego.
///
/// Voz adulta amable, sin diminutivos, sin urgencia (biblia §2.5).
/// Doble botón:
///
/// - **"ya pienso en uno"**: el niño tiene un sitio en mente y va a
///   habitarlo. Aterrizará en la pantalla principal con la tarjeta-
///   invitación pulsable como primer elemento.
/// - **"todavía no"**: el niño todavía no tiene un sit spot. Aterrizará
///   en la pantalla principal igual; la tarjeta seguirá ahí cuando lo
///   piense. No hay urgencia y no hay penalización.
///
/// Ambos botones marcan la presentación como vista — el niño no la
/// volverá a ver salvo que se borre el cuaderno entero. Este principio
/// (información pedagógica accesible una vez, sin repetición) sigue el
/// principio §2.7 "ritmo respetuoso" de la biblia: el cuaderno nunca
/// empuja al niño al uso.
class PantallaPresentacionSitSpot extends StatelessWidget {
  const PantallaPresentacionSitSpot({
    super.key,
    required this.alContinuar,
  });

  /// Llamado al pulsar cualquiera de los dos botones. El caller se
  /// encarga de marcar la presentación como vista y de reconstruir la
  /// app para mostrar la pantalla principal. Se pasa `true` si el niño
  /// pulsó "ya pienso en uno" (intención de crear) y `false` si pulsó
  /// "todavía no". Hoy la diferencia es informativa para el caller
  /// (puede usarse en el futuro para auto-abrir la pantalla de crear);
  /// la pantalla principal en sí trata los dos casos por igual.
  final Future<void> Function({required bool tieneUnSitioPensado})
      alContinuar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PaletaCuaderno.papelClaro,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Text(
                tituloPresentacionSitSpot,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: PaletaCuaderno.tinta,
                ),
              ),
              const SizedBox(height: 24),
              const ExplicacionSitSpot(),
              const Spacer(flex: 2),
              _Boton(
                etiqueta: 'ya pienso en uno',
                primario: true,
                alPulsar: () => alContinuar(tieneUnSitioPensado: true),
              ),
              const SizedBox(height: 14),
              _Boton(
                etiqueta: 'todavía no',
                primario: false,
                alPulsar: () => alContinuar(tieneUnSitioPensado: false),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Título de la presentación pedagógica. Expuesto como const para que
/// la tarjeta-invitación del home lo reuse en su diálogo sin duplicar
/// el string.
const String tituloPresentacionSitSpot = 'Un sitio que conoces';

/// Tres párrafos pedagógicos que explican qué es un sit spot. Se
/// muestran en `PantallaPresentacionSitSpot` (primer arranque) y en
/// el diálogo "qué es un sit spot" accesible desde la tarjeta-
/// invitación del home (cuando el niño pulsó "todavía no" en su día y
/// quiere releerlo). Mismo texto en los dos sitios — refactorizado a
/// widget público para que un cambio de copy sólo toque un fichero.
class ExplicacionSitSpot extends StatelessWidget {
  const ExplicacionSitSpot({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Parrafo(
          'En este cuaderno hay un sitio especial. Lo eliges tú: '
          'un banco del parque, una piedra junto al río, un rincón '
          'del jardín, una ventana.',
        ),
        SizedBox(height: 14),
        _Parrafo(
          'Lo importante no es que sea bonito. Es que puedas '
          'volver. Si vuelves muchas veces, lo verás cambiar — '
          'las hojas, los pájaros, la luz, los bichos. El '
          'cuaderno se llenará de lo que pase allí.',
        ),
        SizedBox(height: 14),
        _Parrafo(
          'Cuando lo encuentres, le pones nombre. No tiene que ser '
          'un nombre serio.',
        ),
      ],
    );
  }
}

class _Parrafo extends StatelessWidget {
  const _Parrafo(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      textAlign: TextAlign.left,
      style: TipografiaCuaderno.serif(
        color: PaletaCuaderno.tinta,
        tamano: TipografiaCuaderno.tamano14,
        altoLinea: 1.55,
      ),
    );
  }
}

class _Boton extends StatelessWidget {
  const _Boton({
    required this.etiqueta,
    required this.alPulsar,
    required this.primario,
  });

  final String etiqueta;
  final VoidCallback alPulsar;
  final bool primario;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: alPulsar,
      style: ElevatedButton.styleFrom(
        backgroundColor: primario
            ? PaletaCuaderno.papelMedio
            : PaletaCuaderno.papelClaro,
        foregroundColor: PaletaCuaderno.tinta,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: PaletaCuaderno.papelOscuro),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w400,
        ),
      ),
      child: Text(etiqueta),
    );
  }
}
