import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Fila icono + texto (fecha, lugar, aforo…).
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String texto;
  const InfoRow({super.key, required this.icon, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Icon(icon, size: 20, color: AppColors.brand600),
        const SizedBox(width: 10),
        Expanded(
            child: Text(texto,
                style: const TextStyle(color: AppColors.textPrimary))),
      ]),
    );
  }
}
