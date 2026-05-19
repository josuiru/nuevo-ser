<?php
/**
 * Smoke tests de NS_Fosiles_Comunidad. Sin PHPUnit ni WP cargado:
 * cubrimos solo lo que NO depende de wpdb ni de funciones WP.
 *
 *  - La constante ESTADOS_VALIDOS contiene los cuatro estados acordados.
 *  - NS_Esquema declara las cuatro tablas nuevas (`fosiles_*`).
 *  - NS_Auth_Adulto registra los cuatro roles (profesor, cuidador,
 *    curador_fosiles, admin_fosiles) en `MAPA_ROL_WP` (vía
 *    `rol_wp_para`).
 *
 * Cualquier validación que toque DB, $wpdb, sanitize_text_field o
 * wp_mail vive en pruebas manuales con WP cargado.
 *
 * Ejecutar: php tests/test_fosiles_comunidad.php
 */

define( 'ABSPATH', __DIR__ );

// Stubs mínimos para que las clases que tocan WP se puedan cargar
// (la mayoría de los métodos PHP requieren `WP_REST_Request` etc.,
// pero las constantes y mapas se leen sin instanciar nada).
if ( ! defined( 'NS_CORE_VERSION' ) ) {
	define( 'NS_CORE_VERSION', 'test' );
}

require_once __DIR__ . '/../includes/class-ns-auth-adulto.php';
require_once __DIR__ . '/../includes/class-ns-esquema.php';
require_once __DIR__ . '/../includes/class-ns-fosiles-comunidad.php';

$fallos = 0;
function afirmar( $esperado, $real, string $titulo ): void {
	global $fallos;
	if ( $esperado !== $real ) {
		$fallos++;
		fprintf(
			STDERR,
			"FALLO: %s\n  esperado: %s\n  real:     %s\n",
			$titulo,
			var_export( $esperado, true ),
			var_export( $real, true )
		);
	}
}

// ----------------------------------------------------------------
// ESTADOS_VALIDOS
// ----------------------------------------------------------------
afirmar(
	array( 'pendiente', 'aprobada', 'rechazada', 'archivada' ),
	NS_Fosiles_Comunidad::ESTADOS_VALIDOS,
	'NS_Fosiles_Comunidad::ESTADOS_VALIDOS contiene los cuatro estados'
);

// ----------------------------------------------------------------
// NS_Esquema declara las cuatro tablas nuevas
// ----------------------------------------------------------------
$claves_esperadas = array(
	'fosiles_aportaciones',
	'fosiles_fotos_blob',
	'fosiles_formaciones_catalogadas',
	'fosiles_borrados_rgpd',
);
foreach ( $claves_esperadas as $clave ) {
	afirmar(
		true,
		array_key_exists( $clave, NS_Esquema::SUFIJOS ),
		"NS_Esquema::SUFIJOS contiene '$clave'"
	);
}

// ----------------------------------------------------------------
// NS_Esquema::games_seed() incluye 'fosiles'
// ----------------------------------------------------------------
$ids_juegos = array_map(
	static function ( array $j ): string {
		return (string) $j['id'];
	},
	NS_Esquema::games_seed()
);
afirmar(
	true,
	in_array( 'fosiles', $ids_juegos, true ),
	"games_seed() incluye el juego 'fosiles'"
);

// ----------------------------------------------------------------
// NS_Auth_Adulto: mapa de roles extendido
// ----------------------------------------------------------------
afirmar(
	'nuevoser_curador_fosiles',
	NS_Auth_Adulto::rol_wp_para( 'curador_fosiles' ),
	"rol_wp_para('curador_fosiles') devuelve el slug WP correcto"
);
afirmar(
	'nuevoser_admin_fosiles',
	NS_Auth_Adulto::rol_wp_para( 'admin_fosiles' ),
	"rol_wp_para('admin_fosiles') devuelve el slug WP correcto"
);
afirmar(
	null,
	NS_Auth_Adulto::validar_rol_login( 'curador_fosiles' ),
	"validar_rol_login('curador_fosiles') acepta el nuevo rol"
);
afirmar(
	null,
	NS_Auth_Adulto::validar_rol_login( 'admin_fosiles' ),
	"validar_rol_login('admin_fosiles') acepta el nuevo rol"
);

if ( 0 === $fallos ) {
	echo "OK\n";
	exit( 0 );
}
fprintf( STDERR, "\n%d fallo(s).\n", $fallos );
exit( 1 );
