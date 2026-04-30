<?php
/**
 * Orquestador del Tutor de El Cuaderno (doc 03 §6 + doc 04 §3).
 *
 * Coordina prompt versionado + Anthropic + filtro de salida. El
 * cliente HTTP a Anthropic se inyecta como callable opcional (mismo
 * patrón que NS_Tutor de Uno Roto y NS_Companion_Agregados) para que
 * los tests no toquen la red.
 *
 * Cuota: el código declara el contrato (30/día, 200/semana) pero la
 * persistencia de contadores requiere una migración M004 que crea
 * `wp_ns_el_cuaderno_tutor_quota`. Hasta entonces, las llamadas a
 * `verificar_cuota` devuelven siempre OK con un TODO marcado.
 *
 * @package NuevoSerCore
 */

if ( ! defined( 'ABSPATH' ) && ! defined( 'NS_TEST_STANDALONE' ) ) {
	exit;
}

require_once __DIR__ . '/class-ns-prompt-cuaderno.php';
require_once __DIR__ . '/class-ns-filtro-cuaderno.php';

final class NS_Tutor_Cuaderno {

	const TURNOS_MAX_DIA    = 30;
	const TURNOS_MAX_SEMANA = 200;

	/**
	 * Procesa una pregunta del niño y devuelve la respuesta filtrada,
	 * con metadatos sobre el filtro aplicado. Salida:
	 *
	 *   array{
	 *     respuesta: string,        // texto que se muestra al niño
	 *     prompt_version: string,   // versión del system prompt usado
	 *     filtro: string,           // 'aceptada' | 'regenerada' |
	 *                               // 'reemplazada_canonico' |
	 *                               // 'fallback_filtrado'
	 *   }
	 *
	 * Estrategia de regeneración: si la primera respuesta cae en
	 * "regenerar", se hace un segundo intento. Si el segundo también
	 * cae en regenerar, se devuelve el fallback canónico filtrado.
	 *
	 * @param callable|null $cliente_anthropic Función con la firma
	 *      `function (string $system, string $pregunta): string`.
	 *      Si null, se usa NS_Anthropic. Inyectable para tests.
	 *
	 * @throws RuntimeException si el cliente subyacente falla y no
	 *      hay forma de devolver respuesta.
	 *
	 * @param string              $idioma   Código de idioma del niño.
	 * @param string              $pregunta Texto del niño (1..1000 chars).
	 * @param array<string,mixed> $contexto Hash con campos del prompt.
	 * @return array{respuesta:string,prompt_version:string,filtro:string}
	 */
	public static function responder(
		string $idioma,
		string $pregunta,
		array $contexto = array(),
		?callable $cliente_anthropic = null
	): array {
		$pregunta_limpia = trim( $pregunta );
		if ( '' === $pregunta_limpia ) {
			throw new InvalidArgumentException( 'pregunta vacía' );
		}
		if ( strlen( $pregunta_limpia ) > 1000 ) {
			throw new InvalidArgumentException( 'pregunta demasiado larga (>1000 chars)' );
		}

		$cliente = $cliente_anthropic ?? array( 'NS_Anthropic', 'pedir_explicacion' );
		$system  = NS_Prompt_Cuaderno::construir( $idioma, $contexto );

		// Primer intento.
		$respuesta = self::invocar( $cliente, $system, $pregunta_limpia );
		$revision  = NS_Filtro_Cuaderno::revisar( $respuesta );

		if ( 'aceptada' === $revision['estado'] ) {
			return self::resultado( $respuesta, 'aceptada' );
		}
		if ( 'reemplazar_canonico' === $revision['estado'] ) {
			return self::resultado(
				NS_Prompt_Cuaderno::fallback_fuera_de_oficio( $idioma ),
				'reemplazada_canonico'
			);
		}

		// Vocabulario prohibido → un reintento. Adjuntamos al system
		// prompt la nota de que el intento anterior no respetaba la
		// voz, así el modelo evita el mismo patrón.
		$system_segundo = $system . "\n\nNota interna: tu respuesta anterior contenía vocabulario prohibido (\"" .
			(string) $revision['patron'] . "\"). Reescribe respetando la voz del Tutor.";
		$segunda  = self::invocar( $cliente, $system_segundo, $pregunta_limpia );
		$revision = NS_Filtro_Cuaderno::revisar( $segunda );

		if ( 'aceptada' === $revision['estado'] ) {
			return self::resultado( $segunda, 'regenerada' );
		}
		if ( 'reemplazar_canonico' === $revision['estado'] ) {
			return self::resultado(
				NS_Prompt_Cuaderno::fallback_fuera_de_oficio( $idioma ),
				'reemplazada_canonico'
			);
		}

		// Sigue en regenerar tras dos intentos: fallback canónico.
		return self::resultado(
			NS_Prompt_Cuaderno::fallback_filtrado( $idioma ),
			'fallback_filtrado'
		);
	}

	/**
	 * Verifica la cuota del niño antes de aceptar el turno. **Stub**
	 * de v1: devuelve siempre OK con TODO. La persistencia requiere
	 * migración M004 que crea `wp_ns_el_cuaderno_tutor_quota` con
	 * (user_id, fecha, turnos_dia, turnos_semana).
	 *
	 * Cuando se implemente, devolverá:
	 *   array{permitido:bool, turnos_dia:int, turnos_semana:int, motivo:?string}
	 *
	 * @return array{permitido:bool,turnos_dia:int,turnos_semana:int,motivo:?string}
	 */
	public static function verificar_cuota( int $nino_id ): array {
		// TODO #11 (memoria decisiones_humanas_pendientes): no hay tabla
		// de cuota todavía — esta función necesita migración M004 antes
		// de poder enforce los límites del doc 03 §6.5. Hasta entonces,
		// permitimos todos los turnos para no bloquear el flujo en el
		// piloto.
		unset( $nino_id );
		return array(
			'permitido'     => true,
			'turnos_dia'    => 0,
			'turnos_semana' => 0,
			'motivo'        => null,
		);
	}

	private static function invocar( callable $cliente, string $system, string $pregunta ): string {
		// El cliente puede ser:
		//   - NS_Anthropic::pedir_explicacion (firma:
		//     pedir_explicacion(id_habilidad, pregunta, contexto_fragmento))
		//     que NO toma system prompt — está fijado dentro de
		//     NS_Anthropic. Para mantener compatibilidad mientras llega
		//     el método específico para Tutor del Cuaderno, lo invocamos
		//     pasando "el-cuaderno" como id_habilidad y el system como
		//     contexto_fragmento.
		//   - Cualquier callable de tests con firma libre — se le pasa
		//     ($system, $pregunta) y se espera string.
		$reflexion = self::reflexion_callable( $cliente );
		$num_args  = $reflexion->getNumberOfParameters();

		if ( $num_args >= 3 ) {
			// Firma compatible con NS_Anthropic::pedir_explicacion.
			return (string) call_user_func( $cliente, 'el-cuaderno', $pregunta, $system );
		}
		// Firma simple ($system, $pregunta) o ($pregunta).
		if ( 2 === $num_args ) {
			return (string) call_user_func( $cliente, $system, $pregunta );
		}
		return (string) call_user_func( $cliente, $pregunta );
	}

	private static function reflexion_callable( callable $cliente ): ReflectionFunctionAbstract {
		if ( is_array( $cliente ) ) {
			return new ReflectionMethod( $cliente[0], $cliente[1] );
		}
		if ( is_string( $cliente ) && false !== strpos( $cliente, '::' ) ) {
			list($clase, $metodo) = explode( '::', $cliente, 2 );
			return new ReflectionMethod( $clase, $metodo );
		}
		if ( $cliente instanceof Closure || is_string( $cliente ) ) {
			return new ReflectionFunction( $cliente );
		}
		// Objeto invocable.
		return new ReflectionMethod( $cliente, '__invoke' );
	}

	private static function resultado( string $respuesta, string $filtro ): array {
		return array(
			'respuesta'      => $respuesta,
			'prompt_version' => NS_Prompt_Cuaderno::VERSION,
			'filtro'         => $filtro,
		);
	}
}
