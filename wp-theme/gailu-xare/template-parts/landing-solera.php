<?php
/**
 * Landing del ecosistema Solera.
 *
 * Vista promocional del paraguas Solera (las 6 verticales agrarias:
 * agro, viticultura, apícola, arbolado urbano, quesera, aceitera).
 * Procede del design package "landing del ecosistema solera" exportado
 * desde claude.ai/design — adaptado al patrón del portfolio:
 *
 *  - sin barra superior propia (el tema ya pinta gxare-topbar)
 *  - CSS y JS encolados sólo cuando esta landing renderiza
 *  - body recibe la clase `gxare-landing-solera` para scopear estilos
 *
 * @package gailu-xare
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

// El CSS/JS de Solera se enqueua aquí porque sólo aplica cuando
// esta plantilla entra en juego — el resto del portfolio no paga
// el peso.
add_filter(
	'body_class',
	static function ( array $clases ): array {
		$clases[] = 'gxare-landing-solera';
		return $clases;
	}
);

wp_enqueue_style(
	'gxare-landing-solera',
	GXARE_THEME_URL . '/assets/css/landing-solera.css',
	array( 'gxare-tokens', 'gxare-portfolio' ),
	GXARE_THEME_VERSION
);
wp_enqueue_script(
	'gxare-landing-solera',
	GXARE_THEME_URL . '/assets/js/landing-solera.js',
	array(),
	GXARE_THEME_VERSION,
	array( 'in_footer' => true, 'strategy' => 'defer' )
);
?>

<article class="gxare-landing gxare-landing-solera-wrap">

	<!-- HERO -->
	<section class="hero contenedor" id="inicio">
		<div class="hero-rejilla">
			<div>
				<span class="hero-etiqueta">
					<span class="punto" aria-hidden="true"></span>
					Seis cuadernos · una misma raíz
				</span>
				<h1>
					Cuadernos de campo para <em>oficios de la tierra.</em>
				</h1>
				<p class="lede">
					Solera es un ecosistema de aplicaciones móviles para profesionales que trabajan con plantas, animales y patrimonio vivo. Una finca, un viñedo, un colmenar, un arbolado municipal, una quesería o una almazara — cada oficio en su cuaderno, con sus catálogos curados, su libro oficial en PDF y su libro económico REAGP. Offline de raíz, en castellano, sin marketing.
				</p>
				<div class="hero-acciones">
					<a href="#apps" class="boton boton-primario">
						<span class="material-symbols-outlined">apps</span>
						Ver las seis apps
					</a>
					<a href="https://github.com/JosuIru/nuevo-ser" target="_blank" rel="noopener" class="boton boton-secundario">
						<span class="material-symbols-outlined">code</span>
						Código en GitHub
					</a>
				</div>
				<div class="hero-meta">
					<div><strong>6</strong><small>verticales activas</small></div>
					<div><strong>11</strong><small>libros oficiales soportados</small></div>
					<div><strong>0</strong><small>datos en la nube por defecto</small></div>
				</div>
			</div>

			<div class="hero-visual" aria-hidden="true">
				<div class="telefono telefono-1" style="--acento: var(--solera-vid);">
					<div class="tel-app">
						<div class="tel-appbar"><span class="material-symbols-outlined">wine_bar</span>Viticultura</div>
						<div class="tel-body">
							<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">spa</span></span><span class="meta"><b>Tempranillo · F3-12</b><span>Cuajado · BBCH 71</span></span></div>
							<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">bug_report</span></span><span class="meta"><b>Mildiu en foliar</b><span>Provisional · catálogo</span></span></div>
							<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">edit_note</span></span><span class="meta"><b>Libro PAC</b><span>23 tratamientos · campaña</span></span></div>
						</div>
						<div class="tel-tab">
							<span class="material-symbols-outlined activo">map</span>
							<span class="material-symbols-outlined">list</span>
							<span class="material-symbols-outlined">add_circle</span>
							<span class="material-symbols-outlined">menu_book</span>
							<span class="material-symbols-outlined">settings</span>
						</div>
					</div>
				</div>
				<div class="telefono telefono-2" style="--acento: var(--solera-api);">
					<div class="tel-app">
						<div class="tel-appbar"><span class="material-symbols-outlined">hive</span>Apícola</div>
						<div class="tel-body">
							<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">hive</span></span><span class="meta"><b>IB-2025-042</b><span>Reina 2024 · viva</span></span></div>
							<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">medication</span></span><span class="meta"><b>Ácido oxálico</b><span>Retirar el 12 oct</span></span></div>
							<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">local_shipping</span></span><span class="meta"><b>Trashumancia</b><span>Cazorla → Aliste</span></span></div>
						</div>
						<div class="tel-tab">
							<span class="material-symbols-outlined">map</span>
							<span class="material-symbols-outlined activo">list</span>
							<span class="material-symbols-outlined">add_circle</span>
							<span class="material-symbols-outlined">menu_book</span>
							<span class="material-symbols-outlined">settings</span>
						</div>
					</div>
				</div>
				<div class="telefono telefono-3" style="--acento: var(--solera-aceite);">
					<div class="tel-app">
						<div class="tel-appbar"><span class="material-symbols-outlined">water_drop</span>Aceitera</div>
						<div class="tel-body">
							<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">eco</span></span><span class="meta"><b>Picual · Parcela 4</b><span>Recolección · 3.420 kg</span></span></div>
							<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">science</span></span><span class="meta"><b>Lote 2026-014</b><span>Acidez 0,18 · K232 1,82</span></span></div>
							<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">description</span></span><span class="meta"><b>Libro AICA</b><span>17 movimientos · provisional</span></span></div>
						</div>
						<div class="tel-tab">
							<span class="material-symbols-outlined">today</span>
							<span class="material-symbols-outlined">map</span>
							<span class="material-symbols-outlined activo">water_drop</span>
							<span class="material-symbols-outlined">menu_book</span>
							<span class="material-symbols-outlined">settings</span>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>

	<!-- MANIFIESTO -->
	<section class="banda papel-2" id="manifiesto">
		<div class="contenedor">
			<div class="titulo-seccion">
				<span class="overline">Manifiesto</span>
				<h2>Una raíz común, seis oficios distintos.</h2>
			</div>
			<div class="manifiesto">
				<p>
					Solera nace de una intuición sencilla: cada planta, cada colmena, cada queso afinado, cada lote de aceite <em>tiene historia</em>, y esa historia se merece un cuaderno digno. No una hoja de Excel desordenada ni una libreta perdida en la furgoneta. Un cuaderno de campo bien hecho: ordenado, trazable, y que respete el vocabulario y los tiempos del oficio.
				</p>
				<p>
					Hablamos a profesionales — viticultores, apicultores, técnicos municipales, queseros, maestros almazareros — que conocen su materia. La app no les explica su trabajo. Les acompaña, recoge lo que necesitan dejar registrado por ley, y produce los PDF que les van a pedir cuando llegue la inspección, el técnico de la OCA, el auditor AICA o la cooperativa.
				</p>
				<p>
					Las coordenadas precisas, las fotos de tu colmenar, los lotes de queso o las analíticas del aceite viven en tu teléfono. <em>Lo que salga del dispositivo, sale porque tú lo decides.</em>
				</p>
			</div>
		</div>
	</section>

	<!-- APPS GRID -->
	<section class="banda" id="apps">
		<div class="contenedor" style="padding-top: 40px;">
			<div class="titulo-seccion">
				<span class="overline">El ecosistema</span>
				<h2>Seis cuadernos especializados, hermanos técnicos.</h2>
				<p>Cada app es independiente — la instalas según tu oficio. Comparten plataforma y vocabulario, así que si tienes un olivar y un colmenar, las dos apps se sienten de la misma familia.</p>
			</div>

			<div class="apps-rejilla">
				<a class="app-tarjeta" href="#detalle" data-app="agro" style="--app-color: var(--solera-agro);">
					<div class="app-cabecera">
						<div class="app-icono"><span class="material-symbols-outlined">forest</span></div>
						<div class="app-titulos">
							<h3>Solera</h3>
							<div class="sello">Gestor de fincas</div>
						</div>
					</div>
					<p class="app-resumen">Frutales, truficultura, olivar, pistacho, vid y dehesa en una sola app. Modelo de planta con identidad persistente y cuaderno MAPA conforme RD 1311/2012.</p>
					<div class="app-meta">
						<span class="precio">€/mes según finca</span>
						<span class="estado-chip estable">Estable</span>
					</div>
				</a>

				<a class="app-tarjeta" href="#detalle" data-app="vid" style="--app-color: var(--solera-vid);">
					<div class="app-cabecera">
						<div class="app-icono"><span class="material-symbols-outlined">wine_bar</span></div>
						<div class="app-titulos">
							<h3>Solera Viticultura</h3>
							<div class="sello">Bodegas 5–30 ha</div>
						</div>
					</div>
					<p class="app-resumen">Cuaderno PAC móvil, calendario BBCH por variedad e IA para mildiu, oídio, botritis y polilla del racimo. Adiós a las hojas de Excel los domingos.</p>
					<div class="app-meta">
						<span class="precio">15–40 €/mes · finca</span>
						<span class="estado-chip estable">Estable</span>
					</div>
				</a>

				<a class="app-tarjeta" href="#detalle" data-app="api" style="--app-color: var(--solera-api);">
					<div class="app-cabecera">
						<div class="app-icono"><span class="material-symbols-outlined">hive</span></div>
						<div class="app-titulos">
							<h3>Solera Apícola</h3>
							<div class="sello">20–200 colmenas</div>
						</div>
					</div>
					<p class="app-resumen">Libro REGA conforme RD 209/2002, gestión de varroa con plazos de seguridad y trashumancia bien modelada como evento de pleno derecho.</p>
					<div class="app-meta">
						<span class="precio">8–20 €/mes · explotación</span>
						<span class="estado-chip estable">Estable</span>
					</div>
				</a>

				<a class="app-tarjeta" href="#detalle" data-app="arbol" style="--app-color: var(--solera-arbol);">
					<div class="app-cabecera">
						<div class="app-icono"><span class="material-symbols-outlined">park</span></div>
						<div class="app-titulos">
							<h3>Solera Arbolado Urbano</h3>
							<div class="sello">B2B — ayuntamientos</div>
						</div>
					</div>
					<p class="app-resumen">Inventario por QR de chapa municipal, evaluación de riesgo VTA y partes de poda firmables. Pensado para concejalías y empresas contratistas de jardinería.</p>
					<div class="app-meta">
						<span class="precio">500–3.000 €/año · municipio</span>
						<span class="estado-chip estable">Estable</span>
					</div>
				</a>

				<a class="app-tarjeta" href="#detalle" data-app="queso" style="--app-color: var(--solera-queso);">
					<div class="app-cabecera">
						<div class="app-icono"><span class="material-symbols-outlined">restaurant</span></div>
						<div class="app-titulos">
							<h3>Solera Quesera</h3>
							<div class="sello">Queserías artesanas</div>
						</div>
					</div>
					<p class="app-resumen">Trazabilidad APPCC de leche a pieza, gestión de afinado por rueda individual y validación de pliego por Denominación de Origen.</p>
					<div class="app-meta">
						<span class="precio">10–25 €/mes · quesería</span>
						<span class="estado-chip beta">Beta</span>
					</div>
				</a>

				<a class="app-tarjeta" href="#detalle" data-app="aceite" style="--app-color: var(--solera-aceite);">
					<div class="app-cabecera">
						<div class="app-icono"><span class="material-symbols-outlined">water_drop</span></div>
						<div class="app-titulos">
							<h3>Solera Aceitera</h3>
							<div class="sello">Almazaras 100–2.000 hl</div>
						</div>
					</div>
					<p class="app-resumen">Olivar, recepción, molturación y libro de movimientos del aceite conforme RD 760/2021 + AICA. Cierra el ciclo del olivar a la botella.</p>
					<div class="app-meta">
						<span class="precio">15–30 €/mes · almazara</span>
						<span class="estado-chip estable">Estable</span>
					</div>
				</a>
			</div>
		</div>
	</section>

	<!-- PLATAFORMA COMÚN -->
	<section class="banda papel-2" id="plataforma">
		<div class="contenedor" style="padding-top: 40px;">
			<div class="titulo-seccion">
				<span class="overline">Plataforma común</span>
				<h2>Lo que todas las apps de Solera tienen en común.</h2>
				<p>El núcleo técnico se llama <code>nuevo_ser_core</code> y vive en el monorepo. Cada vertical lo consume y añade lo suyo. Lo que comparten todas:</p>
			</div>

			<div class="plataforma">
				<div class="feature">
					<span class="material-symbols-outlined">cloud_off</span>
					<h4>Offline de raíz</h4>
					<p>SQLite local. La app sólo va a la nube cuando tú lo decides. En el monte, en la cava o en el campo, todo funciona sin cobertura.</p>
				</div>
				<div class="feature">
					<span class="material-symbols-outlined">menu_book</span>
					<h4>Libros oficiales en PDF</h4>
					<p>Cuaderno PAC (RD 1311/2012), libro REGA, libro AICA del aceite, trazabilidad APPCC, parte municipal de poda. Listo para inspección.</p>
				</div>
				<div class="feature">
					<span class="material-symbols-outlined">camera_alt</span>
					<h4>IA visual con tu clave</h4>
					<p>Claude Vision para identificar plagas, enfermedades y defectos. BYO key — la clave vive en tu móvil, no en nuestros servidores.</p>
				</div>
				<div class="feature">
					<span class="material-symbols-outlined">euro</span>
					<h4>Libro económico REAGP</h4>
					<p>Ingresos y gastos por vertical con cálculo automático de IVA y compensación REAGP. Extracto anual y modelo 347 en PDF.</p>
				</div>
				<div class="feature">
					<span class="material-symbols-outlined">style</span>
					<h4>Catálogos curados</h4>
					<p>Variedades, plagas, sustancias activas y calendarios fenológicos en CSV editables por tu asesor. Sin marcas comerciales por defecto.</p>
				</div>
				<div class="feature">
					<span class="material-symbols-outlined">backup</span>
					<h4>Copia de seguridad</h4>
					<p>Backup zip con base de datos y fotos, safety pre-restore. Tu cuaderno no se pierde cuando cambias de móvil.</p>
				</div>
			</div>
		</div>
	</section>

	<!-- DETALLE POR APP -->
	<section class="banda" id="detalle">
		<div class="contenedor" style="padding-top: 40px;">
			<div class="titulo-seccion">
				<span class="overline">Una a una</span>
				<h2>Cada cuaderno, por dentro.</h2>
				<p>Selecciona un oficio para ver el dominio del cuaderno, los libros oficiales que cubre y a quién está dirigido.</p>
			</div>

			<div class="detalle" id="detalle-host">
				<div class="detalle-tabs" role="tablist" aria-label="Apps del ecosistema">
					<button class="detalle-tab" role="tab" aria-selected="true"  data-tab="agro"   id="tab-agro"   style="--tab-color: var(--solera-agro);"><span class="punto-color"></span>Solera</button>
					<button class="detalle-tab" role="tab" aria-selected="false" data-tab="vid"    id="tab-vid"    style="--tab-color: var(--solera-vid);"><span class="punto-color"></span>Viticultura</button>
					<button class="detalle-tab" role="tab" aria-selected="false" data-tab="api"    id="tab-api"    style="--tab-color: var(--solera-api);"><span class="punto-color"></span>Apícola</button>
					<button class="detalle-tab" role="tab" aria-selected="false" data-tab="arbol"  id="tab-arbol"  style="--tab-color: var(--solera-arbol);"><span class="punto-color"></span>Arbolado urbano</button>
					<button class="detalle-tab" role="tab" aria-selected="false" data-tab="queso"  id="tab-queso"  style="--tab-color: var(--solera-queso);"><span class="punto-color"></span>Quesera</button>
					<button class="detalle-tab" role="tab" aria-selected="false" data-tab="aceite" id="tab-aceite" style="--tab-color: var(--solera-aceite);"><span class="punto-color"></span>Aceitera</button>
				</div>

				<!-- agro -->
				<div class="detalle-panel" role="tabpanel" aria-labelledby="tab-agro" data-panel="agro" style="--panel-color: var(--solera-agro); --acento: var(--solera-agro);">
					<div class="detalle-cuerpo">
						<h3>Solera</h3>
						<p class="quien">Para fincas mixtas de Iberia — frutales, truficultura, olivar, pistacho, vid y dehesa.</p>
						<p class="descripcion">El generalista del ecosistema. Modelo de planta con identidad persistente: cada árbol tiene cosechas, observaciones, incidencias y tratamientos a lo largo de los años. Activas el modo de tu cultivo y la app trae catálogos, fenología y plagas específicas — frutales y trufas conviven en la misma cuenta.</p>
						<ul class="detalle-rasgos">
							<li><span class="material-symbols-outlined">layers</span><div><b>Modos verticalizados</b><span>30 cultivos en 7 categorías. Truficultura es única — ningún competidor la cubre.</span></div></li>
							<li><span class="material-symbols-outlined">description</span><div><b>Cuaderno MAPA (RD 1311/2012)</b><span>PDF con titular, asesor, aplicador, parcelas SIGPAC y tratamientos. Listo para inspección.</span></div></li>
							<li><span class="material-symbols-outlined">smart_toy</span><div><b>IA por foto, manejo cultural</b><span>Claude Vision contra catálogo de 27 plagas. Sin recomendar marcas comerciales.</span></div></li>
							<li><span class="material-symbols-outlined">timeline</span><div><b>Recorridos GPS de inspección</b><span>Buffer incremental anti-crash y export GPX. Lo que recorres queda.</span></div></li>
						</ul>
						<div class="detalle-precio">
							<div><strong>Suscripción</strong><small>según número de fincas</small></div>
							<div><strong>Android</strong><small>APK + Play Store próximamente</small></div>
							<div><strong>Estado</strong><small>F3.5 cerrada · ext. fiscal provisional</small></div>
						</div>
					</div>
					<div class="detalle-visual">
						<div class="tel-frame">
							<div class="tel-app">
								<div class="tel-appbar"><span class="material-symbols-outlined">forest</span>Solera · Hoy</div>
								<div class="tel-body">
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">eco</span></span><span class="meta"><b>Truficultura · Lote A</b><span>Esta semana: riego oxígeno</span></span></div>
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">park</span></span><span class="meta"><b>Almendro A-17</b><span>Floración · 23 marzo</span></span></div>
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">water_drop</span></span><span class="meta"><b>Olivar Sur</b><span>Endurecimiento hueso</span></span></div>
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">timeline</span></span><span class="meta"><b>Inspección martes</b><span>3,2 km · 38 plantas</span></span></div>
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">edit_note</span></span><span class="meta"><b>Cuaderno MAPA</b><span>14 entradas · campaña</span></span></div>
								</div>
								<div class="tel-tab">
									<span class="material-symbols-outlined activo">today</span>
									<span class="material-symbols-outlined">map</span>
									<span class="material-symbols-outlined">add_circle</span>
									<span class="material-symbols-outlined">list</span>
									<span class="material-symbols-outlined">settings</span>
								</div>
							</div>
						</div>
					</div>
				</div>

				<!-- viticultura -->
				<div class="detalle-panel" role="tabpanel" aria-labelledby="tab-vid" data-panel="vid" hidden style="--panel-color: var(--solera-vid); --acento: var(--solera-vid);">
					<div class="detalle-cuerpo">
						<h3>Solera Viticultura</h3>
						<p class="quien">Para bodegas pequeñas y medianas — 5 a 30 hectáreas, viticultor o enólogo al frente del cuaderno.</p>
						<p class="descripcion">Compite con ERP de oficina que cuestan cinco cifras. Solera Viticultura va en el móvil, al campo, y produce el libro PAC de tratamientos firmable desde la cepa. Catálogo de 40 variedades + 10 portainjertos + 19 plagas + 72 estados BBCH ya cargados, con bandera de declaración obligatoria para Xylella y Flavescencia dorada.</p>
						<ul class="detalle-rasgos">
							<li><span class="material-symbols-outlined">description</span><div><b>Libro PAC (RD 1311/2012)</b><span>Tratamientos, materia activa, dosis/ha, NIF aplicador. Verificado contra RD 285/2021.</span></div></li>
							<li><span class="material-symbols-outlined">smart_toy</span><div><b>IA vid-específica</b><span>14 incidencias canónicas (mildiu, oídio, botritis, eutipiosis, yesca…). Matching contra catálogo curado.</span></div></li>
							<li><span class="material-symbols-outlined">event</span><div><b>Calendario BBCH</b><span>9 estados principales × 8 zona-variedades. "Qué toca esta semana" en la pantalla Hoy.</span></div></li>
							<li><span class="material-symbols-outlined">euro</span><div><b>Libro económico vid</b><span>Distingue uva (REAGP 12%) de vino (IVA 21%). Trazabilidad de lotes para el consejo regulador.</span></div></li>
						</ul>
						<div class="detalle-precio">
							<div><strong>15 – 40 €/mes</strong><small>por finca</small></div>
							<div><strong>Android</strong><small>APK release disponible</small></div>
							<div><strong>Estado</strong><small>F1-12 cerrada · CUE digital 2027 en backlog</small></div>
						</div>
					</div>
					<div class="detalle-visual">
						<div class="tel-frame">
							<div class="tel-app">
								<div class="tel-appbar"><span class="material-symbols-outlined">wine_bar</span>Viticultura · Mapa</div>
								<div class="tel-body">
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">spa</span></span><span class="meta"><b>Tempranillo · F3-12</b><span>BBCH 71 · cuajado</span></span></div>
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">bug_report</span></span><span class="meta"><b>Mildiu · provisional</b><span>Anote materia activa</span></span></div>
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">science</span></span><span class="meta"><b>Cobre + Mancozeb</b><span>Dosis 3,5 kg/ha · 8 jun</span></span></div>
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">edit_note</span></span><span class="meta"><b>Libro PAC</b><span>Generar PDF campaña 26</span></span></div>
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">euro</span></span><span class="meta"><b>Vendimia 25/26</b><span>14.300 kg uva · 8.200 kg vino</span></span></div>
								</div>
								<div class="tel-tab">
									<span class="material-symbols-outlined activo">map</span>
									<span class="material-symbols-outlined">list</span>
									<span class="material-symbols-outlined">add_circle</span>
									<span class="material-symbols-outlined">menu_book</span>
									<span class="material-symbols-outlined">settings</span>
								</div>
							</div>
						</div>
					</div>
				</div>

				<!-- apícola -->
				<div class="detalle-panel" role="tabpanel" aria-labelledby="tab-api" data-panel="api" hidden style="--panel-color: var(--solera-api); --acento: var(--solera-api);">
					<div class="detalle-cuerpo">
						<h3>Solera Apícola</h3>
						<p class="quien">Para apicultores profesionales y semi-profesionales — 20 a 200 colmenas, con o sin trashumancia.</p>
						<p class="descripcion">El sector que más papelitos genera por colmena. Solera Apícola lleva el libro oficial REGA conforme RD 209/2002, registra el ciclo completo de tratamientos contra varroa con plazos de seguridad automáticos, y modela la trashumancia como evento con origen, destino y motivo — lo que casi nadie hace bien.</p>
						<ul class="detalle-rasgos">
							<li><span class="material-symbols-outlined">menu_book</span><div><b>Libro oficial REGA</b><span>Tratamientos sanitarios, movimientos, incidencias, cosechas. Veterinario asesor con nº colegiado.</span></div></li>
							<li><span class="material-symbols-outlined">medication</span><div><b>9 sustancias varroa</b><span>Ácido oxálico, fórmico, timol, amitraz… con plazo de seguridad y autorización en ecológico.</span></div></li>
							<li><span class="material-symbols-outlined">local_shipping</span><div><b>Trashumancia como evento</b><span>Origen, destino, número de colmenas, motivo (mielada / invernada / sanitario).</span></div></li>
							<li><span class="material-symbols-outlined">warning</span><div><b>Declaración obligatoria</b><span>Banner rojo automático para loque americana, Tropilaelaps y especies UE clase A.</span></div></li>
						</ul>
						<div class="detalle-precio">
							<div><strong>8 – 20 €/mes</strong><small>por explotación</small></div>
							<div><strong>Android</strong><small>APK release disponible</small></div>
							<div><strong>Estado</strong><small>F1A-10 cerrada · análisis acústico en F2</small></div>
						</div>
					</div>
					<div class="detalle-visual">
						<div class="tel-frame">
							<div class="tel-app">
								<div class="tel-appbar"><span class="material-symbols-outlined">hive</span>Apícola · Colmena</div>
								<div class="tel-body">
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">badge</span></span><span class="meta"><b>IB-2025-042 · Layens</b><span>A. m. ibérica · reina 2024</span></span></div>
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">visibility</span></span><span class="meta"><b>Revisión 3 oct</b><span>Postura A · varroa 3/24h</span></span></div>
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">medication</span></span><span class="meta"><b>Ácido oxálico subl.</b><span>Aplicado 10 oct · retirar 24 oct</span></span></div>
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">local_shipping</span></span><span class="meta"><b>Trashumancia mielada</b><span>Cazorla → Aliste · 24 colmenas</span></span></div>
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">water_drop</span></span><span class="meta"><b>Cosecha primaveral</b><span>18,4 kg miel · lote M-25-04</span></span></div>
								</div>
								<div class="tel-tab">
									<span class="material-symbols-outlined">map</span>
									<span class="material-symbols-outlined activo">list</span>
									<span class="material-symbols-outlined">add_circle</span>
									<span class="material-symbols-outlined">menu_book</span>
									<span class="material-symbols-outlined">settings</span>
								</div>
							</div>
						</div>
					</div>
				</div>

				<!-- arbolado -->
				<div class="detalle-panel" role="tabpanel" aria-labelledby="tab-arbol" data-panel="arbol" hidden style="--panel-color: var(--solera-arbol); --acento: var(--solera-arbol);">
					<div class="detalle-cuerpo">
						<h3>Solera Arbolado Urbano</h3>
						<p class="quien">Para concejalías de medio ambiente y empresas contratistas de jardinería. Producto B2B.</p>
						<p class="descripcion">El único de la familia que no es SaaS individual. Licencia anual por municipio. Cada árbol lleva un QR resistente a intemperie clavado en el tronco; el operario escanea, ve el historial completo y registra la inspección en 30 segundos. Riesgo VTA trazable para defender decisiones de poda o tala ante la concejalía.</p>
						<ul class="detalle-rasgos">
							<li><span class="material-symbols-outlined">qr_code_scanner</span><div><b>QR de chapa municipal</b><span>Inventario por escaneo. Identificador único + historial completo del árbol.</span></div></li>
							<li><span class="material-symbols-outlined">warning</span><div><b>Riesgo VTA trazable</b><span>Visual Tree Assessment simplificada con histórico. El técnico firma cada parte.</span></div></li>
							<li><span class="material-symbols-outlined">content_cut</span><div><b>Partes de poda firmables</b><span>Informe consolidado de campaña con actuaciones, fotos antes/después y técnico responsable.</span></div></li>
							<li><span class="material-symbols-outlined">receipt_long</span><div><b>Facturae 3.2.x para FACe</b><span>Prefactura mensual al ayuntamiento con líneas por tipo de actuación. Estado de cobro hasta el pagado.</span></div></li>
						</ul>
						<div class="detalle-precio">
							<div><strong>500 – 3.000 €/año</strong><small>por municipio</small></div>
							<div><strong>Android</strong><small>App operario + portal técnico</small></div>
							<div><strong>Estado</strong><small>F1U-9 cerrada · F1U-10 con asesor fiscal</small></div>
						</div>
					</div>
					<div class="detalle-visual">
						<div class="tel-frame">
							<div class="tel-app">
								<div class="tel-appbar"><span class="material-symbols-outlined">park</span>Arbolado · IRU-PASEO-42</div>
								<div class="tel-body">
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">park</span></span><span class="meta"><b>Plátano de sombra</b><span>Edad 38 a · perímetro 1,84 m</span></span></div>
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">warning</span></span><span class="meta"><b>VTA 3/5 · observación</b><span>Grieta ramal sur · seguimiento</span></span></div>
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">bug_report</span></span><span class="meta"><b>Procesionaria · riesgo público</b><span>Bacillus thuringiensis · 22 oct</span></span></div>
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">content_cut</span></span><span class="meta"><b>Poda mantenimiento</b><span>0,8 m³ · cuadrilla Iruña</span></span></div>
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">qr_code_scanner</span></span><span class="meta"><b>QR verificado</b><span>Chapa 2024 · estado bueno</span></span></div>
								</div>
								<div class="tel-tab">
									<span class="material-symbols-outlined">map</span>
									<span class="material-symbols-outlined activo">list</span>
									<span class="material-symbols-outlined">qr_code_scanner</span>
									<span class="material-symbols-outlined">menu_book</span>
									<span class="material-symbols-outlined">settings</span>
								</div>
							</div>
						</div>
					</div>
				</div>

				<!-- quesera -->
				<div class="detalle-panel" role="tabpanel" aria-labelledby="tab-queso" data-panel="queso" hidden style="--panel-color: var(--solera-queso); --acento: var(--solera-queso);">
					<div class="detalle-cuerpo">
						<h3>Solera Quesera</h3>
						<p class="quien">Para queserías artesanales — 1 a 10 empleados, 20 a 500 piezas en afinado.</p>
						<p class="descripcion">El proyecto SMART GAZTA del Consejo Regulador Idiazabal ya demostró la urgencia de digitalizar el sector. Solera Quesera lleva la trazabilidad APPCC de la recepción de leche a la pieza, gestiona el afinado como entidad por rueda individual con peso, ubicación y volteos, y valida el pliego de tu Denominación de Origen.</p>
						<ul class="detalle-rasgos">
							<li><span class="material-symbols-outlined">menu_book</span><div><b>Libro de Trazabilidad APPCC</b><span>PDF con 7 secciones inspeccionable. Recepción, producción, curación, analíticas, controles.</span></div></li>
							<li><span class="material-symbols-outlined">inventory_2</span><div><b>Afinado por pieza</b><span>Cada rueda con peso, ubicación en cava, volteos. Como las cepas o las colmenas de las otras Solera.</span></div></li>
							<li><span class="material-symbols-outlined">verified</span><div><b>Verticalización por DO</b><span>Idiazabal, Manchego, Cabrales, Roncal, Mahón… la app valida raza, curación mínima y zona del pliego.</span></div></li>
							<li><span class="material-symbols-outlined">thermostat</span><div><b>Controles APPCC diarios</b><span>Temperatura y humedad relativa por cava, limpieza, plagas, formación de personal.</span></div></li>
						</ul>
						<div class="detalle-precio">
							<div><strong>10 – 25 €/mes</strong><small>por quesería</small></div>
							<div><strong>Android</strong><small>Beta interno</small></div>
							<div><strong>Estado</strong><small>F1-5 con catálogos provisionales · F1-6 en curso</small></div>
						</div>
					</div>
					<div class="detalle-visual">
						<div class="tel-frame">
							<div class="tel-app">
								<div class="tel-appbar"><span class="material-symbols-outlined">restaurant</span>Quesera · Cava</div>
								<div class="tel-body">
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">water_drop</span></span><span class="meta"><b>Recepción 12 mar</b><span>342 L · Latxa · pH 6,7</span></span></div>
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">inventory_2</span></span><span class="meta"><b>Lote 26-014 · 18 piezas</b><span>Curación día 87/120</span></span></div>
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">verified</span></span><span class="meta"><b>DO Idiazabal</b><span>Pliego validado · ✓</span></span></div>
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">thermostat</span></span><span class="meta"><b>Cava B · 12 °C · 85 % HR</b><span>Dentro de rango</span></span></div>
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">science</span></span><span class="meta"><b>Analítica microbiológica</b><span>L. monocytogenes negativo</span></span></div>
								</div>
								<div class="tel-tab">
									<span class="material-symbols-outlined activo">today</span>
									<span class="material-symbols-outlined">inventory_2</span>
									<span class="material-symbols-outlined">add_circle</span>
									<span class="material-symbols-outlined">menu_book</span>
									<span class="material-symbols-outlined">settings</span>
								</div>
							</div>
						</div>
					</div>
				</div>

				<!-- aceitera -->
				<div class="detalle-panel" role="tabpanel" aria-labelledby="tab-aceite" data-panel="aceite" hidden style="--panel-color: var(--solera-aceite); --acento: var(--solera-aceite);">
					<div class="detalle-cuerpo">
						<h3>Solera Aceitera</h3>
						<p class="quien">Para almazaras pequeñas y medianas — 100 a 2.000 hl por campaña, maestro almazarero o técnico de cooperativa.</p>
						<p class="descripcion">Cubre el ciclo completo del olivar a la botella en una sola app: cuaderno PAC olivar, recepción de partidas, molturación, lotes de aceite con sus analíticas, libro de movimientos del aceite conforme RD 760/2021 + AICA, y cierre fiscal REAGP con las reglas peculiares del olivar (aceituna 12% compensación · aceite a granel · aceite envasado).</p>
						<ul class="detalle-rasgos">
							<li><span class="material-symbols-outlined">menu_book</span><div><b>Libro AICA del aceite</b><span>Movimientos cronológicos de cada lote — molturación, traslado, mezcla, envasado, venta, merma.</span></div></li>
							<li><span class="material-symbols-outlined">science</span><div><b>Lote con analítica</b><span>Acidez, peróxidos, K232/K270, panel test sensorial, polifenoles. Categoría VE/V/L automática.</span></div></li>
							<li><span class="material-symbols-outlined">verified</span><div><b>29 DOPs vigentes</b><span>Sierra Mágina, Priego, Estepa, Baena, Les Garrigues, Siurana, Mallorca, Empordà…</span></div></li>
							<li><span class="material-symbols-outlined">euro</span><div><b>REAGP olivar</b><span>Aceituna a almazara 12% compensación, aceite 4%, envasado 10%. Las reglas peculiares del olivar.</span></div></li>
						</ul>
						<div class="detalle-precio">
							<div><strong>15 – 30 €/mes</strong><small>por almazara</small></div>
							<div><strong>Android</strong><small>APK 56 MB · Java 17</small></div>
							<div><strong>Estado</strong><small>F1-A11 cerrada · auditoría humana pendiente</small></div>
						</div>
					</div>
					<div class="detalle-visual">
						<div class="tel-frame">
							<div class="tel-app">
								<div class="tel-appbar"><span class="material-symbols-outlined">water_drop</span>Aceitera · Lote 26-014</div>
								<div class="tel-body">
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">eco</span></span><span class="meta"><b>Picual · Parcela 4 sur</b><span>3.420 kg · vibrador · 18 oct</span></span></div>
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">settings</span></span><span class="meta"><b>Molturación batido frío</b><span>Rendimiento 22,4 % · 766 kg aceite</span></span></div>
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">science</span></span><span class="meta"><b>Analítica</b><span>Acidez 0,18 · K232 1,82 · VE</span></span></div>
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">verified</span></span><span class="meta"><b>DOP Sierra Mágina</b><span>Pliego cumplido · ✓</span></span></div>
									<div class="tel-card"><span class="avatar"><span class="material-symbols-outlined">description</span></span><span class="meta"><b>Libro AICA</b><span>17 movimientos · provisional</span></span></div>
								</div>
								<div class="tel-tab">
									<span class="material-symbols-outlined">today</span>
									<span class="material-symbols-outlined">map</span>
									<span class="material-symbols-outlined activo">water_drop</span>
									<span class="material-symbols-outlined">menu_book</span>
									<span class="material-symbols-outlined">settings</span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>

	<!-- EMPEZAR -->
	<section class="banda papel-2" id="empezar">
		<div class="contenedor" style="padding-top: 40px;">
			<div class="titulo-seccion">
				<span class="overline">Cómo empezar</span>
				<h2>Tres pasos del repositorio al campo.</h2>
				<p>El código vive en GitHub. Las APKs de release están publicadas como assets de la última release del monorepo. Las apps son nativas Android (Flutter); iOS y web aún no.</p>
			</div>
			<div class="pasos">
				<article class="paso">
					<div class="numero">1</div>
					<h4>Clona el monorepo</h4>
					<p>Todo el ecosistema vive en un único repositorio, gestionado con Melos. Hay un <code>CLAUDE.md</code> por app con el estado real de cada vertical, sus catálogos y sus bloqueos.</p>
				</article>
				<article class="paso">
					<div class="numero">2</div>
					<h4>Instala la APK de tu oficio</h4>
					<p>Bajas la release del monorepo y sólo necesitas la APK de la app que te interesa. Si tienes Flutter en el PATH, también puedes correr <code>flutter run</code> desde <code>apps/&lt;vertical&gt;</code>.</p>
				</article>
				<article class="paso">
					<div class="numero">3</div>
					<h4>Configura titular y catálogos</h4>
					<p>El onboarding pide los datos del titular y, si te interesa, tu clave de Anthropic para la IA visual. Los catálogos vienen pre-curados con fuente pública — tu asesor puede sustituirlos editando el CSV correspondiente.</p>
				</article>
			</div>
			<div class="empezar-acciones">
				<a href="https://github.com/JosuIru/nuevo-ser" target="_blank" rel="noopener" class="boton boton-primario">
					<span class="material-symbols-outlined">code</span>Repositorio en GitHub
				</a>
				<a href="https://github.com/JosuIru/nuevo-ser/releases" target="_blank" rel="noopener" class="boton boton-secundario">
					<span class="material-symbols-outlined">download</span>Descargar APKs
				</a>
			</div>
		</div>
	</section>

	<!-- FAQ -->
	<section class="banda" id="faq">
		<div class="contenedor" style="padding-top: 40px;">
			<div class="titulo-seccion">
				<span class="overline">Preguntas frecuentes</span>
				<h2>Lo que la gente suele preguntar.</h2>
			</div>
			<div class="faq">
				<details class="faq-item">
					<summary>¿Las apps son gratis u open source?<span class="material-symbols-outlined">expand_more</span></summary>
					<div class="respuesta">
						<p>El código está liberado bajo <strong>AGPL-3.0</strong> y los contenidos (catálogos, calendarios, plantillas) bajo <strong>CC-BY-SA 4.0</strong>. Puedes clonar, instalar y usar el código sin pagar nada. El plan comercial cubre soporte, hospedaje de sync futura, y validación profesional continua de los catálogos.</p>
					</div>
				</details>

				<details class="faq-item">
					<summary>¿Qué datos suben a la nube?<span class="material-symbols-outlined">expand_more</span></summary>
					<div class="respuesta">
						<p>Por defecto, ninguno. Las apps son offline de raíz — coordenadas, fotos, libros oficiales y datos económicos viven en SQLite local del dispositivo. Lo único que puede salir del móvil son: una foto que tú envías a Anthropic con tu clave para identificar una plaga, un PDF que tú compartes desde el botón "Compartir", o un backup zip que tú decides guardar fuera.</p>
					</div>
				</details>

				<details class="faq-item">
					<summary>¿La IA cuesta algo? ¿Qué clave necesito?<span class="material-symbols-outlined">expand_more</span></summary>
					<div class="respuesta">
						<p>La IA visual usa <strong>Claude Haiku 4.5</strong> con modelo <em>bring-your-own-key</em>: introduces tu clave de la API de Anthropic en Ajustes y pagas a Anthropic directamente por las llamadas que hagas. La clave vive sólo en tu móvil, en SharedPreferences local. Sin clave, la app sigue funcionando — la IA es opcional.</p>
					</div>
				</details>

				<details class="faq-item">
					<summary>¿Los libros oficiales que genera son válidos para inspección?<span class="material-symbols-outlined">expand_more</span></summary>
					<div class="respuesta">
						<p>Los PDF llevan un sello <strong>PROVISIONAL</strong> visible hasta que el asesor humano de referencia firma. La estructura sigue la normativa vigente (RD 1311/2012 para fitosanitarios, RD 209/2002 para el libro REGA, RD 760/2021 + AICA para el libro del aceite, RGSEAA + CE 853/2004 para queserías), pero la auditoría final por técnico OCA, veterinario apícola, auditor AICA o inspector autonómico sigue siendo responsabilidad del titular.</p>
					</div>
				</details>

				<details class="faq-item">
					<summary>¿Funciona sin internet?<span class="material-symbols-outlined">expand_more</span></summary>
					<div class="respuesta">
						<p>Sí, completamente. Catálogos, mapas (con teselas cacheadas), GPS, fotos, libros oficiales y libro económico funcionan sin cobertura. La única función que requiere internet es la IA visual cuando la usas, y el sync multi-operario cuando exista (en F4 / F2 según vertical, no antes).</p>
					</div>
				</details>

				<details class="faq-item">
					<summary>¿Hay versión iOS o web?<span class="material-symbols-outlined">expand_more</span></summary>
					<div class="respuesta">
						<p>Por ahora sólo Android. Las apps están escritas en Flutter y técnicamente compilan a iOS, pero el roadmap actual prioriza estabilidad del núcleo y validación profesional sobre cobertura de plataforma. iOS entrará cuando haya base de suscriptores Android que lo justifique.</p>
					</div>
				</details>

				<details class="faq-item">
					<summary>¿Cómo se llama el repositorio madre y qué relación tiene con Cuadernos de Campo?<span class="material-symbols-outlined">expand_more</span></summary>
					<div class="respuesta">
						<p>El monorepo se llama <code>nuevo-ser</code> — comparte plataforma técnica (<code>nuevo_ser_core</code>) con la línea infantil <em>Colección Nuevo Ser Kids</em> y con las apps de operador <em>Fósiles</em> y <em>Naturaleza</em> del repositorio sibling <em>Cuadernos de Campo</em>. La estética y el tono también son herencia directa de ahí: papel, tinta, sin emoji, voz adulta.</p>
					</div>
				</details>
			</div>
		</div>
	</section>

</article>
