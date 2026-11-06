// Modelos en memoria. Cada clase corresponde a una tabla del MER de PEIP
// (nombres de campo = columnas en camelCase).

class Ciudad {
  final int idCiudad;
  final String nombre;
  const Ciudad(this.idCiudad, this.nombre);
}

class Categoria {
  final int idCategoria;
  final String nombre;
  final String icono; // nombre simbólico, ver theme/app_icons.dart
  final String color; // hex, p. ej. '#7C3AED'
  const Categoria(this.idCategoria, this.nombre, this.icono, this.color);
}

class Etiqueta {
  final int idEtiqueta;
  final String nombre;
  const Etiqueta(this.idEtiqueta, this.nombre);
}

class Organizador {
  final int idOrganizador;
  final String nombre;
  const Organizador(this.idOrganizador, this.nombre);
}

class SerieEvento {
  final int idSerie;
  final String nombre;
  final String periodicidad;
  final int idOrganizador;
  final int idCategoria;
  const SerieEvento(this.idSerie, this.nombre, this.periodicidad,
      this.idOrganizador, this.idCategoria);
}

class Evento {
  final int idEvento;
  final String titulo;
  final String? eslogan;
  final String? descripcion;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final bool todoElDia;
  final String lugar;
  final String estado; // publicado | borrador | cancelado
  final int? aforo;
  final int idCategoria;
  final int idOrganizador;
  final int idCiudad;
  final int? idSerie;
  final int? idEventoAnterior;
  final List<int> idEtiquetas; // tabla evento_etiqueta

  const Evento({
    required this.idEvento,
    required this.titulo,
    this.eslogan,
    this.descripcion,
    required this.fechaInicio,
    required this.fechaFin,
    this.todoElDia = false,
    required this.lugar,
    this.estado = 'publicado',
    this.aforo,
    required this.idCategoria,
    required this.idOrganizador,
    required this.idCiudad,
    this.idSerie,
    this.idEventoAnterior,
    this.idEtiquetas = const [],
  });
}

class TipoEntrada {
  final int idEntrada;
  final String nombre;
  final int precio; // 0 = gratis
  final String? beneficios;
  final int idEvento;
  const TipoEntrada({
    required this.idEntrada,
    required this.nombre,
    required this.precio,
    this.beneficios,
    required this.idEvento,
  });
}

class Reserva {
  final int idReserva;
  final int cantidad;
  final String codigoQr;
  final DateTime fechaReserva;
  final DateTime? fechaUso;
  final int idUsuario;
  final int idEntrada;
  const Reserva({
    required this.idReserva,
    required this.cantidad,
    required this.codigoQr,
    required this.fechaReserva,
    this.fechaUso,
    required this.idUsuario,
    required this.idEntrada,
  });
}

class Usuario {
  final int idUsuario;
  final String nombre;
  final String email;
  final String contrasenaHash;
  final bool personalizacionActiva;
  final int idCiudad;
  final Set<int> intereses; // tabla usuario_interes (idCategoria)
  final Map<int, double> pesosEtiquetas; // tabla usuario_etiqueta

  const Usuario({
    required this.idUsuario,
    required this.nombre,
    required this.email,
    required this.contrasenaHash,
    this.personalizacionActiva = true,
    required this.idCiudad,
    this.intereses = const {},
    this.pesosEtiquetas = const {},
  });

  Usuario copyWith({
    String? nombre,
    bool? personalizacionActiva,
    int? idCiudad,
    Set<int>? intereses,
  }) =>
      Usuario(
        idUsuario: idUsuario,
        nombre: nombre ?? this.nombre,
        email: email,
        contrasenaHash: contrasenaHash,
        personalizacionActiva:
            personalizacionActiva ?? this.personalizacionActiva,
        idCiudad: idCiudad ?? this.idCiudad,
        intereses: intereses ?? this.intereses,
        pesosEtiquetas: pesosEtiquetas,
      );
}

class BusquedaReciente {
  final int idBusqueda;
  final String texto;
  final DateTime fecha;
  final int idUsuario;
  const BusquedaReciente(
      this.idBusqueda, this.texto, this.fecha, this.idUsuario);
}

class EventoGuardado {
  final int idUsuario;
  final int idEvento;
  final DateTime fechaGuardado;
  const EventoGuardado(this.idUsuario, this.idEvento, this.fechaGuardado);
}
