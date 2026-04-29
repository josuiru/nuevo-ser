<?php
/**
 * Cliente HTTP del API de Anthropic. Encapsulado aparte del orquestador
 * para que los tests puedan stubearlo y para que migrar a otro proveedor
 * solo requiera tocar este archivo.
 *
 * Doc 03 §9: modelo barato (haiku), explicaciones cortas, system prompt
 * que limita el alcance al MVP. La key se lee de `NS_ANTHROPIC_KEY`
 * (definida en wp-config.php) — fallar al no estar definida es
 * preferible a que el plugin envíe peticiones sin auth.
 *
 * @package NuevoSerCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class NS_Anthropic {

	private const ENDPOINT      = 'https://api.anthropic.com/v1/messages';
	private const VERSION_API   = '2023-06-01';
	private const MODELO_DEFECTO = 'claude-haiku-4-5';
	private const MAX_TOKENS    = 400;

	/**
	 * Pide una explicación al modelo. Devuelve el texto crudo (todavía
	 * sin pasar por el filtro de salida — eso lo hace el orquestador).
	 *
	 * @throws RuntimeException Si la API no devuelve 200 o el formato
	 *                          de la respuesta es inesperado.
	 */
	public static function pedir_explicacion(
		string $id_habilidad,
		string $pregunta,
		?string $contexto_fragmento = null
	): string {
		if ( ! defined( 'NS_ANTHROPIC_KEY' ) || '' === NS_ANTHROPIC_KEY ) {
			throw new RuntimeException( 'NS_ANTHROPIC_KEY no definida en wp-config.php.' );
		}

		$prompt_sistema = self::construir_prompt_sistema( $id_habilidad, $contexto_fragmento );

		$cuerpo = wp_json_encode(
			array(
				'model'      => self::MODELO_DEFECTO,
				'max_tokens' => self::MAX_TOKENS,
				'system'     => $prompt_sistema,
				'messages'   => array(
					array(
						'role'    => 'user',
						'content' => $pregunta,
					),
				),
			)
		);

		$respuesta = wp_remote_post(
			self::ENDPOINT,
			array(
				'headers' => array(
					'Content-Type'      => 'application/json',
					'x-api-key'         => NS_ANTHROPIC_KEY,
					'anthropic-version' => self::VERSION_API,
				),
				'body'    => $cuerpo,
				'timeout' => 20,
			)
		);

		if ( is_wp_error( $respuesta ) ) {
			throw new RuntimeException( 'Error de red: ' . $respuesta->get_error_message() );
		}
		$codigo = (int) wp_remote_retrieve_response_code( $respuesta );
		$body   = wp_remote_retrieve_body( $respuesta );
		if ( 200 !== $codigo ) {
			throw new RuntimeException( "Anthropic devolvió HTTP {$codigo}: {$body}" );
		}
		$datos = json_decode( $body, true );
		if ( ! is_array( $datos ) || empty( $datos['content'][0]['text'] ) ) {
			throw new RuntimeException( 'Respuesta de Anthropic con formato inesperado.' );
		}
		return (string) $datos['content'][0]['text'];
	}

	/**
	 * Prompt de sistema. Acota voz, idioma, longitud y alcance. La
	 * habilidad se incluye literal — si el modelo la reconoce, mejor;
	 * si no, ya tiene el contexto del Fragmento (o ninguno) para
	 * orientarse. Se mantiene corto: cada token cuesta y el modelo no
	 * necesita un manual entero para responder a un niño.
	 */
	private static function construir_prompt_sistema(
		string $id_habilidad,
		?string $contexto_fragmento
	): string {
		$lineas   = array();
		$lineas[] = 'Eres un tutor de matemáticas para niños de 9 a 12 años.';
		$lineas[] = 'Hablas en castellano, con frases cortas y voz cariñosa.';
		$lineas[] = 'Responde como mucho en 4 frases. Sin emoticonos.';
		$lineas[] = 'No des la solución directa: da la pista o el método para que el niño lo descubra.';
		$lineas[] = 'Solo matemáticas del MVP (fracciones, decimales, porcentajes, divisibilidad, geometría básica, estadística básica).';
		$lineas[] = 'Si te preguntan cualquier otra cosa, responde: "De eso no sé. Pregúntame de matemáticas."';
		$lineas[] = '';
		$lineas[] = 'Habilidad actual: ' . $id_habilidad;
		if ( null !== $contexto_fragmento && '' !== trim( $contexto_fragmento ) ) {
			$lineas[] = 'Lo que ve en pantalla: ' . trim( $contexto_fragmento );
		}
		return implode( "\n", $lineas );
	}
}
