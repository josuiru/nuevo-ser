<?php
/**
 * Filtro de salida del Tutor de El Cuaderno (doc 03 §6.4 + doc 04 §2.3).
 *
 * Tras recibir la respuesta del modelo, antes de devolverla al niño
 * el orquestador la pasa por este filtro. La lista negra del
 * vocabulario prohibido es **estructural** — el doc 04 §2.3 lo declara
 * irrenunciable. Que el modelo lo respete por sí solo (vía system
 * prompt) es ideal pero no suficiente; este filtro es la red de
 * seguridad si el modelo se sale del oficio.
 *
 * La salida es una de tres rutas:
 *   - aceptada: el texto pasa al niño tal cual.
 *   - regenerar: el texto contiene vocabulario prohibido o estilo
 *                fuera de la voz; el orquestador puede pedir una
 *                segunda generación al modelo.
 *   - reemplazar_con_canónico: el texto toca temas fuera de oficio
 *                (religión, política, relaciones personales). Se
 *                sustituye por el mensaje canónico §3.2.
 *
 * @package NuevoSerCore
 */

if ( ! defined( 'ABSPATH' ) && ! defined( 'NS_TEST_STANDALONE' ) ) {
	exit;
}

final class NS_Filtro_Cuaderno {

	/**
	 * Lista negra del doc 04 §2.3. Los patrones se aplican
	 * case-insensitive con \b para no fallar por puntuación. La regla
	 * pedagógica del doc es estricta: cualquier acercamiento a estos
	 * patrones rompe la voz del Tutor.
	 *
	 * @return array<int,string>
	 */
	public static function lista_negra_vocabulario(): array {
		return array(
			// Elogios efusivos.
			'felicidades',
			'felicitaciones',
			'bien hecho',
			'genial',
			'muy bien',
			'perfecto',
			'excelente',
			'fantástico',
			'fantastico',
			'increíble',
			'increible',
			'maravilloso',
			'asombroso',
			// Animación motivacional.
			'a por ello',
			'no te rindas',
			'tú puedes',
			'tu puedes',
			'¡vamos!',
			'sigue así',
			'sigue asi',
			// Jerga de gamificación.
			'nivel completado',
			'has desbloqueado',
			'enhorabuena',
			'puntos extra',
			'logro',
			// Apelativos cariñosos (al niño).
			'cariño',
			'carino',
			'campeón',
			'campeon',
			'campeona',
			'peque',
			'amiguito',
			'amiguita',
			// Juicios estéticos.
			'qué bonito',
			'que bonito',
			'qué maravilloso',
			'que maravilloso',
			'la naturaleza es maravillosa',
			'la naturaleza es asombrosa',
			'qué hermoso',
			'que hermoso',
			// Apelaciones moralizantes.
			'es importante cuidar el planeta',
			'cuida el planeta',
			'los animales necesitan',
			'debemos proteger',
			// "Casi lo tienes" / referencias a logro.
			'casi lo tienes',
			'casi lo conseguiste',
			'lo has conseguido',
			'lo conseguiste',
		);
	}

	/**
	 * Patrones que sugieren contenido fuera del oficio. Heurística
	 * conservadora — falsos positivos preferibles a dejar pasar
	 * conversaciones sobre temas que el Tutor no debe tocar (doc 04
	 * §3.2).
	 *
	 * @return array<int,string>
	 */
	public static function patrones_fuera_de_oficio(): array {
		return array(
			'dios',
			'religión',
			'religion',
			'oraci(ó|o)n',
			'pol(í|i)tica',
			'gobierno',
			'partido pol(í|i)tico',
			'guerra',
			'novio',
			'novia',
			'pareja',
			'amor',
			'beso',
			'mam(á|a) o pap(á|a)', // separación, divorcio
		);
	}

	/**
	 * Revisa la respuesta del modelo. Devuelve un array asociativo:
	 *   - estado: 'aceptada' | 'regenerar' | 'reemplazar_canonico'
	 *   - motivo: explicación legible (string vacío si aceptada)
	 *   - patron: el patrón concreto que ha disparado la regla (o null)
	 *
	 * @return array{estado:string,motivo:string,patron:?string}
	 */
	public static function revisar( string $respuesta ): array {
		$texto = strtolower( $respuesta );

		// 1) Fuera de oficio — sustitución directa por canónico, sin
		//    regeneración. El doc 04 §3.2 deja claro que la respuesta
		//    a estos casos es siempre la misma línea.
		foreach ( self::patrones_fuera_de_oficio() as $patron ) {
			if ( preg_match( '/\b(' . $patron . ')\b/u', $texto ) ) {
				return array(
					'estado' => 'reemplazar_canonico',
					'motivo' => 'fuera de oficio',
					'patron' => $patron,
				);
			}
		}

		// 2) Vocabulario prohibido — regeneración (max 1 reintento en
		//    el orquestador). Búsqueda como subcadena para tolerar
		//    puntuación adyacente.
		foreach ( self::lista_negra_vocabulario() as $patron ) {
			if ( strpos( $texto, $patron ) !== false ) {
				return array(
					'estado' => 'regenerar',
					'motivo' => 'vocabulario prohibido',
					'patron' => $patron,
				);
			}
		}

		// 3) Sospecha de confabulación: nombres científicos (cursiva
		//    Linné) sin contexto. La heurística es muy ligera —
		//    palabras como "Turdus merula" o "Erithacus rubecula"
		//    aparecen "Genus species" en formato latino. No bloqueamos,
		//    el orquestador puede decidir regenerar o suavizar
		//    explícitamente.
		// (Sin acción aquí en v1 — solo lo declaramos para el futuro.)

		return array(
			'estado' => 'aceptada',
			'motivo' => '',
			'patron' => null,
		);
	}

	/**
	 * Detecta si la respuesta menciona nombres científicos sin contexto.
	 * Útil como señal de aviso (no de bloqueo): el orquestador puede
	 * añadir un sufijo "según conocimiento general; consulta una clave
	 * local" si lo prefiere.
	 */
	public static function tiene_nombre_cientifico( string $respuesta ): bool {
		// Genus species: una palabra Capitalizada + una en minúsculas,
		// ambas latín-like (sin tildes).
		return (bool) preg_match(
			'/\b[A-Z][a-z]{2,}\s+[a-z]{2,}\b/u',
			$respuesta
		);
	}
}
