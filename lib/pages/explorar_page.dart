import 'package:flutter/material.dart';

import '../model/models.dart';
import '../theme/app_colors.dart';
import '../widgets/widgets.dart';

class ExplorarPage extends StatefulWidget {
  final ({List<Evento> eventos, bool coincidenciaExacta}) resultado;
  final String consulta;
  final List<BusquedaReciente> recientes;
  final List<Categoria> categorias;
  final int? categoriaFiltro;
  final Categoria Function(int idCategoria) categoriaDe;
  final Ciudad Function(int idCiudad) ciudadDe;
  final bool Function(int idEvento) estaGuardado;
  final bool personalizacionActiva;
  final int Function(Evento evento) afinidadDe;
  final ValueChanged<String> onBuscar;
  final ValueChanged<int> onBorrarReciente;
  final ValueChanged<int> onToggleCategoria;
  final ValueChanged<int> onToggleGuardado;
  final ValueChanged<int> onAbrirEvento;

  const ExplorarPage({
    super.key,
    required this.resultado,
    required this.consulta,
    required this.recientes,
    required this.categorias,
    required this.categoriaFiltro,
    required this.categoriaDe,
    required this.ciudadDe,
    required this.estaGuardado,
    required this.personalizacionActiva,
    required this.afinidadDe,
    required this.onBuscar,
    required this.onBorrarReciente,
    required this.onToggleCategoria,
    required this.onToggleGuardado,
    required this.onAbrirEvento,
  });

  @override
  State<ExplorarPage> createState() => _ExplorarPageState();
}

class _ExplorarPageState extends State<ExplorarPage> {
  late final _ctrl = TextEditingController(text: widget.consulta);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hayConsulta = widget.consulta.isNotEmpty;
    final eventos = widget.resultado.eventos;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          PeipSearchBar(
            controller: _ctrl,
            onSubmitted: widget.onBuscar,
            onClear: () {
              _ctrl.clear();
              widget.onBuscar('');
            },
          ),
          if (!hayConsulta && widget.recientes.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 4, children: [
              for (final r in widget.recientes)
                InputChip(
                  label: Text(r.texto),
                  onPressed: () {
                    _ctrl.text = r.texto;
                    widget.onBuscar(r.texto);
                  },
                  onDeleted: () => widget.onBorrarReciente(r.idBusqueda),
                ),
            ]),
          ],
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              for (final c in widget.categorias) ...[
                PeipChip(
                  label: c.nombre,
                  selected: widget.categoriaFiltro == c.idCategoria,
                  onTap: () => widget.onToggleCategoria(c.idCategoria),
                ),
                const SizedBox(width: 8),
              ],
            ]),
          ),
          Expanded(
            child: eventos.isEmpty
                ? const EmptyState(
                    icon: Icons.search_off,
                    titulo: 'Sin eventos',
                    mensaje: 'No hay nada que mostrar con ese filtro.')
                : hayConsulta
                    ? _listaResultados(eventos)
                    : _listaRecomendados(eventos),
          ),
        ],
      ),
    );
  }

  Widget _listaRecomendados(List<Evento> eventos) {
    return ListView(children: [
      const SectionHeader(titulo: 'Recomendados para ti'),
      for (final e in eventos)
        EventCard(
          evento: e,
          categoria: widget.categoriaDe(e.idCategoria),
          ciudad: widget.ciudadDe(e.idCiudad).nombre,
          guardado: widget.estaGuardado(e.idEvento),
          porcentajeAfinidad:
              widget.personalizacionActiva ? widget.afinidadDe(e) : null,
          onTap: () => widget.onAbrirEvento(e.idEvento),
          onToggleGuardado: () => widget.onToggleGuardado(e.idEvento),
        ),
    ]);
  }

  Widget _listaResultados(List<Evento> eventos) {
    return ListView(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text('${eventos.length} resultados',
            style: const TextStyle(
                fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      ),
      SemanticNote(coincidenciaExacta: widget.resultado.coincidenciaExacta),
      const SizedBox(height: 4),
      for (final e in eventos)
        ResultRow(
          evento: e,
          categoria: widget.categoriaDe(e.idCategoria),
          porcentajeAfinidad:
              widget.personalizacionActiva ? widget.afinidadDe(e) : null,
          onTap: () => widget.onAbrirEvento(e.idEvento),
        ),
    ]);
  }
}
