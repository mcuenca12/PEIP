import 'package:flutter/material.dart';

import '../model/mock_data.dart';
import '../pages/crear_evento_page.dart';
import '../routes/route_args.dart';

class CrearEventoScreen extends StatelessWidget {
  const CrearEventoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CrearEventoArgs;
    return Scaffold(
      appBar: AppBar(
          title: Text(args.evento == null ? 'Crear evento' : 'Editar evento')),
      body: SafeArea(
        child: CrearEventoPage(
          evento: args.evento,
          entradasActuales: args.entradasActuales,
          edicionesAnteriores: args.edicionesAnteriores,
          categorias: MockData.categorias,
          ciudades: MockData.ciudades,
          etiquetas: MockData.etiquetas,
          entradasDe: args.entradasDe,
          onGuardar: args.onGuardar,
        ),
      ),
    );
  }
}
