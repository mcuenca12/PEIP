import 'package:flutter/material.dart';

import '../model/vistas.dart';
import '../widgets/widgets.dart';

class MisTicketsPage extends StatelessWidget {
  final List<TicketVista> tickets;
  final ValueChanged<int> onCancelar;
  final ValueChanged<int> onAbrirTicket;

  const MisTicketsPage({
    super.key,
    required this.tickets,
    required this.onCancelar,
    required this.onAbrirTicket,
  });

  @override
  Widget build(BuildContext context) {
    if (tickets.isEmpty) {
      return const EmptyState(
        icon: Icons.confirmation_num_outlined,
        titulo: 'Sin reservas',
        mensaje: 'Reserva un evento desde su detalle y aparecerá aquí.',
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(children: [
        const SectionHeader(titulo: 'Mis tickets'),
        for (final t in tickets)
          ReservaCard(
            titulo: t.evento.titulo,
            entrada: t.entrada.nombre,
            cantidad: t.reserva.cantidad,
            fecha: t.evento.fechaInicio,
            usada: t.reserva.fechaUso != null,
            onTap: () => onAbrirTicket(t.reserva.idReserva),
            onCancelar: () => onCancelar(t.reserva.idReserva),
          ),
      ]),
    );
  }
}
