import 'package:flutter/material.dart';

import '../model/models.dart';
import 'peip_section_card.dart';

// deja elegir una edición pasada del mismo evento para copiar sus datos
class SelectorEdicionAnterior extends StatelessWidget {
  final List<Evento> ediciones;
  final int? idSeleccionado;
  final ValueChanged<Evento> onSeleccionar;

  const SelectorEdicionAnterior({
    super.key,
    required this.ediciones,
    required this.idSeleccionado,
    required this.onSeleccionar,
  });

  @override
  Widget build(BuildContext context) {
    return PeipSectionCard(
      titulo: 'Partir de una edición anterior',
      subtitulo: 'Copia datos, etiquetas y entradas; la fecha pasa al mes siguiente.',
      child: DropdownButtonFormField<int>(
        initialValue: idSeleccionado,
        isExpanded: true,
        hint: const Text('Elegir edición…'),
        items: [
          for (final e in ediciones)
            DropdownMenuItem(
              value: e.idEvento,
              child: Text(e.titulo, overflow: TextOverflow.ellipsis, maxLines: 1),
            ),
        ],
        onChanged: (id) => onSeleccionar(ediciones.firstWhere((e) => e.idEvento == id)),
      ),
    );
  }
}
