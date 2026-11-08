const _meses = [
  'ene', 'feb', 'mar', 'abr', 'may', 'jun',
  'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
];

String fechaCorta(DateTime d) => '${d.day} ${_meses[d.month - 1]} ${d.year}';

String hora(DateTime d) =>
    '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

String rangoFechas(DateTime ini, DateTime fin, bool todoElDia) {
  if (todoElDia) return '${fechaCorta(ini)} · Todo el día';
  return '${fechaCorta(ini)} · ${hora(ini)} - ${hora(fin)}';
}

String precioTexto(int precio) {
  if (precio == 0) return 'Gratis';
  final s = precio.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return '\$ $buf';
}
