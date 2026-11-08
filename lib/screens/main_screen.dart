import 'package:flutter/material.dart';

import '../model/mock_data.dart';
import '../model/models.dart';
import '../model/vistas.dart';
import '../pages/ajustes_page.dart';
import '../pages/explorar_page.dart';
import '../pages/guardados_page.dart';
import '../pages/mis_tickets_page.dart';
import '../routes/app_routes.dart';
import '../routes/route_args.dart';
import '../utils/busqueda.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const _titulos = ['Explorar', 'Guardados', 'Mis tickets', 'Ajustes'];

  int _tab = 0;
  String _consulta = '';
  int? _categoriaFiltro;
  bool _usuarioListo = false;
  int? _idRecienCreado;

  late Usuario _usuario;
  late final List<Evento> _eventos = List.of(MockData.eventos);
  late final List<TipoEntrada> _tiposEntrada = List.of(MockData.tiposEntrada);
  late final List<Reserva> _reservas = List.of(MockData.reservas);
  late final List<EventoGuardado> _guardados = List.of(MockData.guardados);
  late final List<BusquedaReciente> _busquedas = List.of(MockData.busquedas);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_usuarioListo) {
      _usuario = ModalRoute.of(context)!.settings.arguments as Usuario;
      _usuarioListo = true;
    }
  }

  Categoria _categoriaDe(int id) =>
      MockData.categorias.firstWhere((c) => c.idCategoria == id);

  Ciudad _ciudadDe(int id) => MockData.ciudades.firstWhere((c) => c.idCiudad == id);

  int _precioMinimoDe(int idEvento) => _tiposEntrada
      .where((t) => t.idEvento == idEvento)
      .map((t) => t.precio)
      .reduce((a, b) => a < b ? a : b);

  List<Evento> get _vigentes =>
      _eventos.where((e) => e.estado != 'cancelado').toList();

  List<Evento> get _porCategoria => _categoriaFiltro == null
      ? _vigentes
      : _vigentes.where((e) => e.idCategoria == _categoriaFiltro).toList();

  /// El recién creado se ancla arriba: la afinidad sola no lo garantiza
  /// (nace sin etiquetas propias) y el enunciado pide que se vea de una.
  List<Evento> get _recomendados {
    final lista = ordenarRecomendados(_usuario, _porCategoria);
    final idx = lista.indexWhere((e) => e.idEvento == _idRecienCreado);
    if (idx <= 0) return lista;
    return [lista.removeAt(idx), ...lista];
  }

  ({List<Evento> eventos, bool coincidenciaExacta}) get _resultadoBusqueda {
    if (_consulta.isEmpty) {
      return (eventos: _recomendados, coincidenciaExacta: true);
    }
    final encontrados = buscarPorSignificado(
        _consulta, _recomendados, _categoriaDe, MockData.etiquetas);
    if (encontrados.isNotEmpty) {
      return (eventos: encontrados, coincidenciaExacta: true);
    }
    final cercanos = ordenarRecomendados(_usuario, _recomendados).take(3);
    return (eventos: cercanos.toList(), coincidenciaExacta: false);
  }

  List<BusquedaReciente> get _busquedasDelUsuario => (_busquedas
          .where((b) => b.idUsuario == _usuario.idUsuario)
          .toList()
        ..sort((a, b) => b.fecha.compareTo(a.fecha)));

  void _buscar(String texto) {
    final t = texto.trim();
    setState(() {
      _consulta = t;
      if (t.isEmpty) return;
      final uid = _usuario.idUsuario;
      _busquedas.removeWhere(
          (b) => b.idUsuario == uid && b.texto.toLowerCase() == t.toLowerCase());
      final siguiente =
          _busquedas.fold(0, (m, b) => b.idBusqueda > m ? b.idBusqueda : m) + 1;
      _busquedas.add(BusquedaReciente(siguiente, t, DateTime.now(), uid));
    });
  }

  void _borrarBusqueda(int id) =>
      setState(() => _busquedas.removeWhere((b) => b.idBusqueda == id));

  void _toggleCategoriaFiltro(int id) =>
      setState(() => _categoriaFiltro = _categoriaFiltro == id ? null : id);

  bool _estaGuardado(int idEvento) => _guardados
      .any((g) => g.idUsuario == _usuario.idUsuario && g.idEvento == idEvento);

  void _toggleGuardado(int idEvento) {
    final uid = _usuario.idUsuario;
    setState(() {
      final antes = _guardados.length;
      _guardados.removeWhere((g) => g.idUsuario == uid && g.idEvento == idEvento);
      if (_guardados.length == antes) {
        _guardados.add(EventoGuardado(uid, idEvento, DateTime.now()));
      }
    });
  }

  List<Evento> get _misGuardados => _guardados
      .where((g) => g.idUsuario == _usuario.idUsuario)
      .map((g) => _eventos.firstWhere((e) => e.idEvento == g.idEvento))
      .toList();

  List<TicketVista> get _misTickets {
    final lista = _reservas.where((r) => r.idUsuario == _usuario.idUsuario).map((r) {
      final entrada = _tiposEntrada.firstWhere((t) => t.idEntrada == r.idEntrada);
      final evento = _eventos.firstWhere((e) => e.idEvento == entrada.idEvento);
      return (reserva: r, entrada: entrada, evento: evento);
    }).toList();
    lista.sort((a, b) => b.reserva.fechaReserva.compareTo(a.reserva.fechaReserva));
    return lista;
  }

  void _cancelarReserva(int idReserva) =>
      setState(() => _reservas.removeWhere((r) => r.idReserva == idReserva));

  void _togglePersonalizacion(bool activa) =>
      setState(() => _usuario = _usuario.copyWith(personalizacionActiva: activa));

  void _actualizarIntereses(Set<int> intereses) =>
      setState(() => _usuario = _usuario.copyWith(intereses: intereses));

  void _abrirEvento(int idEvento) {
    final evento = _eventos.firstWhere((e) => e.idEvento == idEvento);
    Navigator.pushNamed(context, AppRoutes.detalle,
        arguments: DetalleArgs(
          evento: evento,
          entradas: _entradasDe(idEvento),
          guardado: _estaGuardado(idEvento),
          esPropio: evento.idOrganizador == kOrganizadorPropio,
          porcentajeAfinidad: _usuario.personalizacionActiva
              ? calcularAfinidad(_usuario, evento)
              : null,
          onToggleGuardado: () => _toggleGuardado(idEvento),
          onReservar: _reservar,
          onEditar: () => _editarEvento(evento),
          onEliminar: () => _eliminarEvento(idEvento),
        ));
  }

  List<TipoEntrada> _entradasDe(int idEvento) =>
      _tiposEntrada.where((t) => t.idEvento == idEvento).toList();

  void _editarEvento(Evento evento) => Navigator.pushNamed(
        context,
        AppRoutes.crearEvento,
        arguments: CrearEventoArgs(
          evento: evento,
          entradasActuales: _entradasDe(evento.idEvento),
          edicionesAnteriores: const [],
          entradasDe: _entradasDe,
          onGuardar: _guardarEvento,
        ),
      );

  void _guardarEvento(Evento e, List<TipoEntrada> entradas) {
    final nuevo = e.idEvento == 0;
    final idEvento = nuevo
        ? _eventos.fold(0, (m, x) => x.idEvento > m ? x.idEvento : m) + 1
        : e.idEvento;
    final guardado = Evento(
      idEvento: idEvento,
      titulo: e.titulo,
      eslogan: e.eslogan,
      descripcion: e.descripcion,
      fechaInicio: e.fechaInicio,
      fechaFin: e.fechaFin,
      todoElDia: e.todoElDia,
      lugar: e.lugar,
      estado: e.estado,
      aforo: e.aforo,
      idCategoria: e.idCategoria,
      idOrganizador: e.idOrganizador,
      idCiudad: e.idCiudad,
      idSerie: e.idSerie,
      idEventoAnterior: e.idEventoAnterior,
      idEtiquetas: e.idEtiquetas,
    );
    setState(() {
      if (nuevo) {
        _eventos.add(guardado);
        _idRecienCreado = idEvento;
      } else {
        _eventos[_eventos.indexWhere((x) => x.idEvento == idEvento)] = guardado;
        final conservadas = entradas.map((t) => t.idEntrada).toSet();
        final quitadas = _tiposEntrada
            .where((t) => t.idEvento == idEvento && !conservadas.contains(t.idEntrada))
            .map((t) => t.idEntrada)
            .toSet();
        _tiposEntrada.removeWhere((t) => quitadas.contains(t.idEntrada));
        _reservas.removeWhere((r) => quitadas.contains(r.idEntrada));
        _tiposEntrada.removeWhere(
            (t) => t.idEvento == idEvento && conservadas.contains(t.idEntrada));
      }
      for (final t in entradas) {
        _tiposEntrada.add(TipoEntrada(
          idEntrada: t.idEntrada != 0
              ? t.idEntrada
              : _tiposEntrada.fold(0, (m, x) => x.idEntrada > m ? x.idEntrada : m) + 1,
          nombre: t.nombre,
          precio: t.precio,
          beneficios: t.beneficios,
          idEvento: idEvento,
        ));
      }
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(nuevo ? 'Evento publicado.' : 'Cambios guardados.')));
  }

  void _reservar(int idEntrada, int cantidad) {
    final siguiente =
        _reservas.fold(0, (m, r) => r.idReserva > m ? r.idReserva : m) + 1;
    final entrada = _tiposEntrada.firstWhere((t) => t.idEntrada == idEntrada);
    final reserva = Reserva(
      idReserva: siguiente,
      cantidad: cantidad,
      codigoQr: 'PEIP-E${entrada.idEvento}-R$siguiente-U${_usuario.idUsuario}',
      fechaReserva: DateTime.now(),
      idUsuario: _usuario.idUsuario,
      idEntrada: idEntrada,
    );
    setState(() => _reservas.add(reserva));
    final evento = _eventos.firstWhere((e) => e.idEvento == entrada.idEvento);
    Navigator.pop(context);
    Navigator.pushNamed(context, AppRoutes.ticket,
        arguments: TicketArgs(
          ticket: (reserva: reserva, entrada: entrada, evento: evento),
          onCancelar: () => _cerrarYCancelar(reserva.idReserva),
        ));
  }

  void _eliminarEvento(int idEvento) {
    setState(() {
      final idsEntrada = _tiposEntrada
          .where((t) => t.idEvento == idEvento)
          .map((t) => t.idEntrada)
          .toSet();
      _reservas.removeWhere((r) => idsEntrada.contains(r.idEntrada));
      _tiposEntrada.removeWhere((t) => t.idEvento == idEvento);
      _guardados.removeWhere((g) => g.idEvento == idEvento);
      _eventos.removeWhere((e) => e.idEvento == idEvento);
    });
    Navigator.pop(context);
  }

  void _cerrarYCancelar(int idReserva) {
    _cancelarReserva(idReserva);
    Navigator.pop(context);
  }

  void _abrirTicket(int idReserva) {
    final ticket = _misTickets.firstWhere((t) => t.reserva.idReserva == idReserva);
    Navigator.pushNamed(context, AppRoutes.ticket,
        arguments: TicketArgs(
          ticket: ticket,
          onCancelar: () => _cerrarYCancelar(idReserva),
        ));
  }

  void _crearEvento() => Navigator.pushNamed(
        context,
        AppRoutes.crearEvento,
        arguments: CrearEventoArgs(
          evento: null,
          entradasActuales: const [],
          edicionesAnteriores:
              _eventos.where((e) => e.idOrganizador == kOrganizadorPropio).toList(),
          entradasDe: _entradasDe,
          onGuardar: _guardarEvento,
        ),
      );

  void _cerrarSesion() => Navigator.pushNamedAndRemoveUntil(
      context, AppRoutes.login, (route) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titulos[_tab])),
      body: SafeArea(
        child: IndexedStack(index: _tab, children: [
          ExplorarPage(
            resultado: _resultadoBusqueda,
            consulta: _consulta,
            recientes: _busquedasDelUsuario,
            categorias: MockData.categorias,
            categoriaFiltro: _categoriaFiltro,
            categoriaDe: _categoriaDe,
            ciudadDe: _ciudadDe,
            estaGuardado: _estaGuardado,
            personalizacionActiva: _usuario.personalizacionActiva,
            onBuscar: _buscar,
            onBorrarReciente: _borrarBusqueda,
            onToggleCategoria: _toggleCategoriaFiltro,
            onToggleGuardado: _toggleGuardado,
            afinidadDe: (e) => calcularAfinidad(_usuario, e),
            precioMinimoDe: _precioMinimoDe,
            onAbrirEvento: _abrirEvento,
          ),
          GuardadosPage(
            eventos: _misGuardados,
            categoriaDe: _categoriaDe,
            ciudadDe: _ciudadDe,
            precioMinimoDe: _precioMinimoDe,
            onToggleGuardado: _toggleGuardado,
            onAbrirEvento: _abrirEvento,
          ),
          MisTicketsPage(
            tickets: _misTickets,
            onCancelar: _cancelarReserva,
            onAbrirTicket: _abrirTicket,
          ),
          AjustesPage(
            usuario: _usuario,
            ciudad: _ciudadDe(_usuario.idCiudad),
            categorias: MockData.categorias,
            etiquetas: MockData.etiquetas,
            onTogglePersonalizacion: _togglePersonalizacion,
            onActualizarIntereses: _actualizarIntereses,
            onCerrarSesion: _cerrarSesion,
          ),
        ]),
      ),
      floatingActionButton: _tab == 0
          ? FloatingActionButton(
              onPressed: _crearEvento,
              tooltip: 'Crear evento',
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: 'Explorar'),
          NavigationDestination(
              icon: Icon(Icons.bookmark_border),
              selectedIcon: Icon(Icons.bookmark),
              label: 'Guardados'),
          NavigationDestination(
              icon: Icon(Icons.confirmation_num_outlined),
              selectedIcon: Icon(Icons.confirmation_num),
              label: 'Tickets'),
          NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Ajustes'),
        ],
      ),
    );
  }
}
