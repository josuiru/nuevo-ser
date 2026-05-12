import 'fragmento_en_tejado.dart';

/// Descripciones pedagógicas de cada tipo de puzzle. Se muestran al
/// pulsar el botón de ayuda (?) en cada pantalla de puzzle.
class AyudaPuzzle {
  static const _ayudas = <TipoFragmentoEnTejado, _Ayuda>{
    TipoFragmentoEnTejado.unitario: _Ayuda(
      'CORTAR EN PARTES IGUALES',
      'Tienes que dividir el Fragmento en el número de partes que indica.\n\n'
          '1. Desliza el dedo para cortar.\n'
          '2. Cada corte debe hacer partes del mismo tamaño.\n'
          '3. Cuando tengas el número exacto de partes, el Fragmento se deshace.\n\n'
          'Cuanto más preciso seas, mejor.',
      'En la vida: repartir una pizza, una tarta o cualquier cosa en partes iguales.',
    ),
    TipoFragmentoEnTejado.comparacion: _Ayuda(
      'COMPARAR FRACCIONES',
      'Tienes dos fracciones y tienes que tocar la mayor.\n\n'
          '• Si tienen el MISMO denominador (número de abajo), gana la que tiene el numerador (número de arriba) más grande.\n'
          '• Si tienen el MISMO numerador, gana la que tiene el denominador más pequeño (porque los trozos son más grandes).',
      'En la vida: saber qué oferta es mejor (3/8 de descuento vs 5/12).',
    ),
    TipoFragmentoEnTejado.comparacionDistinta: _Ayuda(
      'COMPARAR FRACCIONES DISTINTAS',
      'Dos fracciones sin nada en común. No puedes comparar solo mirando.\n\n'
          'Multiplica en cruz:\n'
          '  a/b  ?  c/d  →  a×d  ?  c×b\n'
          'El lado donde el producto sea mayor, esa fracción es la mayor.\n\n'
          'También puedes convertir a decimal dividiendo numerador entre denominador.',
      'En la vida: comparar ofertas con formatos distintos, o repartos diferentes.',
    ),
    TipoFragmentoEnTejado.comparacionDecimal: _Ayuda(
      'COMPARAR DECIMALES',
      'Tienes dos decimales y tienes que tocar el mayor.\n\n'
          'Cuidado: más cifras NO significa más grande.\n'
          '  0,35 NO es mayor que 0,4 (0,4 = 0,40).\n\n'
          'Compara cifra a cifra empezando por la izquierda: décimas, centésimas…',
      'En la vida: comparar precios (0,35 €/kg vs 0,4 €/kg). Más cifras no es más caro.',
    ),
    TipoFragmentoEnTejado.comparacionUnidad: _Ayuda(
      'COMPARAR CON LA UNIDAD',
      '¿La fracción es menor, igual o mayor que 1?\n\n'
          '• numerador < denominador → la fracción es menor que 1 (propia)\n'
          '• numerador = denominador → la fracción es igual a 1\n'
          '• numerador > denominador → la fracción es mayor que 1 (impropia)',
      'En la vida: saber si has comido más de una pizza entera o menos.',
    ),
    TipoFragmentoEnTejado.comparacionMedia: _Ayuda(
      'COMPARAR CON 1/2',
      '¿La fracción es menor, igual o mayor que un medio?\n\n'
          'Aplica esta regla:\n'
          '  2 × numerador < denominador → menor que 1/2\n'
          '  2 × numerador = denominador → igual a 1/2\n'
          '  2 × numerador > denominador → mayor que 1/2\n\n'
          'Ejemplo: 5/9 → 2×5 = 10 > 9 → 5/9 es mayor que 1/2.',
      'En la vida: estimar si un depósito está más de la mitad lleno o menos.',
    ),
    TipoFragmentoEnTejado.espejo: _Ayuda(
      'FRACCIONES EQUIVALENTES',
      'Elige la fracción que vale lo mismo que la que ves.\n\n'
          'Dos fracciones son equivalentes cuando representan la misma cantidad.\n\n'
          'Para comprobarlo, multiplica en cruz: a/b = c/d si a×d = c×b.\n'
          'Para encontrar una equivalente, multiplica o divide numerador y denominador por el mismo número.',
      'En la vida: repartir lo mismo de formas distintas (2/4 de pizza = 1/2).',
    ),
    TipoFragmentoEnTejado.simplificar: _Ayuda(
      'SIMPLIFICAR FRACCIONES',
      'Reduce la fracción a su forma más simple.\n\n'
          'Para simplificar, divide numerador y denominador entre el mismo número (el MCD).\n\n'
          'Ejemplo: 6/8 → divide entre 2 → 3/4.\n'
          '6/8 y 3/4 valen lo mismo, pero 3/4 es la forma más simple.',
      'En la vida: expresar medidas de la forma más simple (4/8 → 1/2).',
    ),
    TipoFragmentoEnTejado.amplificar: _Ayuda(
      'AMPLIFICAR FRACCIONES',
      'Completa el número que falta: a/b = ?/c.\n\n'
          'Para amplificar, multiplica numerador y denominador por el mismo número.\n\n'
          'Ejemplo: 3/4 = ?/12 → 4×3 = 12, así que 3×3 = 9 → 3/4 = 9/12.',
      'En la vida: adaptar una receta para más comensales manteniendo proporciones.',
    ),
    TipoFragmentoEnTejado.decimal: _Ayuda(
      'FRACCIÓN → DECIMAL',
      'Elige el decimal que equivale a la fracción.\n\n'
          'Para convertir una fracción a decimal, divide el numerador entre el denominador.\n\n'
          'Ejemplo: 3/4 = 3 ÷ 4 = 0,75.',
      'En la vida: convertir 3/4 de hora en 0,75 h para calcular tiempo total.',
    ),
    TipoFragmentoEnTejado.porcentaje: _Ayuda(
      'FRACCIÓN → PORCENTAJE',
      'Elige el porcentaje que equivale a la fracción.\n\n'
          'Un porcentaje es una fracción con denominador 100.\n'
          'Para convertir: multiplica la fracción por 100.\n\n'
          'Ejemplo: 3/4 = 3÷4 = 0,75 → 0,75×100 = 75%.',
      'En la vida: entender que 3/4 = 75% en un examen, un descuento o una encuesta.',
    ),
    TipoFragmentoEnTejado.dual: _Ayuda(
      'OPERAR CON FRACCIONES',
      'Calcula el resultado de la operación entre dos fracciones.\n\n'
          '• SUMA y RESTA: iguala los denominadores (mínimo común múltiplo) y suma o resta los numeradores.\n'
          '• MULTIPLICACIÓN: multiplica numerador × numerador y denominador × denominador.\n'
          '• DIVISIÓN: multiplica en cruz (la primera por la inversa de la segunda).',
      'En la vida: sumar ingredientes (1/2 taza + 1/4 taza = 3/4 taza).',
    ),
    TipoFragmentoEnTejado.operacionDecimal: _Ayuda(
      'OPERAR CON DECIMALES',
      'Calcula el resultado de la operación con decimales.\n\n'
          '• SUMA y RESTA: alinea las comas decimales y suma o resta cifra a cifra.\n'
          '• MULTIPLICACIÓN: multiplica sin comas y después coloca la coma (tantos decimales como entre los dos factores).\n'
          '• DIVISIÓN: desplaza la coma para que el divisor sea entero.',
      'En la vida: calcular el total de la compra (1,25 € + 3,80 €).',
    ),
    TipoFragmentoEnTejado.jerarquia: _Ayuda(
      'JERARQUÍA DE OPERACIONES',
      'Calcula respetando la prioridad de las operaciones.\n\n'
          '1. Primero las multiplicaciones (×) y divisiones (÷).\n'
          '2. Después las sumas (+) y restas (−).\n\n'
          'No operes de izquierda a derecha sin respetar la jerarquía, ¡es la trampa!',
      'En la vida: calcular 2 + 3 × 4 en una factura (× va antes que +).',
    ),
    TipoFragmentoEnTejado.jerarquiaFracciones: _Ayuda(
      'JERARQUÍA CON FRACCIONES',
      'Igual que la jerarquía normal, pero con fracciones.\n\n'
          '1. Primero multiplica y divide las fracciones.\n'
          '2. Después suma y resta, igualando denominadores cuando haga falta.\n\n'
          'Recuerda simplificar el resultado si puedes.',
      'En la vida: cálculos mixtos con ingredientes y medidas en cocina.',
    ),
    TipoFragmentoEnTejado.operacionMixta: _Ayuda(
      'DECIMAL + FRACCIÓN',
      'Operación que mezcla un decimal y una fracción.\n\n'
          'Convierte la fracción a decimal (numerador ÷ denominador) y después opera.\n\n'
          'O al revés: convierte el decimal a fracción y opera con fracciones.\n\n'
          'Elige el camino que te resulte más fácil.',
      'En la vida: combinar medidas en distintos formatos (0,5 L + 1/4 L).',
    ),
    TipoFragmentoEnTejado.divisibilidad: _Ayuda(
      'DIVISIBILIDAD',
      '¿El número se puede dividir exactamente?\n\n'
          '• Un número es divisible entre 2 si termina en 0 o cifra par.\n'
          '• Entre 3 si la suma de sus cifras es múltiplo de 3.\n'
          '• Entre 5 si termina en 0 o 5.\n'
          '• Entre 10 si termina en 0.\n\n'
          'Si la división da exacta (resto 0), es divisible.',
      'En la vida: saber si puedes repartir algo en grupos iguales sin que sobre nada.',
    ),
    TipoFragmentoEnTejado.multiplos: _Ayuda(
      'MÚLTIPLOS',
      '¿Un número es múltiplo de otro?\n\n'
          'Un número es múltiplo de otro si se puede dividir exactamente entre él.\n\n'
          'Ejemplo: 15 es múltiplo de 3 porque 15÷3 = 5 exacto.\n'
          '         15 NO es múltiplo de 4 porque 15÷4 no da exacto.',
      'En la vida: calcular cuándo coinciden dos eventos (cada 3 y cada 4 días).',
    ),
    TipoFragmentoEnTejado.divisores: _Ayuda(
      'DIVISORES',
      'Tres números son divisores. El cuarto es el intruso: no lo es.\n\n'
          'Un divisor de N es un número que divide a N exactamente (resto 0).\n\n'
          'Comprueba cada candidato haciendo la división mental. El que no encaja es el intruso.',
      'En la vida: repartir equitativamente entre varias personas sin que sobre nada.',
    ),
    TipoFragmentoEnTejado.primo: _Ayuda(
      'NÚMEROS PRIMOS',
      '¿El número es primo?\n\n'
          'Un número primo solo se puede dividir exactamente entre 1 y entre sí mismo.\n\n'
          'Importante: 1 NO es primo (solo tiene un divisor).\n'
          '2 es el único número primo par.',
      'En la vida: conceptos básicos de cifrado y seguridad digital.',
    ),
    TipoFragmentoEnTejado.mcmMcd: _Ayuda(
      'MCM y MCD',
      'Calcula el Mínimo Común Múltiplo o el Máximo Común Divisor.\n\n'
          '• MCM: descompón los números en factores primos y coge los factores comunes y no comunes con el mayor exponente.\n'
          '• MCD: descompón los números y coge solo los factores comunes con el menor exponente.\n\n'
          'No los confundas: MCM siempre es ≥ que los números; MCD siempre es ≤.',
      'En la vida: sincronizar tiempos (cada 6 y 8 min → cada 24 min coinciden).',
    ),
    TipoFragmentoEnTejado.porcentajeCantidad: _Ayuda(
      'PORCENTAJE DE UNA CANTIDAD',
      'Calcula el porcentaje de una cantidad.\n\n'
          'Fórmula: (porcentaje × cantidad) ÷ 100\n\n'
          'Ejemplo: el 25% de 80 = (25 × 80) ÷ 100 = 2000 ÷ 100 = 20.',
      'En la vida: calcular el 15% de propina o el 21% de IVA.',
    ),
    TipoFragmentoEnTejado.porcentajeDe: _Ayuda(
      '¿QUÉ PORCENTAJE ES?',
      'Una cantidad es ¿qué porcentaje del total?\n\n'
          'Fórmula: (parte ÷ total) × 100\n\n'
          'Ejemplo: 12 de 50 → (12 ÷ 50) × 100 = 0,24 × 100 = 24%.',
      'En la vida: saber qué nota sacaste (12/14 → 85%).',
    ),
    TipoFragmentoEnTejado.aumentoDescuento: _Ayuda(
      'AUMENTOS Y DESCUENTOS',
      'Calcula el resultado tras aplicar un aumento o descuento porcentual.\n\n'
          '1. Calcula el porcentaje de la cantidad.\n'
          '2. Si es aumento → suma el resultado.\n'
          '   Si es descuento → resta el resultado.\n\n'
          'Ejemplo: aumenta un 15% sobre 200 → 15% de 200 = 30 → 200+30 = 230.',
      'En la vida: calcular rebajas (20% descuento) o subidas (10% aumento).',
    ),
    TipoFragmentoEnTejado.proporcional: _Ayuda(
      'PROPORCIONES',
      'Completa la proporción: a:b = c:?\n\n'
          'Dos ratios son proporcionales si el factor de escala es el mismo.\n'
          'Para encontrar el valor que falta: multiplica o divide por el mismo número ambos términos.',
      'En la vida: mantener la misma relación al ampliar una receta o un plano.',
    ),
    TipoFragmentoEnTejado.reglaDeTres: _Ayuda(
      'REGLAS DE TRES',
      'Si "a → b", entonces "c → ?"\n\n'
          'Fórmula: ? = (b × c) ÷ a\n\n'
          'Ejemplo: si 3 kg cuestan 12 €, 5 kg cuestan (12 × 5) ÷ 3 = 60 ÷ 3 = 20 €.',
      'En la vida: si 3 kg cuestan 12 €, ¿cuánto cuestan 5 kg?',
    ),
    TipoFragmentoEnTejado.razon: _Ayuda(
      'RAZÓN',
      'Elige la razón reducida que relaciona dos cantidades.\n\n'
          'Una razón compara dos cantidades. Se reduce dividiendo ambas entre el mismo número (el MCD).\n\n'
          'Ejemplo: 12 manzanas y 8 naranjas → 12:8 → dividiendo entre 4 → 3:2.',
      'En la vida: expresar relaciones (3:2 de manzanas a naranjas en una macedonia).',
    ),
    TipoFragmentoEnTejado.fraccionDeCantidad: _Ayuda(
      'FRACCIÓN DE UNA CANTIDAD',
      'Calcula la fracción de una cantidad.\n\n'
          'Fórmula: (cantidad ÷ denominador) × numerador\n\n'
          'Ejemplo: los 3/5 de 25 → (25 ÷ 5) × 3 = 5 × 3 = 15.',
      'En la vida: calcular los 3/5 de 25 € que te tocan en un reparto.',
    ),
    TipoFragmentoEnTejado.escala: _Ayuda(
      'ESCALA',
      'Aplica la escala y convierte las unidades.\n\n'
          'Escala 1:500 significa que 1 cm en el plano son 500 cm (5 m) en la realidad.\n\n'
          '1. Multiplica la medida del plano por el denominador de la escala.\n'
          '2. Convierte el resultado a la unidad que te pidan (cm → m ÷ 100).',
      'En la vida: leer mapas y planos (1 cm en el mapa = 500 cm reales).',
    ),
    TipoFragmentoEnTejado.lecturaFraccion: _Ayuda(
      'LEER FRACCIONES',
      'Lee el texto y elige la fracción correcta.\n\n'
          '"Tres quintos" → el numerador es 3 y el denominador es 5 → 3/5.\n\n'
          'Cuidado: no inviertas numerador y denominador.',
      'En la vida: entender "tres quintos" en una receta o un reparto.',
    ),
    TipoFragmentoEnTejado.lecturaDecimal: _Ayuda(
      'LEER DECIMALES',
      'Lee el texto y elige el decimal correcto.\n\n'
          '"Veinticinco centésimas" → 0,25\n'
          '"Tres décimas" → 0,3\n\n'
          'Cuidado con las cifras: décimas (1 cifra), centésimas (2 cifras).',
      'En la vida: entender cuando alguien dice "cero coma veinticinco".',
    ),
    TipoFragmentoEnTejado.redondeoDecimal: _Ayuda(
      'REDONDEAR DECIMALES',
      'Redondea el decimal a la décima.\n\n'
          'Para redondear a la décima, mira la centésima:\n'
          '• Si es 5 o más → la décima sube una.\n'
          '• Si es menos de 5 → la décima se queda igual.\n\n'
          'Ejemplo: 2,37 → la centésima es 7 ≥ 5 → 2,4.',
      'En la vida: dar un precio aproximado (2,37 € → 2,4 € al redondear).',
    ),
    TipoFragmentoEnTejado.ordenarDecimales: _Ayuda(
      'ORDENAR DECIMALES',
      'Ordena los decimales de menor a mayor.\n\n'
          'Compara cifra a cifra empezando por la izquierda.\n'
          'Más cifras NO significa más grande: 0,35 > 0,4? No, 0,4 = 0,40.',
      'En la vida: ordenar precios de menor a mayor sin confundirte.',
    ),
    TipoFragmentoEnTejado.ordenarFracciones: _Ayuda(
      'ORDENAR FRACCIONES',
      'Ordena las fracciones de menor a mayor.\n\n'
          'Conviértelas a decimal (numerador ÷ denominador) para compararlas.\n'
          'O multiplica en cruz para ver cuál es mayor.',
      'En la vida: ordenar medidas de ingredientes de menor a mayor.',
    ),
    TipoFragmentoEnTejado.impropio: _Ayuda(
      'IMPROPIA → MIXTA',
      'Convierte la fracción impropia en número mixto.\n\n'
          'Divide el numerador entre el denominador:\n'
          '  • el cociente es la parte entera\n'
          '  • el resto es el nuevo numerador\n'
          '  • el denominador se queda igual\n\n'
          'Ejemplo: 7/4 → 7÷4 = 1 y resto 3 → 1 y 3/4.',
      'En la vida: expresar 7/4 de pizza como "una pizza y tres cuartos".',
    ),
    TipoFragmentoEnTejado.mixtoAImpropio: _Ayuda(
      'MIXTO → IMPROPIA',
      'Convierte el número mixto en fracción impropia.\n\n'
          'Fórmula: (entero × denominador + numerador) / denominador\n\n'
          'Ejemplo: 2 y 3/4 → (2×4 + 3)/4 = (8+3)/4 = 11/4.',
      'En la vida: convertir "2 horas y media" a fracción para operar.',
    ),
    TipoFragmentoEnTejado.longitud: _Ayuda(
      'CONVERTIR LONGITUD',
      'Convierte entre unidades de longitud.\n\n'
          'La escalera métrica: km → hm → dam → m → dm → cm → mm\n'
          'Cada paso multiplica o divide por 10.\n\n'
          'Ejemplo: 5 m = ? cm → de m a cm son 2 pasos ×10 → 5×10×10 = 500 cm.',
      'En la vida: 5 m = 500 cm al medir una habitación o un mueble.',
    ),
    TipoFragmentoEnTejado.masaCapacidad: _Ayuda(
      'CONVERTIR MASA O CAPACIDAD',
      'Convierte entre unidades de masa (g) o capacidad (L).\n\n'
          'Misma escalera que longitud: cada paso ×10.\n\n'
          'Ejemplo: 3 kg = ? g → 3×10×10×10 = 3000 g.\n'
          'Ejemplo: 5 L = ? mL → 5×10×10×10 = 5000 mL.',
      'En la vida: 1 kg = 1000 g para una receta, o 1 L = 1000 mL.',
    ),
    TipoFragmentoEnTejado.superficie: _Ayuda(
      'CONVERTIR SUPERFICIE',
      'Convierte entre unidades de superficie (m², cm²…).\n\n'
          'Cada paso multiplica o divide por 100 (NO por 10).\n\n'
          'Ejemplo: 5 m² = ? cm² → 5×100×100 = 50.000 cm².\n'
          '¡Atento! Es fácil confundirlo con la longitud lineal (×10).',
      'En la vida: calcular 5 m² en cm² para comprar baldosas.',
    ),
    TipoFragmentoEnTejado.tiempo: _Ayuda(
      'CONVERTIR TIEMPO',
      'Convierte entre horas, minutos y segundos.\n\n'
          'El tiempo NO es decimal, es sexagesimal (base 60):\n'
          '  1 hora = 60 minutos\n'
          '  1 minuto = 60 segundos\n\n'
          'Ejemplo: 2 h y 30 min = 2×60 + 30 = 150 min (NO 230).',
      'En la vida: 2 h y 30 min = 150 min (no 230). Útil para planificar.',
    ),
    TipoFragmentoEnTejado.angulo: _Ayuda(
      'CLASIFICAR ÁNGULOS',
      'Elige el nombre del ángulo según su abertura.\n\n'
          '• Agudo: menos de 90°\n'
          '• Recto: exactamente 90°\n'
          '• Obtuso: más de 90° y menos de 180°\n'
          '• Llano: exactamente 180°',
      'En la vida: identificar si una esquina es recta (90°) para muebles.',
    ),
    TipoFragmentoEnTejado.poligono: _Ayuda(
      'NOMBRAR POLÍGONOS',
      'Elige el nombre del polígono según su número de lados.\n\n'
          '• 3 lados → triángulo\n'
          '• 4 lados → cuadrado (o rectángulo)\n'
          '• 5 lados → pentágono\n'
          '• 6 lados → hexágono\n'
          '• 7 lados → heptágono\n'
          '• 8 lados → octágono',
      'En la vida: reconocer formas en señales, mosaicos y construcciones.',
    ),
    TipoFragmentoEnTejado.perimetro: _Ayuda(
      'PERÍMETRO',
      'Calcula el perímetro del polígono.\n\n'
          'El perímetro es la suma de todos los lados.\n\n'
          'En un rectángulo: P = 2 × (base + altura).\n'
          'En un polígono regular: P = lado × número de lados.',
      'En la vida: cuánta valla necesitas para cercar un terreno o un jardín.',
    ),
    TipoFragmentoEnTejado.areaRectangulo: _Ayuda(
      'ÁREA DEL RECTÁNGULO',
      'Calcula el área del rectángulo.\n\n'
          'Fórmula: Área = base × altura\n\n'
          'No lo confundas con el perímetro (que suma los lados).',
      'En la vida: calcular la superficie de una habitación para poner suelo.',
    ),
    TipoFragmentoEnTejado.areaTriangulo: _Ayuda(
      'ÁREA DEL TRIÁNGULO',
      'Calcula el área del triángulo.\n\n'
          'Fórmula: Área = (base × altura) ÷ 2\n\n'
          '¡No olvides dividir entre 2!',
      'En la vida: calcular el área de un tejado o un panel solar triangular.',
    ),
    TipoFragmentoEnTejado.circulo: _Ayuda(
      'CÍRCULO: ÁREA Y PERÍMETRO',
      'Calcula el área o el perímetro del círculo.\n\n'
          'Usa π ≈ 3,14.\n\n'
          '• Perímetro (circunferencia) = 2 × π × radio\n'
          '• Área = π × radio²\n\n'
          'No las confundas: el perímetro mide el borde, el área mide el interior.',
      'En la vida: calcular la superficie de una mesa redonda o su borde.',
    ),
    TipoFragmentoEnTejado.volumen: _Ayuda(
      'VOLUMEN DEL ORTOEDRO',
      'Calcula el volumen de la caja.\n\n'
          'Fórmula: Volumen = largo × ancho × alto\n\n'
          'No lo confundas con el área superficial (que suma todas las caras).',
      'En la vida: cuántos litros caben en una pecera o una caja.',
    ),
    TipoFragmentoEnTejado.simetria: _Ayuda(
      'SIMETRÍA AXIAL',
      '¿La figura es simétrica respecto al eje marcado?\n\n'
          'Una figura es simétrica si al doblarla por el eje, las dos mitades coinciden exactamente.\n\n'
          'Imagina un espejo en la línea. ¿El reflejo sería idéntico?',
      'En la vida: reconocer formas simétricas en la naturaleza y el arte.',
    ),
    TipoFragmentoEnTejado.graficoBarras: _Ayuda(
      'GRÁFICO DE BARRAS',
      'Lee el valor en el gráfico de barras.\n\n'
          'Mira la altura de la barra señalada y compárala con los números del eje vertical.\n'
          'Si te piden el total, suma todas las barras.',
      'En la vida: leer datos en periódicos, informes y estadísticas.',
    ),
    TipoFragmentoEnTejado.graficoCircular: _Ayuda(
      'GRÁFICO CIRCULAR',
      'Lee el porcentaje de la porción señalada.\n\n'
          'El círculo entero representa el 100%. Cada porción es una parte.\n'
          'Fíjate en el tamaño de la porción respecto al círculo completo.',
      'En la vida: entender porcentajes visuales en encuestas y resultados.',
    ),
    TipoFragmentoEnTejado.media: _Ayuda(
      'MEDIA ARITMÉTICA',
      'Calcula la media de los números.\n\n'
          'Fórmula: (suma de todos los números) ÷ (cantidad de números)\n\n'
          '1. Suma todos los números.\n'
          '2. Divide entre cuántos números hay.',
      'En la vida: calcular la nota media o el gasto promedio por día.',
    ),
    TipoFragmentoEnTejado.modaMediana: _Ayuda(
      'MODA Y MEDIANA',
      'Calcula la moda o la mediana.\n\n'
          '• Moda: el número que más se repite.\n'
          '• Mediana: ordena los números y elige el del centro. Si hay dos, haz la media.',
      'En la vida: entender qué talla es la más común (moda) o el salario típico (mediana).',
    ),
    TipoFragmentoEnTejado.probabilidad: _Ayuda(
      'PROBABILIDAD',
      'Calcula la probabilidad como fracción.\n\n'
          'Fórmula: P = (casos favorables) / (casos totales)\n\n'
          'Ejemplo: en una bolsa con 3 bolas rojas y 5 azules,\n'
          'P(roja) = 3/8. Simplifica si puedes.',
      'En la vida: calcular la probabilidad de que llueva o de ganar un juego.',
    ),
    TipoFragmentoEnTejado.probabilidadPorcentaje: _Ayuda(
      'PROBABILIDAD → PORCENTAJE',
      'Convierte la probabilidad de fracción a porcentaje.\n\n'
          'Fórmula: (numerador ÷ denominador) × 100\n\n'
          'Ejemplo: P = 3/4 → (3÷4)×100 = 0,75×100 = 75%.',
      'En la vida: expresar "3 de cada 4" como 75% de probabilidad.',
    ),
    TipoFragmentoEnTejado.sumaBasica: _Ayuda(
      'SUMA BÁSICA',
      'Suma los dos números.\n\n'
          'Si necesitas, puedes usar los dedos o hacer la suma en tu cabeza.\n'
          'Es la operación más básica. Tómate tu tiempo.',
      'En la vida: contar dinero, sumar objetos, calcular el total de una compra pequeña.',
    ),
    TipoFragmentoEnTejado.ecuacionLineal: _Ayuda(
      'ECUACIÓN LINEAL',
      'Encuentra el valor de x.\n\n'
          'Para despejar x, pasa los números al otro lado del signo =:\n'
          '  • si están sumando → pasan restando\n'
          '  • si están restando → pasan sumando\n'
          '  • si están multiplicando → pasan dividiendo\n\n'
          'Ejemplo: x + 5 = 12 → x = 12 - 5 → x = 7.',
      'En la vida: calcular cuánto tiempo falta para ahorrar suficiente dinero.',
    ),
    TipoFragmentoEnTejado.potenciaNatural: _Ayuda(
      'POTENCIAS',
      'Calcula la potencia.\n\n'
          'aⁿ = a × a × a … (n veces)\n\n'
          'Ejemplo: 2³ = 2 × 2 × 2 = 8.\n\n'
          '¡Cuidado! No multipliques base × exponente (2³ ≠ 2×3).',
      'En la vida: calcular áreas (3² = 9) o crecimiento exponencial (doblar cada día).',
    ),
    TipoFragmentoEnTejado.raizCuadrada: _Ayuda(
      'RAÍZ CUADRADA',
      'Calcula la raíz cuadrada.\n\n'
          '√x es el número que multiplicado por sí mismo da x.\n\n'
          'Ejemplo: √25 = 5 porque 5 × 5 = 25.\n\n'
          'Pista: aprende los cuadrados perfectos (1, 4, 9, 16, 25, 36…).',
      'En la vida: calcular el lado de un cuadrado a partir de su área.',
    ),
    TipoFragmentoEnTejado.pitagoras: _Ayuda(
      'TEOREMA DE PITÁGORAS',
      'En un triángulo rectángulo:\n\n'
          'hipotenusa² = cateto₁² + cateto₂²\n\n'
          'Identifica primero la hipotenusa (el lado más largo, frente al ángulo recto).\n'
          'Después aplica la fórmula.',
      'En la vida: calcular la altura de una escalera apoyada en la pared.',
    ),
    TipoFragmentoEnTejado.ecuacionAmbosLados: _Ayuda(
      'ECUACIÓN EN AMBOS LADOS',
      'La incógnita está en los dos lados de la ecuación.\n\n'
          '1. Agrupa las x en un lado (pásalas todas a la izquierda).\n'
          '2. Agrupa los números en el otro lado.\n'
          '3. Despeja x.',
      'En la vida: resolver problemas donde la incógnita aparece dos veces.',
    ),
    TipoFragmentoEnTejado.enteroSigno: _Ayuda(
      'ENTEROS CON SIGNO',
      'Opera con números enteros que pueden tener signo negativo.\n\n'
          'Recuerda: -(-3) = +3  y  -3 × -2 = +6\n'
          '          -3 + (-2) = -5  y  -3 - (-2) = -1\n\n'
          'Dos negativos seguidos se convierten en positivo.',
      'En la vida: temperaturas bajo cero, deber dinero, profundidad marina.',
    ),
    TipoFragmentoEnTejado.valorAbsoluto: _Ayuda(
      'VALOR ABSOLUTO',
      'El valor absoluto de un número es su distancia hasta el 0.\n\n'
          '|5| = 5 y |-5| = 5 — ambos están a 5 unidades del 0.\n\n'
          'El valor absoluto siempre es positivo o cero.',
      'En la vida: medir distancia entre dos puntos (da igual la dirección).',
    ),
    TipoFragmentoEnTejado.sistemaDosXDos: _Ayuda(
      'SISTEMA DE ECUACIONES',
      'Resuelve el sistema de dos ecuaciones.\n\n'
          'Método de sustitución:\n'
          '1. Despeja una incógnita en una ecuación.\n'
          '2. Sustitúyela en la otra ecuación.\n'
          '3. Resuelve la ecuación de una incógnita.\n'
          '4. Calcula la otra incógnita.',
      'En la vida: calcular dos cosas a la vez (precio de una manzana y una naranja).',
    ),
    TipoFragmentoEnTejado.relacionLineal: _Ayuda(
      'RELACIÓN LINEAL',
      'Encuentra la regla que relaciona los datos.\n\n'
          'Una relación lineal es de la forma y = mx + n.\n'
          '  • m es la pendiente (cuánto sube y cuando x aumenta 1).\n'
          '  • n es el valor de y cuando x = 0.\n\n'
          'Busca el patrón: ¿cuánto cambia y cada vez que x cambia 1?',
      'En la vida: calcular cuánto pagas según los kWh consumidos.',
    ),
  };

  /// Devuelve el título y la explicación para un tipo de puzzle.
  /// Si no hay ayuda registrada, devuelve un texto genérico.
  static (String titulo, String texto, String transferencia) paraTipo(
      TipoFragmentoEnTejado tipo) {
    final ayuda = _ayudas[tipo];
    if (ayuda != null) return (ayuda.titulo, ayuda.texto, ayuda.transferencia);
    return ('Puzzle', 'Resuelve el puzzle usando lo que has aprendido.', '');
  }
}

class _Ayuda {
  final String titulo;
  final String texto;
  final String transferencia;
  const _Ayuda(this.titulo, this.texto, this.transferencia);
}
