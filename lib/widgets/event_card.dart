import 'package:flutter/material.dart';

import '../model/models.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../utils/formato.dart';
import 'peip_badge.dart';

/// Tarjeta de evento para listas (recomendados, guardados).
class EventCard extends StatelessWidget {
  final Evento evento;
  final Categoria categoria;
  final String ciudad;
  final bool guardado;
  final int? porcentajeAfinidad;
  final VoidCallback onTap;
  final VoidCallback onToggleGuardado;

  const EventCard({
    super.key,
    required this.evento,
    required this.categoria,
    required this.ciudad,
    required this.guardado,
    required this.onTap,
    required this.onToggleGuardado,
    this.porcentajeAfinidad,
  });

  @override
  Widget build(BuildContext context) {
    final color = colorDeHex(categoria.color);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(14)),
              child: Icon(iconoDe(categoria.icono),
                  color: Colors.white, size: 30),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(spacing: 6, runSpacing: 4, children: [
                    PeipBadge(
                        tipo: PeipBadgeType.categoria,
                        texto: categoria.nombre,
                        color: color),
                    if (porcentajeAfinidad != null)
                      PeipBadge(
                          tipo: PeipBadgeType.match,
                          texto: '$porcentajeAfinidad% afinidad'),
                  ]),
                  const SizedBox(height: 4),
                  Text(evento.titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(
                      '${fechaCorta(evento.fechaInicio)} · $ciudad · ${evento.lugar}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            IconButton(
              tooltip: guardado ? 'Quitar de guardados' : 'Guardar',
              onPressed: onToggleGuardado,
              icon: Icon(guardado ? Icons.bookmark : Icons.bookmark_border,
                  color: AppColors.brand600),
            ),
          ]),
        ),
      ),
    );
  }
}
