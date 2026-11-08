import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String titulo;
  final String? accion;
  final VoidCallback? onAccion;

  const SectionHeader({
    super.key,
    required this.titulo,
    this.accion,
    this.onAccion,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(titulo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary)),
          ),
          if (accion != null)
            TextButton(onPressed: onAccion, child: Text(accion!)),
        ],
      ),
    );
  }
}
