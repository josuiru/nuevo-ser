import 'package:flutter/material.dart';

void main() => runApp(const LasVersionesApp());

class LasVersionesApp extends StatelessWidget {
  const LasVersionesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Las Versiones',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B5B95)),
        useMaterial3: true,
      ),
      home: const PantallaEsqueleto(),
    );
  }
}

class PantallaEsqueleto extends StatelessWidget {
  const PantallaEsqueleto({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Las Versiones',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300),
              ),
              SizedBox(height: 16),
              Text(
                'Juego de pensamiento histórico — Colección Nuevo Ser Kids',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              Text(
                'Esqueleto. Implementación en Fase 10 del roadmap.',
                style: TextStyle(fontSize: 12, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
