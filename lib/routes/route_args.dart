import 'package:flutter/material.dart';

import '../model/models.dart';
import '../model/vistas.dart';

/// Lo que recibe /evento por settings.arguments: el evento y los
/// callbacks hacia el estado que vive en MainScreen (ver
/// docs/convenciones-curso.md, "Cómo se pasan datos y callbacks").
class DetalleArgs {
  final Evento evento;
  final List<TipoEntrada> entradas;
  final bool guardado;
  final bool esPropio;
  final int? porcentajeAfinidad;
  final VoidCallback onToggleGuardado;
  final void Function(int idEntrada, int cantidad) onReservar;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const DetalleArgs({
    required this.evento,
    required this.entradas,
    required this.guardado,
    required this.esPropio,
    required this.porcentajeAfinidad,
    required this.onToggleGuardado,
    required this.onReservar,
    required this.onEditar,
    required this.onEliminar,
  });
}

/// Lo que recibe /ticket: la reserva ya resuelta y el callback de cancelar.
class TicketArgs {
  final TicketVista ticket;
  final VoidCallback onCancelar;

  const TicketArgs({required this.ticket, required this.onCancelar});
}
