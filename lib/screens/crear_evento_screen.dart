import 'package:flutter/material.dart';

class CrearEventoScreen extends StatelessWidget {
  const CrearEventoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear evento')),
      body: const SafeArea(child: Center(child: Text('Crear o editar evento'))),
    );
  }
}
