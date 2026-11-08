import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String mensaje;

  const EmptyState({
    super.key,
    required this.icon,
    required this.titulo,
    required this.mensaje,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 56, color: AppColors.border),
          const SizedBox(height: 12),
          Text(titulo,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text(mensaje,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary)),
        ]),
      ),
    );
  }
}
