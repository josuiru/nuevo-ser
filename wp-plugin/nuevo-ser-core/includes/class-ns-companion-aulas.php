<?php
/**
 * Endpoints de Aulas (`/classrooms/*`).
 *
 * En este slice sólo cubre la pieza que encaja con el JWT del niño:
 * `POST /classrooms/{code}/join`. La creación del aula
 * (`POST /classrooms`) y los agregados (`GET /classrooms/{id}/aggregates`)
 * dependen de un mecanismo de autenticación del profesor que aún no está
 * decidido (cookie WP + nonce, Application Passwords o JWT-de-profesor)
 * y entran en un slice posterior.
 *
 * Hermano de NS_Companion_Cuaderno y NS_Companion_Mosaicos: misma forma
 * de validación pura + comprobación con DB, mismo error 400 con
 * `invalid_fields`.
 *
 * @package NuevoSerCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class NS_Companion_Aulas {

	/** Longitud mínima de un código de aula. */
	public const MIN_CODE = 4;

	/** Longitud máxima. Coincide con el VARCHAR(16) de la tabla. */
	public const MAX_CODE = 16;

	/**
	 * POST /classrooms/{code}/join
	 *
	 * El niño dueño del JWT se une al aula que tiene ese `code`. Si ya
	 * era miembro activo, devuelve 200 con su membresía existente
	 * (operación idempotente — la misma app puede invocar el endpoint
	 * tras una reinstalación sin observar duplicados ni errores).
	 *
	 * @param WP_REST_Request $request
	 * @return WP_REST_Response|WP_Error
	 */
	public static function unirse( WP_REST_Request $request ) {
		global $wpdb;

		$nino_id = (int) $request->get_param( '_nino_id' );
		if ( $nino_id <= 0 ) {
			return new WP_Error(
				'ns_aulas_sin_nino',
				'Falta el identificador del niño en el token.',
				array( 'status' => 401 )
			);
		}

		$code = (string) $request->get_param( 'code' );
		$campos_invalidos = self::validar_codigo( $code );
		if ( ! empty( $campos_invalidos ) ) {
			return self::error_validacion(
				'campos_invalidos',
				'El código del aula no pasa la validación.',
				array( 'invalid_fields' => $campos_invalidos )
			);
		}

		$tabla_aulas    = NS_Esquema::nombre_tabla( 'classrooms' );
		$tabla_miembros = NS_Esquema::nombre_tabla( 'classroom_members' );

		// El code se busca en mayúsculas — convención de los códigos de
		// invitación. La columna es CI por defecto en MySQL pero
		// normalizar reduce sorpresas.
		$code_normalizado = strtoupper( $code );

		$aula = $wpdb->get_row(
			$wpdb->prepare(
				"SELECT id, code, name, game_ids, language, active
				 FROM {$tabla_aulas}
				 WHERE code = %s",
				$code_normalizado
			),
			ARRAY_A
		);

		if ( ! $aula ) {
			return new WP_Error(
				'ns_aulas_codigo_no_existe',
				'No existe ningún aula con ese código.',
				array( 'status' => 404 )
			);
		}

		if ( (int) $aula['active'] !== 1 ) {
			return new WP_Error(
				'ns_aulas_inactiva',
				'El aula está inactiva y no admite nuevos miembros.',
				array( 'status' => 409 )
			);
		}

		$classroom_id = (int) $aula['id'];

		// ¿Ya es miembro?
		$existente = $wpdb->get_row(
			$wpdb->prepare(
				"SELECT joined_at, active FROM {$tabla_miembros}
				 WHERE classroom_id = %d AND user_id = %d",
				$classroom_id,
				$nino_id
			),
			ARRAY_A
		);

		$ahora = gmdate( 'Y-m-d H:i:s' );

		if ( $existente ) {
			// Si fue dado de baja en su día, lo reactivamos. El joined_at
			// histórico se preserva — es la fecha de su primer ingreso.
			if ( (int) $existente['active'] !== 1 ) {
				$wpdb->update(
					$tabla_miembros,
					array( 'active' => 1 ),
					array(
						'classroom_id' => $classroom_id,
						'user_id'      => $nino_id,
					),
					array( '%d' ),
					array( '%d', '%d' )
				);
			}
			$joined_at = (string) $existente['joined_at'];
			$status    = 200;
		} else {
			$insertado = $wpdb->insert(
				$tabla_miembros,
				array(
					'classroom_id' => $classroom_id,
					'user_id'      => $nino_id,
					'joined_at'    => $ahora,
					'active'       => 1,
				),
				array( '%d', '%d', '%s', '%d' )
			);
			if ( false === $insertado ) {
				return new WP_Error(
					'ns_aulas_join_error',
					'No se pudo registrar la membresía.',
					array( 'status' => 500 )
				);
			}
			$joined_at = $ahora;
			$status    = 201;
		}

		$respuesta = new WP_REST_Response(
			array(
				'classroom_id' => $classroom_id,
				'code'         => (string) $aula['code'],
				'name'         => (string) $aula['name'],
				'game_ids'     => self::decodificar_lista_games( $aula['game_ids'] ?? null ),
				'language'     => (string) $aula['language'],
				'joined_at'    => $joined_at,
			),
			$status
		);
		return $respuesta;
	}

	/**
	 * Valida el formato del código del aula. Pura — testeable sin WP.
	 * No comprueba existencia (eso requiere DB).
	 *
	 * @return array<string,string> `campo => motivo`. Vacío si OK.
	 */
	public static function validar_codigo( string $code ): array {
		$campos_invalidos = array();
		$normalizado      = strtoupper( trim( $code ) );

		if ( '' === $normalizado ) {
			$campos_invalidos['code'] = 'requerido';
			return $campos_invalidos;
		}

		$longitud = strlen( $normalizado );
		if ( $longitud < self::MIN_CODE || $longitud > self::MAX_CODE ) {
			$campos_invalidos['code'] = 'longitud_invalida';
			return $campos_invalidos;
		}

		if ( ! preg_match( '/^[A-Z0-9]+$/', $normalizado ) ) {
			$campos_invalidos['code'] = 'formato_invalido';
		}

		return $campos_invalidos;
	}

	/**
	 * `game_ids` se guarda como LONGTEXT JSON. Si está corrupto o
	 * vacío, se devuelve lista vacía (auto-curación) en lugar de
	 * romper el join — el aula sigue siendo válida aunque su lista de
	 * juegos sea ilegible.
	 *
	 * @param mixed $crudo
	 * @return array<int,string>
	 */
	private static function decodificar_lista_games( $crudo ): array {
		if ( null === $crudo || '' === $crudo ) {
			return array();
		}
		$decodificado = json_decode( (string) $crudo, true );
		if ( ! is_array( $decodificado ) ) {
			return array();
		}
		// Forzamos que sean strings (los game_ids viven en VARCHAR de
		// `ns_games`); descartamos shapes inesperados.
		$resultado = array();
		foreach ( $decodificado as $valor ) {
			if ( is_string( $valor ) && '' !== $valor ) {
				$resultado[] = $valor;
			}
		}
		return $resultado;
	}

	private static function error_validacion( string $code, string $mensaje, array $data = array() ): WP_Error {
		return new WP_Error(
			$code,
			$mensaje,
			array_merge( array( 'status' => 400 ), $data )
		);
	}
}
