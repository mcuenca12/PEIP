import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/formato.dart';

/// Tarjeta de un ticket reservado (lista "Mis tickets").
class ReservaCard extends StatelessWidget {
  final String titulo;
  final String entrada;
  final int cantidad;
  final DateTime fecha;
  final bool usada;
  final VoidCallback onTap;
  final VoidCallback onCancelar;

  const ReservaCard({
    super.key,
    required this.titulo,
    required this.entrada,
    required this.cantidad,
    required this.fecha,
    required this.usada,
    required this.onTap,
    required this.onCancelar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Icon(Icons.qr_code_2,
            size: 38, color: usada ? AppColors.textMuted : AppColors.brand600),
        title: Text(titulo,
            style: const TextStyle(
                fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        subtitle: Text(
            '$cantidad × $entrada · ${fechaCorta(fecha)}${usada ? ' · Usada' : ''}',
            style: const TextStyle(color: AppColors.textSecondary)),
        trailing: usada
            ? null
            : IconButton(
                tooltip: 'Cancelar reserva',
                icon:
                    const Icon(Icons.delete_outline, color: AppColors.danger),
                onPressed: onCancelar),
      ),
    );
  }
}
