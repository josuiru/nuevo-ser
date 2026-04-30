<?php
/**
 * Smoke tests de validación de los endpoints de El Cuaderno
 * (`POST /el-cuaderno/observaciones`, `POST /el-cuaderno/sit-spot`,
 * `GET  /el-cuaderno/misterios`).
 *
 * Sin PHPUnit ni WordPress: prueba las funciones puras `validar_observacion`,
 * `validar_sit_spot`, `aplica_a_region` y `aplica_a_season`. La parte que
 * toca DB (idempotencia por UUID, jubilar sit spot anterior) se valida con
 * WP-CLI o tests de integración.
 *
 * Ejecutar con: `php tests/test_el_cuaderno.php`.
 */

define( 'ABSPATH', __DIR__ );

require_once __DIR__ . '/../includes/class-ns-el-cuaderno.php';

$fallos = 0;

/**
 * @param mixed $esperado
 * @param mixed $real
 */
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

function afirmar_verdadero( bool $real, string $titulo ): void {
	afirmar( true, $real, $titulo );
}

function afirmar_falso( bool $real, string $titulo ): void {
	afirmar( false, $real, $titulo );
}

// ═══ validar_observacion ════════════════════════════════════════════

$base_observacion = array(
	'uuid'           => '7f3c0e26-94e8-4b3a-9a2b-d7c1d5e2f834',
	'occurred_at'    => '2026-04-30T17:48:00Z',
	'what_seen_hash' => str_repeat( 'a', 64 ),
	'confidence'     => 'hipotesis_activa',
);

// ─── caso feliz ──────────────────────────────────────────────────────

afirmar(
	array(),
	NS_El_Cuaderno::validar_observacion( $base_observacion ),
	'el-cuaderno: observación mínima válida pasa'
);

afirmar(
	array(),
	NS_El_Cuaderno::validar_observacion( array_merge( $base_observacion, array(
		'place_name'  => 'El Roble Grande',
		'region_code' => 'ES-NA-PA',
		'proposed_id' => 'petirrojo',
	) ) ),
	'el-cuaderno: observación con place_name y region_code válidos pasa'
);

// ─── uuid ────────────────────────────────────────────────────────────

$campos = NS_El_Cuaderno::validar_observacion( array_merge( $base_observacion, array( 'uuid' => '' ) ) );
afirmar( 'invalid', $campos['uuid'] ?? null, 'el-cuaderno: uuid vacío rechaza' );

$campos = NS_El_Cuaderno::validar_observacion( array_merge( $base_observacion, array( 'uuid' => 'no-es-un-uuid' ) ) );
afirmar( 'invalid', $campos['uuid'] ?? null, 'el-cuaderno: uuid mal formado rechaza' );

$campos = NS_El_Cuaderno::validar_observacion( array_merge( $base_observacion, array( 'uuid' => '7F3C0E2694E84B3A9A2BD7C1D5E2F834' ) ) );
afirmar(
	array(),
	$campos,
	'el-cuaderno: uuid 32 hex sin guiones (mayúsculas) pasa'
);

// ─── occurred_at ─────────────────────────────────────────────────────

$campos = NS_El_Cuaderno::validar_observacion( array_merge( $base_observacion, array( 'occurred_at' => '' ) ) );
afirmar( 'requerido', $campos['occurred_at'] ?? null, 'el-cuaderno: occurred_at vacío rechaza' );

$cuerpo_sin_fecha = $base_observacion;
unset( $cuerpo_sin_fecha['occurred_at'] );
$campos = NS_El_Cuaderno::validar_observacion( $cuerpo_sin_fecha );
afirmar( 'requerido', $campos['occurred_at'] ?? null, 'el-cuaderno: occurred_at ausente rechaza' );

// ─── what_seen_hash ──────────────────────────────────────────────────

$campos = NS_El_Cuaderno::validar_observacion( array_merge( $base_observacion, array( 'what_seen_hash' => '' ) ) );
afirmar( 'sha256_hex_requerido', $campos['what_seen_hash'] ?? null, 'el-cuaderno: what_seen_hash vacío rechaza' );

$campos = NS_El_Cuaderno::validar_observacion( array_merge( $base_observacion, array( 'what_seen_hash' => str_repeat( 'a', 63 ) ) ) );
afirmar( 'sha256_hex_requerido', $campos['what_seen_hash'] ?? null, 'el-cuaderno: what_seen_hash 63 hex rechaza' );

$campos = NS_El_Cuaderno::validar_observacion( array_merge( $base_observacion, array( 'what_seen_hash' => str_repeat( 'g', 64 ) ) ) );
afirmar( 'sha256_hex_requerido', $campos['what_seen_hash'] ?? null, 'el-cuaderno: what_seen_hash con caracteres no-hex rechaza' );

$campos = NS_El_Cuaderno::validar_observacion( array_merge( $base_observacion, array( 'what_seen_hash' => strtoupper( str_repeat( 'a', 64 ) ) ) ) );
afirmar( array(), $campos, 'el-cuaderno: what_seen_hash en MAYÚSCULAS pasa (la regex es case-insensitive)' );

// ─── confidence ──────────────────────────────────────────────────────

$campos = NS_El_Cuaderno::validar_observacion( array_merge( $base_observacion, array( 'confidence' => 'consenso' ) ) );
afirmar( array(), $campos, 'el-cuaderno: confidence=consenso pasa' );

$campos = NS_El_Cuaderno::validar_observacion( array_merge( $base_observacion, array( 'confidence' => 'no_segura' ) ) );
afirmar( array(), $campos, 'el-cuaderno: confidence=no_segura pasa' );

$campos = NS_El_Cuaderno::validar_observacion( array_merge( $base_observacion, array( 'confidence' => 'abandonado' ) ) );
afirmar( 'valor_invalido', $campos['confidence'] ?? null, 'el-cuaderno: confidence=abandonado rechaza (es estado de Misterio, no de observación)' );

$campos = NS_El_Cuaderno::validar_observacion( array_merge( $base_observacion, array( 'confidence' => '' ) ) );
afirmar( 'valor_invalido', $campos['confidence'] ?? null, 'el-cuaderno: confidence vacío rechaza' );

// ─── region_code ─────────────────────────────────────────────────────

$campos = NS_El_Cuaderno::validar_observacion( array_merge( $base_observacion, array( 'region_code' => 'ES' ) ) );
afirmar( array(), $campos, 'el-cuaderno: region_code ES (NUTS-0) pasa' );

$campos = NS_El_Cuaderno::validar_observacion( array_merge( $base_observacion, array( 'region_code' => 'ES-NA' ) ) );
afirmar( array(), $campos, 'el-cuaderno: region_code ES-NA (NUTS-2) pasa' );

$campos = NS_El_Cuaderno::validar_observacion( array_merge( $base_observacion, array( 'region_code' => 'ES-NA-PA' ) ) );
afirmar( array(), $campos, 'el-cuaderno: region_code ES-NA-PA (NUTS-3) pasa' );

$campos = NS_El_Cuaderno::validar_observacion( array_merge( $base_observacion, array( 'region_code' => 'es-na-pa' ) ) );
afirmar( 'formato_invalido', $campos['region_code'] ?? null, 'el-cuaderno: region_code lowercase rechaza (NUTS exige mayúsculas)' );

$campos = NS_El_Cuaderno::validar_observacion( array_merge( $base_observacion, array( 'region_code' => '12345' ) ) );
afirmar( 'formato_invalido', $campos['region_code'] ?? null, 'el-cuaderno: region_code numérico rechaza' );

// region_code vacío o ausente NO rechaza — es opcional.
$campos = NS_El_Cuaderno::validar_observacion( array_merge( $base_observacion, array( 'region_code' => '' ) ) );
afirmar( array(), $campos, 'el-cuaderno: region_code vacío pasa (opcional)' );

// ─── place_name ──────────────────────────────────────────────────────

$campos = NS_El_Cuaderno::validar_observacion(
	array_merge( $base_observacion, array( 'place_name' => str_repeat( 'a', 256 ) ) )
);
afirmar( 'demasiado_largo', $campos['place_name'] ?? null, 'el-cuaderno: place_name de 256 chars rechaza' );

$campos = NS_El_Cuaderno::validar_observacion(
	array_merge( $base_observacion, array( 'place_name' => str_repeat( 'a', 255 ) ) )
);
afirmar( array(), $campos, 'el-cuaderno: place_name de 255 chars pasa' );

// ═══ validar_sit_spot ═══════════════════════════════════════════════

$base_sit_spot = array(
	'uuid' => '11112222-3333-4444-5555-666677778888',
	'name' => 'El Roble Grande',
);

afirmar(
	array(),
	NS_El_Cuaderno::validar_sit_spot( $base_sit_spot ),
	'sit-spot: payload mínimo válido pasa'
);

afirmar(
	array(),
	NS_El_Cuaderno::validar_sit_spot( array_merge( $base_sit_spot, array( 'region_code' => 'ES-NA-PA' ) ) ),
	'sit-spot: con region_code NUTS-3 válido pasa'
);

$campos = NS_El_Cuaderno::validar_sit_spot( array_merge( $base_sit_spot, array( 'name' => '' ) ) );
afirmar( 'requerido', $campos['name'] ?? null, 'sit-spot: name vacío rechaza' );

$campos = NS_El_Cuaderno::validar_sit_spot( array_merge( $base_sit_spot, array( 'name' => '   ' ) ) );
afirmar( 'requerido', $campos['name'] ?? null, 'sit-spot: name solo espacios rechaza' );

$campos = NS_El_Cuaderno::validar_sit_spot( array_merge( $base_sit_spot, array( 'name' => str_repeat( 'a', 256 ) ) ) );
afirmar( 'demasiado_largo', $campos['name'] ?? null, 'sit-spot: name de 256 chars rechaza' );

$campos = NS_El_Cuaderno::validar_sit_spot( array_merge( $base_sit_spot, array( 'uuid' => 'roto' ) ) );
afirmar( 'invalid', $campos['uuid'] ?? null, 'sit-spot: uuid roto rechaza' );

$campos = NS_El_Cuaderno::validar_sit_spot( array_merge( $base_sit_spot, array( 'region_code' => 'es-na' ) ) );
afirmar( 'formato_invalido', $campos['region_code'] ?? null, 'sit-spot: region_code lowercase rechaza' );

// ═══ aplica_a_region ════════════════════════════════════════════════

$mist_global = array( 'region_filter' => null );
afirmar_verdadero(
	NS_El_Cuaderno::aplica_a_region( $mist_global, 'ES-NA-PA' ),
	'misterios: filtro region_filter=null aplica a cualquier región'
);

$mist_iberia = array( 'region_filter' => array( 'ES', 'PT' ) );
afirmar_verdadero(
	NS_El_Cuaderno::aplica_a_region( $mist_iberia, 'ES-NA-PA' ),
	'misterios: filtro [ES,PT] casa por prefijo ES con ES-NA-PA'
);
afirmar_verdadero(
	NS_El_Cuaderno::aplica_a_region( $mist_iberia, 'PT-15' ),
	'misterios: filtro [ES,PT] casa con PT-15'
);
afirmar_falso(
	NS_El_Cuaderno::aplica_a_region( $mist_iberia, 'FR' ),
	'misterios: filtro [ES,PT] no aplica a FR'
);

$mist_navarra = array( 'region_filter' => array( 'ES-NA' ) );
afirmar_verdadero(
	NS_El_Cuaderno::aplica_a_region( $mist_navarra, 'ES-NA-PA' ),
	'misterios: filtro ES-NA casa con ES-NA-PA por prefijo'
);
afirmar_falso(
	NS_El_Cuaderno::aplica_a_region( $mist_navarra, 'ES-MD' ),
	'misterios: filtro ES-NA no aplica a ES-MD'
);

// ═══ aplica_a_season ════════════════════════════════════════════════

$mist_otono = array( 'season' => array( 'verano', 'otono' ) );
afirmar_verdadero(
	NS_El_Cuaderno::aplica_a_season( $mist_otono, 'verano' ),
	'misterios: season [verano,otono] aplica a verano'
);
afirmar_verdadero(
	NS_El_Cuaderno::aplica_a_season( $mist_otono, 'otono' ),
	'misterios: season [verano,otono] aplica a otono'
);
afirmar_falso(
	NS_El_Cuaderno::aplica_a_season( $mist_otono, 'invierno' ),
	'misterios: season [verano,otono] NO aplica a invierno'
);

$mist_anual = array( 'season' => array( 'todo_el_anio' ) );
afirmar_verdadero(
	NS_El_Cuaderno::aplica_a_season( $mist_anual, 'invierno' ),
	'misterios: season todo_el_anio cubre invierno'
);
afirmar_verdadero(
	NS_El_Cuaderno::aplica_a_season( $mist_anual, 'primavera' ),
	'misterios: season todo_el_anio cubre primavera'
);

afirmar_verdadero(
	NS_El_Cuaderno::aplica_a_season( array( 'season' => array() ), 'invierno' ),
	'misterios: season vacía equivale a global (no filtra)'
);

// ═══ Resultado final ════════════════════════════════════════════════

if ( $fallos > 0 ) {
	fprintf( STDERR, "\n%d test(s) fallaron.\n", $fallos );
	exit( 1 );
}

echo "OK: todos los smoke tests de NS_El_Cuaderno verdes.\n";
exit( 0 );
