import 'package:flutter/material.dart';

import '../model/mock_data.dart';
import '../model/models.dart';
import '../theme/app_colors.dart';
import '../utils/formato.dart';
import '../widgets/widgets.dart';

class _EntradaForm {
  final int idEntrada; // 0 = nueva
  final TextEditingController nombre;
  final TextEditingController precio;
  final TextEditingController beneficios;

  _EntradaForm({
    this.idEntrada = 0,
    String nombre = '',
    int precio = 0,
    String beneficios = '',
  })  : nombre = TextEditingController(text: nombre),
        precio = TextEditingController(text: precio.toString()),
        beneficios = TextEditingController(text: beneficios);

  void dispose() {
    nombre.dispose();
    precio.dispose();
    beneficios.dispose();
  }
}

/// Crea un evento nuevo o edita uno existente ([evento] != null).
/// Al crear, permite partir de una edición anterior (evento_anterior).
class CrearEventoPage extends StatefulWidget {
  final Evento? evento;
  final List<TipoEntrada> entradasActuales;
  final List<Evento> edicionesAnteriores;
  final List<Categoria> categorias;
  final List<Ciudad> ciudades;
  final List<Etiqueta> etiquetas;
  final List<TipoEntrada> Function(int idEvento) entradasDe;
  final void Function(Evento evento, List<TipoEntrada> entradas) onGuardar;

  const CrearEventoPage({
    super.key,
    required this.evento,
    required this.entradasActuales,
    required this.edicionesAnteriores,
    required this.categorias,
    required this.ciudades,
    required this.etiquetas,
    required this.entradasDe,
    required this.onGuardar,
  });

  @override
  State<CrearEventoPage> createState() => _CrearEventoPageState();
}

class _CrearEventoPageState extends State<CrearEventoPage> {
  final _titulo = TextEditingController();
  final _eslogan = TextEditingController();
  final _descripcion = TextEditingController();
  final _lugar = TextEditingController();
  final _aforo = TextEditingController();
  late int _idCategoria = widget.categorias.first.idCategoria;
  late int _idCiudad = widget.ciudades.first.idCiudad;
  bool _todoElDia = false;
  late DateTime _inicio = DateTime(2026, 12, 20, 18);
  late DateTime _fin = DateTime(2026, 12, 20, 21);
  final Set<int> _etiquetas = {};
  final List<_EntradaForm> _entradas = [];
  int? _idEventoAnterior;
  int? _idSerie;
  int? _anteriorElegido;

  bool get _editando => widget.evento != null;

  @override
  void initState() {
    super.initState();
    final e = widget.evento;
    if (e != null) {
      _cargar(e, widget.entradasActuales, desplazar: false);
      _idEventoAnterior = e.idEventoAnterior;
      _idSerie = e.idSerie;
    } else {
      _entradas.add(_EntradaForm(nombre: 'General'));
    }
  }

  void _cargar(Evento e, List<TipoEntrada> entradas, {required bool desplazar}) {
    _titulo.text = e.titulo;
    _eslogan.text = e.eslogan ?? '';
    _descripcion.text = e.descripcion ?? '';
    _lugar.text = e.lugar;
    _aforo.text = e.aforo?.toString() ?? '';
    _idCategoria = e.idCategoria;
    _idCiudad = e.idCiudad;
    _todoElDia = e.todoElDia;
    DateTime mover(DateTime d) =>
        desplazar ? DateTime(d.year, d.month + 1, d.day, d.hour, d.minute) : d;
    _inicio = mover(e.fechaInicio);
    _fin = mover(e.fechaFin);
    _etiquetas
      ..clear()
      ..addAll(e.idEtiquetas);
    for (final f in _entradas) {
      f.dispose();
    }
    _entradas
      ..clear()
      ..addAll(entradas.map((t) => _EntradaForm(
            idEntrada: desplazar ? 0 : t.idEntrada,
            nombre: t.nombre,
            precio: t.precio,
            beneficios: t.beneficios ?? '',
          )));
    if (_entradas.isEmpty) _entradas.add(_EntradaForm(nombre: 'General'));
  }

  @override
  void dispose() {
    for (final c in [_titulo, _eslogan, _descripcion, _lugar, _aforo]) {
      c.dispose();
    }
    for (final f in _entradas) {
      f.dispose();
    }
    super.dispose();
  }

  Future<DateTime?> _elegirFecha(DateTime actual) async {
    final d = await showDatePicker(
      context: context,
      initialDate: actual,
      firstDate: DateTime(2026),
      lastDate: DateTime(2028),
    );
    if (d == null || !mounted) return null;
    if (_todoElDia) return DateTime(d.year, d.month, d.day);
    final t = await showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(actual));
    if (t == null) return null;
    return DateTime(d.year, d.month, d.day, t.hour, t.minute);
  }

  void _aviso(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  void _guardar(String estado) {
    if (_titulo.text.trim().isEmpty || _lugar.text.trim().isEmpty) {
      _aviso('El título y el lugar son obligatorios.');
      return;
    }
    if (!_todoElDia && !_fin.isAfter(_inicio)) {
      _aviso('La fecha de fin debe ser posterior al inicio.');
      return;
    }
    final entradas = <TipoEntrada>[];
    for (final f in _entradas) {
      final nombre = f.nombre.text.trim();
      final precio = int.tryParse(f.precio.text.trim());
      if (nombre.isEmpty || precio == null || precio < 0) {
        _aviso('Cada entrada necesita nombre y un precio válido.');
        return;
      }
      entradas.add(TipoEntrada(
        idEntrada: f.idEntrada,
        nombre: nombre,
        precio: precio,
        beneficios:
            f.beneficios.text.trim().isEmpty ? null : f.beneficios.text.trim(),
        idEvento: widget.evento?.idEvento ?? 0,
      ));
    }
    final evento = Evento(
      idEvento: widget.evento?.idEvento ?? 0,
      titulo: _titulo.text.trim(),
      eslogan: _eslogan.text.trim().isEmpty ? null : _eslogan.text.trim(),
      descripcion:
          _descripcion.text.trim().isEmpty ? null : _descripcion.text.trim(),
      fechaInicio: _inicio,
      fechaFin: _todoElDia && !_fin.isAfter(_inicio) ? _inicio : _fin,
      todoElDia: _todoElDia,
      lugar: _lugar.text.trim(),
      estado: estado,
      aforo: int.tryParse(_aforo.text.trim()),
      idCategoria: _idCategoria,
      idOrganizador: widget.evento?.idOrganizador ?? kOrganizadorPropio,
      idCiudad: _idCiudad,
      idSerie: _idSerie,
      idEventoAnterior: _idEventoAnterior,
      idEtiquetas: _etiquetas.toList(),
    );
    widget.onGuardar(evento, entradas);
  }

  Widget _bloqueEdicionAnterior() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppColors.brand50, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Partir de una edición anterior',
              style: TextStyle(fontWeight: FontWeight.w700)),
          const Text(
              'Copia datos, etiquetas y entradas; la fecha pasa al mes siguiente.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          DropdownButtonFormField<int>(
            initialValue: _anteriorElegido,
            isExpanded: true,
            hint: const Text('Elegir edición…'),
            items: [
              for (final e in widget.edicionesAnteriores)
                DropdownMenuItem(
                    value: e.idEvento,
                    child: Text(e.titulo,
                        overflow: TextOverflow.ellipsis, maxLines: 1))
            ],
            onChanged: (id) {
              final e = widget.edicionesAnteriores.firstWhere((x) => x.idEvento == id);
              setState(() {
                _anteriorElegido = id;
                _cargar(e, widget.entradasDe(e.idEvento), desplazar: true);
                _idEventoAnterior = e.idEvento;
                _idSerie = e.idSerie;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _filaEntrada(int i) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          flex: 3,
          child: PeipFormField(
              label: 'Nombre', child: PeipTextField(controller: _entradas[i].nombre)),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: PeipFormField(
            label: 'Precio',
            child: PeipTextField(
                controller: _entradas[i].precio, keyboardType: TextInputType.number),
          ),
        ),
        IconButton(
          tooltip: 'Quitar entrada',
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: _entradas.length > 1
              ? () => setState(() => _entradas.removeAt(i).dispose())
              : null,
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (!_editando && widget.edicionesAnteriores.isNotEmpty) ...[
          _bloqueEdicionAnterior(),
          const SizedBox(height: 16),
        ],
        PeipFormField(label: 'Título', child: PeipTextField(controller: _titulo)),
        const SizedBox(height: 12),
        PeipFormField(label: 'Eslogan', child: PeipTextField(controller: _eslogan)),
        const SizedBox(height: 12),
        PeipFormField(
            label: 'Descripción',
            child: PeipTextField(controller: _descripcion, maxLines: 4)),
        const SizedBox(height: 12),
        PeipFormField(label: 'Lugar', child: PeipTextField(controller: _lugar)),
        const SizedBox(height: 12),
        PeipFormField(
          label: 'Aforo',
          child: PeipTextField(controller: _aforo, keyboardType: TextInputType.number),
        ),
        const SizedBox(height: 12),
        PeipFormField(
          label: 'Categoría',
          child: DropdownButtonFormField<int>(
            initialValue: _idCategoria,
            isExpanded: true,
            items: [
              for (final c in widget.categorias)
                DropdownMenuItem(value: c.idCategoria, child: Text(c.nombre))
            ],
            onChanged: (v) => setState(() => _idCategoria = v!),
          ),
        ),
        const SizedBox(height: 12),
        PeipFormField(
          label: 'Ciudad',
          child: DropdownButtonFormField<int>(
            initialValue: _idCiudad,
            isExpanded: true,
            items: [
              for (final c in widget.ciudades)
                DropdownMenuItem(value: c.idCiudad, child: Text(c.nombre))
            ],
            onChanged: (v) => setState(() => _idCiudad = v!),
          ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Todo el día'),
          value: _todoElDia,
          onChanged: (v) => setState(() => _todoElDia = v),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.event),
          title: const Text('Inicio'),
          subtitle: Text(_todoElDia
              ? fechaCorta(_inicio)
              : '${fechaCorta(_inicio)} ${hora(_inicio)}'),
          onTap: () async {
            final d = await _elegirFecha(_inicio);
            if (d != null) setState(() => _inicio = d);
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.event_available),
          title: const Text('Fin'),
          subtitle: Text(
              _todoElDia ? fechaCorta(_fin) : '${fechaCorta(_fin)} ${hora(_fin)}'),
          onTap: () async {
            final d = await _elegirFecha(_fin);
            if (d != null) setState(() => _fin = d);
          },
        ),
        const SectionHeader(titulo: 'Etiquetas'),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final t in widget.etiquetas)
            PeipChip(
              label: t.nombre,
              selected: _etiquetas.contains(t.idEtiqueta),
              onTap: () => setState(() {
                if (!_etiquetas.add(t.idEtiqueta)) _etiquetas.remove(t.idEtiqueta);
              }),
            ),
        ]),
        const SectionHeader(titulo: 'Tipos de entrada'),
        for (var i = 0; i < _entradas.length; i++) _filaEntrada(i),
        PeipButton(
          label: 'Agregar tipo de entrada',
          kind: PeipButtonKind.secondary,
          icon: Icons.add,
          onPressed: () => setState(() => _entradas.add(_EntradaForm())),
        ),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(
            child: PeipButton(
              label: 'Guardar borrador',
              kind: PeipButtonKind.secondary,
              onPressed: () => _guardar('borrador'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: PeipButton(
              label: _editando ? 'Guardar cambios' : 'Publicar',
              onPressed: () => _guardar('publicado'),
            ),
          ),
        ]),
      ],
    );
  }
}
