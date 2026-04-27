<?php
/**
 * Orquestador del tutor en el servidor. Replica el flujo del cliente
 * (`ServicioTutor` Dart) pero del lado del backend:
 *
 *   1. Filtro entrada (PHP, segunda capa).
 *   2. Caché en BD — clave = sha256(id_habilidad|pregunta_normalizada).
 *   3. Llamada a Anthropic.
 *   4. Filtro salida.
 *   5. Persiste en caché.
 *   6. Devuelve `{explicacion, fuente}`.
 *
 * El cliente HTTP a Anthropic se inyecta vía un callable opcional —
 * en producción usa `UROTO_Anthropic::pedir_explicacion`, en tests se
 * pasa un stub. Misma estrategia que el `cliente HTTP` de Dart.
 *
 * @package UnoRotoCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class UROTO_Tutor {

	/** TTL en segundos. 30 días — paralelo al cliente. */
	public const TTL_CACHE = 30 * DAY_IN_SECONDS;

	/**
	 * Llamado por el endpoint REST. Devuelve un array con la forma
	 * que el cliente espera, o un WP_REST_Response con error 422 si
	 * el filtro rechaza.
	 *
	 * @param callable|null $cliente_anthropic Callable que recibe
	 *      (id_habilidad, pregunta, contexto) y devuelve string. Si
	 *      null, usa el cliente real.
	 * @return WP_REST_Response
	 */
	public static function explicar(
		string $id_habilidad,
		string $pregunta,
		?string $contexto_fragmento = null,
		?callable $cliente_anthropic = null
	): WP_REST_Response {
		$revision = UROTO_Filtro_Tutor::revisar_pregunta( $pregunta );
		if ( ! $revision['ok'] ) {
			return new WP_REST_Response(
				array(
					'error'  => UROTO_Filtro_Tutor::mensaje_amable( $revision['motivo'] ),
					'motivo' => $revision['motivo'],
				),
				422
			);
		}
		$pregunta_limpia = $revision['limpio'];

		$clave = UROTO_Filtro_Tutor::clave_cache( $id_habilidad, $pregunta_limpia );

		$desde_cache = self::leer_cache( $clave );
		if ( null !== $desde_cache ) {
			return new WP_REST_Response(
				array( 'explicacion' => $desde_cache, 'fuente' => 'cache' ),
				200
			);
		}

		try {
			$cliente = $cliente_anthropic ?? array( 'UROTO_Anthropic', 'pedir_explicacion' );
			$cruda   = (string) call_user_func(
				$cliente,
				$id_habilidad,
				$pregunta_limpia,
				$contexto_fragmento
			);
		} catch ( Throwable $e ) {
			return new WP_REST_Response(
				array( 'error' => 'No he podido pensarlo ahora, vuelve a intentarlo en un rato.' ),
				502
			);
		}

		$revision_salida = UROTO_Filtro_Tutor::revisar_respuesta( $cruda );
		if ( ! $revision_salida['ok'] ) {
			return new WP_REST_Response(
				array( 'error' => 'Hoy no puedo ayudarte con eso, prueba a preguntarlo de otra forma.' ),
				422
			);
		}
		$explicacion = $revision_salida['limpio'];

		self::escribir_cache( $clave, $id_habilidad, $pregunta_limpia, $explicacion );

		return new WP_REST_Response(
			array( 'explicacion' => $explicacion, 'fuente' => 'llm' ),
			200
		);
	}

	private static function nombre_tabla(): string {
		return UROTO_Esquema::nombre_tabla( 'cache_tutor' );
	}

	/** Devuelve la explicación cacheada o null si no existe / caducó. */
	private static function leer_cache( string $clave ): ?string {
		global $wpdb;
		$tabla    = self::nombre_tabla();
		$umbral   = gmdate( 'Y-m-d H:i:s', time() - self::TTL_CACHE );
		$fila     = $wpdb->get_row(
			$wpdb->prepare(
				"SELECT respuesta, creado_en FROM {$tabla} WHERE clave_hash = %s",
				$clave
			),
			ARRAY_A
		);
		if ( ! $fila ) {
			return null;
		}
		if ( $fila['creado_en'] < $umbral ) {
			$wpdb->delete( $tabla, array( 'clave_hash' => $clave ), array( '%s' ) );
			return null;
		}
		// Actualizar contador de usos sin tocar creado_en.
		$wpdb->query(
			$wpdb->prepare(
				"UPDATE {$tabla} SET usos = usos + 1 WHERE clave_hash = %s",
				$clave
			)
		);
		return (string) $fila['respuesta'];
	}

	private static function escribir_cache(
		string $clave,
		string $id_habilidad,
		string $pregunta,
		string $respuesta
	): void {
		global $wpdb;
		$tabla = self::nombre_tabla();
		$wpdb->replace(
			$tabla,
			array(
				'clave_hash'   => $clave,
				'id_habilidad' => $id_habilidad,
				'pregunta'     => $pregunta,
				'respuesta'    => $respuesta,
				'creado_en'    => current_time( 'mysql', true ),
				'usos'         => 1,
			),
			array( '%s', '%s', '%s', '%s', '%s', '%d' )
		);
	}

	/**
	 * Métricas básicas de la caché. Pensado para un endpoint admin —
	 * útil para auditar uso (cuántas preguntas únicas, cuántas
	 * habilidades preguntadas, qué proporción de hits viene de cache
	 * vs llm). NO incluye datos personales: solo agregados.
	 *
	 * @return array{
	 *     total_entradas:int,
	 *     total_usos:int,
	 *     habilidades_distintas:int,
	 *     mas_preguntadas:list<array{id_habilidad:string,entradas:int,usos:int}>
	 * }
	 */
	public static function metricas(): array {
		global $wpdb;
		$tabla = self::nombre_tabla();
		$total = $wpdb->get_row(
			"SELECT COUNT(*) AS n_entradas, COALESCE(SUM(usos),0) AS n_usos,
			        COUNT(DISTINCT id_habilidad) AS n_habilidades
			 FROM {$tabla}",
			ARRAY_A
		);
		$top = $wpdb->get_results(
			"SELECT id_habilidad, COUNT(*) AS entradas, COALESCE(SUM(usos),0) AS usos
			 FROM {$tabla}
			 GROUP BY id_habilidad
			 ORDER BY usos DESC, entradas DESC
			 LIMIT 5",
			ARRAY_A
		);
		return array(
			'total_entradas'        => (int) ( $total['n_entradas'] ?? 0 ),
			'total_usos'            => (int) ( $total['n_usos'] ?? 0 ),
			'habilidades_distintas' => (int) ( $total['n_habilidades'] ?? 0 ),
			'mas_preguntadas'       => array_map(
				static function ( array $fila ): array {
					return array(
						'id_habilidad' => (string) $fila['id_habilidad'],
						'entradas'     => (int) $fila['entradas'],
						'usos'         => (int) $fila['usos'],
					);
				},
				$top ?: array()
			),
		);
	}

	/**
	 * Borra entradas de caché caducadas (> TTL_CACHE). Llamado por
	 * un cron diario. La purga al leer (en `leer_cache`) solo limpia
	 * lo que se vuelve a consultar — sin esto, las entradas viejas
	 * que nadie pregunta crecerían sin techo en BD.
	 *
	 * @return int Número de filas borradas.
	 */
	public static function purgar_caduca(): int {
		global $wpdb;
		$tabla  = self::nombre_tabla();
		$umbral = gmdate( 'Y-m-d H:i:s', time() - self::TTL_CACHE );
		$borradas = $wpdb->query(
			$wpdb->prepare(
				"DELETE FROM {$tabla} WHERE creado_en < %s",
				$umbral
			)
		);
		return (int) $borradas;
	}
}
