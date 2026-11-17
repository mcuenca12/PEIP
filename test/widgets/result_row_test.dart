import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:peip/model/models.dart';
import 'package:peip/widgets/result_row.dart';

final _evento = Evento(
  idEvento: 7,
  titulo: 'Coaching for Team Leads',
  fechaInicio: DateTime(2026, 12, 4, 14),
  fechaFin: DateTime(2026, 12, 4, 18),
  lugar: 'Auditorio Varela',
  idCategoria: 2,
  idOrganizador: 3,
  idCiudad: 1,
);

const _categoria = Categoria(2, 'Liderazgo', 'leadership', '#7C3AED');

Widget _conFila({int precioMinimo = 90000, int? afinidad, VoidCallback? onTap}) => MaterialApp(
  home: Scaffold(
    body: ResultRow(
      evento: _evento,
      categoria: _categoria,
      precioMinimo: precioMinimo,
      porcentajeAfinidad: afinidad,
      onTap: onTap ?? () {},
    ),
  ),
);

void main() {
  testWidgets('muestra el título y la categoría con la fecha', (tester) async {
    await tester.pumpWidget(_conFila());
    expect(find.text('Coaching for Team Leads'), findsOneWidget);
    expect(find.text('Liderazgo · 4 dic 2026'), findsOneWidget);
  });

  testWidgets('con precio en cero muestra Gratis', (tester) async {
    await tester.pumpWidget(_conFila(precioMinimo: 0));
    expect(find.text('Gratis'), findsOneWidget);
  });

  testWidgets('con precio muestra el valor formateado', (tester) async {
    await tester.pumpWidget(_conFila());
    expect(find.text('\$ 90.000'), findsOneWidget);
  });

  testWidgets('el porcentaje de afinidad es opcional', (tester) async {
    await tester.pumpWidget(_conFila());
    expect(find.textContaining('%'), findsNothing);

    await tester.pumpWidget(_conFila(afinidad: 71));
    expect(find.text('71%'), findsOneWidget);
  });

  testWidgets('tocar la fila reporta hacia arriba', (tester) async {
    var abierto = 0;
    await tester.pumpWidget(_conFila(onTap: () => abierto++));
    await tester.tap(find.text('Coaching for Team Leads'));
    expect(abierto, 1);
  });
}
