import 'package:flutter/material.dart';

import '../model/models.dart';
import '../theme/app_colors.dart';
import '../utils/formato.dart';

/// Opción seleccionable de tipo de entrada.
class TicketTypeTile extends StatelessWidget {
  final TipoEntrada entrada;
  final bool selected;
  final VoidCallback onTap;

  const TicketTypeTile({
    super.key,
    required this.entrada,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: selected ? AppColors.brand50 : AppColors.surface,
          border: Border.all(
              color: selected ? AppColors.brand600 : AppColors.border,
              width: selected ? 2 : 1),
        ),
        child: Row(children: [
          Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: AppColors.brand600),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entrada.nombre,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                if (entrada.beneficios != null)
                  Text(entrada.beneficios!,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(precioTexto(entrada.precio),
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ]),
      ),
    );
  }
}
