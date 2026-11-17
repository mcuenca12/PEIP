import 'package:flutter/material.dart';

import 'peip_form_field.dart';
import 'peip_text_field.dart';

// una línea del listado de tipos de entrada; onQuitar en null deshabilita el botón
class FilaTipoEntrada extends StatelessWidget {
  final TextEditingController nombre;
  final TextEditingController precio;
  final VoidCallback? onQuitar;

  const FilaTipoEntrada({
    super.key,
    required this.nombre,
    required this.precio,
    required this.onQuitar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: PeipFormField(label: 'Nombre', child: PeipTextField(controller: nombre)),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: PeipFormField(
              label: 'Precio',
              child: PeipTextField(controller: precio, keyboardType: TextInputType.number),
            ),
          ),
          IconButton(
            tooltip: 'Quitar entrada',
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: onQuitar,
          ),
        ],
      ),
    );
  }
}
