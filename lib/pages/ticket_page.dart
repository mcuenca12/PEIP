import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../model/vistas.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../utils/formato.dart';
import '../widgets/widgets.dart';

class TicketPage extends StatelessWidget {
  final TicketVista ticket;
  final VoidCallback onCancelar;

  const TicketPage({super.key, required this.ticket, required this.onCancelar});

  Widget _fila(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(etiqueta, style: const TextStyle(color: AppColors.textSecondary)),
          Flexible(
            child: Text(valor,
                textAlign: TextAlign.end,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }

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
            boxShadow: AppShadows.tarjeta,
          ),
          child: Column(children: [
            QrImageView(data: r.codigoQr, size: 180),
            const SizedBox(height: 8),
            SelectableText(r.codigoQr,
                style: const TextStyle(
                    fontFamily: 'monospace', fontWeight: FontWeight.w700)),
            const Divider(height: 32),
            _fila('Evento', e.titulo),
            _fila('Tipo de entrada', ticket.entrada.nombre),
            _fila('Cantidad', '${r.cantidad}'),
            _fila('Total pagado',
                precioTexto(r.cantidad * ticket.entrada.precio)),
            _fila('Lugar', e.lugar),
            _fila('Fecha', rangoFechas(e.fechaInicio, e.fechaFin, e.todoElDia)),
            _fila(
                r.fechaUso != null ? 'Usado el' : 'Reservado el',
                r.fechaUso != null
                    ? '${fechaCorta(r.fechaUso!)} ${hora(r.fechaUso!)}'
                    : fechaCorta(r.fechaReserva)),
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
