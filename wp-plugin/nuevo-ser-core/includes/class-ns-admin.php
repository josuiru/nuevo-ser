<?php
/**
 * Panel wp-admin del plugin Nuevo Ser Core. Permite al operador
 * gestionar tutores y niños desde la interfaz de WordPress sin tener
 * que invocar los endpoints REST con curl. Pensado para piloto:
 * sin paginación, sin filtros, sin búsquedas.
 *
 * **Acceso**: solo usuarios WordPress con capability `manage_options`
 * (admins por defecto). El plugin no añade roles propios — la
 * separación entre admins WP y usuarios del plugin (`ns_users`,
 * `ns_ninos`) se mantiene intacta.
 *
 * **Páginas**:
 * - Cuentas: lista de tutores con sus niños + formulario "crear
 *   cuenta nueva" + botón "borrar cuenta" con confirmación.
 * - Estado: indica si `NS_JWT_SECRET` y `NS_ANTHROPIC_KEY` están
 *   definidas (sin mostrar los valores) y enseña los conteos de
 *   tablas para diagnóstico.
 *
 * **Seguridad**: nonces en todos los formularios, sanitización de
 * inputs, capability check antes de cualquier mutación.
 *
 * @package NuevoSerCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class NS_Admin {

	private const SLUG_RAIZ     = 'nuevo-ser-core';
	private const SLUG_CUENTAS  = 'nuevo-ser-core';
	private const SLUG_ESTADO   = 'nuevo-ser-core-estado';
	private const NONCE_CREAR   = 'ns_admin_crear_cuenta';
	private const NONCE_BORRAR  = 'ns_admin_borrar_cuenta';

	/**
	 * Hook principal — registra menú + handlers POST.
	 */
	public static function registrar(): void {
		add_action( 'admin_menu', array( __CLASS__, 'anadir_menu' ) );
		add_action( 'admin_post_ns_crear_cuenta', array( __CLASS__, 'manejar_crear_cuenta' ) );
		add_action( 'admin_post_ns_borrar_cuenta', array( __CLASS__, 'manejar_borrar_cuenta' ) );
	}

	public static function anadir_menu(): void {
		add_menu_page(
			'Nuevo Ser Core',
			'Nuevo Ser Core',
			'manage_options',
			self::SLUG_CUENTAS,
			array( __CLASS__, 'pintar_cuentas' ),
			'dashicons-book',
			60
		);

		add_submenu_page(
			self::SLUG_RAIZ,
			'Cuentas',
			'Cuentas',
			'manage_options',
			self::SLUG_CUENTAS,
			array( __CLASS__, 'pintar_cuentas' )
		);

		add_submenu_page(
			self::SLUG_RAIZ,
			'Estado del plugin',
			'Estado',
			'manage_options',
			self::SLUG_ESTADO,
			array( __CLASS__, 'pintar_estado' )
		);
	}

	// =================================================================
	// Página: Cuentas
	// =================================================================

	public static function pintar_cuentas(): void {
		if ( ! current_user_can( 'manage_options' ) ) {
			wp_die( esc_html__( 'No tienes permiso para ver esta página.' ) );
		}

		$usuarios = NS_Repositorio::listar_usuarios_con_ninos();
		$mensaje  = isset( $_GET['ns_msg'] ) ? sanitize_text_field( wp_unslash( $_GET['ns_msg'] ) ) : '';
		?>
		<div class="wrap">
			<h1>Cuentas — Nuevo Ser Core</h1>

			<?php self::pintar_aviso( $mensaje ); ?>

			<h2>Cuentas existentes</h2>
			<?php if ( empty( $usuarios ) ) : ?>
				<p><em>Aún no hay cuentas. Crea la primera abajo.</em></p>
			<?php else : ?>
				<table class="widefat striped">
					<thead>
						<tr>
							<th>Tutor</th>
							<th>Email</th>
							<th>Locale</th>
							<th>Niños</th>
							<th>Creada</th>
							<th>Acciones</th>
						</tr>
					</thead>
					<tbody>
						<?php foreach ( $usuarios as $u ) : ?>
							<tr>
								<td><?php echo esc_html( $u['nombre_tutor'] ); ?></td>
								<td><code><?php echo esc_html( $u['email'] ); ?></code></td>
								<td><?php echo esc_html( $u['locale'] ); ?></td>
								<td>
									<?php if ( empty( $u['ninos'] ) ) : ?>
										<em>—</em>
									<?php else : ?>
										<?php
										$nombres = array_map(
											static function ( array $n ): string {
												return sprintf(
													'%s <small>(id %d)</small>',
													esc_html( $n['nombre_mostrar'] ),
													(int) $n['id']
												);
											},
											$u['ninos']
										);
										echo wp_kses(
											implode( '<br>', $nombres ),
											array( 'small' => array(), 'br' => array() )
										);
										?>
									<?php endif; ?>
								</td>
								<td><?php echo esc_html( $u['creado_en'] ); ?></td>
								<td>
									<form method="post" action="<?php echo esc_url( admin_url( 'admin-post.php' ) ); ?>"
										onsubmit="return confirm('¿Seguro que quieres borrar esta cuenta? Se borrarán también los niños asociados y su progreso. No se puede deshacer.');">
										<input type="hidden" name="action" value="ns_borrar_cuenta">
										<input type="hidden" name="usuario_id" value="<?php echo (int) $u['id']; ?>">
										<?php wp_nonce_field( self::NONCE_BORRAR ); ?>
										<button type="submit" class="button button-link-delete">Borrar</button>
									</form>
								</td>
							</tr>
						<?php endforeach; ?>
					</tbody>
				</table>
			<?php endif; ?>

			<h2 style="margin-top: 2em;">Crear cuenta nueva</h2>
			<p>
				Crea un tutor (persona adulta) y su primer niño en una
				sola operación. La pareja resultante se puede usar
				inmediatamente desde el cuaderno → Ajustes → Iniciar
				sesión, con el mismo email y password que pongas aquí.
			</p>
			<form method="post" action="<?php echo esc_url( admin_url( 'admin-post.php' ) ); ?>">
				<input type="hidden" name="action" value="ns_crear_cuenta">
				<?php wp_nonce_field( self::NONCE_CREAR ); ?>
				<table class="form-table" role="presentation">
					<tbody>
						<tr>
							<th scope="row"><label for="ns_email">Email del tutor</label></th>
							<td><input name="email" id="ns_email" type="email" class="regular-text" required></td>
						</tr>
						<tr>
							<th scope="row"><label for="ns_password">Password</label></th>
							<td>
								<input name="password" id="ns_password" type="password" class="regular-text" minlength="8" required>
								<p class="description">Mínimo 8 caracteres.</p>
							</td>
						</tr>
						<tr>
							<th scope="row"><label for="ns_nombre_tutor">Nombre del tutor</label></th>
							<td><input name="nombre_tutor" id="ns_nombre_tutor" type="text" class="regular-text" required></td>
						</tr>
						<tr>
							<th scope="row"><label for="ns_nombre_nino">Nombre del niño</label></th>
							<td><input name="nombre_nino" id="ns_nombre_nino" type="text" class="regular-text" required></td>
						</tr>
						<tr>
							<th scope="row"><label for="ns_locale">Locale</label></th>
							<td>
								<select name="locale" id="ns_locale">
									<option value="es" selected>es — castellano</option>
									<option value="eu">eu — euskera</option>
									<option value="ca">ca — catalán</option>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
				<?php submit_button( 'Crear cuenta' ); ?>
			</form>
		</div>
		<?php
	}

	// =================================================================
	// Página: Estado
	// =================================================================

	public static function pintar_estado(): void {
		if ( ! current_user_can( 'manage_options' ) ) {
			wp_die( esc_html__( 'No tienes permiso para ver esta página.' ) );
		}

		global $wpdb;
		$tabla_usuarios = NS_Esquema::nombre_tabla( 'usuarios' );
		$tabla_ninos    = NS_Esquema::nombre_tabla( 'ninos' );

		$total_usuarios = (int) $wpdb->get_var( "SELECT COUNT(*) FROM {$tabla_usuarios}" );
		$total_ninos    = (int) $wpdb->get_var( "SELECT COUNT(*) FROM {$tabla_ninos}" );
		?>
		<div class="wrap">
			<h1>Estado — Nuevo Ser Core</h1>

			<h2>Configuración crítica</h2>
			<table class="widefat striped">
				<tbody>
					<tr>
						<td><strong>Versión del plugin</strong></td>
						<td><code><?php echo esc_html( NS_CORE_VERSION ); ?></code></td>
					</tr>
					<tr>
						<td><strong>NS_JWT_SECRET</strong> en <code>wp-config.php</code></td>
						<td>
							<?php if ( defined( 'NS_JWT_SECRET' ) && '' !== NS_JWT_SECRET ) : ?>
								<span style="color: #2c8a3e;">✓ definida</span>
							<?php else : ?>
								<span style="color: #b32d2e;">✗ falta</span> —
								imprescindible para firmar tokens.
							<?php endif; ?>
						</td>
					</tr>
					<tr>
						<td><strong>NS_ANTHROPIC_KEY</strong> en <code>wp-config.php</code></td>
						<td>
							<?php if ( defined( 'NS_ANTHROPIC_KEY' ) && '' !== NS_ANTHROPIC_KEY ) : ?>
								<span style="color: #2c8a3e;">✓ definida</span> — el Tutor IA puede responder.
							<?php else : ?>
								<span style="color: #b32d2e;">✗ falta</span> —
								sin esta clave, <code>/tutor</code> devuelve error y el cliente cae al fallback canónico.
							<?php endif; ?>
						</td>
					</tr>
				</tbody>
			</table>

			<h2 style="margin-top: 2em;">Tablas</h2>
			<table class="widefat striped">
				<thead>
					<tr>
						<th>Tabla</th>
						<th>Filas</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><code><?php echo esc_html( $tabla_usuarios ); ?></code></td>
						<td><?php echo (int) $total_usuarios; ?></td>
					</tr>
					<tr>
						<td><code><?php echo esc_html( $tabla_ninos ); ?></code></td>
						<td><?php echo (int) $total_ninos; ?></td>
					</tr>
				</tbody>
			</table>

			<h2 style="margin-top: 2em;">Endpoints expuestos</h2>
			<p>
				Namespace canónico: <code>/wp-json/nuevo-ser/v1/*</code>.
				Alias deprecado: <code>/wp-json/uno-roto/v1/*</code> (vivo
				hasta v1.5).
			</p>
		</div>
		<?php
	}

	// =================================================================
	// Handlers POST
	// =================================================================

	public static function manejar_crear_cuenta(): void {
		if ( ! current_user_can( 'manage_options' ) ) {
			wp_die( esc_html__( 'No tienes permiso.' ) );
		}
		check_admin_referer( self::NONCE_CREAR );

		$email        = sanitize_email( (string) ( $_POST['email'] ?? '' ) );
		$password     = (string) ( $_POST['password'] ?? '' );
		$nombre_tutor = sanitize_text_field( (string) ( $_POST['nombre_tutor'] ?? '' ) );
		$nombre_nino  = sanitize_text_field( (string) ( $_POST['nombre_nino'] ?? '' ) );
		$locale       = sanitize_text_field( (string) ( $_POST['locale'] ?? 'es' ) );

		if ( ! is_email( $email ) || strlen( $password ) < 8 || '' === $nombre_nino ) {
			self::redirigir_con_mensaje( 'invalido' );
			return;
		}

		if ( NS_Repositorio::buscar_usuario_por_email( $email ) ) {
			self::redirigir_con_mensaje( 'duplicado' );
			return;
		}

		$usuario_id = NS_Repositorio::crear_usuario(
			$email,
			password_hash( $password, PASSWORD_DEFAULT ),
			$nombre_tutor,
			$locale
		);
		NS_Repositorio::crear_nino( $usuario_id, $nombre_nino, $locale );

		self::redirigir_con_mensaje( 'creada' );
	}

	public static function manejar_borrar_cuenta(): void {
		if ( ! current_user_can( 'manage_options' ) ) {
			wp_die( esc_html__( 'No tienes permiso.' ) );
		}
		check_admin_referer( self::NONCE_BORRAR );

		$usuario_id = isset( $_POST['usuario_id'] ) ? (int) $_POST['usuario_id'] : 0;
		if ( $usuario_id <= 0 ) {
			self::redirigir_con_mensaje( 'invalido' );
			return;
		}

		NS_Repositorio::borrar_cuenta( $usuario_id );
		self::redirigir_con_mensaje( 'borrada' );
	}

	// =================================================================
	// Helpers
	// =================================================================

	private static function redirigir_con_mensaje( string $codigo ): void {
		$url = add_query_arg(
			array(
				'page'   => self::SLUG_CUENTAS,
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
			'creada'    => array( 'updated', 'Cuenta creada. Ya puedes iniciar sesión desde el cuaderno con ese email + password.' ),
			'borrada'   => array( 'updated', 'Cuenta borrada (junto con sus niños y su progreso).' ),
			'invalido'  => array( 'error', 'Datos inválidos. Revisa email, password (≥ 8 caracteres) y nombre del niño.' ),
			'duplicado' => array( 'error', 'Ese email ya está registrado.' ),
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
