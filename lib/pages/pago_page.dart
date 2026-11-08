import 'package:flutter/material.dart';

import '../model/models.dart';
import '../theme/app_colors.dart';
import '../utils/formato.dart';
import '../widgets/widgets.dart';

/// Confirmación de compra, simulada: no pide datos reales de pago. Queda
/// lista para conectar una pasarela de verdad en la siguiente entrega.
class PagoPage extends StatefulWidget {
  final String eventoTitulo;
  final TipoEntrada entrada;
  final int cantidad;
  final VoidCallback onConfirmar;

  const PagoPage({
    super.key,
    required this.eventoTitulo,
    required this.entrada,
    required this.cantidad,
    required this.onConfirmar,
  });

  @override
  State<PagoPage> createState() => _PagoPageState();
}

class _PagoPageState extends State<PagoPage> {
  String _metodo = 'Tarjeta';
  bool _procesando = false;

  Future<void> _confirmar() async {
    setState(() => _procesando = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) widget.onConfirmar();
  }

  Widget _fila(String etiqueta, String valor, {bool destacado = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(etiqueta,
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: destacado ? FontWeight.w700 : FontWeight.w400)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(valor,
                textAlign: TextAlign.end,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: destacado ? 18 : 14,
                    color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.entrada.precio * widget.cantidad;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(children: [
        PeipSectionCard(
          titulo: 'Resumen de tu compra',
          child: Column(children: [
            _fila('Evento', widget.eventoTitulo),
            _fila('Tipo de entrada', widget.entrada.nombre),
            _fila('Cantidad', '${widget.cantidad}'),
            _fila('Precio unitario', precioTexto(widget.entrada.precio)),
            const Divider(height: 20),
            _fila('Total', precioTexto(total), destacado: true),
          ]),
        ),
        PeipSectionCard(
          titulo: 'Método de pago',
          child: Wrap(spacing: 8, runSpacing: 8, children: [
            for (final m in const ['Tarjeta', 'PSE', 'Efectivo'])
              PeipChip(
                label: m,
                selected: _metodo == m,
                onTap: () => setState(() => _metodo = m),
              ),
          ]),
        ),
        const SizedBox(height: 8),
        PeipButton(
          label: _procesando ? 'Procesando…' : 'Confirmar compra',
          onPressed: _procesando ? null : _confirmar,
        ),
      ]),
    );
  }
}
