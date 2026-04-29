<?php
/**
 * Lógica del flujo "He olvidado mi contraseña".
 *
 *   solicitar_reset(email): genera un token aleatorio, guarda su hash
 *     en BD con expiración 30 min, envía email al usuario con link
 *     `https://<sitio>/wp-json/nuevo-ser/v1/auth/pagina-reset?token=...`.
 *     Si el email no existe en la BD devuelve 200 igualmente — política
 *     anti-enumeración: que un atacante no pueda saber qué emails
 *     tenemos registrados.
 *
 *   usar_reset(token, nueva_password): valida el hash, comprueba que
 *     no esté expirado ni usado, hashea la nueva password y la guarda
 *     en `uroto_usuarios`. Marca el token como usado.
 *
 * Rate limit muy básico: máximo 3 emisiones por usuario en 15 minutos.
 *
 * @package NuevoSerCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class NS_Reset_Password {

	/** Vida útil del token: 30 minutos. */
	private const TTL_SEGUNDOS = 30 * 60;

	/** Tope de tokens emitidos por usuario en una ventana de 15 min. */
	private const TOPE_EMISIONES_POR_VENTANA = 3;
	private const VENTANA_RATE_LIMIT_SEGUNDOS = 15 * 60;

	/**
	 * Solicita reset para [email]. Devuelve siempre `true` (la app no
	 * debe poder distinguir entre email existente y no existente).
	 *
	 * Si rate-limit golpea, devuelve `false` para que el llamador
	 * pueda registrar el evento — la respuesta al cliente sigue siendo
	 * 200 OK.
	 */
	public static function solicitar( string $email ): bool {
		$usuario = NS_Repositorio::buscar_usuario_por_email( $email );
		if ( ! $usuario ) {
			return true; // anti-enumeración
		}

		if ( self::sobre_limite_de_emisiones( (int) $usuario['id'] ) ) {
			return false;
		}

		// 32 bytes random → 64 chars hex. Lo que viaja al usuario es
		// el hex; lo que guardamos en BD es su sha256. Si la BD se
		// fuga, los tokens emitidos no son utilizables.
		$token_plano  = bin2hex( random_bytes( 32 ) );
		$token_hash   = hash( 'sha256', $token_plano );
		$expira_en    = gmdate( 'Y-m-d H:i:s', time() + self::TTL_SEGUNDOS );

		global $wpdb;
		$tabla = NS_Esquema::nombre_tabla( 'password_reset' );
		$wpdb->insert(
			$tabla,
			array(
				'usuario_id' => (int) $usuario['id'],
				'token_hash' => $token_hash,
				'expira_en'  => $expira_en,
			),
			array( '%d', '%s', '%s' )
		);

		self::enviar_email( (string) $usuario['email'], $token_plano );
		return true;
	}

	/**
	 * Usa un token de reset. Si todo va bien, devuelve `true`.
	 * En caso contrario devuelve un código de error tipo string:
	 *   - 'token_invalido' (no existe / firma mal)
	 *   - 'token_expirado'
	 *   - 'token_usado'
	 *   - 'password_corta' (menor de 8 caracteres)
	 *
	 * @return true|string
	 */
	public static function usar( string $token_plano, string $nueva_password ) {
		if ( strlen( $nueva_password ) < 8 ) {
			return 'password_corta';
		}
		$token_hash = hash( 'sha256', $token_plano );

		global $wpdb;
		$tabla = NS_Esquema::nombre_tabla( 'password_reset' );
		$fila  = $wpdb->get_row(
			$wpdb->prepare( "SELECT * FROM {$tabla} WHERE token_hash = %s", $token_hash ),
			ARRAY_A
		);
		if ( ! $fila ) {
			return 'token_invalido';
		}
		if ( ! empty( $fila['usado_en'] ) ) {
			return 'token_usado';
		}
		if ( strtotime( (string) $fila['expira_en'] . ' UTC' ) < time() ) {
			return 'token_expirado';
		}

		$nuevo_hash = password_hash( $nueva_password, PASSWORD_DEFAULT );
		$tabla_usuarios = NS_Esquema::nombre_tabla( 'usuarios' );
		$wpdb->update(
			$tabla_usuarios,
			array( 'password_hash' => $nuevo_hash ),
			array( 'id' => (int) $fila['usuario_id'] ),
			array( '%s' ),
			array( '%d' )
		);
		$wpdb->update(
			$tabla,
			array( 'usado_en' => gmdate( 'Y-m-d H:i:s' ) ),
			array( 'id' => (int) $fila['id'] ),
			array( '%s' ),
			array( '%d' )
		);
		// Invalidamos también todos los OTROS tokens vivos del usuario
		// (defensa en profundidad: si pudo cambiar la contraseña, los
		// tokens previos ya no deberían valer).
		$wpdb->query(
			$wpdb->prepare(
				"UPDATE {$tabla} SET usado_en = UTC_TIMESTAMP() WHERE usuario_id = %d AND usado_en IS NULL",
				(int) $fila['usuario_id']
			)
		);
		return true;
	}

	private static function sobre_limite_de_emisiones( int $usuario_id ): bool {
		global $wpdb;
		$tabla = NS_Esquema::nombre_tabla( 'password_reset' );
		$desde = gmdate( 'Y-m-d H:i:s', time() - self::VENTANA_RATE_LIMIT_SEGUNDOS );
		$num   = (int) $wpdb->get_var(
			$wpdb->prepare(
				"SELECT COUNT(*) FROM {$tabla} WHERE usuario_id = %d AND creado_en >= %s",
				$usuario_id,
				$desde
			)
		);
		return $num >= self::TOPE_EMISIONES_POR_VENTANA;
	}

	private static function enviar_email( string $email, string $token_plano ): void {
		$asunto = 'Restablecer tu contraseña — Uno Roto';
		// La página HTML que renderiza el formulario de "nueva
		// contraseña" vive en el propio plugin como endpoint REST GET.
		$enlace = self::url_pagina_reset( $token_plano );
		$mensaje = "Hola.\n\n"
			. "Para crear una nueva contraseña entra aquí:\n\n"
			. $enlace . "\n\n"
			. "El enlace caduca en 30 minutos.\n\n"
			. "Si no fuiste tú, ignora este mensaje — tu cuenta sigue intacta.\n\n"
			. "Equipo Uno Roto";
		wp_mail(
			$email,
			$asunto,
			$mensaje,
			array( 'Content-Type: text/plain; charset=UTF-8' )
		);
	}

	private static function url_pagina_reset( string $token_plano ): string {
		// Construimos la URL con esquema real de la petición — útil
		// si el sitio está mal configurado en DB (`siteurl` http
		// cuando entra https). `home_url()` la base, después la
		// reescribimos.
		$path = rest_url( NS_Endpoints::NAMESPACE_CANONICO . '/auth/pagina-reset' );
		$path = add_query_arg( 'token', $token_plano, $path );
		// Forzamos https si la request actual es https.
		if ( is_ssl() ) {
			$path = set_url_scheme( $path, 'https' );
		}
		return $path;
	}

	/**
	 * Renderiza la página HTML que el usuario abre desde el email.
	 * Si recibe POST con `token` + `password` válidos, llama a `usar()`
	 * y muestra mensaje de éxito.
	 */
	public static function pagina_reset_html( WP_REST_Request $request ): void {
		// Aceptamos tanto GET (con token en query) como POST (con
		// token + password). La página es self-submitting.
		$token    = (string) $request->get_param( 'token' );
		$method   = strtoupper( (string) $request->get_method() );

		$mensaje_estado = '';
		$exito          = false;

		if ( 'POST' === $method ) {
			$nueva_password = (string) $request->get_param( 'password' );
			$resultado      = self::usar( $token, $nueva_password );
			if ( true === $resultado ) {
				$exito          = true;
				$mensaje_estado = 'Contraseña actualizada. Vuelve a la app y entra con la nueva contraseña.';
			} else {
				$mapa = array(
					'token_invalido'  => 'El enlace no es válido. Pide uno nuevo desde la app.',
					'token_expirado'  => 'El enlace ha caducado (válido 30 minutos). Pide uno nuevo desde la app.',
					'token_usado'     => 'Este enlace ya se usó. Pide uno nuevo si necesitas cambiar otra vez.',
					'password_corta'  => 'La contraseña debe tener al menos 8 caracteres.',
				);
				$mensaje_estado = $mapa[ $resultado ] ?? 'Algo no fue bien. Inténtalo de nuevo.';
			}
		} elseif ( '' === $token ) {
			$mensaje_estado = 'Falta el token. Abre el enlace desde tu correo.';
		}

		// Salida HTML — emitimos directo y morimos para que WP no
		// añada cabeceras o cuerpos JSON.
		header( 'Content-Type: text/html; charset=UTF-8' );

		?>
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Restablecer contraseña — Uno Roto</title>
<style>
  body { font-family: system-ui, -apple-system, sans-serif; background: #0A0618; color: #E6E0FF; margin: 0; padding: 32px 16px; }
  main { max-width: 420px; margin: 0 auto; background: #140A2E; padding: 28px 24px; border-radius: 12px; border: 1px solid rgba(138,92,255,0.45); }
  h1 { font-weight: 300; letter-spacing: 0.1em; margin: 0 0 6px 0; font-size: 18px; }
  p.lead { color: #9E95C7; font-size: 13px; line-height: 1.5; margin: 0 0 24px 0; }
  label { display: block; color: #9E95C7; font-size: 12px; letter-spacing: 0.05em; margin-bottom: 6px; }
  input[type=password] { width: 100%; box-sizing: border-box; padding: 12px 14px; font-size: 15px; border-radius: 8px; border: 1px solid rgba(138,92,255,0.5); background: #0A0618; color: #E6E0FF; outline: none; }
  input[type=password]:focus { border-color: #8A5CFF; }
  button { width: 100%; margin-top: 16px; padding: 12px; background: #8A5CFF; color: #0A0618; border: 0; border-radius: 8px; font-weight: 600; font-size: 14px; letter-spacing: 0.08em; cursor: pointer; }
  .estado { margin-top: 20px; padding: 12px 14px; border-radius: 8px; font-size: 13px; line-height: 1.5; }
  .ok { background: rgba(126,232,176,0.12); color: #7EE8B0; border: 1px solid rgba(126,232,176,0.4); }
  .err { background: rgba(255,77,157,0.10); color: #FF4D9D; border: 1px solid rgba(255,77,157,0.4); }
</style>
</head>
<body>
<main>
  <h1>NUEVA CONTRASEÑA</h1>
  <p class="lead">Elige una contraseña nueva para tu cuenta de Uno Roto. Mínimo 8 caracteres.</p>
  <?php if ( ! $exito ) : ?>
    <form method="post">
      <input type="hidden" name="token" value="<?php echo esc_attr( $token ); ?>">
      <label for="password">Nueva contraseña</label>
      <input id="password" name="password" type="password" minlength="8" required autofocus>
      <button type="submit">Guardar</button>
    </form>
  <?php endif; ?>
  <?php if ( '' !== $mensaje_estado ) : ?>
    <div class="estado <?php echo $exito ? 'ok' : 'err'; ?>"><?php echo esc_html( $mensaje_estado ); ?></div>
  <?php endif; ?>
</main>
</body>
</html>
		<?php

		exit; // detener WP REST de añadir su body JSON.
	}
}
