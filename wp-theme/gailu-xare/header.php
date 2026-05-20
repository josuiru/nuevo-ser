<?php
/**
 * Cabecera del tema Gailu Xare.
 *
 * @package gailu-xare
 */
?><!doctype html>
<html <?php language_attributes(); ?>>
<head>
	<meta charset="<?php bloginfo( 'charset' ); ?>">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<?php wp_head(); ?>
</head>
<body <?php body_class(); ?>>

<nav class="gxare-topbar">
	<div class="gxare-topbar__inner">
		<a class="gxare-brand" href="<?php echo esc_url( home_url( '/' ) ); ?>">
			<span class="gxare-brand__nombre">Gailu Xare</span>
			<span class="gxare-brand__sub">taller de Josu Iru</span>
		</a>
		<nav class="gxare-topbar__menu">
			<a href="<?php echo esc_url( home_url( '/#proyectos' ) ); ?>">Proyectos</a>
			<a href="<?php echo esc_url( home_url( '/#descargas' ) ); ?>">Descargas</a>
			<a href="<?php echo esc_url( home_url( '/#sobre' ) ); ?>">Sobre</a>
			<a href="https://github.com/JosuIru" target="_blank" rel="noopener">GitHub</a>
		</nav>
	</div>
</nav>

<main class="gxare-main">
