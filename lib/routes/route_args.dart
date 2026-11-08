import 'package:flutter/material.dart';

import '../model/models.dart';
import '../model/vistas.dart';

// lo que recibe /evento: el evento y los callbacks hacia MainScreen
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

// resumen de la compra, onConfirmar es quien realmente crea la reserva
class PagoArgs {
  final String eventoTitulo;
  final TipoEntrada entrada;
  final int cantidad;
  final VoidCallback onConfirmar;

  const PagoArgs({
    required this.eventoTitulo,
    required this.entrada,
    required this.cantidad,
    required this.onConfirmar,
  });
}

class TicketArgs {
  final TicketVista ticket;
  final VoidCallback onCancelar;

  const TicketArgs({required this.ticket, required this.onCancelar});
}

class CrearEventoArgs {
  final Evento? evento;
  final List<TipoEntrada> entradasActuales;
  final List<Evento> edicionesAnteriores;
  final List<TipoEntrada> Function(int idEvento) entradasDe;
  final void Function(Evento evento, List<TipoEntrada> entradas) onGuardar;

  const CrearEventoArgs({
    required this.evento,
    required this.entradasActuales,
    required this.edicionesAnteriores,
    required this.entradasDe,
    required this.onGuardar,
  });
}
