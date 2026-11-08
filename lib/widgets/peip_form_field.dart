import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Etiqueta + cualquier input (texto, selector, switch…).
class PeipFormField extends StatelessWidget {
  final String label;
  final Widget child;

  const PeipFormField({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}
