import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:peip/model/models.dart';
import 'package:peip/widgets/event_card.dart';

final _evento = Evento(
  idEvento: 7,
  titulo: 'Agile Leadership Workshop',
  fechaInicio: DateTime(2026, 12, 4, 14),
  fechaFin: DateTime(2026, 12, 4, 18),
  lugar: 'Auditorio Varela',
  idCategoria: 2,
  idOrganizador: 3,
  idCiudad: 1,
);

const _categoria = Categoria(2, 'Liderazgo', 'leadership', '#7C3AED');

Widget _conTarjeta({
  bool guardado = false,
  int precioMinimo = 140000,
  int? afinidad,
  VoidCallback? onTap,
  VoidCallback? onToggleGuardado,
}) => MaterialApp(
  home: Scaffold(
    body: EventCard(
      evento: _evento,
      categoria: _categoria,
      ciudad: 'Cali',
      guardado: guardado,
      precioMinimo: precioMinimo,
      porcentajeAfinidad: afinidad,
      onTap: onTap ?? () {},
      onToggleGuardado: onToggleGuardado ?? () {},
    ),
  ),
);

void main() {
  testWidgets('muestra título, fecha y ciudad', (tester) async {
    await tester.pumpWidget(_conTarjeta());
    expect(find.text('Agile Leadership Workshop'), findsOneWidget);
    expect(find.text('4 dic 2026 · Cali'), findsOneWidget);
    expect(find.text('Liderazgo'), findsOneWidget);
  });

  testWidgets('con precio en cero muestra Gratis en lugar del valor', (tester) async {
    await tester.pumpWidget(_conTarjeta(precioMinimo: 0));
    expect(find.text('Gratis'), findsOneWidget);
    expect(find.textContaining('\$'), findsNothing);
  });

  testWidgets('con precio muestra el valor formateado', (tester) async {
    await tester.pumpWidget(_conTarjeta());
    expect(find.text('\$ 140.000'), findsOneWidget);
    expect(find.text('Gratis'), findsNothing);
  });

  testWidgets('el porcentaje de afinidad solo aparece si se lo pasan', (tester) async {
    await tester.pumpWidget(_conTarjeta());
    expect(find.textContaining('%'), findsNothing);

    await tester.pumpWidget(_conTarjeta(afinidad: 84));
    expect(find.text('84%'), findsOneWidget);
  });

  testWidgets('el icono de guardado refleja el estado', (tester) async {
    await tester.pumpWidget(_conTarjeta());
    expect(find.byIcon(Icons.bookmark_border), findsOneWidget);

    await tester.pumpWidget(_conTarjeta(guardado: true));
    expect(find.byIcon(Icons.bookmark), findsOneWidget);
  });

  testWidgets('tocar la tarjeta abre el detalle', (tester) async {
    var abierto = 0;
    await tester.pumpWidget(_conTarjeta(onTap: () => abierto++));
    await tester.tap(find.text('Agile Leadership Workshop'));
    expect(abierto, 1);
  });

  // El botón de guardar vive dentro del InkWell de la tarjeta: hay que
  // comprobar que tocarlo no dispara además la navegación al detalle.
  testWidgets('tocar guardar no abre el detalle', (tester) async {
    var abierto = 0;
    var guardados = 0;
    await tester.pumpWidget(
      _conTarjeta(onTap: () => abierto++, onToggleGuardado: () => guardados++),
    );
    await tester.tap(find.byIcon(Icons.bookmark_border));
    expect(guardados, 1);
    expect(abierto, 0);
  });
}
