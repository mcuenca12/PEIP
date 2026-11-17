// Modelos en memoria. Cada clase corresponde a una tabla del MER de PEIP:
// los campos son las columnas en camelCase, y fromMap/toMap hacen la
// traducción contra los nombres reales, que en Postgres van en snake_case.
//
// Solo llevan toMap las tablas donde la app escribe. Los catálogos (ciudad,
// categoría, etiqueta, organizador, serie) se leen y nunca se insertan desde
// el cliente, así que no lo necesitan.
//
// Las columnas de identidad las genera la base, de modo que toMap no las
// incluye: al actualizar, el servicio filtra por id.

DateTime _fecha(Object? v) => DateTime.parse(v as String);

class Ciudad {
  final int idCiudad;
  final String nombre;
  const Ciudad(this.idCiudad, this.nombre);

  factory Ciudad.fromMap(Map<String, dynamic> m) =>
      Ciudad(m['id_ciudad'] as int, m['nombre'] as String);
}

class Categoria {
  final int idCategoria;
  final String nombre;
  final String icono; // nombre simbólico, ver theme/app_icons.dart
  final String color; // hex, p. ej. '#7C3AED'
  const Categoria(this.idCategoria, this.nombre, this.icono, this.color);

  factory Categoria.fromMap(Map<String, dynamic> m) => Categoria(
    m['id_categoria'] as int,
    m['nombre'] as String,
    m['icono'] as String,
    m['color'] as String,
  );
}

class Etiqueta {
  final int idEtiqueta;
  final String nombre;
  const Etiqueta(this.idEtiqueta, this.nombre);

  factory Etiqueta.fromMap(Map<String, dynamic> m) =>
      Etiqueta(m['id_etiqueta'] as int, m['nombre'] as String);
}

class Organizador {
  final int idOrganizador;
  final String nombre;
  const Organizador(this.idOrganizador, this.nombre);

  factory Organizador.fromMap(Map<String, dynamic> m) =>
      Organizador(m['id_organizador'] as int, m['nombre'] as String);
}

class SerieEvento {
  final int idSerie;
  final String nombre;
  final String periodicidad;
  final int idOrganizador;
  final int idCategoria;
  const SerieEvento(
    this.idSerie,
    this.nombre,
    this.periodicidad,
    this.idOrganizador,
    this.idCategoria,
  );

  factory SerieEvento.fromMap(Map<String, dynamic> m) => SerieEvento(
    m['id_serie'] as int,
    m['nombre'] as String,
    m['periodicidad'] as String,
    m['id_organizador'] as int,
    m['id_categoria'] as int,
  );
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
  final String? imagenPath; // ruta en Storage, null si no tiene imagen
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
    this.imagenPath,
    required this.idCategoria,
    required this.idOrganizador,
    required this.idCiudad,
    this.idSerie,
    this.idEventoAnterior,
    this.idEtiquetas = const [],
  });

  // Se lee de la vista v_evento, que ya trae las etiquetas agregadas.
  factory Evento.fromMap(Map<String, dynamic> m) => Evento(
    idEvento: m['id_evento'] as int,
    titulo: m['titulo'] as String,
    eslogan: m['eslogan'] as String?,
    descripcion: m['descripcion'] as String?,
    fechaInicio: _fecha(m['fecha_inicio']),
    fechaFin: _fecha(m['fecha_fin']),
    todoElDia: m['todo_el_dia'] as bool,
    lugar: m['lugar'] as String,
    estado: m['estado'] as String,
    aforo: m['aforo'] as int?,
    imagenPath: m['imagen_path'] as String?,
    idCategoria: m['id_categoria'] as int,
    idOrganizador: m['id_organizador'] as int,
    idCiudad: m['id_ciudad'] as int,
    idSerie: m['id_serie'] as int?,
    idEventoAnterior: m['id_evento_anterior'] as int?,
    idEtiquetas: List<int>.from(m['id_etiquetas'] as List? ?? const []),
  );

  // idEtiquetas no va aquí: esa relación se guarda en evento_etiqueta.
  Map<String, dynamic> toMap() => {
    'titulo': titulo,
    'eslogan': eslogan,
    'descripcion': descripcion,
    'fecha_inicio': fechaInicio.toIso8601String(),
    'fecha_fin': fechaFin.toIso8601String(),
    'todo_el_dia': todoElDia,
    'lugar': lugar,
    'estado': estado,
    'aforo': aforo,
    'imagen_path': imagenPath,
    'id_categoria': idCategoria,
    'id_organizador': idOrganizador,
    'id_ciudad': idCiudad,
    'id_serie': idSerie,
    'id_evento_anterior': idEventoAnterior,
  };
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

  factory TipoEntrada.fromMap(Map<String, dynamic> m) => TipoEntrada(
    idEntrada: m['id_entrada'] as int,
    nombre: m['nombre'] as String,
    precio: m['precio'] as int,
    beneficios: m['beneficios'] as String?,
    idEvento: m['id_evento'] as int,
  );

  Map<String, dynamic> toMap() => {
    'nombre': nombre,
    'precio': precio,
    'beneficios': beneficios,
    'id_evento': idEvento,
  };
}

class Reserva {
  final int idReserva;
  final int cantidad;
  final String codigoQr;
  final DateTime fechaReserva;
  final DateTime? fechaUso;
  final String idUsuario;
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

  factory Reserva.fromMap(Map<String, dynamic> m) => Reserva(
    idReserva: m['id_reserva'] as int,
    cantidad: m['cantidad'] as int,
    codigoQr: m['codigo_qr'] as String,
    fechaReserva: _fecha(m['fecha_reserva']),
    fechaUso: m['fecha_uso'] == null ? null : _fecha(m['fecha_uso']),
    idUsuario: m['id_usuario'] as String,
    idEntrada: m['id_entrada'] as int,
  );

  // codigo_qr y fecha_reserva los pone la base con sus valores por defecto.
  Map<String, dynamic> toMap() => {
    'cantidad': cantidad,
    'id_usuario': idUsuario,
    'id_entrada': idEntrada,
  };
}

class Usuario {
  final String idUsuario;
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

  // email y contraseña viven en auth.users, no en la tabla usuario: el correo
  // llega aparte, de la sesión. Intereses y pesos salen de sus propias tablas.
  factory Usuario.fromMap(
    Map<String, dynamic> m, {
    String email = '',
    Set<int> intereses = const {},
    Map<int, double> pesosEtiquetas = const {},
  }) => Usuario(
    idUsuario: m['id_usuario'] as String,
    nombre: m['nombre'] as String,
    email: email,
    contrasenaHash: '',
    personalizacionActiva: m['personalizacion_activa'] as bool,
    idCiudad: m['id_ciudad'] as int,
    intereses: intereses,
    pesosEtiquetas: pesosEtiquetas,
  );

  Map<String, dynamic> toMap() => {
    'nombre': nombre,
    'personalizacion_activa': personalizacionActiva,
    'id_ciudad': idCiudad,
  };

  Usuario copyWith({
    String? nombre,
    bool? personalizacionActiva,
    int? idCiudad,
    Set<int>? intereses,
  }) => Usuario(
    idUsuario: idUsuario,
    nombre: nombre ?? this.nombre,
    email: email,
    contrasenaHash: contrasenaHash,
    personalizacionActiva: personalizacionActiva ?? this.personalizacionActiva,
    idCiudad: idCiudad ?? this.idCiudad,
    intereses: intereses ?? this.intereses,
    pesosEtiquetas: pesosEtiquetas,
  );
}

class BusquedaReciente {
  final int idBusqueda;
  final String texto;
  final DateTime fecha;
  final String idUsuario;
  const BusquedaReciente(this.idBusqueda, this.texto, this.fecha, this.idUsuario);

  factory BusquedaReciente.fromMap(Map<String, dynamic> m) => BusquedaReciente(
    m['id_busqueda'] as int,
    m['texto'] as String,
    _fecha(m['fecha']),
    m['id_usuario'] as String,
  );

  Map<String, dynamic> toMap() => {'texto': texto, 'id_usuario': idUsuario};
}

class EventoGuardado {
  final String idUsuario;
  final int idEvento;
  final DateTime fechaGuardado;
  const EventoGuardado(this.idUsuario, this.idEvento, this.fechaGuardado);

  factory EventoGuardado.fromMap(Map<String, dynamic> m) => EventoGuardado(
    m['id_usuario'] as String,
    m['id_evento'] as int,
    _fecha(m['fecha_guardado']),
  );

  Map<String, dynamic> toMap() => {'id_usuario': idUsuario, 'id_evento': idEvento};
}
