import 'package:flutter/material.dart';

import '../model/models.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../utils/formato.dart';
import 'peip_badge.dart';

/// Tarjeta de evento para listas (recomendados, guardados). Imagen arriba
/// con los badges superpuestos y el botón de guardar, como en el
/// componente "Event Card" de la galería de Figma — antes tenía un bloque
/// de ícono a la izquierda y el contenido al lado, que no era el patrón real.
class EventCard extends StatelessWidget {
  final Evento evento;
  final Categoria categoria;
  final String ciudad;
  final bool guardado;
  final int precioMinimo;
  final int? porcentajeAfinidad;
  final VoidCallback onTap;
  final VoidCallback onToggleGuardado;

  const EventCard({
    super.key,
    required this.evento,
    required this.categoria,
    required this.ciudad,
    required this.guardado,
    required this.precioMinimo,
    required this.onTap,
    required this.onToggleGuardado,
    this.porcentajeAfinidad,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              Container(height: 120, color: colorImagenEvento(evento.idEvento)),
              if (porcentajeAfinidad != null)
                Positioned(
                  top: 10,
                  left: 10,
                  child: PeipBadge(
                      tipo: PeipBadgeType.match, texto: '$porcentajeAfinidad%'),
                ),
              Positioned(
                bottom: 10,
                left: 10,
                child: PeipBadge(
                    tipo: PeipBadgeType.categoria, texto: categoria.nombre),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: _BotonGuardar(guardado: guardado, onTap: onToggleGuardado),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(evento.titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text('${fechaCorta(evento.fechaInicio)} · $ciudad',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      precioMinimo == 0
                          ? const PeipBadge(
                              tipo: PeipBadgeType.gratis, texto: 'Gratis')
                          : Text(precioTexto(precioMinimo),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary)),
                      const Row(children: [
                        Text('Ver',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.brand600)),
                        Icon(Icons.arrow_forward,
                            size: 14, color: AppColors.brand600),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BotonGuardar extends StatelessWidget {
  final bool guardado;
  final VoidCallback onTap;

  const _BotonGuardar({required this.guardado, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.35),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(guardado ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white, size: 18),
        ),
      ),
    );
  }
}
