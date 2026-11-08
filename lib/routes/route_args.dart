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

/// Lo que recibe /pago: el resumen de la compra antes de confirmarla.
/// Es simulado (sin pasarela real); queda listo para conectar en la
/// siguiente entrega. [onConfirmar] es quien de verdad crea la Reserva.
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

/// Lo que recibe /ticket: la reserva ya resuelta y el callback de cancelar.
class TicketArgs {
  final TicketVista ticket;
  final VoidCallback onCancelar;

  const TicketArgs({required this.ticket, required this.onCancelar});
}

/// Lo que recibe /crear-evento. [evento] null es creación; con evento, es
/// edición. [edicionesAnteriores] solo aplica a creación (ver
/// docs/pantallas.md, "Partir de una edición anterior").
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
