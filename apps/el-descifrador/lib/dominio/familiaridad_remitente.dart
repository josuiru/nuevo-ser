// Familiaridad del niño con cada remitente recurrente.
//
// Cada vez que el niño trabaja una pieza de Inês, Mansfield, Iria,
// Joan, Bea, Manuel, Antón o Aitziber, su familiaridad con ese
// personaje aumenta en uno. El nivel resultante (desconocido →
// saludando → conocido → familiar → cercano) es lo que aparece en
// la página del personaje del cuaderno propio.
//
// Esta lógica es **estructura del cuaderno**, no progreso evaluable.
// El niño nunca ve un número crudo. Ve la página del personaje
// ganar densidad y la fórmula de saludo del personaje cambiar.
//
// Idea inspirada en patrones de "reputation with NPC" de
// Kingdom of Loathing / West of Loathing — deuda declarada en
// `el-descifrador-08-referencias-y-deudas.md`. Allí el sistema mide
// "reputación" como número visible; aquí lo invertimos: el número es
// invisible, el resultado es **una mejor página de personaje**.

import 'voz_remitente.dart';

/// Nivel cualitativo de familiaridad. Derivado del contador interno
/// de piezas trabajadas con el remitente.
enum NivelFamiliaridad {
  /// El niño no ha trabajado ninguna pieza de este remitente todavía.
  /// La página del personaje en el cuaderno no existe aún.
  desconocido(piezasMinimas: 0, etiquetaCanonica: 'Desconocido'),

  /// El niño ha trabajado una pieza. Sabe quién es el remitente,
  /// poco más. La página del personaje aparece con su nombre y oficio.
  saludando(piezasMinimas: 1, etiquetaCanonica: 'Saludando'),

  /// Tres piezas trabajadas. Conoce sus tics y su voz. La página del
  /// personaje empieza a tener observaciones del aprendiz.
  conocido(piezasMinimas: 3, etiquetaCanonica: 'Conocido'),

  /// Siete piezas. Familiar — reconoce la letra antes de leer la firma,
  /// sabe qué espera de él/ella. La página tiene anécdotas acumuladas.
  familiar(piezasMinimas: 7, etiquetaCanonica: 'Familiar'),

  /// Quince piezas. Cercano — relación de oficio sólida. La página
  /// tiene apartado de "cosas que solo nosotros sabemos".
  cercano(piezasMinimas: 15, etiquetaCanonica: 'Cercano');

  const NivelFamiliaridad({
    required this.piezasMinimas,
    required this.etiquetaCanonica,
  });

  final int piezasMinimas;
  final String etiquetaCanonica;

  /// Deriva el nivel desde el número de piezas trabajadas. Devuelve el
  /// nivel más alto cuyo umbral se ha alcanzado.
  static NivelFamiliaridad desdePiezas(int piezas) {
    NivelFamiliaridad resultado = NivelFamiliaridad.desconocido;
    for (final nivel in NivelFamiliaridad.values) {
      if (piezas >= nivel.piezasMinimas) {
        resultado = nivel;
      }
    }
    return resultado;
  }
}

/// Estado inmutable de familiaridad del niño con todos los remitentes
/// recurrentes. Vive dentro del cuaderno propio del niño y se
/// persiste por perfil.
class FamiliaridadRemitente {
  FamiliaridadRemitente._(this._piezasPorRemitente);

  /// Estado inicial: ningún remitente conocido.
  factory FamiliaridadRemitente.inicial() {
    return FamiliaridadRemitente._(const {});
  }

  /// Reconstruye desde mapa de piezas. Usado por el repositorio al
  /// cargar de shared_preferences.
  factory FamiliaridadRemitente.desdeMapa(Map<VozRemitente, int> piezas) {
    return FamiliaridadRemitente._(Map.unmodifiable(piezas));
  }

  final Map<VozRemitente, int> _piezasPorRemitente;

  /// Piezas trabajadas con este remitente. Cero si aún no se ha visto.
  int piezasTrabajadasCon(VozRemitente remitente) {
    return _piezasPorRemitente[remitente] ?? 0;
  }

  /// Nivel de familiaridad con este remitente.
  NivelFamiliaridad nivelCon(VozRemitente remitente) {
    return NivelFamiliaridad.desdePiezas(piezasTrabajadasCon(remitente));
  }

  /// Remitentes con los que el niño tiene al menos una pieza trabajada.
  /// El cuaderno los muestra como páginas de personaje activas.
  Set<VozRemitente> remitentesConocidos() {
    return _piezasPorRemitente.entries
        .where((entrada) => entrada.value > 0)
        .map((entrada) => entrada.key)
        .toSet();
  }

  /// Devuelve un nuevo estado con la familiaridad incrementada en uno
  /// para el remitente dado. La clase es inmutable — esta operación
  /// produce nueva instancia para que el llamador pueda persistirla.
  ///
  /// Si el remitente es null (voz puntual no recurrente, como Niko el
  /// compañero aprendiz), no produce cambio.
  FamiliaridadRemitente conPiezaTrabajadaCon(VozRemitente? remitente) {
    if (remitente == null) return this;

    final nuevo = Map<VozRemitente, int>.from(_piezasPorRemitente);
    nuevo[remitente] = (nuevo[remitente] ?? 0) + 1;
    return FamiliaridadRemitente._(Map.unmodifiable(nuevo));
  }

  /// Serializa a Map<String, int> donde la clave es el identificador
  /// técnico del remitente. Para persistencia JSON.
  Map<String, int> serializar() {
    return {
      for (final entrada in _piezasPorRemitente.entries)
        entrada.key.identificadorTecnico: entrada.value,
    };
  }

  /// Deserializa desde Map<String, int>. Tolera identificadores
  /// desconocidos — los ignora silenciosamente (puede pasar si se
  /// elimina un remitente recurrente del catálogo entre versiones).
  factory FamiliaridadRemitente.deserializar(Map<String, dynamic> mapa) {
    final piezas = <VozRemitente, int>{};
    for (final entrada in mapa.entries) {
      final remitente = VozRemitente.desdeIdentificador(entrada.key);
      if (remitente != null) {
        final valor = entrada.value;
        if (valor is int && valor > 0) {
          piezas[remitente] = valor;
        }
      }
    }
    return FamiliaridadRemitente.desdeMapa(piezas);
  }
}
