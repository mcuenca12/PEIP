import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum PeipBadgeType { match, categoria, gratis }

// el badge de categoria no cambia de color según la categoría
class PeipBadge extends StatelessWidget {
  final PeipBadgeType tipo;
  final String texto;

  const PeipBadge({super.key, required this.tipo, required this.texto});

  @override
  Widget build(BuildContext context) {
    switch (tipo) {
      case PeipBadgeType.gratis:
        return Text(
          texto,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.success,
          ),
        );
      case PeipBadgeType.match:
        return _pastilla(fondo: AppColors.textPrimary, colorTexto: Colors.white);
      case PeipBadgeType.categoria:
        return _pastilla(fondo: AppColors.brand50, colorTexto: AppColors.textPrimary);
    }
  }

  Widget _pastilla({required Color fondo, required Color colorTexto}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: fondo, borderRadius: BorderRadius.circular(20)),
      child: Text(
        texto,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: colorTexto),
      ),
    );
  }
}
