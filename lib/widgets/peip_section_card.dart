import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Agrupa un bloque de formulario bajo un título, en una tarjeta propia.
/// Del patrón de "Publicar un evento" en Figma (Información básica, Cuándo,
/// Dónde…), que agrupaba en paneles en vez de un formulario plano.
class PeipSectionCard extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  final Widget child;

  const PeipSectionCard({
    super.key,
    required this.titulo,
    required this.child,
    this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary)),
          if (subtitulo != null) ...[
            const SizedBox(height: 2),
            Text(subtitulo!,
                style:
                    const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
