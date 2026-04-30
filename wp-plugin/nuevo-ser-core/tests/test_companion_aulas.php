<?php
/**
 * Smoke tests de validación de POST /classrooms/{code}/join.
 * Sin PHPUnit ni WordPress: prueba la función pura
 * `NS_Companion_Aulas::validar_codigo`. La parte que toca DB (existencia
 * del aula, estado active, idempotencia de la membresía) se valida con
 * WP-CLI o tests de integración.
 *
 * Ejecutar con: `php tests/test_companion_aulas.php`.
 */

define( 'ABSPATH', __DIR__ );

require_once __DIR__ . '/../includes/class-ns-companion-aulas.php';

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

// ─── Códigos válidos ──────────────────────────────────────────

afirmar( array(), NS_Companion_Aulas::validar_codigo( 'ABCD' ), 'aulas: code 4 chars pasa' );
afirmar( array(), NS_Companion_Aulas::validar_codigo( 'ABC123' ), 'aulas: code mixto letras+nums pasa' );
afirmar( array(), NS_Companion_Aulas::validar_codigo( 'A1B2C3D4E5F6G7H8' ), 'aulas: code 16 chars pasa' );

// Lowercase se normaliza, no se rechaza por sí mismo.
afirmar( array(), NS_Companion_Aulas::validar_codigo( 'abc123' ), 'aulas: code lowercase se acepta (normaliza upper)' );

// Con espacios alrededor también pasa (trim).
afirmar( array(), NS_Companion_Aulas::validar_codigo( '  ABC123  ' ), 'aulas: code con espacios alrededor pasa' );

// ─── code requerido ───────────────────────────────────────────

$campos = NS_Companion_Aulas::validar_codigo( '' );
afirmar( 'requerido', $campos['code'] ?? null, 'aulas: code vacío rechaza' );

$campos = NS_Companion_Aulas::validar_codigo( '   ' );
afirmar( 'requerido', $campos['code'] ?? null, 'aulas: code solo espacios rechaza' );

// ─── longitud_invalida ─────────────────────────────────────────

$campos = NS_Companion_Aulas::validar_codigo( 'ABC' );
afirmar( 'longitud_invalida', $campos['code'] ?? null, 'aulas: code 3 chars rechaza' );

$campos = NS_Companion_Aulas::validar_codigo( str_repeat( 'A', 17 ) );
afirmar( 'longitud_invalida', $campos['code'] ?? null, 'aulas: code 17 chars rechaza' );

// ─── formato_invalido ──────────────────────────────────────────

$campos = NS_Companion_Aulas::validar_codigo( 'ABC-123' );
afirmar( 'formato_invalido', $campos['code'] ?? null, 'aulas: code con guion rechaza' );

$campos = NS_Companion_Aulas::validar_codigo( 'ABC_DEF' );
afirmar( 'formato_invalido', $campos['code'] ?? null, 'aulas: code con underscore rechaza' );

$campos = NS_Companion_Aulas::validar_codigo( 'ABC ÑDEF' );
afirmar( 'formato_invalido', $campos['code'] ?? null, 'aulas: code con espacio interior rechaza' );

$campos = NS_Companion_Aulas::validar_codigo( 'ABCÑ' );
afirmar( 'formato_invalido', $campos['code'] ?? null, 'aulas: code con Ñ rechaza' );

// ─── validar_input_creacion ────────────────────────────────────

afirmar(
	array(),
	NS_Companion_Aulas::validar_input_creacion( '6º A', 'es', array( 'uno-roto' ) ),
	'aulas: input mínimo válido pasa'
);

afirmar(
	array(),
	NS_Companion_Aulas::validar_input_creacion(
		'Aula Maxwell',
		'eu',
		array( 'uno-roto', 'las-versiones', 'el-cuaderno' )
	),
	'aulas: tres game_ids válidos pasan'
);

// name requerido / vacío / sólo espacios
$campos = NS_Companion_Aulas::validar_input_creacion( null, 'es', array( 'uno-roto' ) );
afirmar( 'requerido', $campos['name'] ?? null, 'aulas: name null rechaza' );
$campos = NS_Companion_Aulas::validar_input_creacion( '', 'es', array( 'uno-roto' ) );
afirmar( 'requerido', $campos['name'] ?? null, 'aulas: name vacío rechaza' );
$campos = NS_Companion_Aulas::validar_input_creacion( '   ', 'es', array( 'uno-roto' ) );
afirmar( 'requerido', $campos['name'] ?? null, 'aulas: name sólo espacios rechaza' );

// name demasiado largo
$campos = NS_Companion_Aulas::validar_input_creacion(
	str_repeat( 'A', 129 ),
	'es',
	array( 'uno-roto' )
);
afirmar( 'demasiado_largo', $campos['name'] ?? null, 'aulas: name 129 chars rechaza' );

// language demasiado largo
$campos = NS_Companion_Aulas::validar_input_creacion(
	'Aula',
	str_repeat( 'a', 9 ),
	array( 'uno-roto' )
);
afirmar( 'demasiado_largo', $campos['language'] ?? null, 'aulas: language 9 chars rechaza' );

// language null se considera OK (el handler usa 'es' como default).
$campos = NS_Companion_Aulas::validar_input_creacion( 'Aula', null, array( 'uno-roto' ) );
afirmar( null, $campos['language'] ?? null, 'aulas: language null aceptado (default \'es\')' );

// game_ids requerido / no array / vacío
$campos = NS_Companion_Aulas::validar_input_creacion( 'Aula', 'es', null );
afirmar( 'requerido', $campos['game_ids'] ?? null, 'aulas: game_ids null rechaza' );
$campos = NS_Companion_Aulas::validar_input_creacion( 'Aula', 'es', 'uno-roto' );
afirmar( 'requerido', $campos['game_ids'] ?? null, 'aulas: game_ids string rechaza' );
$campos = NS_Companion_Aulas::validar_input_creacion( 'Aula', 'es', array() );
afirmar( 'requerido', $campos['game_ids'] ?? null, 'aulas: game_ids vacío rechaza' );

// game_ids con elementos no-string
$campos = NS_Companion_Aulas::validar_input_creacion( 'Aula', 'es', array( 'uno-roto', 42 ) );
afirmar( 'formato_invalido', $campos['game_ids'] ?? null, 'aulas: game_ids con int rechaza' );
$campos = NS_Companion_Aulas::validar_input_creacion( 'Aula', 'es', array( 'uno-roto', '' ) );
afirmar( 'formato_invalido', $campos['game_ids'] ?? null, 'aulas: game_ids con vacío rechaza' );
$campos = NS_Companion_Aulas::validar_input_creacion( 'Aula', 'es', array( 'uno-roto', '   ' ) );
afirmar( 'formato_invalido', $campos['game_ids'] ?? null, 'aulas: game_ids con sólo espacios rechaza' );

// ─── generar_codigo ────────────────────────────────────────────

for ( $i = 0; $i < 50; $i++ ) {
	$code = NS_Companion_Aulas::generar_codigo();
	afirmar( 6, strlen( $code ), 'aulas: code generado tiene 6 chars' );
	afirmar( 1, preg_match( '/^[A-Z2-9]+$/', $code ), 'aulas: code generado en alfabeto sin O/0/I/1' );
	// Sin O / 0 / I / 1 explícitamente.
	afirmar( false, str_contains( $code, '0' ), 'aulas: code no contiene 0' );
	afirmar( false, str_contains( $code, '1' ), 'aulas: code no contiene 1' );
	afirmar( false, str_contains( $code, 'O' ), 'aulas: code no contiene O' );
	afirmar( false, str_contains( $code, 'I' ), 'aulas: code no contiene I' );
}

// 50 códigos consecutivos no deben repetirse — el espacio (32^6) es
// enorme; si dos coinciden, el RNG está roto.
$generados = array();
for ( $i = 0; $i < 50; $i++ ) {
	$generados[] = NS_Companion_Aulas::generar_codigo();
}
afirmar( 50, count( array_unique( $generados ) ), 'aulas: 50 codes únicos en 50 generaciones' );

// El code generado pasa la validación de formato del lado del niño
// (`validar_codigo`) — invariante crítico para el flujo end-to-end.
$code = NS_Companion_Aulas::generar_codigo();
afirmar( array(), NS_Companion_Aulas::validar_codigo( $code ), 'aulas: code generado pasa validar_codigo' );

// ─── sumar_aggregates ──────────────────────────────────────────

// Lista vacía → array vacío.
afirmar( array(), NS_Companion_Aulas::sumar_aggregates( array() ), 'aulas: sumar 0 payloads → []' );

// Un solo payload → mismo payload (filtrado de claves no agregables).
$uno = array(
	'observaciones_total'         => 7,
	'sit_spot_visitas'            => 2,
	'observaciones_por_misterio'  => array( 'mist-001' => 5, 'mist-002' => 2 ),
	'observaciones_por_confianza' => array( 'consenso' => 4, 'hipotesis_activa' => 3 ),
	'region_code'                 => 'ES',
);
$resultado = NS_Companion_Aulas::sumar_aggregates( array( $uno ) );
afirmar( 7, $resultado['observaciones_total'] ?? null, 'aulas: 1 payload, total preservado' );
afirmar( 2, $resultado['sit_spot_visitas'] ?? null, 'aulas: 1 payload, sit_spot preservado' );
afirmar(
	array( 'mist-001' => 5, 'mist-002' => 2 ),
	$resultado['observaciones_por_misterio'] ?? null,
	'aulas: 1 payload, mapa misterio preservado'
);
afirmar( false, isset( $resultado['region_code'] ), 'aulas: region_code (string) descartado en agregado' );

// Dos payloads — counts ints sumados, mapas mergeados sumando claves
// coincidentes y manteniendo las nuevas.
$dos = array(
	array(
		'observaciones_total'         => 3,
		'observaciones_por_misterio'  => array( 'mist-001' => 2, 'mist-003' => 1 ),
	),
	array(
		'observaciones_total'         => 4,
		'observaciones_por_misterio'  => array( 'mist-001' => 1, 'mist-002' => 5 ),
	),
);
$resultado = NS_Companion_Aulas::sumar_aggregates( $dos );
afirmar( 7, $resultado['observaciones_total'], 'aulas: 2 payloads, total = 3+4 = 7' );
afirmar(
	array( 'mist-001' => 3, 'mist-003' => 1, 'mist-002' => 5 ),
	$resultado['observaciones_por_misterio'],
	'aulas: 2 payloads, mapa misterio mergeado correctamente'
);

// Payload corrupto en medio — se ignora silenciosamente.
$con_corrupto = array(
	array( 'observaciones_total' => 5 ),
	'no soy un array',
	array( 'observaciones_total' => 3 ),
	null,
	array( 'observaciones_total' => 'string que no debería estar aquí' ),
	array( 'observaciones_total' => 2 ),
);
$resultado = NS_Companion_Aulas::sumar_aggregates( $con_corrupto );
afirmar( 10, $resultado['observaciones_total'], 'aulas: payloads corruptos se ignoran (5+3+2=10)' );

// Tipos inesperados a nivel sub-clave: string en vez de int → ignora.
$mezcla = array(
	array( 'observaciones_por_misterio' => array( 'mist-001' => 5, 'mist-002' => 'no soy int' ) ),
	array( 'observaciones_por_misterio' => array( 'mist-001' => 2, 'mist-002' => 3 ) ),
);
$resultado = NS_Companion_Aulas::sumar_aggregates( $mezcla );
afirmar(
	array( 'mist-001' => 7, 'mist-002' => 3 ),
	$resultado['observaciones_por_misterio'],
	'aulas: subvalor no-int en un payload se ignora, sigue sumando los válidos'
);

// Constante k mínimo expuesta.
afirmar( 5, NS_Companion_Aulas::K_MINIMO_AGREGADOS, 'aulas: K_MINIMO_AGREGADOS = 5 (regla de privacidad)' );

if ( 0 === $fallos ) {
	echo "OK\n";
	exit( 0 );
} else {
	fprintf( STDERR, "%d fallo(s).\n", $fallos );
	exit( 1 );
}
