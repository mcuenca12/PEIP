import 'package:flutter/material.dart';

import '../model/models.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../utils/formato.dart';
import '../widgets/widgets.dart';

class DetalleEventoPage extends StatefulWidget {
  final Evento evento;
  final Categoria categoria;
  final String ciudad;
  final String organizador;
  final String? serieNombre;
  final String? edicionAnteriorTitulo;
  final List<TipoEntrada> entradas;
  final List<Etiqueta> etiquetas;
  final bool guardado;
  final int? porcentajeAfinidad;
  final VoidCallback onToggleGuardado;
  final void Function(int idEntrada, int cantidad) onReservar;

  const DetalleEventoPage({
    super.key,
    required this.evento,
    required this.categoria,
    required this.ciudad,
    required this.organizador,
    required this.serieNombre,
    required this.edicionAnteriorTitulo,
    required this.entradas,
    required this.etiquetas,
    required this.guardado,
    required this.porcentajeAfinidad,
    required this.onToggleGuardado,
    required this.onReservar,
  });

  @override
  State<DetalleEventoPage> createState() => _DetalleEventoPageState();
}

class _DetalleEventoPageState extends State<DetalleEventoPage> {
  late bool _guardado = widget.guardado;
  int? _idEntrada;
  int _cantidad = 1;

  void _toggleGuardado() {
    setState(() => _guardado = !_guardado);
    widget.onToggleGuardado();
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.evento;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          height: 140,
          decoration: BoxDecoration(
              color: colorImagenEvento(e.idEvento),
              borderRadius: BorderRadius.circular(18)),
          child: Center(
              child: Icon(iconoDe(widget.categoria.icono),
                  size: 64, color: Colors.white)),
        ),
        const SizedBox(height: 16),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(spacing: 6, runSpacing: 4, children: [
                  PeipBadge(
                      tipo: PeipBadgeType.categoria, texto: widget.categoria.nombre),
                  if (widget.porcentajeAfinidad != null)
                    PeipBadge(
                        tipo: PeipBadgeType.match,
                        texto: '${widget.porcentajeAfinidad}% afinidad'),
                ]),
                const SizedBox(height: 6),
                Text(e.titulo,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary)),
                if (e.eslogan != null)
                  Text(e.eslogan!,
                      style:
                          const TextStyle(color: AppColors.textSecondary, fontSize: 15)),
              ],
            ),
          ),
          IconButton(
            tooltip: _guardado ? 'Quitar de guardados' : 'Guardar',
            onPressed: _toggleGuardado,
            icon: Icon(_guardado ? Icons.bookmark : Icons.bookmark_border,
                color: AppColors.brand600),
          ),
        ]),
        const SizedBox(height: 8),
        InfoRow(
            icon: Icons.event,
            texto: rangoFechas(e.fechaInicio, e.fechaFin, e.todoElDia)),
        InfoRow(icon: Icons.place, texto: '${e.lugar} · ${widget.ciudad}'),
        InfoRow(icon: Icons.groups, texto: 'Organiza ${widget.organizador}'),
        if (e.aforo != null)
          InfoRow(icon: Icons.people_outline, texto: 'Aforo ${e.aforo}'),
        if (widget.serieNombre != null)
          InfoRow(icon: Icons.repeat, texto: 'Serie: ${widget.serieNombre}'),
        if (widget.edicionAnteriorTitulo != null)
          InfoRow(
              icon: Icons.history,
              texto: 'Edición anterior: ${widget.edicionAnteriorTitulo}'),
        if (widget.etiquetas.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 6, children: [
            for (final t in widget.etiquetas) PeipChip(label: t.nombre),
          ]),
        ],
        if (e.descripcion != null) ...[
          const SectionHeader(titulo: 'Acerca del evento'),
          Text(e.descripcion!, style: const TextStyle(color: AppColors.textPrimary)),
        ],
        const SectionHeader(titulo: 'Entradas'),
        if (widget.entradas.isEmpty)
          const Text('Aún no hay entradas disponibles.',
              style: TextStyle(color: AppColors.textSecondary)),
        for (final t in widget.entradas)
          TicketTypeTile(
            entrada: t,
            selected: _idEntrada == t.idEntrada,
            onTap: () => setState(() => _idEntrada = t.idEntrada),
          ),
        if (widget.entradas.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(children: [
            const Text('Cantidad', style: TextStyle(fontWeight: FontWeight.w600)),
            const Spacer(),
            IconButton(
                onPressed: _cantidad > 1 ? () => setState(() => _cantidad--) : null,
                icon: const Icon(Icons.remove_circle_outline)),
            Text('$_cantidad',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            IconButton(
                onPressed: _cantidad < 10 ? () => setState(() => _cantidad++) : null,
                icon: const Icon(Icons.add_circle_outline)),
          ]),
          if (_idEntrada != null) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Total: ',
                    style: TextStyle(color: AppColors.textSecondary)),
                Text(
                    precioTexto(widget.entradas
                            .firstWhere((t) => t.idEntrada == _idEntrada)
                            .precio *
                        _cantidad),
                    style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: AppColors.textPrimary)),
              ],
            ),
          ],
          const SizedBox(height: 8),
          PeipButton(
            label: 'Ir a pagar',
            icon: Icons.confirmation_number_outlined,
            onPressed: _idEntrada == null
                ? null
                : () => widget.onReservar(_idEntrada!, _cantidad),
          ),
        ],
      ],
    );
  }
}
