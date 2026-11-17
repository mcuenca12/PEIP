import '../model/models.dart';

// puntaje base: intereses + etiquetas + si es en su ciudad
double _puntajeCrudo(Usuario usuario, Evento evento) {
  var puntaje = usuario.intereses.contains(evento.idCategoria) ? 2.0 : 0.0;
  for (final idEtiqueta in evento.idEtiquetas) {
    puntaje += usuario.pesosEtiquetas[idEtiqueta] ?? 0;
  }
  if (evento.idCiudad == usuario.idCiudad) puntaje += 1;
  return puntaje;
}

// El puntaje crudo se presenta en la franja 63-84%. El piso existe porque
// estos eventos ya pasaron el filtro de recomendados: mostrar un 4% en una
// tarjeta que la app está recomendando se contradice.
int calcularAfinidad(Usuario usuario, Evento evento) {
  final normalizado = (_puntajeCrudo(usuario, evento) / 4.0).clamp(0.0, 1.0);
  return (63 + normalizado * (84 - 63)).round();
}

List<Evento> ordenarRecomendados(Usuario usuario, List<Evento> eventos) {
  final lista = List<Evento>.of(eventos);
  if (usuario.personalizacionActiva) {
    lista.sort((a, b) {
      final cmp = calcularAfinidad(usuario, b).compareTo(calcularAfinidad(usuario, a));
      return cmp != 0 ? cmp : a.fechaInicio.compareTo(b.fechaInicio);
    });
  } else {
    lista.sort((a, b) => a.fechaInicio.compareTo(b.fechaInicio));
  }
  return lista;
}

const _sinonimos = {
  'liderazgo': 'leadership',
  'lider': 'leadership',
  'líder': 'leadership',
  'equipo': 'team',
  'equipos': 'team',
  'agil': 'agile',
  'ágil': 'agile',
  'agilidad': 'agile',
  'entrega': 'delivery',
  'datos': 'data',
  'analitica': 'analytics',
  'analítica': 'analytics',
  'estadistica': 'statistics',
  'estadística': 'statistics',
  'investigacion': 'research',
  'investigación': 'research',
  'innovacion': 'innovation',
  'innovación': 'innovation',
  'emprendimiento': 'entrepreneurship',
  'oratoria': 'speaking',
  'finanzas': 'finance',
  'economia': 'economics',
  'economía': 'economics',
  'sostenibilidad': 'sustainability',
  'bienestar': 'wellbeing',
  'certificacion': 'certification',
  'certificación': 'certification',
  'cambio': 'change',
  'proyecto': 'project',
  'proyectos': 'project',
  'tecnologia': 'tech',
  'tecnología': 'tech',
  'clinica': 'clinical',
  'clínica': 'clinical',
  'salud': 'medical',
};

const _vacias = {
  'algo',
  'sobre',
  'para',
  'mi',
  'tu',
  'su',
  'lo',
  'que',
  'y',
  'o',
  'de',
  'la',
  'el',
  'en',
  'un',
  'una',
  'del',
  'al',
  'los',
  'las',
  'con',
  'por',
};

Set<String> _palabrasClave(String consulta) {
  final limpio = consulta.toLowerCase().replaceAll(RegExp(r'[^a-záéíóúñ0-9\s]'), ' ');
  return limpio
      .split(RegExp(r'\s+'))
      .where((p) => p.length > 2 && !_vacias.contains(p))
      .map((p) => _sinonimos[p] ?? p)
      .toSet();
}

String _textoBuscable(Evento e, Categoria c, List<Etiqueta> etiquetas) {
  final nombresEtiquetas = etiquetas
      .where((t) => e.idEtiquetas.contains(t.idEtiqueta))
      .map((t) => t.nombre);
  return [
    e.titulo,
    e.eslogan ?? '',
    e.descripcion ?? '',
    c.nombre,
    ...nombresEtiquetas,
  ].join(' ').toLowerCase();
}

// Compara palabras clave (con sinónimos es/en) contra el texto del evento.
// Si la consulta trae varias palabras pide dos coincidencias, para no traer
// medio catálogo por una palabra suelta de una frase larga; si trae una sola,
// se conforma con esa.
List<Evento> buscarPorSignificado(
  String consulta,
  List<Evento> eventos,
  Categoria Function(int idCategoria) categoriaDe,
  List<Etiqueta> etiquetas,
) {
  final claves = _palabrasClave(consulta);
  if (claves.isEmpty) return eventos;
  final minimo = claves.length > 1 ? 2 : 1;
  final puntuados = <({Evento evento, int puntaje})>[];
  for (final e in eventos) {
    final texto = _textoBuscable(e, categoriaDe(e.idCategoria), etiquetas);
    final puntaje = claves.where(texto.contains).length;
    if (puntaje >= minimo) puntuados.add((evento: e, puntaje: puntaje));
  }
  puntuados.sort((a, b) => b.puntaje.compareTo(a.puntaje));
  return [for (final p in puntuados) p.evento];
}
