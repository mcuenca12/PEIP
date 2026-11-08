import 'package:flutter/material.dart';

import '../pages/pago_page.dart';
import '../routes/route_args.dart';

class PagoScreen extends StatelessWidget {
  const PagoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PagoArgs;
    return Scaffold(
      appBar: AppBar(title: const Text('Confirmar compra')),
      body: SafeArea(
        child: PagoPage(
          eventoTitulo: args.eventoTitulo,
          entrada: args.entrada,
          cantidad: args.cantidad,
          onConfirmar: args.onConfirmar,
        ),
      ),
    );
  }
}
