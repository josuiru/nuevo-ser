<?php
/**
 * Panel wp-admin para curadores de Fósiles.
 *
 * Aterrizan en `/wp-admin/admin.php?page=fosiles-aportaciones` después
 * de hacer login en wp-login.php con su cuenta WordPress (rol
 * `nuevoser_curador_fosiles` o `nuevoser_admin_fosiles`).
 *
 * Tres páginas:
 *
 *   - "Aportaciones" — lista paginada por estado (pendiente por
 *     defecto), con thumbnail + datos declarados.
 *   - "Revisar" — visible solo cuando llegas con `?id=N`. Formulario
 *     con campos curados + selector de formación + botones aprobar /
 *     rechazar / archivar.
 *   - "Catálogo" — CRUD básico de formaciones (solo capability
 *     `nuevoser_fosiles_gestionar_catalogo`).
 *
 * @package NuevoSerCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class NS_Fosiles_Admin {

	private const SLUG_RAIZ          = 'fosiles-aportaciones';
	private const SLUG_REVISAR       = 'fosiles-revisar';
	private const SLUG_CATALOGO      = 'fosiles-catalogo';
	private const NONCE_REVISAR      = 'ns_fosiles_revisar';
	private const NONCE_CATALOGO     = 'ns_fosiles_catalogo';

	public static function registrar(): void {
		add_action( 'admin_menu', array( __CLASS__, 'anadir_menu' ) );
		add_action( 'admin_post_ns_fosiles_revisar', array( __CLASS__, 'manejar_revisar' ) );
		add_action( 'admin_post_ns_fosiles_catalogo', array( __CLASS__, 'manejar_catalogo' ) );
	}

	public static function anadir_menu(): void {
		add_menu_page(
			'Fósiles · Comunidad',
			'Fósiles',
			'nuevoser_fosiles_revisar',
			self::SLUG_RAIZ,
			array( __CLASS__, 'pintar_aportaciones' ),
			'dashicons-search',
			62
		);

		add_submenu_page(
			self::SLUG_RAIZ,
			'Aportaciones',
			'Aportaciones',
			'nuevoser_fosiles_revisar',
			self::SLUG_RAIZ,
			array( __CLASS__, 'pintar_aportaciones' )
		);

		add_submenu_page(
			self::SLUG_RAIZ,
			'Revisar aportación',
			'Revisar',
			'nuevoser_fosiles_revisar',
			self::SLUG_REVISAR,
			array( __CLASS__, 'pintar_revisar' )
		);

		add_submenu_page(
			self::SLUG_RAIZ,
			'Catálogo de formaciones',
			'Catálogo',
			'nuevoser_fosiles_gestionar_catalogo',
			self::SLUG_CATALOGO,
			array( __CLASS__, 'pintar_catalogo' )
		);
	}

	// =================================================================
	// Página: Aportaciones (lista)
	// =================================================================

	public static function pintar_aportaciones(): void {
		if ( ! current_user_can( 'nuevoser_fosiles_revisar' ) ) {
			wp_die( esc_html__( 'No tienes permiso para ver esta página.' ) );
		}

		global $wpdb;
		$tabla_aportac = NS_Esquema::nombre_tabla( 'fosiles_aportaciones' );
		$tabla_blobs   = NS_Esquema::nombre_tabla( 'fosiles_fotos_blob' );

		$estado_seleccionado = isset( $_GET['estado'] ) ? sanitize_text_field( wp_unslash( $_GET['estado'] ) ) : 'pendiente';
		if ( ! in_array( $estado_seleccionado, NS_Fosiles_Comunidad::ESTADOS_VALIDOS, true ) ) {
			$estado_seleccionado = 'pendiente';
		}

		$pag        = max( 1, isset( $_GET['pag'] ) ? (int) $_GET['pag'] : 1 );
		$por_pagina = 20;
		$offset     = ( $pag - 1 ) * $por_pagina;

		$total = (int) $wpdb->get_var(
			$wpdb->prepare(
				"SELECT COUNT(*) FROM {$tabla_aportac} WHERE estado = %s",
				$estado_seleccionado
			)
		);
		$filas = $wpdb->get_results(
			$wpdb->prepare(
				"SELECT a.*, b.ruta_archivo, b.thumbnail_ruta
				   FROM {$tabla_aportac} a
				   JOIN {$tabla_blobs} b ON b.id = a.foto_blob_id
				  WHERE a.estado = %s
				  ORDER BY a.fecha_creacion DESC
				  LIMIT %d OFFSET %d",
				$estado_seleccionado,
				$por_pagina,
				$offset
			),
			ARRAY_A
		);
		$base_url = self::base_url_uploads();

		$mensaje = isset( $_GET['ns_msg'] ) ? sanitize_text_field( wp_unslash( $_GET['ns_msg'] ) ) : '';
		?>
		<div class="wrap">
			<h1>Aportaciones de la comunidad</h1>

			<?php self::pintar_aviso( $mensaje ); ?>

			<p>
				<?php
				$enlaces = array();
				foreach ( NS_Fosiles_Comunidad::ESTADOS_VALIDOS as $estado ) {
					$url    = add_query_arg(
						array( 'page' => self::SLUG_RAIZ, 'estado' => $estado ),
						admin_url( 'admin.php' )
					);
					$activo = $estado === $estado_seleccionado;
					$enlaces[] = sprintf(
						'<a href="%s"%s>%s</a>',
						esc_url( $url ),
						$activo ? ' class="current" style="font-weight:bold;"' : '',
						esc_html( ucfirst( $estado ) )
					);
				}
				echo wp_kses(
					implode( ' &middot; ', $enlaces ),
					array( 'a' => array( 'href' => array(), 'class' => array(), 'style' => array() ) )
				);
				?>
			</p>

			<?php if ( empty( $filas ) ) : ?>
				<p><em>No hay aportaciones en estado <strong><?php echo esc_html( $estado_seleccionado ); ?></strong>.</em></p>
			<?php else : ?>
				<table class="widefat striped">
					<thead>
						<tr>
							<th style="width:120px;">Foto</th>
							<th>Datos declarados</th>
							<th>Contacto</th>
							<th>Recibida</th>
							<th>Acción</th>
						</tr>
					</thead>
					<tbody>
						<?php foreach ( $filas as $fila ) : ?>
							<?php
							$ruta_thumb = '' !== (string) $fila['thumbnail_ruta']
								? (string) $fila['thumbnail_ruta']
								: (string) $fila['ruta_archivo'];
							$foto_url   = $base_url . '/' . ltrim( $ruta_thumb, '/' );
							$revisar_url = add_query_arg(
								array(
									'page' => self::SLUG_REVISAR,
									'id'   => (int) $fila['id'],
								),
								admin_url( 'admin.php' )
							);
							?>
							<tr>
								<td>
									<a href="<?php echo esc_url( $revisar_url ); ?>">
										<img src="<?php echo esc_url( $foto_url ); ?>" alt="foto" style="max-width:100px;max-height:100px;object-fit:cover;border:1px solid #ddd;">
									</a>
								</td>
								<td>
									<strong><?php echo esc_html( ucfirst( (string) $fila['tipo'] ) ); ?></strong>
									<?php if ( '' !== (string) $fila['especie_declarada'] ) : ?>
										&middot; <?php echo esc_html( $fila['especie_declarada'] ); ?>
									<?php endif; ?>
									<br>
									<small>
										<?php if ( '' !== (string) $fila['edad_declarada'] ) : ?>
											Edad: <?php echo esc_html( $fila['edad_declarada'] ); ?><br>
										<?php endif; ?>
										<?php if ( '' !== (string) $fila['formacion_declarada'] ) : ?>
											Formación: <?php echo esc_html( $fila['formacion_declarada'] ); ?><br>
										<?php endif; ?>
										<?php if ( '' !== (string) $fila['notas_aficionado'] ) : ?>
											<em><?php echo esc_html( wp_trim_words( (string) $fila['notas_aficionado'], 24 ) ); ?></em>
										<?php endif; ?>
									</small>
								</td>
								<td>
									<small>
										<code><?php echo esc_html( $fila['email_contacto'] ); ?></code>
										<?php if ( '' !== (string) $fila['nombre_contacto'] ) : ?>
											<br><?php echo esc_html( $fila['nombre_contacto'] ); ?>
										<?php endif; ?>
									</small>
								</td>
								<td><small><?php echo esc_html( $fila['fecha_creacion'] ); ?></small></td>
								<td>
									<a class="button button-primary" href="<?php echo esc_url( $revisar_url ); ?>">Revisar</a>
								</td>
							</tr>
						<?php endforeach; ?>
					</tbody>
				</table>

				<?php self::pintar_paginacion( $pag, $por_pagina, $total, $estado_seleccionado ); ?>
			<?php endif; ?>
		</div>
		<?php
	}

	// =================================================================
	// Página: Revisar aportación individual
	// =================================================================

	public static function pintar_revisar(): void {
		if ( ! current_user_can( 'nuevoser_fosiles_revisar' ) ) {
			wp_die( esc_html__( 'No tienes permiso para ver esta página.' ) );
		}

		$id = isset( $_GET['id'] ) ? (int) $_GET['id'] : 0;
		if ( $id <= 0 ) {
			echo '<div class="wrap"><h1>Revisar aportación</h1>'
				. '<p>Selecciona una aportación desde la lista.</p></div>';
			return;
		}

		global $wpdb;
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
			echo '<div class="wrap"><h1>Revisar aportación</h1>'
				. '<p>No se encontró la aportación.</p></div>';
			return;
		}

		$base_url   = self::base_url_uploads();
		$foto_url   = $base_url . '/' . ltrim( (string) $fila['ruta_archivo'], '/' );
		$formaciones = self::cargar_formaciones_activas();
		?>
		<div class="wrap">
			<h1>Revisar aportación #<?php echo (int) $fila['id']; ?>
				<a href="<?php echo esc_url( admin_url( 'admin.php?page=' . self::SLUG_RAIZ ) ); ?>" class="page-title-action">← Volver a la lista</a>
			</h1>

			<p>
				<strong>Estado:</strong> <?php echo esc_html( $fila['estado'] ); ?>
				&middot; <strong>Recibida:</strong> <?php echo esc_html( $fila['fecha_creacion'] ); ?>
				<?php if ( ! empty( $fila['fecha_revision'] ) ) : ?>
					&middot; <strong>Revisada:</strong> <?php echo esc_html( $fila['fecha_revision'] ); ?>
				<?php endif; ?>
			</p>

			<div style="display:flex;gap:2em;flex-wrap:wrap;">
				<div style="flex:1;min-width:320px;">
					<h2>Foto</h2>
					<a href="<?php echo esc_url( $foto_url ); ?>" target="_blank">
						<img src="<?php echo esc_url( $foto_url ); ?>" alt="foto del hallazgo" style="max-width:100%;height:auto;border:1px solid #ddd;">
					</a>
					<p>
						<small>
							<?php echo (int) $fila['ancho_px']; ?> × <?php echo (int) $fila['alto_px']; ?> px
							&middot; <?php echo esc_html( size_format( (int) $fila['tamano_bytes'] ) ); ?>
						</small>
					</p>
					<h3>Datos declarados</h3>
					<table class="widefat">
						<tbody>
							<tr><th>Tipo</th><td><?php echo esc_html( $fila['tipo'] ); ?></td></tr>
							<tr><th>Especie</th><td><?php echo esc_html( $fila['especie_declarada'] ); ?></td></tr>
							<tr><th>Edad</th><td><?php echo esc_html( $fila['edad_declarada'] ); ?></td></tr>
							<tr><th>Formación</th><td><?php echo esc_html( $fila['formacion_declarada'] ); ?></td></tr>
							<tr><th>Notas</th><td><?php echo esc_html( $fila['notas_aficionado'] ?? '' ); ?></td></tr>
							<tr><th>Email contacto</th><td><code><?php echo esc_html( $fila['email_contacto'] ); ?></code></td></tr>
							<tr><th>Nombre contacto</th><td><?php echo esc_html( $fila['nombre_contacto'] ); ?></td></tr>
						</tbody>
					</table>
				</div>

				<div style="flex:1;min-width:320px;">
					<h2>Curaduría</h2>
					<form method="post" action="<?php echo esc_url( admin_url( 'admin-post.php' ) ); ?>">
						<input type="hidden" name="action" value="ns_fosiles_revisar">
						<input type="hidden" name="aportacion_id" value="<?php echo (int) $fila['id']; ?>">
						<?php wp_nonce_field( self::NONCE_REVISAR ); ?>

						<table class="form-table" role="presentation">
							<tbody>
								<tr>
									<th scope="row"><label for="ns_formacion">Formación catalogada</label></th>
									<td>
										<select name="formacion_catalogada_id" id="ns_formacion">
											<option value="0">— Selecciona —</option>
											<?php foreach ( $formaciones as $f ) : ?>
												<option value="<?php echo (int) $f['id']; ?>"
													<?php selected( (int) ( $fila['formacion_catalogada_id'] ?? 0 ), (int) $f['id'] ); ?>>
													<?php echo esc_html( $f['nombre_oficial'] ); ?>
													(<?php echo esc_html( $f['codigo'] ); ?>)
												</option>
											<?php endforeach; ?>
										</select>
										<p class="description">
											Si no encuentras la formación adecuada, créala desde
											<a href="<?php echo esc_url( admin_url( 'admin.php?page=' . self::SLUG_CATALOGO ) ); ?>">Catálogo</a>
											y vuelve aquí.
										</p>
									</td>
								</tr>
								<tr>
									<th scope="row"><label for="ns_especie_curada">Especie curada</label></th>
									<td>
										<input name="especie_curada" id="ns_especie_curada" type="text" class="regular-text" value="<?php echo esc_attr( $fila['especie_curada'] ?: $fila['especie_declarada'] ); ?>">
									</td>
								</tr>
								<tr>
									<th scope="row"><label for="ns_edad_curada">Edad curada</label></th>
									<td>
										<input name="edad_curada" id="ns_edad_curada" type="text" class="regular-text" value="<?php echo esc_attr( $fila['edad_curada'] ?: $fila['edad_declarada'] ); ?>">
									</td>
								</tr>
								<tr>
									<th scope="row"><label for="ns_comentarios">Comentarios del curador</label></th>
									<td>
										<textarea name="comentarios" id="ns_comentarios" rows="5" class="large-text"><?php echo esc_textarea( $fila['comentarios_curador'] ?? '' ); ?></textarea>
										<p class="description">Aparecerá en la app debajo de la foto. Tono divulgativo.</p>
									</td>
								</tr>
								<tr>
									<th scope="row"><label for="ns_motivo">Motivo (solo si rechazas)</label></th>
									<td>
										<textarea name="motivo_rechazo" id="ns_motivo" rows="3" class="large-text"><?php echo esc_textarea( $fila['motivo_rechazo'] ?? '' ); ?></textarea>
										<p class="description">Se envía por email al aficionado si pulsas "Rechazar".</p>
									</td>
								</tr>
							</tbody>
						</table>

						<p>
							<button type="submit" name="decision" value="aprobar" class="button button-primary">Aprobar</button>
							<button type="submit" name="decision" value="rechazar" class="button">Rechazar</button>
							<button type="submit" name="decision" value="archivar" class="button"
								onclick="return confirm('Archivar sin notificar al aficionado. ¿Continuar?');">Archivar</button>
						</p>
					</form>
				</div>
			</div>
		</div>
		<?php
	}

	// =================================================================
	// Página: Catálogo de formaciones
	// =================================================================

	public static function pintar_catalogo(): void {
		if ( ! current_user_can( 'nuevoser_fosiles_gestionar_catalogo' ) ) {
			wp_die( esc_html__( 'No tienes permiso para gestionar el catálogo.' ) );
		}

		global $wpdb;
		$tabla = NS_Esquema::nombre_tabla( 'fosiles_formaciones_catalogadas' );
		$filas = $wpdb->get_results( "SELECT * FROM {$tabla} ORDER BY nombre_oficial ASC", ARRAY_A );

		$mensaje = isset( $_GET['ns_msg'] ) ? sanitize_text_field( wp_unslash( $_GET['ns_msg'] ) ) : '';
		?>
		<div class="wrap">
			<h1>Catálogo de formaciones</h1>

			<?php self::pintar_aviso( $mensaje ); ?>

			<p>
				El catálogo limita qué formaciones puede elegir un curador
				al aprobar una aportación. Espejo de
				<code>apps/fosiles/lib/datos/formacion_a_fosiles.dart</code>;
				si añades formaciones nuevas, considera reflejarlas allí
				para que el motor de sugerencias las use.
			</p>

			<h2>Formaciones existentes</h2>
			<?php if ( empty( $filas ) ) : ?>
				<p><em>Aún no hay formaciones catalogadas.</em></p>
			<?php else : ?>
				<table class="widefat striped">
					<thead>
						<tr>
							<th>Código</th>
							<th>Nombre oficial</th>
							<th>Período</th>
							<th>Edad</th>
							<th>Activa</th>
							<th>Acciones</th>
						</tr>
					</thead>
					<tbody>
						<?php foreach ( $filas as $fila ) : ?>
							<tr>
								<td><code><?php echo esc_html( $fila['codigo'] ); ?></code></td>
								<td><?php echo esc_html( $fila['nombre_oficial'] ); ?></td>
								<td><?php echo esc_html( $fila['periodo'] ); ?></td>
								<td><?php echo esc_html( $fila['edad_aproximada'] ); ?></td>
								<td><?php echo (int) $fila['activo'] === 1 ? '✓' : '—'; ?></td>
								<td>
									<form method="post" action="<?php echo esc_url( admin_url( 'admin-post.php' ) ); ?>" style="display:inline;">
										<input type="hidden" name="action" value="ns_fosiles_catalogo">
										<input type="hidden" name="operacion" value="toggle">
										<input type="hidden" name="formacion_id" value="<?php echo (int) $fila['id']; ?>">
										<?php wp_nonce_field( self::NONCE_CATALOGO ); ?>
										<button type="submit" class="button button-small">
											<?php echo (int) $fila['activo'] === 1 ? 'Desactivar' : 'Activar'; ?>
										</button>
									</form>
								</td>
							</tr>
						<?php endforeach; ?>
					</tbody>
				</table>
			<?php endif; ?>

			<h2 style="margin-top: 2em;">Crear nueva formación</h2>
			<form method="post" action="<?php echo esc_url( admin_url( 'admin-post.php' ) ); ?>">
				<input type="hidden" name="action" value="ns_fosiles_catalogo">
				<input type="hidden" name="operacion" value="crear">
				<?php wp_nonce_field( self::NONCE_CATALOGO ); ?>
				<table class="form-table" role="presentation">
					<tbody>
						<tr>
							<th scope="row"><label for="cat_codigo">Código (slug)</label></th>
							<td>
								<input name="codigo" id="cat_codigo" type="text" class="regular-text" required pattern="[a-z0-9\-]+">
								<p class="description">Ej. <code>calizas-urgonianas-aralar</code>. Solo minúsculas, números y guiones. Es la clave que la app usa para localizar la formación.</p>
							</td>
						</tr>
						<tr>
							<th scope="row"><label for="cat_nombre">Nombre oficial</label></th>
							<td><input name="nombre_oficial" id="cat_nombre" type="text" class="regular-text" required></td>
						</tr>
						<tr>
							<th scope="row"><label for="cat_periodo">Período</label></th>
							<td><input name="periodo" id="cat_periodo" type="text" class="regular-text" placeholder="Ej. Cretácico inferior"></td>
						</tr>
						<tr>
							<th scope="row"><label for="cat_edad">Edad aproximada</label></th>
							<td><input name="edad_aproximada" id="cat_edad" type="text" class="regular-text" placeholder="Ej. 125–115 Ma"></td>
						</tr>
						<tr>
							<th scope="row"><label for="cat_desc">Descripción</label></th>
							<td><textarea name="descripcion" id="cat_desc" rows="4" class="large-text"></textarea></td>
						</tr>
						<tr>
							<th scope="row">¿Activa?</th>
							<td><label><input type="checkbox" name="activo" value="1" checked> Visible para curadores</label></td>
						</tr>
					</tbody>
				</table>
				<?php submit_button( 'Crear formación' ); ?>
			</form>
		</div>
		<?php
	}

	// =================================================================
	// Handlers POST
	// =================================================================

	public static function manejar_revisar(): void {
		if ( ! current_user_can( 'nuevoser_fosiles_revisar' ) ) {
			wp_die( esc_html__( 'No tienes permiso.' ) );
		}
		check_admin_referer( self::NONCE_REVISAR );

		$id        = isset( $_POST['aportacion_id'] ) ? (int) $_POST['aportacion_id'] : 0;
		$decision  = isset( $_POST['decision'] ) ? sanitize_text_field( wp_unslash( $_POST['decision'] ) ) : '';
		if ( $id <= 0 || ! in_array( $decision, array( 'aprobar', 'rechazar', 'archivar' ), true ) ) {
			self::redirigir_lista_con_mensaje( 'invalido' );
			return;
		}

		$cuerpo_json = array();
		if ( 'aprobar' === $decision ) {
			$cuerpo_json = array(
				'formacion_catalogada_id' => isset( $_POST['formacion_catalogada_id'] ) ? (int) $_POST['formacion_catalogada_id'] : 0,
				'especie_curada'          => sanitize_text_field( wp_unslash( (string) ( $_POST['especie_curada'] ?? '' ) ) ),
				'edad_curada'             => sanitize_text_field( wp_unslash( (string) ( $_POST['edad_curada'] ?? '' ) ) ),
				'comentarios'             => sanitize_textarea_field( wp_unslash( (string) ( $_POST['comentarios'] ?? '' ) ) ),
			);
		} elseif ( 'rechazar' === $decision ) {
			$motivo = sanitize_textarea_field( wp_unslash( (string) ( $_POST['motivo_rechazo'] ?? '' ) ) );
			if ( '' === $motivo ) {
				self::redirigir_revisar_con_mensaje( $id, 'motivo_requerido' );
				return;
			}
			$cuerpo_json = array( 'motivo' => $motivo );
		}

		// Invocar el mismo handler REST internamente. Pasa por
		// validación y emails de notificación.
		$request = new WP_REST_Request(
			'aprobar' === $decision ? 'POST' : 'POST',
			'/nuevo-ser/v1/fosiles/aportaciones/' . $id . '/' . $decision
		);
		$request->set_param( 'id', $id );
		$request->set_body( wp_json_encode( $cuerpo_json ) );
		$request->set_header( 'Content-Type', 'application/json' );

		$metodo = 'aprobar' === $decision ? 'aprobar_aportacion'
			: ( 'rechazar' === $decision ? 'rechazar_aportacion' : 'archivar_aportacion' );
		$respuesta = NS_Fosiles_Comunidad::$metodo( $request );

		$status = $respuesta instanceof WP_REST_Response ? $respuesta->get_status() : 500;
		if ( $status >= 200 && $status < 300 ) {
			self::redirigir_lista_con_mensaje( $decision );
			return;
		}

		$data    = $respuesta instanceof WP_REST_Response ? $respuesta->get_data() : array();
		$codigo  = is_array( $data ) && isset( $data['error'] ) ? (string) $data['error'] : 'error';
		self::redirigir_revisar_con_mensaje( $id, $codigo );
	}

	public static function manejar_catalogo(): void {
		if ( ! current_user_can( 'nuevoser_fosiles_gestionar_catalogo' ) ) {
			wp_die( esc_html__( 'No tienes permiso.' ) );
		}
		check_admin_referer( self::NONCE_CATALOGO );

		global $wpdb;
		$tabla = NS_Esquema::nombre_tabla( 'fosiles_formaciones_catalogadas' );

		$operacion = sanitize_text_field( wp_unslash( (string) ( $_POST['operacion'] ?? '' ) ) );

		if ( 'crear' === $operacion ) {
			$codigo = sanitize_text_field( wp_unslash( (string) ( $_POST['codigo'] ?? '' ) ) );
			$nombre = sanitize_text_field( wp_unslash( (string) ( $_POST['nombre_oficial'] ?? '' ) ) );
			if ( '' === $codigo || '' === $nombre || ! preg_match( '/^[a-z0-9\-]+$/', $codigo ) ) {
				self::redirigir_catalogo_con_mensaje( 'invalido' );
				return;
			}
			$insertado = $wpdb->insert(
				$tabla,
				array(
					'codigo'          => $codigo,
					'nombre_oficial'  => $nombre,
					'periodo'         => sanitize_text_field( wp_unslash( (string) ( $_POST['periodo'] ?? '' ) ) ),
					'edad_aproximada' => sanitize_text_field( wp_unslash( (string) ( $_POST['edad_aproximada'] ?? '' ) ) ),
					'descripcion'     => sanitize_textarea_field( wp_unslash( (string) ( $_POST['descripcion'] ?? '' ) ) ),
					'activo'          => empty( $_POST['activo'] ) ? 0 : 1,
				),
				array( '%s', '%s', '%s', '%s', '%s', '%d' )
			);
			self::redirigir_catalogo_con_mensaje( false === $insertado ? 'duplicado' : 'creada' );
			return;
		}

		if ( 'toggle' === $operacion ) {
			$id = isset( $_POST['formacion_id'] ) ? (int) $_POST['formacion_id'] : 0;
			if ( $id <= 0 ) {
				self::redirigir_catalogo_con_mensaje( 'invalido' );
				return;
			}
			$activo_actual = (int) $wpdb->get_var( $wpdb->prepare( "SELECT activo FROM {$tabla} WHERE id = %d", $id ) );
			$wpdb->update(
				$tabla,
				array( 'activo' => 1 === $activo_actual ? 0 : 1 ),
				array( 'id' => $id ),
				array( '%d' ),
				array( '%d' )
			);
			self::redirigir_catalogo_con_mensaje( 'toggled' );
			return;
		}

		self::redirigir_catalogo_con_mensaje( 'invalido' );
	}

	// =================================================================
	// Helpers
	// =================================================================

	private static function cargar_formaciones_activas(): array {
		global $wpdb;
		$tabla = NS_Esquema::nombre_tabla( 'fosiles_formaciones_catalogadas' );
		$filas = $wpdb->get_results(
			"SELECT id, codigo, nombre_oficial FROM {$tabla} WHERE activo = 1 ORDER BY nombre_oficial ASC",
			ARRAY_A
		);
		return is_array( $filas ) ? $filas : array();
	}

	private static function base_url_uploads(): string {
		$uploads = wp_upload_dir( null, false );
		return trailingslashit( (string) $uploads['baseurl'] ) . 'fosiles-comunidad';
	}

	private static function pintar_paginacion( int $pag, int $por_pagina, int $total, string $estado ): void {
		$total_paginas = (int) ceil( $total / $por_pagina );
		if ( $total_paginas <= 1 ) {
			return;
		}
		echo '<p style="margin-top:1em;">Página ';
		for ( $i = 1; $i <= $total_paginas; $i++ ) {
			$url = add_query_arg(
				array(
					'page'   => self::SLUG_RAIZ,
					'estado' => $estado,
					'pag'    => $i,
				),
				admin_url( 'admin.php' )
			);
			if ( $i === $pag ) {
				printf( '<strong>%d</strong> ', $i );
			} else {
				printf( '<a href="%s">%d</a> ', esc_url( $url ), $i );
			}
		}
		echo '</p>';
	}

	private static function redirigir_lista_con_mensaje( string $codigo ): void {
		$url = add_query_arg(
			array(
				'page'   => self::SLUG_RAIZ,
				'ns_msg' => $codigo,
			),
			admin_url( 'admin.php' )
		);
		wp_safe_redirect( $url );
		exit;
	}

	private static function redirigir_revisar_con_mensaje( int $id, string $codigo ): void {
		$url = add_query_arg(
			array(
				'page'   => self::SLUG_REVISAR,
				'id'     => $id,
				'ns_msg' => $codigo,
			),
			admin_url( 'admin.php' )
		);
		wp_safe_redirect( $url );
		exit;
	}

	private static function redirigir_catalogo_con_mensaje( string $codigo ): void {
		$url = add_query_arg(
			array(
				'page'   => self::SLUG_CATALOGO,
				'ns_msg' => $codigo,
			),
			admin_url( 'admin.php' )
		);
		wp_safe_redirect( $url );
		exit;
	}

	private static function pintar_aviso( string $codigo ): void {
		if ( '' === $codigo ) {
			return;
		}
		$mensajes = array(
			'aprobar'                 => array( 'updated', 'Aportación aprobada. Aficionado notificado por email.' ),
			'rechazar'                => array( 'updated', 'Aportación rechazada. Aficionado notificado por email.' ),
			'archivar'                => array( 'updated', 'Aportación archivada (sin notificar al aficionado).' ),
			'creada'                  => array( 'updated', 'Formación creada en el catálogo.' ),
			'duplicado'               => array( 'error', 'Ese código ya existe en el catálogo. Elige otro.' ),
			'toggled'                 => array( 'updated', 'Estado de la formación cambiado.' ),
			'invalido'                => array( 'error', 'Datos inválidos.' ),
			'motivo_requerido'        => array( 'error', 'Para rechazar tienes que escribir un motivo.' ),
			'formacion_catalogada_requerida' => array( 'error', 'Para aprobar tienes que seleccionar una formación catalogada.' ),
			'formacion_no_existe'     => array( 'error', 'La formación seleccionada no existe o está desactivada.' ),
		);
		if ( ! isset( $mensajes[ $codigo ] ) ) {
			return;
		}
		[ $clase, $texto ] = $mensajes[ $codigo ];
		printf(
			'<div class="notice notice-%s is-dismissible"><p>%s</p></div>',
			esc_attr( $clase ),
			esc_html( $texto )
		);
	}
}
