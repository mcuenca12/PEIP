import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../model/vistas.dart';
import '../theme/app_colors.dart';
import '../utils/formato.dart';
import '../widgets/widgets.dart';

class TicketPage extends StatelessWidget {
  final TicketVista ticket;
  final VoidCallback onCancelar;

  const TicketPage({super.key, required this.ticket, required this.onCancelar});

  @override
  Widget build(BuildContext context) {
    final r = ticket.reserva;
    final e = ticket.evento;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(children: [
            Text(e.titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text(rangoFechas(e.fechaInicio, e.fechaFin, e.todoElDia),
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            QrImageView(data: r.codigoQr, size: 200),
            const SizedBox(height: 8),
            SelectableText(r.codigoQr,
                style: const TextStyle(
                    fontFamily: 'monospace', fontWeight: FontWeight.w700)),
            const Divider(height: 32),
            InfoRow(
                icon: Icons.confirmation_number_outlined,
                texto:
                    '${r.cantidad} × ${ticket.entrada.nombre} (${precioTexto(ticket.entrada.precio)})'),
            InfoRow(icon: Icons.place, texto: e.lugar),
            InfoRow(
                icon: Icons.schedule,
                texto: r.fechaUso != null
                    ? 'Usado el ${fechaCorta(r.fechaUso!)} ${hora(r.fechaUso!)}'
                    : 'Reservado el ${fechaCorta(r.fechaReserva)}'),
          ]),
        ),
        const SizedBox(height: 20),
        if (r.fechaUso == null)
          PeipButton(
              label: 'Cancelar reserva',
              kind: PeipButtonKind.danger,
              icon: Icons.delete_outline,
              onPressed: onCancelar),
      ],
    );
  }
}
