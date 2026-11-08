import 'package:flutter/material.dart';

import '../model/models.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';

/// Tile de área de interés, para la rejilla del onboarding.
class InterestTile extends StatelessWidget {
  final Categoria categoria;
  final bool selected;
  final VoidCallback onTap;

  const InterestTile({
    super.key,
    required this.categoria,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = colorDeHex(categoria.color);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: selected ? AppColors.textPrimary : Colors.transparent,
              width: 3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(iconoDe(categoria.icono), color: Colors.white, size: 24),
                if (selected)
                  const Icon(Icons.check_circle, color: Colors.white, size: 20),
              ],
            ),
            const Spacer(),
            Text(categoria.nombre,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    height: 1.15)),
          ],
        ),
      ),
    );
  }
}
