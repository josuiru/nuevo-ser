<?php
/**
 * Hooks de activación y desactivación. En activación aplica las
 * migraciones con dbDelta() y resuelve la M001 (rename de prefijo
 * wp_uroto_* → wp_ns_*); idempotente si el esquema ya está al día.
 *
 * @package NuevoSerCore
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

class NS_Activacion {

	private const HOOK_PURGA_TUTOR = 'uroto_cron_purga_tutor';

	/**
	 * Nombre de la opción que registra la versión de schema instalada.
	 * Se mantiene el prefijo `uroto_` por decisión D5 — es BD persistent
	 * state que no aporta nada renombrar; se contemplará en v1.5 si hay
	 * una pasada de limpieza unificada de keys de wp_options.
	 */
	private const OPCION_VERSION = 'uroto_core_version';

	public static function activar(): void {
		self::desactivar_plugin_viejo();
		self::aplicar_migracion_m001();
		self::aplicar_esquema();
		self::sembrar_games();
		self::registrar_roles_adultos();
		self::sembrar_formaciones_fosiles();
		update_option( self::OPCION_VERSION, NS_CORE_VERSION );
		self::programar_cron();
	}

	/**
	 * Si el plugin antiguo `uno-roto-core` sigue activo (testers que tenían
	 * la versión previa instalada), lo desactivamos antes de proseguir.
	 * Sin esto, los dos plugins registrarían los mismos hooks y endpoints,
	 * provocando colisiones. La cabecera `Replaces: uno-roto-core` del
	 * archivo principal documenta este comportamiento.
	 */
	private static function desactivar_plugin_viejo(): void {
		$ruta_viejo = 'uno-roto-core/uno-roto-core.php';
		if ( ! function_exists( 'is_plugin_active' ) ) {
			require_once ABSPATH . 'wp-admin/includes/plugin.php';
		}
		if ( is_plugin_active( $ruta_viejo ) ) {
			deactivate_plugins( $ruta_viejo, true );
		}
	}

	public static function desactivar(): void {
		// Dejamos las tablas intactas al desactivar — solo se borran
		// en uninstall.php para evitar pérdida accidental de datos.
		// El cron sí lo desprogramamos: si el plugin no está activo,
		// el callback no existiría y WP loguearía warnings.
		wp_clear_scheduled_hook( self::HOOK_PURGA_TUTOR );
	}

	/**
	 * Migración silenciosa al cargar el plugin: si la versión guardada
	 * en BD es distinta de la del código, aplicamos el esquema de
	 * nuevo (dbDelta es idempotente) y la M001. Esto cubre el caso en
	 * que el plugin ya estaba activo cuando cambió el código — ahí
	 * register_activation_hook no se dispara, y sin esta verificación
	 * las tablas nuevas no se crean.
	 */
	public static function migrar_si_hace_falta(): void {
		$version_bd = get_option( self::OPCION_VERSION, '' );
		if ( NS_CORE_VERSION === $version_bd ) {
			return;
		}
		self::aplicar_migracion_m001();
		self::aplicar_esquema();
		self::sembrar_games();
		self::registrar_roles_adultos();
		self::sembrar_formaciones_fosiles();
		update_option( self::OPCION_VERSION, NS_CORE_VERSION );
		// Si el cron aún no estaba programado (sitio que se actualizó
		// desde una versión antes de existir el cron), lo añadimos
		// aquí — `programar_cron` es idempotente.
		self::programar_cron();
	}

	/**
	 * Registra los roles WP custom usados por NS_Auth_Adulto
	 * (`nuevoser_profesor` y `nuevoser_cuidador`). Idempotente —
	 * `add_role()` devuelve null si el rol ya existe, no falla.
	 *
	 * Capabilities mínimas: sólo `read`. Lo único que hace falta
	 * para que `wp_authenticate` les funcione y los endpoints de
	 * profesor/cuidador validen su rol con `user_has_role`.
	 *
	 * Los roles NO se borran al desactivar el plugin — borrarlos
	 * sin avisar perdería el rol asignado a usuarios reales. La
	 * limpieza definitiva se haría desde uninstall.php (tampoco
	 * la hacemos hoy, igual que con las tablas: pérdida potencial
	 * de datos, mejor que el operador humano lo decida).
	 */
	private static function registrar_roles_adultos(): void {
		if ( ! function_exists( 'add_role' ) ) {
			return;
		}
		add_role(
			NS_Auth_Adulto::ROL_WP_PROFESOR,
			'Nuevo Ser — Profesor',
			array( 'read' => true )
		);
		add_role(
			NS_Auth_Adulto::ROL_WP_CUIDADOR,
			'Nuevo Ser — Cuidador',
			array( 'read' => true )
		);

		// Curador de Fósiles — revisa las aportaciones de la comunidad
		// (foto + datos declarados) que llegan al moderation queue
		// desde la app. Capability propia para que los endpoints REST
		// puedan autorizar con `current_user_can()` y el submenú de
		// wp-admin filtre la visibilidad.
		add_role(
			NS_Auth_Adulto::ROL_WP_CURADOR_FOSILES,
			'Nuevo Ser — Curador de Fósiles',
			array(
				'read'                        => true,
				'nuevoser_fosiles_revisar'    => true,
			)
		);

		// Admin de Fósiles — además de revisar, gestiona el catálogo
		// de formaciones geológicas catalogadas y la lista de curadores.
		// Sin acceso a `manage_options` (no toca configuración global
		// de WordPress).
		add_role(
			NS_Auth_Adulto::ROL_WP_ADMIN_FOSILES,
			'Nuevo Ser — Admin de Fósiles',
			array(
				'read'                                     => true,
				'nuevoser_fosiles_revisar'                 => true,
				'nuevoser_fosiles_gestionar_catalogo'      => true,
				'nuevoser_fosiles_gestionar_curadores'     => true,
			)
		);

		// El administrador global de WP también puede revisar y gestionar
		// el catálogo — útil para entornos de demo y para el operador
		// del proyecto (Josu) sin necesitar otra cuenta.
		$administrator = get_role( 'administrator' );
		if ( $administrator instanceof WP_Role ) {
			$administrator->add_cap( 'nuevoser_fosiles_revisar' );
			$administrator->add_cap( 'nuevoser_fosiles_gestionar_catalogo' );
			$administrator->add_cap( 'nuevoser_fosiles_gestionar_curadores' );
		}
	}

	/**
	 * Migración M001 (C4 del refactor): para sitios con tablas del plugin
	 * antiguo (`{prefix}uroto_*`), las renombra al nuevo prefijo
	 * (`{prefix}ns_*`). Idempotente — si las nuevas ya existen, no toca
	 * nada. Si una vieja existe pero la nueva también, asume que la
	 * migración ya pasó y la vieja es residuo: la deja como está para
	 * que el operador humano la inspeccione antes de borrarla.
	 *
	 * No usa transacciones porque RENAME TABLE en MySQL no es
	 * transaccional. La idempotencia se basa en la condición previa:
	 * "renombrar solo si la vieja existe y la nueva no".
	 */
	private static function aplicar_migracion_m001(): void {
		global $wpdb;
		foreach ( NS_Esquema::SUFIJOS_VIEJOS as $clave => $sufijo_viejo ) {
			$tabla_vieja = $wpdb->prefix . $sufijo_viejo;
			$tabla_nueva = NS_Esquema::nombre_tabla( $clave );
			if ( ! self::tabla_existe( $tabla_vieja ) ) {
				continue;
			}
			if ( self::tabla_existe( $tabla_nueva ) ) {
				// Ambas existen: la migración ya pasó alguna vez. No tocar.
				continue;
			}
			$sql_vieja  = esc_sql( $tabla_vieja );
			$sql_nueva  = esc_sql( $tabla_nueva );
			$wpdb->query( "RENAME TABLE `{$sql_vieja}` TO `{$sql_nueva}`" ); // phpcs:ignore WordPress.DB.PreparedSQL
		}
	}

	private static function tabla_existe( string $tabla ): bool {
		global $wpdb;
		$sql_tabla = esc_sql( $tabla );
		$resultado = $wpdb->get_var( "SHOW TABLES LIKE '{$sql_tabla}'" ); // phpcs:ignore WordPress.DB.PreparedSQL
		return ! empty( $resultado );
	}

	/**
	 * Inserta los juegos seed en `ns_games` con INSERT IGNORE — idempotente
	 * y barato. Sin esto la tabla queda vacía tras la primera activación
	 * y los endpoints futuros que validen `game_id` rechazarían todo.
	 */
	private static function sembrar_games(): void {
		global $wpdb;
		$tabla = NS_Esquema::nombre_tabla( 'games' );
		foreach ( NS_Esquema::games_seed() as $fila ) {
			$wpdb->query( // phpcs:ignore WordPress.DB.PreparedSQL
				$wpdb->prepare(
					"INSERT IGNORE INTO {$tabla} (id, name, age_min, age_max, schema_version) VALUES (%s, %s, %d, %d, %s)",
					$fila['id'],
					$fila['name'],
					$fila['age_min'],
					$fila['age_max'],
					$fila['schema_version']
				)
			);
		}
	}

	/**
	 * Siembra `wp_ns_fosiles_formaciones_catalogadas` con el catálogo
	 * exportado desde el cliente Dart
	 * (`apps/fosiles/lib/datos/formacion_a_fosiles.dart`).
	 *
	 * El JSON vive en `seeds/fosiles_formaciones.json`, regenerado a
	 * mano con `flutter test test/exportar_formaciones_a_json_test.dart`
	 * cada vez que el catálogo Dart cambia.
	 *
	 * Estrategia: INSERT ... ON DUPLICATE KEY UPDATE sobre `codigo`
	 * (UNIQUE). Idempotente: reejecutarlo al actualizar el plugin
	 * propaga cambios de nombre/descripción/regiones sin perder las
	 * formaciones nuevas que un admin haya creado a mano por
	 * wp-admin (los códigos a mano no chocan con los del seed).
	 *
	 * Si el JSON no está presente (caso poco común — desarrollador
	 * que no haya ejecutado el exportador), se omite silenciosamente:
	 * el admin podrá crear el catálogo a mano desde wp-admin →
	 * Fósiles → Catálogo.
	 */
	private static function sembrar_formaciones_fosiles(): void {
		$ruta_seed = NS_CORE_DIR . 'seeds/fosiles_formaciones.json';
		if ( ! is_readable( $ruta_seed ) ) {
			return;
		}
		$contenido = file_get_contents( $ruta_seed );
		if ( false === $contenido ) {
			return;
		}
		$catalogo = json_decode( $contenido, true );
		if ( ! is_array( $catalogo ) ) {
			return;
		}

		global $wpdb;
		$tabla = NS_Esquema::nombre_tabla( 'fosiles_formaciones_catalogadas' );
		$ahora = gmdate( 'Y-m-d H:i:s' );

		foreach ( $catalogo as $formacion ) {
			if ( ! is_array( $formacion ) ) {
				continue;
			}
			$codigo = isset( $formacion['codigo'] ) ? (string) $formacion['codigo'] : '';
			$nombre = isset( $formacion['nombre_oficial'] ) ? (string) $formacion['nombre_oficial'] : '';
			if ( '' === $codigo || '' === $nombre ) {
				continue;
			}
			$periodo         = isset( $formacion['periodo'] ) ? (string) $formacion['periodo'] : '';
			$edad_aprox      = isset( $formacion['edad_aproximada'] ) ? (string) $formacion['edad_aproximada'] : '';
			$descripcion     = isset( $formacion['descripcion'] ) ? (string) $formacion['descripcion'] : '';
			$activo          = empty( $formacion['activo'] ) ? 0 : 1;
			$regiones_json   = isset( $formacion['regiones'] ) ? wp_json_encode( $formacion['regiones'] ) : null;

			// INSERT ... ON DUPLICATE KEY UPDATE preserva `id` y
			// `creado_en` originales; solo refresca los campos
			// derivables del catálogo Dart. El `actualizado_en` lo
			// gestiona MySQL con ON UPDATE CURRENT_TIMESTAMP.
			$sql = "INSERT INTO {$tabla}
				(codigo, nombre_oficial, periodo, edad_aproximada, regiones, descripcion, activo, creado_en)
				VALUES (%s, %s, %s, %s, %s, %s, %d, %s)
				ON DUPLICATE KEY UPDATE
					nombre_oficial = VALUES(nombre_oficial),
					periodo = VALUES(periodo),
					edad_aproximada = VALUES(edad_aproximada),
					regiones = VALUES(regiones),
					descripcion = VALUES(descripcion),
					activo = VALUES(activo)";

			$wpdb->query( // phpcs:ignore WordPress.DB.PreparedSQL
				$wpdb->prepare(
					$sql,
					$codigo,
					$nombre,
					$periodo,
					$edad_aprox,
					$regiones_json,
					$descripcion,
					$activo,
					$ahora
				)
			);
		}
	}

	/** Programa el cron diario si no estaba ya. Idempotente. */
	private static function programar_cron(): void {
		if ( false === wp_next_scheduled( self::HOOK_PURGA_TUTOR ) ) {
			wp_schedule_event( time() + HOUR_IN_SECONDS, 'daily', self::HOOK_PURGA_TUTOR );
		}
	}

	/** Callback del cron: borra entradas caducadas de la caché del tutor. */
	public static function ejecutar_purga_tutor(): void {
		if ( ! class_exists( 'NS_Tutor' ) ) {
			return;
		}
		NS_Tutor::purgar_caduca();
	}

	private static function aplicar_esquema(): void {
		require_once ABSPATH . 'wp-admin/includes/upgrade.php';
		foreach ( NS_Esquema::sentencias_create() as $sql ) {
			dbDelta( $sql );
		}
	}
}
