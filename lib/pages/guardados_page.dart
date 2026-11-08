import 'package:flutter/material.dart';

import '../model/models.dart';
import '../widgets/widgets.dart';

class GuardadosPage extends StatelessWidget {
  final List<Evento> eventos;
  final Categoria Function(int idCategoria) categoriaDe;
  final Ciudad Function(int idCiudad) ciudadDe;
  final int Function(int idEvento) precioMinimoDe;
  final ValueChanged<int> onToggleGuardado;
  final ValueChanged<int> onAbrirEvento;

  const GuardadosPage({
    super.key,
    required this.eventos,
    required this.categoriaDe,
    required this.ciudadDe,
    required this.precioMinimoDe,
    required this.onToggleGuardado,
    required this.onAbrirEvento,
  });

  @override
  Widget build(BuildContext context) {
    if (eventos.isEmpty) {
      return const EmptyState(
        icon: Icons.bookmark_border,
        titulo: 'Nada guardado todavía',
        mensaje: 'Los eventos que guardes desde Explorar aparecen aquí.',
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(children: [
        const SectionHeader(titulo: 'Guardados'),
        for (final e in eventos)
          EventCard(
            evento: e,
            categoria: categoriaDe(e.idCategoria),
            ciudad: ciudadDe(e.idCiudad).nombre,
            guardado: true,
            precioMinimo: precioMinimoDe(e.idEvento),
            onTap: () => onAbrirEvento(e.idEvento),
            onToggleGuardado: () => onToggleGuardado(e.idEvento),
          ),
      ]),
    );
  }
}
