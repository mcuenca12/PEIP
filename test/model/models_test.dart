import 'package:flutter_test/flutter_test.dart';

import 'package:peip/model/models.dart';

// Las filas de abajo imitan lo que devuelve Supabase: claves en snake_case y
// las fechas como texto ISO. Si alguien renombra una columna del esquema sin
// tocar el modelo, estas pruebas son las que lo avisan.
void main() {
  group('Evento', () {
    final fila = {
      'id_evento': 7,
      'titulo': 'Agile Leadership Workshop',
      'eslogan': 'Liderar sin mandar',
      'descripcion': null,
      'fecha_inicio': '2026-12-04T14:00:00.000Z',
      'fecha_fin': '2026-12-04T18:00:00.000Z',
      'todo_el_dia': false,
      'lugar': 'Auditorio Varela',
      'estado': 'publicado',
      'aforo': 60,
      'imagen_path': 'eventos/7.jpg',
      'id_categoria': 2,
      'id_organizador': 3,
      'id_ciudad': 1,
      'id_serie': null,
      'id_evento_anterior': null,
      'id_etiquetas': [1, 4, 9],
    };

    test('lee todas las columnas de la vista', () {
      final e = Evento.fromMap(fila);
      expect(e.idEvento, 7);
      expect(e.titulo, 'Agile Leadership Workshop');
      expect(e.descripcion, isNull);
      expect(e.fechaInicio, DateTime.parse('2026-12-04T14:00:00.000Z'));
      expect(e.todoElDia, false);
      expect(e.aforo, 60);
      expect(e.imagenPath, 'eventos/7.jpg');
      expect(e.idEtiquetas, [1, 4, 9]);
    });

    test('sin etiquetas devuelve una lista vacía, no null', () {
      final e = Evento.fromMap({...fila, 'id_etiquetas': null});
      expect(e.idEtiquetas, isEmpty);
    });

    test('toMap no manda la columna de identidad', () {
      final m = Evento.fromMap(fila).toMap();
      expect(m.containsKey('id_evento'), false);
      expect(m['titulo'], 'Agile Leadership Workshop');
      expect(m['fecha_inicio'], contains('2026-12-04'));
    });

    test('toMap no manda las etiquetas, que van en su propia tabla', () {
      expect(Evento.fromMap(fila).toMap().containsKey('id_etiquetas'), false);
    });
  });

  group('Reserva', () {
    final fila = {
      'id_reserva': 2,
      'cantidad': 3,
      'codigo_qr': 'PEIP-AGILE-DIC-0002',
      'fecha_reserva': '2026-11-05T15:00:00.000Z',
      'fecha_uso': null,
      'id_usuario': '00000000-0000-4000-8000-000000000001',
      'id_entrada': 14,
    };

    test('fecha_uso en null queda en null', () {
      final r = Reserva.fromMap(fila);
      expect(r.fechaUso, isNull);
      expect(r.idUsuario, '00000000-0000-4000-8000-000000000001');
    });

    test('fecha_uso con valor se parsea', () {
      final r = Reserva.fromMap({...fila, 'fecha_uso': '2026-12-04T14:30:00.000Z'});
      expect(r.fechaUso, DateTime.parse('2026-12-04T14:30:00.000Z'));
    });

    test('toMap deja que la base ponga el qr y la fecha', () {
      final m = Reserva.fromMap(fila).toMap();
      expect(m.keys, containsAll(['cantidad', 'id_usuario', 'id_entrada']));
      expect(m.containsKey('codigo_qr'), false);
      expect(m.containsKey('fecha_reserva'), false);
    });
  });

  group('Usuario', () {
    final fila = {
      'id_usuario': '00000000-0000-4000-8000-000000000001',
      'nombre': 'Ana Torres',
      'personalizacion_activa': true,
      'id_ciudad': 3,
    };

    test('el correo y los intereses llegan por fuera de la fila', () {
      final u = Usuario.fromMap(
        fila,
        email: 'ana.torres@icesi.edu.co',
        intereses: const {1, 2},
        pesosEtiquetas: const {1: 0.86},
      );
      expect(u.email, 'ana.torres@icesi.edu.co');
      expect(u.intereses, {1, 2});
      expect(u.pesosEtiquetas[1], 0.86);
    });

    test('sin esos datos no falla, quedan vacíos', () {
      final u = Usuario.fromMap(fila);
      expect(u.email, '');
      expect(u.intereses, isEmpty);
    });

    test('toMap solo manda lo que de verdad está en la tabla usuario', () {
      final m = Usuario.fromMap(fila, email: 'ana@icesi.edu.co').toMap();
      expect(m, {'nombre': 'Ana Torres', 'personalizacion_activa': true, 'id_ciudad': 3});
    });
  });

  group('catálogos y relaciones', () {
    test('Categoria', () {
      final c = Categoria.fromMap({
        'id_categoria': 2,
        'nombre': 'Liderazgo',
        'icono': 'leadership',
        'color': '#7C3AED',
      });
      expect(c.idCategoria, 2);
      expect(c.color, '#7C3AED');
    });

    test('TipoEntrada', () {
      final fila = {
        'id_entrada': 14,
        'nombre': 'General Access',
        'precio': 140000,
        'beneficios': null,
        'id_evento': 7,
      };
      final t = TipoEntrada.fromMap(fila);
      expect(t.precio, 140000);
      expect(t.beneficios, isNull);
      expect(t.toMap().containsKey('id_entrada'), false);
    });

    test('EventoGuardado usa la llave compuesta completa', () {
      final g = EventoGuardado.fromMap({
        'id_usuario': '00000000-0000-4000-8000-000000000001',
        'id_evento': 11,
        'fecha_guardado': '2026-11-02T14:00:00.000Z',
      });
      expect(g.idEvento, 11);
      expect(g.toMap(), {
        'id_usuario': '00000000-0000-4000-8000-000000000001',
        'id_evento': 11,
      });
    });

    test('BusquedaReciente', () {
      final b = BusquedaReciente.fromMap({
        'id_busqueda': 1,
        'texto': 'agile',
        'fecha': '2026-11-03T16:00:00.000Z',
        'id_usuario': '00000000-0000-4000-8000-000000000001',
      });
      expect(b.texto, 'agile');
      expect(b.toMap(), {'texto': 'agile', 'id_usuario': b.idUsuario});
    });
  });
}
