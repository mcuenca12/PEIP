import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Barra de progreso del registro (Cuenta → Intereses → Preferencias),
/// como el "Step 2 of 3" del onboarding en Figma.
class PasoIndicador extends StatelessWidget {
  final int actual;
  final int total;

  const PasoIndicador({super.key, required this.actual, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          for (var i = 1; i <= total; i++) ...[
            if (i > 1) const SizedBox(width: 4),
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: i <= actual ? AppColors.brand600 : AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ]),
        const SizedBox(height: 6),
        Text('Paso $actual de $total',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}
