<?php
/**
 * Endpoints REST del módulo "ciencia ciudadana" de la app Fósiles.
 *
 * Bajo `/wp-json/nuevo-ser/v1/fosiles/*`. Tres grupos:
 *
 *   - Públicos (sin JWT, rate-limited):
 *       POST   /fosiles/aportaciones
 *       GET    /fosiles/fotos-comunidad/por-formacion/{codigo}
 *       POST   /fosiles/aportaciones/borrar-mis-aportaciones
 *       GET    /fosiles/aportaciones/confirmar-borrado?token={hex}
 *
 *   - Curador (JWT `tipo='curador_fosiles'` o capability
 *     `nuevoser_fosiles_revisar`):
 *       GET    /fosiles/aportaciones?estado=pendiente&pag=N
 *       GET    /fosiles/aportaciones/(?P<id>\d+)
 *       POST   /fosiles/aportaciones/(?P<id>\d+)/aprobar
 *       POST   /fosiles/aportaciones/(?P<id>\d+)/rechazar
 *       POST   /fosiles/aportaciones/(?P<id>\d+)/archivar
 *
 *   - Admin (capability `nuevoser_fosiles_gestionar_catalogo`):
 *       GET    /fosiles/formaciones-catalogadas
 *       POST   /fosiles/formaciones-catalogadas
 *       PUT    /fosiles/formaciones-catalogadas/(?P<id>\d+)
 *       DELETE /fosiles/formaciones-catalogadas/(?P<id>\d+)
 *
 * Frontera de privacidad:
 *  - La app NUNCA sube coordenadas precisas del hallazgo; solo foto +
 *    datos declarados + contacto (email + nombre opcional).
 *  - Email/nombre/IP/token_dispositivo NUNCA aparecen en la respuesta
 *    pública (`fotos-comunidad/por-formacion`). Quedan solo en backend
 *    para que el curador notifique y para el ledger RGPD.
 *
 * @package NuevoSerCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class NS_Fosiles_Comunidad {

	/** Subdirectorio bajo wp-content/uploads donde caen los blobs. */
	private const SUBDIR_UPLOADS = 'fosiles-comunidad';

	/** Tipos válidos de hallazgo. */
	private const TIPOS_VALIDOS = array( 'fosil', 'mineral' );

	/** Estados válidos de una aportación. */
	public const ESTADOS_VALIDOS = array(
		'pendiente',
		'aprobada',
		'rechazada',
		'archivada',
	);

	/** Tamaño máximo aceptado para la foto subida (bytes). */
	private const MAX_FOTO_BYTES = 8 * 1024 * 1024;

	/** Límite diario de subidas por token_dispositivo. */
	private const LIMITE_DIA_POR_TOKEN = 5;

	/** Límite diario de subidas por IP. */
	private const LIMITE_DIA_POR_IP = 10;

	/** Vida útil del token RGPD de borrado (segundos). 24 h. */
	private const VIDA_TOKEN_RGPD = 24 * 60 * 60;

	// ============================================================
	// Endpoint público: subir aportación
	// ============================================================

	/**
	 * POST /fosiles/aportaciones (público, multipart).
	 *
	 * Multipart esperado:
	 *   - foto    archivo  (image/jpeg | image/png, ≤ 8 MB).
	 *   - datos   string   JSON con { tipo, especie, edad, formacion,
	 *                                 notas, email, nombre,
	 *                                 token_dispositivo, consentimiento }.
	 *
	 * Rate-limit por token_dispositivo (5/día) y por IP (10/día). Si
	 * alguno se rebasa, devuelve 429. La foto del exceso NO se guarda.
	 */
	public static function crear_aportacion( WP_REST_Request $request ) {
		global $wpdb;

		$files = $request->get_file_params();
		if ( empty( $files['foto'] ) ) {
			return self::error_validacion( 'foto_requerida', 'Falta la foto del hallazgo.' );
		}

		$foto = $files['foto'];
		if ( ! empty( $foto['error'] ) && UPLOAD_ERR_OK !== (int) $foto['error'] ) {
			return self::error_validacion(
				'foto_invalida',
				'No se pudo subir la foto (código ' . (int) $foto['error'] . ').'
			);
		}

		$datos_raw = (string) $request->get_param( 'datos' );
		if ( '' === $datos_raw ) {
			return self::error_validacion( 'datos_requeridos', 'Falta el JSON con los datos del hallazgo.' );
		}
		$datos = json_decode( $datos_raw, true );
		if ( ! is_array( $datos ) ) {
			return self::error_validacion( 'datos_invalidos', 'El campo `datos` debe ser un JSON objeto.' );
		}

		// --- Validación de los datos del hallazgo ---
		$tipo = strtolower( trim( (string) ( $datos['tipo'] ?? '' ) ) );
		if ( ! in_array( $tipo, self::TIPOS_VALIDOS, true ) ) {
			return self::error_validacion( 'tipo_invalido', 'El tipo debe ser "fosil" o "mineral".' );
		}

		$email = sanitize_email( (string) ( $datos['email'] ?? '' ) );
		if ( '' === $email || ! is_email( $email ) ) {
			return self::error_validacion( 'email_invalido', 'Email no válido.' );
		}

		$consentimiento = ! empty( $datos['consentimiento'] );
		if ( ! $consentimiento ) {
			return self::error_validacion(
				'consentimiento_requerido',
				'Falta el consentimiento explícito (RGPD art. 6.1.a).'
			);
		}

		$token_dispositivo = trim( (string) ( $datos['token_dispositivo'] ?? '' ) );
		if ( '' === $token_dispositivo || strlen( $token_dispositivo ) > 64 ) {
			return self::error_validacion(
				'token_dispositivo_invalido',
				'Falta o no es válido el token de dispositivo.'
			);
		}

		$nombre              = sanitize_text_field( (string) ( $datos['nombre'] ?? '' ) );
		$especie_declarada   = self::recortar( $datos['especie'] ?? '', 255 );
		$edad_declarada      = self::recortar( $datos['edad'] ?? '', 128 );
		$formacion_declarada = self::recortar( $datos['formacion'] ?? '', 255 );
		$notas_aficionado    = self::recortar( $datos['notas'] ?? '', 4000 );

		// --- Rate-limit antes de tocar disco ---
		$ip = self::ip_solicitud();
		$limite_token = self::contar_aportaciones_dia( 'token_dispositivo', $token_dispositivo );
		if ( $limite_token >= self::LIMITE_DIA_POR_TOKEN ) {
			return new WP_REST_Response(
				array(
					'error'  => 'rate_limit_dispositivo',
					'limite' => self::LIMITE_DIA_POR_TOKEN,
				),
				429
			);
		}
		$limite_ip = self::contar_aportaciones_dia( 'ip_subida', $ip );
		if ( $limite_ip >= self::LIMITE_DIA_POR_IP ) {
			return new WP_REST_Response(
				array(
					'error'  => 'rate_limit_ip',
					'limite' => self::LIMITE_DIA_POR_IP,
				),
				429
			);
		}

		// --- Persistir la foto ---
		$blob_id = self::persistir_foto( $foto );
		if ( $blob_id instanceof WP_Error || $blob_id instanceof WP_REST_Response ) {
			return $blob_id;
		}

		// --- Insertar la aportación ---
		$tabla = NS_Esquema::nombre_tabla( 'fosiles_aportaciones' );
		$ahora = gmdate( 'Y-m-d H:i:s' );

		$insertado = $wpdb->insert(
			$tabla,
			array(
				'fecha_creacion'     => $ahora,
				'estado'             => 'pendiente',
				'tipo'               => $tipo,
				'email_contacto'     => $email,
				'nombre_contacto'    => $nombre,
				'especie_declarada'  => $especie_declarada,
				'edad_declarada'     => $edad_declarada,
				'formacion_declarada'=> $formacion_declarada,
				'notas_aficionado'   => $notas_aficionado,
				'foto_blob_id'       => $blob_id,
				'token_dispositivo'  => $token_dispositivo,
				'ip_subida'          => $ip,
				'consentimiento'     => 1,
			),
			array( '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%d', '%s', '%s', '%d' )
		);

		if ( false === $insertado ) {
			return new WP_Error(
				'ns_fosiles_insert_error',
				'No se pudo guardar la aportación.',
				array( 'status' => 500 )
			);
		}

		$id = (int) $wpdb->insert_id;
		return new WP_REST_Response(
			array(
				'id'     => $id,
				'estado' => 'pendiente',
			),
			201
		);
	}

	// ============================================================
	// Endpoint público: galería por formación
	// ============================================================

	/**
	 * GET /fosiles/fotos-comunidad/por-formacion/{codigo}
	 *
	 * Devuelve un array de fotos APROBADAS asociadas a la formación
	 * catalogada con `codigo` dado. Sin auth: cualquier app Fósiles
	 * desplegada lo consume al pinchar un punto sobre el mapa.
	 */
	public static function listar_fotos_por_formacion( WP_REST_Request $request ) {
		global $wpdb;

		$codigo = self::recortar( $request->get_param( 'codigo' ), 96 );
		if ( '' === $codigo ) {
			return new WP_REST_Response( array(), 200 );
		}

		$tabla_formaciones  = NS_Esquema::nombre_tabla( 'fosiles_formaciones_catalogadas' );
		$tabla_aportaciones = NS_Esquema::nombre_tabla( 'fosiles_aportaciones' );
		$tabla_blobs        = NS_Esquema::nombre_tabla( 'fosiles_fotos_blob' );

		$formacion = $wpdb->get_row(
			$wpdb->prepare(
				"SELECT id FROM {$tabla_formaciones} WHERE codigo = %s AND activo = 1",
				$codigo
			),
			ARRAY_A
		);
		if ( null === $formacion ) {
			return new WP_REST_Response( array(), 200 );
		}

		$filas = $wpdb->get_results(
			$wpdb->prepare(
				"SELECT a.id, a.tipo, a.especie_curada, a.edad_curada,
				        a.comentarios_curador, a.fecha_revision,
				        b.ruta_archivo, b.thumbnail_ruta
				   FROM {$tabla_aportaciones} a
				   JOIN {$tabla_blobs} b ON b.id = a.foto_blob_id
				  WHERE a.formacion_catalogada_id = %d
				    AND a.estado = 'aprobada'
				  ORDER BY a.fecha_revision DESC
				  LIMIT 200",
				(int) $formacion['id']
			),
			ARRAY_A
		);

		$base_url = self::base_url_uploads();
		$salida   = array();
		foreach ( (array) $filas as $fila ) {
			$ruta_foto    = ltrim( (string) $fila['ruta_archivo'], '/' );
			$ruta_thumb   = '' !== (string) $fila['thumbnail_ruta']
				? ltrim( (string) $fila['thumbnail_ruta'], '/' )
				: $ruta_foto;
			$salida[]     = array(
				'id'                  => (int) $fila['id'],
				'formacion_codigo'    => $codigo,
				'tipo'                => (string) $fila['tipo'],
				'especie_curada'      => (string) $fila['especie_curada'],
				'edad_curada'         => (string) $fila['edad_curada'],
				'comentarios_curador' => (string) ( $fila['comentarios_curador'] ?? '' ),
				'foto_url'            => $base_url . '/' . $ruta_foto,
				'thumbnail_url'       => $base_url . '/' . $ruta_thumb,
				'fecha_aprobacion'    => (int) strtotime( (string) $fila['fecha_revision'] ),
			);
		}

		return new WP_REST_Response( $salida, 200 );
	}

	// ============================================================
	// Endpoint público: solicitar borrado RGPD por email
	// ============================================================

	/**
	 * POST /fosiles/aportaciones/borrar-mis-aportaciones
	 *
	 * Body JSON: `{email}`. Emite un token de un solo uso (24h) y lo
	 * envía por email. La respuesta es siempre 202 si el email parece
	 * válido — no revelamos si tenemos o no aportaciones de ese email
	 * (enumeration attack).
	 */
	public static function solicitar_borrado_rgpd( WP_REST_Request $request ) {
		global $wpdb;

		$body  = $request->get_json_params();
		$email = sanitize_email( (string) ( is_array( $body ) ? ( $body['email'] ?? '' ) : '' ) );
		if ( '' === $email || ! is_email( $email ) ) {
			return self::error_validacion( 'email_invalido', 'Email no válido.' );
		}

		$tabla     = NS_Esquema::nombre_tabla( 'fosiles_borrados_rgpd' );
		$token     = bin2hex( random_bytes( 24 ) );
		$token_hash = hash( 'sha256', $token );
		$ahora     = time();
		$expira    = $ahora + self::VIDA_TOKEN_RGPD;

		$wpdb->insert(
			$tabla,
			array(
				'email_contacto' => $email,
				'token_hash'     => $token_hash,
				'expira_en'      => gmdate( 'Y-m-d H:i:s', $expira ),
				'ip_solicitud'   => self::ip_solicitud(),
				'creado_en'      => gmdate( 'Y-m-d H:i:s', $ahora ),
			),
			array( '%s', '%s', '%s', '%s', '%s' )
		);

		// El enlace de confirmación es un GET — lo abrirá el cliente
		// de correo del aficionado en su navegador, sin necesidad de
		// volver a la app.
		$url = add_query_arg(
			array( 'token' => $token ),
			rest_url( 'nuevo-ser/v1/fosiles/aportaciones/confirmar-borrado' )
		);

		$cuerpo  = "Has solicitado borrar tus aportaciones a la app Fósiles.\n\n";
		$cuerpo .= "Para confirmarlo y borrar TODAS tus aportaciones (pendientes y aprobadas),\n";
		$cuerpo .= "haz click en este enlace dentro de las próximas 24 horas:\n\n";
		$cuerpo .= $url . "\n\n";
		$cuerpo .= "Si no fuiste tú quien lo pidió, ignora este mensaje — el enlace caduca solo.\n\n";
		$cuerpo .= "— Equipo de la app Fósiles\n";

		wp_mail(
			$email,
			'Confirma el borrado de tus aportaciones — Fósiles',
			$cuerpo
		);

		return new WP_REST_Response(
			array( 'estado' => 'email_enviado' ),
			202
		);
	}

	/**
	 * GET /fosiles/aportaciones/confirmar-borrado?token={hex}
	 *
	 * Verifica el token, marca el ledger como usado y borra TODAS las
	 * aportaciones (y sus blobs) asociadas al email. Devuelve HTML
	 * sencillo porque lo abre el navegador del usuario, no la app.
	 */
	public static function confirmar_borrado_rgpd( WP_REST_Request $request ) {
		global $wpdb;

		$token = (string) $request->get_param( 'token' );
		if ( '' === $token || ! ctype_xdigit( $token ) ) {
			return self::respuesta_html(
				400,
				'Enlace inválido',
				'<p>Este enlace de borrado no es válido o ya ha sido usado.</p>'
			);
		}

		$tabla_tokens     = NS_Esquema::nombre_tabla( 'fosiles_borrados_rgpd' );
		$tabla_aportac    = NS_Esquema::nombre_tabla( 'fosiles_aportaciones' );
		$tabla_blobs      = NS_Esquema::nombre_tabla( 'fosiles_fotos_blob' );

		$token_hash = hash( 'sha256', $token );
		$fila       = $wpdb->get_row(
			$wpdb->prepare(
				"SELECT id, email_contacto, expira_en, usado_en
				   FROM {$tabla_tokens} WHERE token_hash = %s",
				$token_hash
			),
			ARRAY_A
		);
		if ( null === $fila ) {
			return self::respuesta_html(
				404,
				'Enlace no encontrado',
				'<p>No reconocemos este enlace de borrado.</p>'
			);
		}
		if ( null !== $fila['usado_en'] ) {
			return self::respuesta_html(
				410,
				'Enlace ya usado',
				'<p>Este enlace ya se usó. Tus aportaciones ya fueron borradas.</p>'
			);
		}
		if ( strtotime( (string) $fila['expira_en'] ) < time() ) {
			return self::respuesta_html(
				410,
				'Enlace caducado',
				'<p>Este enlace ha caducado. Solicita uno nuevo desde la app.</p>'
			);
		}

		$email = (string) $fila['email_contacto'];

		// Recolectar blobs asociados antes de borrar las aportaciones,
		// para poder eliminarlos físicamente del disco.
		$blob_ids = $wpdb->get_col(
			$wpdb->prepare(
				"SELECT foto_blob_id FROM {$tabla_aportac} WHERE email_contacto = %s",
				$email
			)
		);

		$wpdb->delete(
			$tabla_aportac,
			array( 'email_contacto' => $email ),
			array( '%s' )
		);

		// Para cada blob, si ya no lo referencia ninguna aportación
		// activa, borrar la fila y el archivo. La unicidad por sha256
		// permite que dos aportaciones distintas compartan blob; el
		// COUNT(*) protege contra borrados accidentales.
		foreach ( (array) $blob_ids as $blob_id ) {
			$blob_id = (int) $blob_id;
			if ( $blob_id <= 0 ) {
				continue;
			}
			$cuantas = (int) $wpdb->get_var(
				$wpdb->prepare(
					"SELECT COUNT(*) FROM {$tabla_aportac} WHERE foto_blob_id = %d",
					$blob_id
				)
			);
			if ( $cuantas > 0 ) {
				continue;
			}
			$blob = $wpdb->get_row(
				$wpdb->prepare(
					"SELECT ruta_archivo, thumbnail_ruta FROM {$tabla_blobs} WHERE id = %d",
					$blob_id
				),
				ARRAY_A
			);
			if ( null !== $blob ) {
				self::borrar_archivo_upload( (string) $blob['ruta_archivo'] );
				if ( '' !== (string) $blob['thumbnail_ruta'] ) {
					self::borrar_archivo_upload( (string) $blob['thumbnail_ruta'] );
				}
				$wpdb->delete( $tabla_blobs, array( 'id' => $blob_id ), array( '%d' ) );
			}
		}

		$wpdb->update(
			$tabla_tokens,
			array( 'usado_en' => gmdate( 'Y-m-d H:i:s' ) ),
			array( 'id' => (int) $fila['id'] ),
			array( '%s' ),
			array( '%d' )
		);

		return self::respuesta_html(
			200,
			'Borrado completado',
			'<p>Tus aportaciones (pendientes y aprobadas) se han borrado.</p>'
				. '<p>Si quieres aportar de nuevo en el futuro, vuelve a usar la app.</p>'
		);
	}

	// ============================================================
	// Endpoints de curador
	// ============================================================

	/**
	 * GET /fosiles/aportaciones?estado=pendiente&pag=N
	 *
	 * Devuelve la cola de revisión. Por defecto `estado=pendiente`.
	 */
	public static function listar_aportaciones_curador( WP_REST_Request $request ) {
		global $wpdb;

		$estado = strtolower( (string) ( $request->get_param( 'estado' ) ?: 'pendiente' ) );
		if ( ! in_array( $estado, self::ESTADOS_VALIDOS, true ) ) {
			$estado = 'pendiente';
		}

		$pag        = max( 1, (int) $request->get_param( 'pag' ) );
		$por_pagina = 20;
		$offset     = ( $pag - 1 ) * $por_pagina;

		$tabla_aportac = NS_Esquema::nombre_tabla( 'fosiles_aportaciones' );
		$tabla_blobs   = NS_Esquema::nombre_tabla( 'fosiles_fotos_blob' );

		$total = (int) $wpdb->get_var(
			$wpdb->prepare(
				"SELECT COUNT(*) FROM {$tabla_aportac} WHERE estado = %s",
				$estado
			)
		);
		$filas = $wpdb->get_results(
			$wpdb->prepare(
				"SELECT a.id, a.fecha_creacion, a.tipo,
				        a.especie_declarada, a.edad_declarada, a.formacion_declarada,
				        a.notas_aficionado, a.email_contacto, a.nombre_contacto,
				        b.ruta_archivo, b.thumbnail_ruta
				   FROM {$tabla_aportac} a
				   JOIN {$tabla_blobs} b ON b.id = a.foto_blob_id
				  WHERE a.estado = %s
				  ORDER BY a.fecha_creacion DESC
				  LIMIT %d OFFSET %d",
				$estado,
				$por_pagina,
				$offset
			),
			ARRAY_A
		);

		$base_url = self::base_url_uploads();
		$items    = array();
		foreach ( (array) $filas as $fila ) {
			$items[] = array(
				'id'                  => (int) $fila['id'],
				'fecha_creacion'      => (string) $fila['fecha_creacion'],
				'tipo'                => (string) $fila['tipo'],
				'especie_declarada'   => (string) $fila['especie_declarada'],
				'edad_declarada'      => (string) $fila['edad_declarada'],
				'formacion_declarada' => (string) $fila['formacion_declarada'],
				'notas_aficionado'    => (string) ( $fila['notas_aficionado'] ?? '' ),
				'email_contacto'      => (string) $fila['email_contacto'],
				'nombre_contacto'     => (string) $fila['nombre_contacto'],
				'foto_url'            => $base_url . '/' . ltrim( (string) $fila['ruta_archivo'], '/' ),
				'thumbnail_url'       => $base_url . '/' . ltrim(
					'' !== (string) $fila['thumbnail_ruta']
						? (string) $fila['thumbnail_ruta']
						: (string) $fila['ruta_archivo'],
					'/'
				),
			);
		}

		return new WP_REST_Response(
			array(
				'items'      => $items,
				'pag'        => $pag,
				'por_pagina' => $por_pagina,
				'total'      => $total,
			),
			200
		);
	}

	/**
	 * GET /fosiles/aportaciones/{id} (curador).
	 */
	public static function ver_aportacion_curador( WP_REST_Request $request ) {
		global $wpdb;

		$id = (int) $request->get_param( 'id' );
		if ( $id <= 0 ) {
			return self::error_validacion( 'id_invalido', 'Identificador inválido.' );
		}

		$tabla_aportac = NS_Esquema::nombre_tabla( 'fosiles_aportaciones' );
		$tabla_blobs   = NS_Esquema::nombre_tabla( 'fosiles_fotos_blob' );

		$fila = $wpdb->get_row(
			$wpdb->prepare(
				"SELECT a.*, b.ruta_archivo, b.thumbnail_ruta, b.tamano_bytes, b.ancho_px, b.alto_px
				   FROM {$tabla_aportac} a
				   JOIN {$tabla_blobs} b ON b.id = a.foto_blob_id
				  WHERE a.id = %d",
				$id
			),
			ARRAY_A
		);
		if ( null === $fila ) {
			return new WP_REST_Response( array( 'error' => 'no_encontrada' ), 404 );
		}

		$base_url = self::base_url_uploads();
		$ruta     = ltrim( (string) $fila['ruta_archivo'], '/' );
		$ruta_th  = '' !== (string) $fila['thumbnail_ruta']
			? ltrim( (string) $fila['thumbnail_ruta'], '/' )
			: $ruta;

		return new WP_REST_Response(
			array(
				'id'                      => (int) $fila['id'],
				'fecha_creacion'          => (string) $fila['fecha_creacion'],
				'fecha_revision'          => $fila['fecha_revision'],
				'estado'                  => (string) $fila['estado'],
				'tipo'                    => (string) $fila['tipo'],
				'email_contacto'          => (string) $fila['email_contacto'],
				'nombre_contacto'         => (string) $fila['nombre_contacto'],
				'especie_declarada'       => (string) $fila['especie_declarada'],
				'edad_declarada'          => (string) $fila['edad_declarada'],
				'formacion_declarada'     => (string) $fila['formacion_declarada'],
				'notas_aficionado'        => (string) ( $fila['notas_aficionado'] ?? '' ),
				'formacion_catalogada_id' => $fila['formacion_catalogada_id'] === null
					? null
					: (int) $fila['formacion_catalogada_id'],
				'especie_curada'          => (string) $fila['especie_curada'],
				'edad_curada'             => (string) $fila['edad_curada'],
				'comentarios_curador'     => (string) ( $fila['comentarios_curador'] ?? '' ),
				'motivo_rechazo'          => $fila['motivo_rechazo'],
				'foto_url'                => $base_url . '/' . $ruta,
				'thumbnail_url'           => $base_url . '/' . $ruta_th,
				'tamano_bytes'            => (int) $fila['tamano_bytes'],
				'ancho_px'                => (int) $fila['ancho_px'],
				'alto_px'                 => (int) $fila['alto_px'],
			),
			200
		);
	}

	/**
	 * POST /fosiles/aportaciones/{id}/aprobar (curador).
	 *
	 * Body JSON: `{formacion_catalogada_id, especie_curada, edad_curada,
	 *              comentarios?}`.
	 */
	public static function aprobar_aportacion( WP_REST_Request $request ) {
		global $wpdb;

		$id = (int) $request->get_param( 'id' );
		if ( $id <= 0 ) {
			return self::error_validacion( 'id_invalido', 'Identificador inválido.' );
		}

		$body = $request->get_json_params();
		if ( ! is_array( $body ) ) {
			return self::error_validacion( 'body_invalido', 'Body JSON inválido.' );
		}

		$formacion_id = (int) ( $body['formacion_catalogada_id'] ?? 0 );
		if ( $formacion_id <= 0 ) {
			return self::error_validacion(
				'formacion_catalogada_requerida',
				'Selecciona una formación catalogada antes de aprobar.'
			);
		}

		$tabla_formaciones = NS_Esquema::nombre_tabla( 'fosiles_formaciones_catalogadas' );
		$formacion         = $wpdb->get_row(
			$wpdb->prepare(
				"SELECT id, nombre_oficial FROM {$tabla_formaciones} WHERE id = %d AND activo = 1",
				$formacion_id
			),
			ARRAY_A
		);
		if ( null === $formacion ) {
			return self::error_validacion(
				'formacion_no_existe',
				'La formación seleccionada no existe o está desactivada.'
			);
		}

		$especie_curada = self::recortar( $body['especie_curada'] ?? '', 255 );
		$edad_curada    = self::recortar( $body['edad_curada'] ?? '', 128 );
		$comentarios    = self::recortar( $body['comentarios'] ?? '', 4000 );

		$tabla = NS_Esquema::nombre_tabla( 'fosiles_aportaciones' );
		$ahora = gmdate( 'Y-m-d H:i:s' );

		$actualizadas = $wpdb->update(
			$tabla,
			array(
				'estado'                  => 'aprobada',
				'fecha_revision'          => $ahora,
				'formacion_catalogada_id' => $formacion_id,
				'especie_curada'          => $especie_curada,
				'edad_curada'             => $edad_curada,
				'comentarios_curador'     => $comentarios,
				'curador_user_id'         => self::curador_user_id( $request ),
				'motivo_rechazo'          => null,
			),
			array( 'id' => $id ),
			array( '%s', '%s', '%d', '%s', '%s', '%s', '%d', '%s' ),
			array( '%d' )
		);

		if ( false === $actualizadas ) {
			return new WP_Error(
				'ns_fosiles_update_error',
				'No se pudo aprobar la aportación.',
				array( 'status' => 500 )
			);
		}

		// Notificar al aficionado.
		$email_destino = (string) $wpdb->get_var(
			$wpdb->prepare( "SELECT email_contacto FROM {$tabla} WHERE id = %d", $id )
		);
		if ( '' !== $email_destino ) {
			$cuerpo  = "¡Tu aportación a la app Fósiles ha sido APROBADA por un curador!\n\n";
			$cuerpo .= "La foto aparece ahora dentro de la app, asociada a la formación:\n";
			$cuerpo .= "  " . $formacion['nombre_oficial'] . "\n\n";
			if ( '' !== $especie_curada ) {
				$cuerpo .= "Identificación curada: " . $especie_curada . "\n";
			}
			if ( '' !== $edad_curada ) {
				$cuerpo .= "Edad geológica: " . $edad_curada . "\n";
			}
			if ( '' !== $comentarios ) {
				$cuerpo .= "\nComentario del curador:\n  " . $comentarios . "\n";
			}
			$cuerpo .= "\nGracias por contribuir. — Equipo de la app Fósiles\n";
			wp_mail(
				$email_destino,
				'Tu aportación ha sido aprobada — Fósiles',
				$cuerpo
			);
		}

		return new WP_REST_Response( array( 'estado' => 'aprobada' ), 200 );
	}

	/**
	 * POST /fosiles/aportaciones/{id}/rechazar (curador).
	 *
	 * Body JSON: `{motivo}`. El motivo se envía por email al aficionado.
	 */
	public static function rechazar_aportacion( WP_REST_Request $request ) {
		global $wpdb;

		$id = (int) $request->get_param( 'id' );
		if ( $id <= 0 ) {
			return self::error_validacion( 'id_invalido', 'Identificador inválido.' );
		}

		$body   = $request->get_json_params();
		$motivo = self::recortar( is_array( $body ) ? ( $body['motivo'] ?? '' ) : '', 4000 );
		if ( '' === $motivo ) {
			return self::error_validacion( 'motivo_requerido', 'Indica un motivo de rechazo.' );
		}

		$tabla = NS_Esquema::nombre_tabla( 'fosiles_aportaciones' );
		$ahora = gmdate( 'Y-m-d H:i:s' );

		$wpdb->update(
			$tabla,
			array(
				'estado'         => 'rechazada',
				'fecha_revision' => $ahora,
				'motivo_rechazo' => $motivo,
				'curador_user_id'=> self::curador_user_id( $request ),
			),
			array( 'id' => $id ),
			array( '%s', '%s', '%s', '%d' ),
			array( '%d' )
		);

		$email_destino = (string) $wpdb->get_var(
			$wpdb->prepare( "SELECT email_contacto FROM {$tabla} WHERE id = %d", $id )
		);
		if ( '' !== $email_destino ) {
			$cuerpo  = "Tu aportación a la app Fósiles no se ha podido aprobar.\n\n";
			$cuerpo .= "Motivo del curador:\n  " . $motivo . "\n\n";
			$cuerpo .= "Si crees que es un malentendido, puedes volver a enviar una foto "
				. "con mejor detalle desde la app. Gracias por participar.\n";
			wp_mail(
				$email_destino,
				'Sobre tu aportación a Fósiles',
				$cuerpo
			);
		}

		return new WP_REST_Response( array( 'estado' => 'rechazada' ), 200 );
	}

	/**
	 * POST /fosiles/aportaciones/{id}/archivar (curador).
	 *
	 * Para spam o entradas irrelevantes. Sin email al aficionado.
	 */
	public static function archivar_aportacion( WP_REST_Request $request ) {
		global $wpdb;

		$id = (int) $request->get_param( 'id' );
		if ( $id <= 0 ) {
			return self::error_validacion( 'id_invalido', 'Identificador inválido.' );
		}

		$tabla = NS_Esquema::nombre_tabla( 'fosiles_aportaciones' );
		$wpdb->update(
			$tabla,
			array(
				'estado'         => 'archivada',
				'fecha_revision' => gmdate( 'Y-m-d H:i:s' ),
				'curador_user_id'=> self::curador_user_id( $request ),
			),
			array( 'id' => $id ),
			array( '%s', '%s', '%d' ),
			array( '%d' )
		);

		return new WP_REST_Response( array( 'estado' => 'archivada' ), 200 );
	}

	// ============================================================
	// Endpoints de admin: catálogo de formaciones
	// ============================================================

	public static function listar_formaciones_admin( WP_REST_Request $request ) {
		global $wpdb;
		$tabla = NS_Esquema::nombre_tabla( 'fosiles_formaciones_catalogadas' );
		$filas = $wpdb->get_results(
			"SELECT * FROM {$tabla} ORDER BY nombre_oficial ASC",
			ARRAY_A
		);
		$salida = array();
		foreach ( (array) $filas as $fila ) {
			$salida[] = self::formacion_a_json( $fila );
		}
		return new WP_REST_Response( $salida, 200 );
	}

	public static function crear_formacion_admin( WP_REST_Request $request ) {
		global $wpdb;
		$body = $request->get_json_params();
		if ( ! is_array( $body ) ) {
			return self::error_validacion( 'body_invalido', 'Body JSON inválido.' );
		}

		$codigo = self::recortar( $body['codigo'] ?? '', 96 );
		$nombre = self::recortar( $body['nombre_oficial'] ?? '', 255 );
		if ( '' === $codigo || '' === $nombre ) {
			return self::error_validacion( 'campos_requeridos', 'Faltan codigo y nombre_oficial.' );
		}

		$tabla     = NS_Esquema::nombre_tabla( 'fosiles_formaciones_catalogadas' );
		$insertado = $wpdb->insert(
			$tabla,
			array(
				'codigo'           => $codigo,
				'nombre_oficial'   => $nombre,
				'periodo'          => self::recortar( $body['periodo'] ?? '', 64 ),
				'edad_aproximada'  => self::recortar( $body['edad_aproximada'] ?? '', 96 ),
				'regiones'         => isset( $body['regiones'] ) ? wp_json_encode( $body['regiones'] ) : null,
				'descripcion'      => self::recortar( $body['descripcion'] ?? '', 4000 ),
				'activo'           => empty( $body['activo'] ) ? 0 : 1,
			),
			array( '%s', '%s', '%s', '%s', '%s', '%s', '%d' )
		);

		if ( false === $insertado ) {
			// Probablemente UNIQUE KEY codigo.
			return new WP_REST_Response(
				array( 'error' => 'codigo_duplicado_o_db_error' ),
				409
			);
		}
		return new WP_REST_Response(
			array( 'id' => (int) $wpdb->insert_id, 'codigo' => $codigo ),
			201
		);
	}

	public static function actualizar_formacion_admin( WP_REST_Request $request ) {
		global $wpdb;
		$id = (int) $request->get_param( 'id' );
		if ( $id <= 0 ) {
			return self::error_validacion( 'id_invalido', 'Identificador inválido.' );
		}
		$body = $request->get_json_params();
		if ( ! is_array( $body ) ) {
			return self::error_validacion( 'body_invalido', 'Body JSON inválido.' );
		}

		$campos = array();
		$tipos  = array();
		foreach ( array(
			'codigo'           => '%s',
			'nombre_oficial'   => '%s',
			'periodo'          => '%s',
			'edad_aproximada'  => '%s',
			'descripcion'      => '%s',
		) as $clave => $tipo ) {
			if ( array_key_exists( $clave, $body ) ) {
				$campos[ $clave ] = self::recortar( $body[ $clave ], 'descripcion' === $clave ? 4000 : 255 );
				$tipos[]          = $tipo;
			}
		}
		if ( array_key_exists( 'regiones', $body ) ) {
			$campos['regiones'] = wp_json_encode( $body['regiones'] );
			$tipos[]            = '%s';
		}
		if ( array_key_exists( 'activo', $body ) ) {
			$campos['activo'] = empty( $body['activo'] ) ? 0 : 1;
			$tipos[]          = '%d';
		}

		if ( empty( $campos ) ) {
			return new WP_REST_Response( array( 'estado' => 'sin_cambios' ), 200 );
		}

		$tabla = NS_Esquema::nombre_tabla( 'fosiles_formaciones_catalogadas' );
		$wpdb->update( $tabla, $campos, array( 'id' => $id ), $tipos, array( '%d' ) );

		return new WP_REST_Response( array( 'estado' => 'actualizada' ), 200 );
	}

	public static function borrar_formacion_admin( WP_REST_Request $request ) {
		global $wpdb;
		$id = (int) $request->get_param( 'id' );
		if ( $id <= 0 ) {
			return self::error_validacion( 'id_invalido', 'Identificador inválido.' );
		}
		// No borramos físicamente; desactivamos para preservar referencias
		// históricas en aportaciones aprobadas.
		$tabla = NS_Esquema::nombre_tabla( 'fosiles_formaciones_catalogadas' );
		$wpdb->update( $tabla, array( 'activo' => 0 ), array( 'id' => $id ), array( '%d' ), array( '%d' ) );
		return new WP_REST_Response( array( 'estado' => 'desactivada' ), 200 );
	}

	// ============================================================
	// Permission callbacks
	// ============================================================

	/**
	 * Acepta:
	 *   - JWT con `tipo='curador_fosiles'` o `tipo='admin_fosiles'`
	 *   - Sesión WP con capability `nuevoser_fosiles_revisar`
	 */
	public static function permiso_curador( WP_REST_Request $request ) {
		if ( self::tiene_capability( 'nuevoser_fosiles_revisar' ) ) {
			return true;
		}
		$id_jwt = self::id_usuario_jwt_fosiles( $request, array( 'curador_fosiles', 'admin_fosiles' ) );
		if ( $id_jwt > 0 ) {
			$request->set_param( '_user_id', $id_jwt );
			return true;
		}
		return new WP_Error(
			'ns_fosiles_sin_permiso',
			'Necesitas iniciar sesión como curador.',
			array( 'status' => 401 )
		);
	}

	/**
	 * Acepta solo `admin_fosiles` o capability `nuevoser_fosiles_gestionar_catalogo`.
	 */
	public static function permiso_admin( WP_REST_Request $request ) {
		if ( self::tiene_capability( 'nuevoser_fosiles_gestionar_catalogo' ) ) {
			return true;
		}
		$id_jwt = self::id_usuario_jwt_fosiles( $request, array( 'admin_fosiles' ) );
		if ( $id_jwt > 0 ) {
			$request->set_param( '_user_id', $id_jwt );
			return true;
		}
		return new WP_Error(
			'ns_fosiles_sin_permiso_admin',
			'Necesitas iniciar sesión como administrador del catálogo.',
			array( 'status' => 401 )
		);
	}

	// ============================================================
	// Helpers internos
	// ============================================================

	private static function tiene_capability( string $cap ): bool {
		return is_user_logged_in() && current_user_can( $cap );
	}

	private static function id_usuario_jwt_fosiles( WP_REST_Request $request, array $tipos_aceptados ): int {
		if ( ! class_exists( 'NS_JWT' ) ) {
			return 0;
		}
		$token = NS_JWT::leer_token_de_request( $request );
		if ( ! $token ) {
			return 0;
		}
		$carga = NS_JWT::validar( $token );
		if ( ! $carga || ! isset( $carga['user_id'] ) ) {
			return 0;
		}
		$tipo = NS_JWT::tipo_de_carga( $carga );
		if ( ! in_array( $tipo, $tipos_aceptados, true ) ) {
			return 0;
		}
		return (int) $carga['user_id'];
	}

	private static function curador_user_id( WP_REST_Request $request ): int {
		$id_param = (int) $request->get_param( '_user_id' );
		if ( $id_param > 0 ) {
			return $id_param;
		}
		if ( is_user_logged_in() ) {
			return (int) get_current_user_id();
		}
		return 0;
	}

	private static function contar_aportaciones_dia( string $columna, string $valor ): int {
		global $wpdb;
		if ( ! in_array( $columna, array( 'token_dispositivo', 'ip_subida' ), true ) ) {
			return 0;
		}
		$tabla = NS_Esquema::nombre_tabla( 'fosiles_aportaciones' );
		// Ventana de 24h hacia atrás. Las aportaciones archivadas y
		// rechazadas siguen contando — el rate-limit es por dispositivo/IP,
		// no por estado final.
		$sql = "SELECT COUNT(*) FROM {$tabla} WHERE {$columna} = %s AND fecha_creacion >= (UTC_TIMESTAMP() - INTERVAL 1 DAY)";
		return (int) $wpdb->get_var( $wpdb->prepare( $sql, $valor ) );
	}

	/**
	 * Mueve la foto subida desde `$_FILES['foto']['tmp_name']` al
	 * directorio `wp-content/uploads/fosiles-comunidad/YYYY/MM/<sha256>.<ext>`.
	 * Si ya existe un blob con el mismo sha256, reusa la fila (dedupe).
	 */
	private static function persistir_foto( array $foto ) {
		global $wpdb;

		$tmp = (string) ( $foto['tmp_name'] ?? '' );
		if ( '' === $tmp || ! is_readable( $tmp ) ) {
			return self::error_validacion( 'foto_no_legible', 'No se pudo leer la foto subida.' );
		}
		$tamano = (int) ( $foto['size'] ?? 0 );
		if ( $tamano <= 0 || $tamano > self::MAX_FOTO_BYTES ) {
			return self::error_validacion(
				'foto_tamano_invalido',
				'La foto debe pesar entre 1 byte y ' . ( self::MAX_FOTO_BYTES / ( 1024 * 1024 ) ) . ' MB.'
			);
		}

		$mime = self::detectar_mime( $tmp, (string) ( $foto['name'] ?? '' ) );
		if ( ! in_array( $mime, array( 'image/jpeg', 'image/png' ), true ) ) {
			return self::error_validacion(
				'foto_mime_invalido',
				'La foto debe ser JPEG o PNG.'
			);
		}

		$sha256 = hash_file( 'sha256', $tmp );
		$tabla_blobs = NS_Esquema::nombre_tabla( 'fosiles_fotos_blob' );

		// Dedupe: si ya existe, devolver el id sin escribir disco.
		$existente = $wpdb->get_var(
			$wpdb->prepare( "SELECT id FROM {$tabla_blobs} WHERE sha256 = %s", $sha256 )
		);
		if ( $existente ) {
			return (int) $existente;
		}

		$ext         = 'image/png' === $mime ? 'png' : 'jpg';
		$uploads     = wp_upload_dir( null, true );
		if ( ! empty( $uploads['error'] ) ) {
			return new WP_Error(
				'ns_fosiles_uploads_error',
				'No se pudo acceder al directorio de uploads: ' . $uploads['error'],
				array( 'status' => 500 )
			);
		}
		$ano         = gmdate( 'Y' );
		$mes         = gmdate( 'm' );
		$relativa    = self::SUBDIR_UPLOADS . "/{$ano}/{$mes}/{$sha256}.{$ext}";
		$absoluta    = trailingslashit( $uploads['basedir'] ) . $relativa;
		$dir_destino = dirname( $absoluta );
		if ( ! wp_mkdir_p( $dir_destino ) ) {
			return new WP_Error(
				'ns_fosiles_mkdir_error',
				'No se pudo crear el directorio destino para la foto.',
				array( 'status' => 500 )
			);
		}

		if ( ! @move_uploaded_file( $tmp, $absoluta ) ) {
			// Fallback para CLI / tests donde no es upload real.
			if ( ! @copy( $tmp, $absoluta ) ) {
				return new WP_Error(
					'ns_fosiles_copy_error',
					'No se pudo guardar la foto.',
					array( 'status' => 500 )
				);
			}
		}
		@chmod( $absoluta, 0644 );

		// Dimensiones (opcional — getimagesize devuelve false si no es
		// imagen válida; en ese caso lo dejamos a 0).
		$ancho = 0;
		$alto  = 0;
		$dim   = @getimagesize( $absoluta );
		if ( is_array( $dim ) ) {
			$ancho = (int) ( $dim[0] ?? 0 );
			$alto  = (int) ( $dim[1] ?? 0 );
		}

		$wpdb->insert(
			$tabla_blobs,
			array(
				'ruta_archivo'  => $relativa,
				'mime'          => $mime,
				'sha256'        => $sha256,
				'tamano_bytes'  => $tamano,
				'ancho_px'      => $ancho,
				'alto_px'       => $alto,
				'thumbnail_ruta'=> '',
				'creado_en'     => gmdate( 'Y-m-d H:i:s' ),
			),
			array( '%s', '%s', '%s', '%d', '%d', '%d', '%s', '%s' )
		);

		return (int) $wpdb->insert_id;
	}

	private static function detectar_mime( string $ruta, string $nombre ): string {
		if ( function_exists( 'finfo_open' ) ) {
			$finfo = finfo_open( FILEINFO_MIME_TYPE );
			if ( $finfo ) {
				$mime = (string) finfo_file( $finfo, $ruta );
				finfo_close( $finfo );
				if ( '' !== $mime ) {
					return $mime;
				}
			}
		}
		$ext = strtolower( pathinfo( $nombre, PATHINFO_EXTENSION ) );
		if ( 'png' === $ext ) {
			return 'image/png';
		}
		return 'image/jpeg';
	}

	private static function base_url_uploads(): string {
		$uploads = wp_upload_dir( null, false );
		return trailingslashit( (string) $uploads['baseurl'] ) . self::SUBDIR_UPLOADS;
	}

	private static function borrar_archivo_upload( string $relativa ): void {
		if ( '' === $relativa ) {
			return;
		}
		$relativa = ltrim( $relativa, '/' );
		// Solo borramos rutas que comiencen por el subdir del módulo;
		// evita que una ruta absoluta colada por error toque ficheros
		// fuera del área de la comunidad.
		if ( ! str_starts_with( $relativa, self::SUBDIR_UPLOADS . '/' ) ) {
			return;
		}
		$uploads = wp_upload_dir( null, false );
		$abs     = trailingslashit( (string) $uploads['basedir'] ) . $relativa;
		if ( file_exists( $abs ) ) {
			@unlink( $abs );
		}
	}

	private static function ip_solicitud(): string {
		$ip = (string) ( $_SERVER['REMOTE_ADDR'] ?? '' );
		if ( '' === $ip ) {
			return '';
		}
		return substr( $ip, 0, 64 );
	}

	private static function recortar( $valor, int $max ): string {
		$texto = is_string( $valor ) ? $valor : (string) $valor;
		$texto = sanitize_text_field( $texto );
		if ( strlen( $texto ) > $max ) {
			$texto = substr( $texto, 0, $max );
		}
		return $texto;
	}

	private static function formacion_a_json( array $fila ): array {
		$regiones = array();
		if ( ! empty( $fila['regiones'] ) ) {
			$decodificado = json_decode( (string) $fila['regiones'], true );
			if ( is_array( $decodificado ) ) {
				$regiones = $decodificado;
			}
		}
		return array(
			'id'              => (int) $fila['id'],
			'codigo'          => (string) $fila['codigo'],
			'nombre_oficial'  => (string) $fila['nombre_oficial'],
			'periodo'         => (string) $fila['periodo'],
			'edad_aproximada' => (string) $fila['edad_aproximada'],
			'regiones'        => $regiones,
			'descripcion'     => (string) ( $fila['descripcion'] ?? '' ),
			'activo'          => (int) $fila['activo'] === 1,
		);
	}

	private static function error_validacion( string $codigo, string $mensaje, array $extra = array() ): WP_REST_Response {
		return new WP_REST_Response(
			array_merge(
				array( 'error' => $codigo, 'mensaje' => $mensaje ),
				$extra
			),
			400
		);
	}

	private static function respuesta_html( int $status, string $titulo, string $cuerpo ): WP_REST_Response {
		$html  = '<!doctype html><html lang="es"><head><meta charset="utf-8">';
		$html .= '<meta name="viewport" content="width=device-width, initial-scale=1">';
		$html .= '<title>' . esc_html( $titulo ) . '</title>';
		$html .= '<style>body{font-family:system-ui,sans-serif;max-width:560px;margin:4rem auto;padding:0 1rem;color:#2D3A2E;}h1{font-size:1.4rem;}</style>';
		$html .= '</head><body>';
		$html .= '<h1>' . esc_html( $titulo ) . '</h1>';
		$html .= $cuerpo;
		$html .= '</body></html>';

		$respuesta = new WP_REST_Response( $html, $status );
		$respuesta->header( 'Content-Type', 'text/html; charset=utf-8' );
		return $respuesta;
	}
}
