import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Etiqueta inferida con su barra de peso (0 a 1), para Ajustes.
class InferredTagRow extends StatelessWidget {
  final String etiqueta;
  final double peso;

  const InferredTagRow({
    super.key,
    required this.etiqueta,
    required this.peso,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Expanded(
          flex: 2,
          child: Text(etiqueta,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textPrimary)),
        ),
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: peso,
              minHeight: 8,
              backgroundColor: AppColors.border,
              color: AppColors.brand600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text('${(peso * 100).round()}%',
            style:
                const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ]),
    );
  }
}
