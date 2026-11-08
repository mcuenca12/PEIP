import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum PeipBadgeType { match, categoria, gratis }

/// Pastilla pequeña para afinidad, categoría o gratuidad.
class PeipBadge extends StatelessWidget {
  final PeipBadgeType tipo;
  final String texto;
  final Color? color;

  const PeipBadge({
    super.key,
    required this.tipo,
    required this.texto,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final base = color ??
        switch (tipo) {
          PeipBadgeType.match => AppColors.brand600,
          PeipBadgeType.categoria => AppColors.brand600,
          PeipBadgeType.gratis => AppColors.success,
        };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: base.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(texto,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700, color: base)),
    );
  }
}
