<?php
/**
 * BORRADOR — flujo de vínculo cuidador↔niño con consentimiento
 * parental por magic link.
 *
 * **NO ES UN FLUJO DE PRODUCCIÓN.** Está aquí como proof of
 * concept del shape de los endpoints; el método de consentimiento
 * (`'magic_link_borrador'` literal en `ns_caregiver_links`)
 * señala explícitamente que falta validación legal antes de
 * activarlo en producción.
 *
 * Pendiente humano antes de producción (memoria
 * `project_el_cuaderno_decisiones_humanas_pendientes` ítem 5):
 * 1. Asesoría LOPDGDD: ¿basta magic link? ¿hace falta verificación
 *    de identidad del progenitor (DNI, doble factor, firma…)?
 *    Datos de menores → criterios reforzados de la AEPD.
 * 2. Texto del email de invitación: voz amable, sin diminutivos,
 *    sin alarmar al cuidador. Pasa el test §2.3 doc 04 El Cuaderno
 *    ("¿podría salir esto de alguien con cuarenta años caminando
 *    el monte?").
 * 3. Mecanismo real de envío de email: sin esto el `request`
 *    devuelve el token en la respuesta — útil para test manual,
 *    inseguro para producción (cualquier intermediario lo lee).
 * 4. ¿El progenitor inicia el vínculo desde la app del niño (con
 *    el JWT del niño, como hoy) o desde wp-admin con su cookie?
 *    Hoy se usa el JWT del niño porque es lo que ya está cableado
 *    en los clientes; revisable cuando exista una pantalla
 *    dedicada para el progenitor.
 * 5. Caducidad del token: hoy 24 h, alineado con UX típica de
 *    magic links. Confirmar con la asesoría legal.
 *
 * Endpoints:
 *   POST /caregivers/link/request
 *     auth: Bearer JWT del niño (`permiso_jwt`)
 *     body: { cuidador_email }
 *     201: { consent_token, child_user_id, caregiver_user_id, expires_at }
 *     400: cuidador_email faltante o malformado.
 *     404: el cuidador no existe en WP o no tiene rol nuevoser_cuidador.
 *     409: ya existe un link activo o pendiente sin verificar.
 *
 *   POST /caregivers/link/verify
 *     auth: Bearer JWT del cuidador (`permiso_jwt_cuidador`)
 *     body: { consent_token }
 *     200: { caregiver_user_id, child_user_id, consent_verified_at }
 *     400: consent_token faltante.
 *     404: token no existe.
 *     403: el token pertenece a otro cuidador (no el del JWT).
 *     410: token expirado (>24h).
 *
 *   GET /caregivers/{caregiverId}/children/{childId}/summary
 *     auth: Bearer JWT del cuidador (`permiso_jwt_cuidador`)
 *     query: ?game_id=... (opcional)
 *     200: { game_id, iso_week, summary_text, conversation_prompt, generated_at }
 *     403: caregiverId != _user_id, o no hay link verificado para
 *          (caregiver, child).
 *     404: no hay weekly_summary disponible.
 *
 * @package NuevoSerCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class NS_Caregivers {

	/** Etiqueta del método de consentimiento usada en `ns_caregiver_links`. */
	public const CONSENT_METHOD_BORRADOR = 'magic_link_borrador';

	/** Longitud del consent_token en chars (hex). 32 chars = 16 bytes random. */
	public const LONGITUD_CONSENT_TOKEN = 32;

	/** Caducidad del token en segundos. 24 horas. */
	public const SEGUNDOS_VALIDEZ_TOKEN = 86400;

	/**
	 * POST /caregivers/link/request
	 *
	 * El progenitor (autenticado con el JWT del niño) invita a un
	 * cuidador conocido por email. El cuidador debe tener cuenta WP
	 * con rol `nuevoser_cuidador` previamente.
	 */
	public static function solicitar_vinculo( WP_REST_Request $request ) {
		global $wpdb;

		$nino_id = (int) $request->get_param( '_nino_id' );
		if ( $nino_id <= 0 ) {
			return new WP_Error(
				'ns_caregivers_sin_nino',
				'Falta el identificador del niño en el token.',
				array( 'status' => 401 )
			);
		}

		$email = sanitize_email( (string) $request->get_param( 'cuidador_email' ) );
		$error = self::validar_email_invitacion( $email );
		if ( null !== $error ) {
			return new WP_REST_Response( array( 'error' => $error ), 400 );
		}

		// Resolver al cuidador en wp_users por email + rol.
		$usuario = get_user_by( 'email', $email );
		if ( ! ( $usuario instanceof WP_User )
			|| ! in_array( NS_Auth_Adulto::ROL_WP_CUIDADOR, (array) $usuario->roles, true ) ) {
			return new WP_REST_Response(
				array(
					'error' => 'No existe un cuidador registrado con ese email. Pídele que cree su cuenta primero.',
				),
				404
			);
		}
		$caregiver_user_id = (int) $usuario->ID;

		// Idempotencia: si ya hay un link verificado, no creamos otro.
		// Si hay uno pendiente sin verificar pero no expirado, también
		// 409 con el token existente (para que el progenitor pueda
		// reenviar el email manualmente sin generar tokens en cadena).
		$tabla = NS_Esquema::nombre_tabla( 'caregiver_links' );
		$existente = $wpdb->get_row(
			$wpdb->prepare(
				"SELECT consent_token, consent_verified_at, created_at, active
				 FROM {$tabla}
				 WHERE caregiver_user_id = %d AND child_user_id = %d",
				$caregiver_user_id,
				$nino_id
			),
			ARRAY_A
		);
		if ( $existente ) {
			if ( null !== $existente['consent_verified_at'] && (int) $existente['active'] === 1 ) {
				return new WP_REST_Response(
					array( 'error' => 'Este cuidador ya tiene un vínculo verificado con el niño.' ),
					409
				);
			}
			$creado_en = (int) strtotime( (string) $existente['created_at'] );
			$expira_en = $creado_en + self::SEGUNDOS_VALIDEZ_TOKEN;
			if ( time() < $expira_en && ! empty( $existente['consent_token'] ) ) {
				return new WP_REST_Response(
					array(
						'error'              => 'Ya hay una invitación pendiente con un token válido. Reenvíalo o espera a que caduque.',
						'consent_token'      => (string) $existente['consent_token'],
						'expires_at'         => gmdate( 'Y-m-d H:i:s', $expira_en ),
					),
					409
				);
			}
			// Token expirado: lo regeneramos sobre la misma fila más abajo.
		}

		// Generamos un token único. La columna tiene UNIQUE KEY, así que
		// si por colisión el INSERT falla, reintentamos. Espacio: 32 chars
		// hex = 128 bits — la colisión es astronómicamente improbable.
		$token = self::generar_consent_token();
		$ahora = gmdate( 'Y-m-d H:i:s' );

		if ( $existente ) {
			$resultado = $wpdb->update(
				$tabla,
				array(
					'consent_method'      => self::CONSENT_METHOD_BORRADOR,
					'consent_token'       => $token,
					'consent_verified_at' => null,
					'consent_evidence'    => null,
					'active'              => 1,
					'created_at'          => $ahora,
					'revoked_at'          => null,
				),
				array(
					'caregiver_user_id' => $caregiver_user_id,
					'child_user_id'     => $nino_id,
				),
				array( '%s', '%s', '%s', '%s', '%d', '%s', '%s' ),
				array( '%d', '%d' )
			);
		} else {
			$resultado = $wpdb->insert(
				$tabla,
				array(
					'caregiver_user_id' => $caregiver_user_id,
					'child_user_id'     => $nino_id,
					'consent_method'    => self::CONSENT_METHOD_BORRADOR,
					'consent_token'     => $token,
					'active'            => 1,
					'created_at'        => $ahora,
				),
				array( '%d', '%d', '%s', '%s', '%d', '%s' )
			);
		}
		if ( false === $resultado ) {
			return new WP_Error(
				'ns_caregivers_request_error',
				'No se pudo registrar la invitación.',
				array( 'status' => 500 )
			);
		}

		$expires_at = gmdate( 'Y-m-d H:i:s', strtotime( $ahora ) + self::SEGUNDOS_VALIDEZ_TOKEN );
		return new WP_REST_Response(
			array(
				'consent_token'     => $token,
				'caregiver_user_id' => $caregiver_user_id,
				'child_user_id'     => $nino_id,
				'expires_at'        => $expires_at,
				// El cliente debe tratar este flujo como BORRADOR.
				// En producción real este campo podría desaparecer y
				// el token sólo viajaría por email al cuidador.
				'borrador_aviso'    => 'magic_link_borrador: pendiente de validación LOPDGDD',
			),
			201
		);
	}

	/**
	 * POST /caregivers/link/verify
	 *
	 * El cuidador (con su propio JWT, tipo='cuidador') confirma que
	 * recibió el token y acepta el vínculo. Marca el link como
	 * verificado, persiste evidencia auditable.
	 */
	public static function verificar_vinculo( WP_REST_Request $request ) {
		global $wpdb;

		$caregiver_user_id = (int) $request->get_param( '_user_id' );
		if ( $caregiver_user_id <= 0 ) {
			return new WP_Error(
				'ns_caregivers_sin_user',
				'Falta el identificador del cuidador en el token.',
				array( 'status' => 401 )
			);
		}

		$token = trim( (string) $request->get_param( 'consent_token' ) );
		if ( '' === $token ) {
			return new WP_REST_Response(
				array( 'error' => 'consent_token requerido' ),
				400
			);
		}

		$tabla = NS_Esquema::nombre_tabla( 'caregiver_links' );
		$fila  = $wpdb->get_row(
			$wpdb->prepare(
				"SELECT caregiver_user_id, child_user_id, created_at, consent_verified_at
				 FROM {$tabla}
				 WHERE consent_token = %s",
				$token
			),
			ARRAY_A
		);
		if ( ! $fila ) {
			return new WP_REST_Response(
				array( 'error' => 'Token no válido.' ),
				404
			);
		}
		if ( (int) $fila['caregiver_user_id'] !== $caregiver_user_id ) {
			return new WP_REST_Response(
				array( 'error' => 'Este token no es para esta cuenta de cuidador.' ),
				403
			);
		}
		if ( null !== $fila['consent_verified_at'] ) {
			// Idempotencia: si ya está verificado, devolvemos 200 con
			// la misma fecha — el cuidador puede pulsar el enlace dos
			// veces sin sorpresas.
			return new WP_REST_Response(
				array(
					'caregiver_user_id'   => $caregiver_user_id,
					'child_user_id'       => (int) $fila['child_user_id'],
					'consent_verified_at' => (string) $fila['consent_verified_at'],
				),
				200
			);
		}
		$creado_en = (int) strtotime( (string) $fila['created_at'] );
		if ( time() > $creado_en + self::SEGUNDOS_VALIDEZ_TOKEN ) {
			return new WP_REST_Response(
				array( 'error' => 'Token expirado. Pide al progenitor que reenvíe la invitación.' ),
				410
			);
		}

		$ahora = gmdate( 'Y-m-d H:i:s' );
		$evidencia = array(
			'consent_method'   => self::CONSENT_METHOD_BORRADOR,
			'requested_at'     => (string) $fila['created_at'],
			'verified_at'      => $ahora,
			'verified_by_ip'   => isset( $_SERVER['REMOTE_ADDR'] )
				? sanitize_text_field( wp_unslash( (string) $_SERVER['REMOTE_ADDR'] ) )
				: '',
			'borrador_aviso'   => 'magic_link_borrador: este flujo no es producción todavía',
		);

		$wpdb->update(
			$tabla,
			array(
				'consent_verified_at' => $ahora,
				'consent_evidence'    => wp_json_encode( $evidencia ),
			),
			array(
				'caregiver_user_id' => $caregiver_user_id,
				'child_user_id'     => (int) $fila['child_user_id'],
			),
			array( '%s', '%s' ),
			array( '%d', '%d' )
		);

		return new WP_REST_Response(
			array(
				'caregiver_user_id'   => $caregiver_user_id,
				'child_user_id'       => (int) $fila['child_user_id'],
				'consent_verified_at' => $ahora,
			),
			200
		);
	}

	/**
	 * GET /caregivers/{caregiverId}/children/{childId}/summary
	 *
	 * El cuidador consulta el último resumen LLM del niño. Sólo lee
	 * `summary_text` y `conversation_prompt` — NUNCA texto libre del
	 * cuaderno (eso vive sólo en el dispositivo del niño, doc 03 §6
	 * El Cuaderno principio 1).
	 */
	public static function ver_resumen( WP_REST_Request $request ) {
		global $wpdb;

		$caregiver_user_id_token = (int) $request->get_param( '_user_id' );
		$caregiver_id_url        = (int) $request->get_param( 'caregiverId' );
		$child_id_url            = (int) $request->get_param( 'childId' );

		if ( $caregiver_user_id_token <= 0 ) {
			return new WP_Error(
				'ns_caregivers_sin_user',
				'Falta el identificador del cuidador en el token.',
				array( 'status' => 401 )
			);
		}
		if ( $caregiver_id_url !== $caregiver_user_id_token ) {
			return new WP_REST_Response(
				array( 'error' => 'No tienes permiso para ver resúmenes de otro cuidador.' ),
				403
			);
		}

		$tabla_links = NS_Esquema::nombre_tabla( 'caregiver_links' );
		$link = $wpdb->get_row(
			$wpdb->prepare(
				"SELECT consent_verified_at, active
				 FROM {$tabla_links}
				 WHERE caregiver_user_id = %d AND child_user_id = %d",
				$caregiver_user_id_token,
				$child_id_url
			),
			ARRAY_A
		);
		if ( ! $link
			|| null === $link['consent_verified_at']
			|| (int) $link['active'] !== 1 ) {
			return new WP_REST_Response(
				array( 'error' => 'No hay vínculo verificado con este niño.' ),
				403
			);
		}

		$game_id_filtro = trim( (string) $request->get_param( 'game_id' ) );
		$tabla_summaries = NS_Esquema::nombre_tabla( 'weekly_summaries' );
		$where_extras    = '';
		$valores         = array( $child_id_url );
		if ( '' !== $game_id_filtro ) {
			$where_extras = ' AND game_id = %s';
			$valores[]    = $game_id_filtro;
		}

		$fila = $wpdb->get_row(
			$wpdb->prepare(
				"SELECT game_id, iso_week, summary_text, conversation_prompt, generated_at
				 FROM {$tabla_summaries}
				 WHERE user_id = %d{$where_extras}
				 ORDER BY iso_week DESC, generated_at DESC
				 LIMIT 1", // phpcs:ignore WordPress.DB.PreparedSQL
				...$valores
			),
			ARRAY_A
		);
		if ( ! $fila ) {
			return new WP_REST_Response(
				array( 'error' => 'No hay todavía ningún resumen disponible para este niño.' ),
				404
			);
		}

		return new WP_REST_Response(
			array(
				'game_id'             => (string) $fila['game_id'],
				'iso_week'            => (string) $fila['iso_week'],
				'summary_text'        => (string) $fila['summary_text'],
				'conversation_prompt' => null === $fila['conversation_prompt']
					? null
					: (string) $fila['conversation_prompt'],
				'generated_at'        => (string) $fila['generated_at'],
			),
			200
		);
	}

	/**
	 * Validación pura del email del cuidador en /link/request.
	 * Devuelve null si OK, mensaje humano si no. No toca DB ni WP.
	 */
	public static function validar_email_invitacion( $email ): ?string {
		if ( ! is_string( $email ) || '' === trim( (string) $email ) ) {
			return 'cuidador_email requerido';
		}
		// `is_email` está disponible en WP — pero para que la función
		// sea testeable en smoke (sin WP), hacemos validación manual
		// alineada con la regla de WP (filter_var con FILTER_VALIDATE_EMAIL).
		if ( ! filter_var( $email, FILTER_VALIDATE_EMAIL ) ) {
			return 'cuidador_email malformado';
		}
		return null;
	}

	/**
	 * Genera un consent_token criptográficamente seguro de 32 chars
	 * hex (16 bytes random → 128 bits). Espacio total: 2^128 — la
	 * colisión es astronómicamente improbable, pero la columna
	 * `consent_token` tiene UNIQUE KEY como protección extra.
	 */
	public static function generar_consent_token(): string {
		return bin2hex( random_bytes( self::LONGITUD_CONSENT_TOKEN / 2 ) );
	}
}
