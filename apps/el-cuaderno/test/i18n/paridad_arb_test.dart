@TestOn('vm')
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Protege dos invariantes de los archivos ARB (es/eu/ca):
///
/// 1. **Paridad de claves** — cuando se añade una clave nueva al
///    castellano (`app_es.arb` es el template), es fácil olvidar
///    añadirla también a `app_eu.arb` y `app_ca.arb`. La generación
///    nativa `gen_l10n` cae al template para las claves missing — la
///    app sigue compilando, pero el niño en euskera/catalán ve
///    castellano sin que nadie se dé cuenta.
///
/// 2. **Coherencia de placeholders** — si la clave declara un
///    placeholder `{nombre}` en su metadato `@clave.placeholders`,
///    los tres idiomas deben usarlo en su valor. Si en eu se traduce
///    libremente y se omite el `{nombre}`, gen_l10n compila pero el
///    nombre del niño desaparece de la frase en eu.
void main() {
  final raiz = Directory.current.path.endsWith('el-cuaderno')
      ? '.'
      : 'apps/el-cuaderno';
  final esCrudo = _cargarArbCrudo('$raiz/lib/nucleo/i18n/arb/app_es.arb');
  final euCrudo = _cargarArbCrudo('$raiz/lib/nucleo/i18n/arb/app_eu.arb');
  final caCrudo = _cargarArbCrudo('$raiz/lib/nucleo/i18n/arb/app_ca.arb');

  test('paridad de claves entre app_es.arb, app_eu.arb y app_ca.arb', () {
    final es = _clavesVisibles(esCrudo);
    final eu = _clavesVisibles(euCrudo);
    final ca = _clavesVisibles(caCrudo);

    final faltanEnEu = es.difference(eu);
    final faltanEnCa = es.difference(ca);
    final extraEnEu = eu.difference(es);
    final extraEnCa = ca.difference(es);

    expect(
      faltanEnEu,
      isEmpty,
      reason: 'Claves en app_es.arb que no están en app_eu.arb: $faltanEnEu',
    );
    expect(
      faltanEnCa,
      isEmpty,
      reason: 'Claves en app_es.arb que no están en app_ca.arb: $faltanEnCa',
    );
    expect(
      extraEnEu,
      isEmpty,
      reason: 'Claves en app_eu.arb que no están en app_es.arb (template): '
          '$extraEnEu',
    );
    expect(
      extraEnCa,
      isEmpty,
      reason: 'Claves en app_ca.arb que no están en app_es.arb (template): '
          '$extraEnCa',
    );
  });

  test('los placeholders del template aparecen en eu y ca', () {
    final divergencias = <String>[];
    for (final clave in _clavesVisibles(esCrudo)) {
      final metadato = esCrudo['@$clave'];
      if (metadato is! Map<String, dynamic>) continue;
      final placeholders =
          (metadato['placeholders'] as Map<String, dynamic>?)?.keys ?? const [];
      if (placeholders.isEmpty) continue;
      for (final ph in placeholders) {
        final marcador = '{$ph}';
        for (final entry in {'eu': euCrudo, 'ca': caCrudo}.entries) {
          final valor = entry.value[clave];
          if (valor is! String) continue;
          if (!valor.contains(marcador)) {
            divergencias.add(
              'app_${entry.key}.arb · clave "$clave" no contiene el '
              'placeholder "$marcador" declarado en el template. '
              'Valor actual: ${jsonEncode(valor)}',
            );
          }
        }
      }
    }
    expect(divergencias, isEmpty, reason: divergencias.join('\n'));
  });
}

Map<String, dynamic> _cargarArbCrudo(String ruta) {
  final contenido = File(ruta).readAsStringSync();
  return jsonDecode(contenido) as Map<String, dynamic>;
}

/// Devuelve sólo las claves de string visibles. Excluye:
/// - `@<clave>`: metadatos de placeholders generados por `gen_l10n`.
/// - `_<clave>`: notas internas para mantenedores (ej. `_TODO_GLOBAL`
///   en `app_eu.arb`/`app_ca.arb` que documenta el estado pendiente
///   de revisión por hablante nativo, sin equivalente en el template
///   castellano porque sólo aplica a los idiomas no nativos).
Set<String> _clavesVisibles(Map<String, dynamic> arb) {
  return arb.keys
      .where((clave) => !clave.startsWith('@') && !clave.startsWith('_'))
      .toSet();
}
