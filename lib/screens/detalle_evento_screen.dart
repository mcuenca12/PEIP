import 'package:flutter/material.dart';

import '../model/mock_data.dart';
import '../pages/detalle_evento_page.dart';
import '../routes/route_args.dart';

class DetalleEventoScreen extends StatelessWidget {
  const DetalleEventoScreen({super.key});

  Future<void> _confirmarEliminar(
      BuildContext context, VoidCallback onEliminar) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Eliminar evento'),
        content: const Text('Se eliminarán también sus entradas y reservas.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () => Navigator.pop(c, true),
              child: const Text('Eliminar')),
        ],
      ),
    );
    if (ok == true) onEliminar();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as DetalleArgs;
    final e = args.evento;
    final categoria =
        MockData.categorias.firstWhere((c) => c.idCategoria == e.idCategoria);
    final ciudad = MockData.ciudades.firstWhere((c) => c.idCiudad == e.idCiudad);
    final organizador = MockData.organizadores
        .firstWhere((o) => o.idOrganizador == e.idOrganizador);
    final serie = e.idSerie == null
        ? null
        : MockData.series.firstWhere((s) => s.idSerie == e.idSerie).nombre;
    final edicionAnterior = e.idEventoAnterior == null
        ? null
        : MockData.eventos
            .firstWhere((x) => x.idEvento == e.idEventoAnterior)
            .titulo;
    final etiquetas = MockData.etiquetas
        .where((t) => e.idEtiquetas.contains(t.idEtiqueta))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle'), actions: [
        if (args.esPropio) ...[
          IconButton(
              tooltip: 'Editar',
              icon: const Icon(Icons.edit_outlined),
              onPressed: args.onEditar),
          IconButton(
              tooltip: 'Eliminar',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _confirmarEliminar(context, args.onEliminar)),
        ],
      ]),
      body: SafeArea(
        child: DetalleEventoPage(
          evento: e,
          categoria: categoria,
          ciudad: ciudad.nombre,
          organizador: organizador.nombre,
          serieNombre: serie,
          edicionAnteriorTitulo: edicionAnterior,
          entradas: args.entradas,
          etiquetas: etiquetas,
          guardado: args.guardado,
          porcentajeAfinidad: args.porcentajeAfinidad,
          onToggleGuardado: args.onToggleGuardado,
          onReservar: args.onReservar,
        ),
      ),
    );
  }
}
