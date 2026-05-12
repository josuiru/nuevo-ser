// Solera Aceitera — esqueleto F1-A1.
//
// Esta es la primera fase del fork: pubspec, branding, estructura y
// app mínima compilable en linux desktop + Android. NO incluye modelos,
// BD, pantallas reales ni catálogos — esos llegan en F1-A2 (modelos +
// sqflite), F1-A3 (pantallas) y F1-A6 (catálogos).
//
// El placeholder visible al arrancar avisa explícitamente del estado
// para que un humano que abra la app entienda que está en obras y no
// confunda con un producto vendible.
//
// Detalle de fase y diferenciadores en `CLAUDE.md` del paquete.

import 'package:flutter/material.dart';

void main() {
  runApp(const AppSoleraAceitera());
}

/// Color primario de la paleta — verde oliva oscuro. Mantenido como
/// constante top-level para que F1-A8 (branding final) pueda
/// sustituirlo en un único punto sin tocar el árbol de widgets.
const Color colorPrimarioAceitera = Color(0xFF5C6B3A);

/// Color de fondo cálido (crema) para `scaffoldBackgroundColor`. Crea
/// la sensación de campo soleado + papel de cuaderno antiguo, en línea
/// con el resto de la suite Solera (crema savia en arbolado, ámbar en
/// apícola, burdeos+crema en viticultura, dorado+crema en quesera).
const Color colorCremaAceitera = Color(0xFFF5EFE2);

class AppSoleraAceitera extends StatelessWidget {
  const AppSoleraAceitera({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solera Aceitera',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: colorPrimarioAceitera,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: colorCremaAceitera,
        fontFamily: 'Roboto',
      ),
      home: const _PantallaEsqueletoF1A1(),
    );
  }
}

/// Pantalla placeholder del esqueleto F1-A1. Se sustituye por la
/// `PantallaHoy` real cuando entre F1-A3.
class _PantallaEsqueletoF1A1 extends StatelessWidget {
  const _PantallaEsqueletoF1A1();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solera Aceitera'),
        backgroundColor: colorPrimarioAceitera,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.eco,
                size: 96,
                color: colorPrimarioAceitera,
              ),
              const SizedBox(height: 24),
              Text(
                'Solera Aceitera',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: colorPrimarioAceitera,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Esqueleto F1-A1',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.black54,
                    ),
              ),
              const SizedBox(height: 24),
              Text(
                'Cuaderno de explotación olivarera y libro de movimientos '
                'del aceite para almazaras pequeñas y medianas. '
                'Esta fase sólo siembra el paquete y la estructura — '
                'los modelos, la base de datos y las pantallas reales '
                'llegan en F1-A2 y F1-A3.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black87,
                      height: 1.4,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
