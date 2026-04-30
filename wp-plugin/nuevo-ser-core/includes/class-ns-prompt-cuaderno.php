<?php
/**
 * Prompt versionado del Tutor de El Cuaderno (doc 03 §6.2 + doc 04 §3).
 *
 * Vive server-side. El cliente NUNCA construye el prompt — solo manda
 * la pregunta del niño + contexto declarado (idioma, edad, región,
 * estación, skill relacionada). Esto preserva el principio del doc:
 * "el prompt no es editable por cliente" — un dispositivo
 * comprometido no puede saltarse las reglas (vocabulario prohibido,
 * alcance de oficio) reescribiendo el system message.
 *
 * Versionado: la constante `VERSION` cambia cuando el prompt cambia.
 * Eso permite (en el futuro) cachear respuestas frecuentes asociadas
 * a la versión del prompt — al cambiar el prompt, las respuestas
 * caché viejas se invalidan automáticamente.
 *
 * @package NuevoSerCore
 */

if ( ! defined( 'ABSPATH' ) && ! defined( 'NS_TEST_STANDALONE' ) ) {
	exit;
}

final class NS_Prompt_Cuaderno {

	/**
	 * Versión del prompt. Bumpear cuando se cambie cualquier parte
	 * del system message (texto, ejemplos, reglas). El cliente Dart
	 * almacena esta cadena junto a la respuesta cacheada.
	 */
	const VERSION = 'cuaderno-v1-2026-04-30';

	/**
	 * Idiomas soportados. Cualquier otro fallbackea a 'es'.
	 */
	private const IDIOMAS = array( 'es', 'eu', 'ca' );

	/**
	 * Construye el system prompt para una conversación. Devuelve
	 * exactamente la cadena que va en el campo `system` de Anthropic.
	 *
	 * Contexto opcional — los huecos no rellenados desaparecen del
	 * bloque "Contexto" sin dejar líneas vacías:
	 *
	 *   - edad (int)
	 *   - region_code (string NUTS)
	 *   - season (otono|invierno|primavera|verano|todo_el_anio)
	 *   - skill_id (string del catálogo de El Cuaderno)
	 *   - nivel_skill (int 0-4)
	 *   - observacion_adjunta (string libre — qué viste, qué crees que es)
	 *
	 * @param string               $idioma   Código de idioma del niño.
	 * @param array<string,mixed>  $contexto Hash con los campos arriba.
	 */
	public static function construir( string $idioma, array $contexto = array() ): string {
		$idioma_efectivo = in_array( $idioma, self::IDIOMAS, true ) ? $idioma : 'es';

		$base = self::texto_base( $idioma_efectivo );
		$ctx  = self::bloque_contexto( $contexto );

		if ( '' === $ctx ) {
			return $base;
		}
		return $base . "\n\n" . $ctx;
	}

	/**
	 * Mensaje canónico de fallback — se devuelve al niño cuando el
	 * filtro de salida rechaza la respuesta del modelo y la regeneración
	 * vuelve a fallar (doc 03 §6.4). Idéntico siempre, idioma del niño.
	 */
	public static function fallback_filtrado( string $idioma ): string {
		switch ( $idioma ) {
			case 'eu':
				return 'Une honetan ezin dizut hau erantzun. Saiatu beste modu batera galdetzen.';
			case 'ca':
				return 'Ara mateix no et puc respondre això. Prova a preguntar-ho d\'una altra manera.';
			case 'es':
			default:
				return 'Ahora mismo no puedo responder a eso. Prueba a preguntarlo de otra manera.';
		}
	}

	/**
	 * Mensaje canónico de fuera de oficio (doc 04 §3.2). Se usa cuando
	 * el filtro detecta contenido fuera del alcance del juego.
	 */
	public static function fallback_fuera_de_oficio( string $idioma ): string {
		switch ( $idioma ) {
			case 'eu':
				return 'Hori ez dago nire eskuragarri. Saiatu zure etxean galdetzen.';
			case 'ca':
				return 'Això queda fora del que puc ajudar. Prova de preguntar-ho a algú de casa.';
			case 'es':
			default:
				return 'Eso queda fuera de lo que puedo ayudar. Prueba a preguntárselo a alguien de tu casa.';
		}
	}

	private static function texto_base( string $idioma ): string {
		// El system prompt vive en castellano. Indicamos al modelo en
		// qué idioma responder dentro del propio cuerpo. Mantener el
		// system prompt en una sola lengua simplifica las reglas y
		// evita que un cambio de copia se haga solo en uno de los tres
		// idiomas. Las reglas son universales.
		$reglas = self::reglas_oficio();
		$idioma_humano = self::idioma_humano( $idioma );
		return <<<PROMPT
Eres el Tutor de El Cuaderno. Hablas como bióloga competente que enseña a una aprendiza naturalista. Vives en el oficio de la observación de campo.

Tu trabajo es responder dudas sobre observación, identificación, ciclos, hábitats, técnicas de campo y uso de claves dicotómicas. Nada más.

Reglas estrictas (doc 04 §3.2):

{$reglas}

Idioma de la respuesta: {$idioma_humano}. La respuesta debe ser breve — entre 2 y 5 frases. Cada frase concreta.

Si no sabes, di "No lo sé" sin disimular. Si sabes parcialmente, di qué sabes y qué no. Está prohibido confabular hechos biológicos.

Si la conversación se aleja del oficio (religión, política, relaciones personales del niño, deberes escolares ajenos al cuaderno), respondes exactamente: "Eso queda fuera de lo que puedo ayudar. Prueba a preguntárselo a alguien de tu casa." y nada más.

Cuando un niño identifica algo correctamente, confirmas seco: "Limonera. Coincide con la clave." sin celebración. Cuando identifica mal, no descalificas — preguntas para redirigir: "Mira otra vez. ¿Las antenas tienen la punta blanca?"

Conocimiento limitado: tú no has caminado por el sit spot del niño. Si un dato depende del lugar concreto, dilo: "No lo sé desde aquí; mira tú." o equivalente.
PROMPT;
	}

	private static function reglas_oficio(): string {
		// Lista de reglas en orden estable. Se enseñan al modelo en
		// vez de filtrar 100% server-side porque la prevención dentro
		// del prompt reduce la tasa de regeneraciones.
		$reglas = array(
			'Solo respondes sobre el oficio del juego.',
			'Sin elogios efusivos, sin animación motivacional, sin jerga de gamificación.',
			'Sin apelativos cariñosos: nada de "cariño", "campeón", "peque", "amiguito".',
			'Sin juicios estéticos: no digas "qué bonito", "qué maravilloso", "la naturaleza es asombrosa".',
			'Sin moralización: no digas "es importante cuidar el planeta", "los animales necesitan...".',
			'Sin presentarte como amiga: no digas "a mí me encantan", no expreses emociones propias.',
			'Sin retener al niño: si la conversación se alarga sin sustancia, sugiere cierre con "Esto ya lo tienes. Vuelve al cuaderno."',
		);
		$lineas = array();
		foreach ( $reglas as $i => $regla ) {
			$lineas[] = ( $i + 1 ) . '. ' . $regla;
		}
		return implode( "\n", $lineas );
	}

	private static function bloque_contexto( array $contexto ): string {
		$lineas = array();
		if ( ! empty( $contexto['edad'] ) ) {
			$lineas[] = 'Edad de la aprendiza: ' . (int) $contexto['edad'] . ' años.';
		}
		if ( ! empty( $contexto['region_code'] ) ) {
			$lineas[] = 'Región (NUTS): ' . (string) $contexto['region_code'] . '.';
		}
		if ( ! empty( $contexto['season'] ) ) {
			$lineas[] = 'Estación actual: ' . (string) $contexto['season'] . '.';
		}
		if ( ! empty( $contexto['skill_id'] ) ) {
			$skill = (string) $contexto['skill_id'];
			if ( isset( $contexto['nivel_skill'] ) ) {
				$nivel = (int) $contexto['nivel_skill'];
				$lineas[] = "Habilidad relacionada: {$skill} (nivel {$nivel}).";
			} else {
				$lineas[] = "Habilidad relacionada: {$skill}.";
			}
		}
		if ( ! empty( $contexto['observacion_adjunta'] ) ) {
			$obs = (string) $contexto['observacion_adjunta'];
			// Limita a 500 chars para evitar prompt injection desde un
			// texto largo que el niño hubiera pegado.
			if ( strlen( $obs ) > 500 ) {
				$obs = substr( $obs, 0, 500 ) . '…';
			}
			$lineas[] = 'Observación adjunta del niño: "' . $obs . '"';
		}
		if ( empty( $lineas ) ) {
			return '';
		}
		return "Contexto:\n- " . implode( "\n- ", $lineas );
	}

	private static function idioma_humano( string $codigo ): string {
		switch ( $codigo ) {
			case 'eu':
				return 'euskara';
			case 'ca':
				return 'català';
			case 'es':
			default:
				return 'castellano';
		}
	}
}
