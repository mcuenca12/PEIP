import 'package:flutter/material.dart';

import '../model/models.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../utils/formato.dart';
import 'peip_badge.dart';

/// Fila horizontal de resultados de búsqueda.
class ResultRow extends StatelessWidget {
  final Evento evento;
  final Categoria categoria;
  final int? porcentajeAfinidad;
  final VoidCallback onTap;

  const ResultRow({
    super.key,
    required this.evento,
    required this.categoria,
    required this.onTap,
    this.porcentajeAfinidad,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colorDeHex(categoria.color),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(iconoDe(categoria.icono),
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(evento.titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppColors.textPrimary)),
                Text(
                    '${categoria.nombre} · ${fechaCorta(evento.fechaInicio)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          if (porcentajeAfinidad != null)
            PeipBadge(
                tipo: PeipBadgeType.match, texto: '$porcentajeAfinidad%'),
        ]),
      ),
    );
  }
}
