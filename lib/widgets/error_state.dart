import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'peip_button.dart';

class ErrorState extends StatelessWidget {
  final String mensaje;
  final VoidCallback onReintentar;

  const ErrorState({
    super.key,
    this.mensaje = 'No pudimos cargar la información.',
    required this.onReintentar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 56, color: AppColors.border),
            const SizedBox(height: 12),
            const Text(
              'Algo salió mal',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            PeipButton(
              label: 'Reintentar',
              icon: Icons.refresh,
              kind: PeipButtonKind.secondary,
              expand: false,
              onPressed: onReintentar,
            ),
          ],
        ),
      ),
    );
  }
}
