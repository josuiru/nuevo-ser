<?php
/**
 * Filtro de seguridad PHP del tutor IA.
 *
 * Réplica de `app/lib/dominio/tutor/filtro_seguridad.dart`. El contrato
 * canónico vive en el archivo Dart; cualquier cambio aquí debe
 * reflejarse allí (y al revés). Esta es la segunda capa: aunque el
 * cliente filtre antes de mandar, el servidor no confía en el cliente.
 *
 * Mismas reglas:
 *   - Longitudes máximas (280 pregunta / 1200 respuesta).
 *   - Bloqueo de PII: email, teléfono, URL.
 *   - Patrones obvios de inyección de prompt.
 *   - Lista corta de fuera-de-alcance.
 *   - Mensajes amables para los rechazos.
 *
 * @package UnoRotoCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class UROTO_Filtro_Tutor {

	public const LONGITUD_MAXIMA_PREGUNTA  = 280;
	public const LONGITUD_MAXIMA_RESPUESTA = 1200;

	public const MOTIVO_VACIO              = 'vacio';
	public const MOTIVO_DEMASIADO_LARGO    = 'demasiadoLargo';
	public const MOTIVO_CONTIENE_EMAIL     = 'contieneEmail';
	public const MOTIVO_CONTIENE_TELEFONO  = 'contieneTelefono';
	public const MOTIVO_CONTIENE_URL       = 'contieneUrl';
	public const MOTIVO_INYECCION_PROMPT   = 'posibleInyeccionPrompt';
	public const MOTIVO_FUERA_DE_ALCANCE   = 'fueraDeAlcance';

	private const PATRONES_INYECCION = array(
		'ignora las instrucciones',
		'ignore previous',
		'disregard',
		'olvida lo anterior',
		'olvida las reglas',
		'system prompt',
		'eres un',
		'pretend you are',
		'jailbreak',
	);

	private const PALABRAS_FUERA_DE_ALCANCE = array(
		'medicamento',
		'medicina',
		'suicid',
		'novia',
		'novio',
	);

	private const REGEX_EMAIL    = '/\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b/';
	private const REGEX_TELEFONO = '/(\+?\d[\d\s\-]{7,14}\d)/';
	private const REGEX_URL      = '/https?:\/\/\S+|www\.\S+\.\S+/i';

	/**
	 * Revisa la pregunta del niño antes de pasarla a Anthropic.
	 *
	 * @return array{ok: bool, motivo: ?string, limpio: ?string}
	 */
	public static function revisar_pregunta( string $pregunta ): array {
		$saneada = trim( $pregunta );
		if ( '' === $saneada ) {
			return array( 'ok' => false, 'motivo' => self::MOTIVO_VACIO, 'limpio' => null );
		}
		if ( mb_strlen( $saneada ) > self::LONGITUD_MAXIMA_PREGUNTA ) {
			return array( 'ok' => false, 'motivo' => self::MOTIVO_DEMASIADO_LARGO, 'limpio' => null );
		}
		if ( preg_match( self::REGEX_EMAIL, $saneada ) ) {
			return array( 'ok' => false, 'motivo' => self::MOTIVO_CONTIENE_EMAIL, 'limpio' => null );
		}
		if ( preg_match( self::REGEX_TELEFONO, $saneada ) ) {
			return array( 'ok' => false, 'motivo' => self::MOTIVO_CONTIENE_TELEFONO, 'limpio' => null );
		}
		if ( preg_match( self::REGEX_URL, $saneada ) ) {
			return array( 'ok' => false, 'motivo' => self::MOTIVO_CONTIENE_URL, 'limpio' => null );
		}
		$saneada_min = mb_strtolower( $saneada );
		foreach ( self::PATRONES_INYECCION as $patron ) {
			if ( false !== mb_strpos( $saneada_min, $patron ) ) {
				return array( 'ok' => false, 'motivo' => self::MOTIVO_INYECCION_PROMPT, 'limpio' => null );
			}
		}
		foreach ( self::PALABRAS_FUERA_DE_ALCANCE as $palabra ) {
			if ( false !== mb_strpos( $saneada_min, $palabra ) ) {
				return array( 'ok' => false, 'motivo' => self::MOTIVO_FUERA_DE_ALCANCE, 'limpio' => null );
			}
		}
		return array( 'ok' => true, 'motivo' => null, 'limpio' => $saneada );
	}

	/**
	 * Revisa la respuesta del LLM antes de devolverla al cliente. Si
	 * pasa todos los chequeos pero supera la longitud máxima, la trunca.
	 *
	 * @return array{ok: bool, motivo: ?string, limpio: ?string}
	 */
	public static function revisar_respuesta( string $respuesta ): array {
		$saneada = trim( $respuesta );
		if ( '' === $saneada ) {
			return array( 'ok' => false, 'motivo' => self::MOTIVO_VACIO, 'limpio' => null );
		}
		if ( preg_match( self::REGEX_EMAIL, $saneada ) ) {
			return array( 'ok' => false, 'motivo' => self::MOTIVO_CONTIENE_EMAIL, 'limpio' => null );
		}
		if ( preg_match( self::REGEX_TELEFONO, $saneada ) ) {
			return array( 'ok' => false, 'motivo' => self::MOTIVO_CONTIENE_TELEFONO, 'limpio' => null );
		}
		if ( preg_match( self::REGEX_URL, $saneada ) ) {
			return array( 'ok' => false, 'motivo' => self::MOTIVO_CONTIENE_URL, 'limpio' => null );
		}
		if ( mb_strlen( $saneada ) > self::LONGITUD_MAXIMA_RESPUESTA ) {
			$saneada = mb_substr( $saneada, 0, self::LONGITUD_MAXIMA_RESPUESTA - 1 ) . '…';
		}
		return array( 'ok' => true, 'motivo' => null, 'limpio' => $saneada );
	}

	/**
	 * Mensaje cariñoso para el motivo. Mismas frases que el cliente
	 * Dart — la app ya las tiene localmente, pero las repetimos aquí
	 * para los pocos casos en que solo el filtro servidor pille algo
	 * (cliente desactualizado, llamada directa).
	 */
	public static function mensaje_amable( string $motivo ): string {
		switch ( $motivo ) {
			case self::MOTIVO_VACIO:
				return 'Cuéntame qué te ha trabado, con tus palabras.';
			case self::MOTIVO_DEMASIADO_LARGO:
				return 'Hazlo más corto, con lo justo.';
			case self::MOTIVO_CONTIENE_EMAIL:
			case self::MOTIVO_CONTIENE_TELEFONO:
			case self::MOTIVO_CONTIENE_URL:
				return 'No me cuentes datos personales — solo de matemáticas.';
			case self::MOTIVO_INYECCION_PROMPT:
			case self::MOTIVO_FUERA_DE_ALCANCE:
			default:
				return 'De eso no sé. Pregúntame del Fragmento que tienes delante.';
		}
	}

	/**
	 * Normaliza la pregunta para usarla como clave de caché.
	 * Equivale al `_construirClave` del cliente Dart.
	 */
	public static function clave_cache( string $id_habilidad, string $pregunta ): string {
		$normalizada = preg_replace( '/\s+/', ' ', mb_strtolower( trim( $pregunta ) ) );
		return hash( 'sha256', $id_habilidad . '|' . $normalizada );
	}
}
