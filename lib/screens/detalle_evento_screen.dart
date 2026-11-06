import 'package:flutter/material.dart';

class DetalleEventoScreen extends StatelessWidget {
  const DetalleEventoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Evento')),
      body: const SafeArea(child: Center(child: Text('Detalle del evento'))),
    );
  }
}
