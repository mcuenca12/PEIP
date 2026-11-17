import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:peip/widgets/peip_button.dart';

Widget _conBoton({
  VoidCallback? onPressed,
  PeipButtonKind kind = PeipButtonKind.primary,
  IconData? icon,
  bool expand = true,
}) => MaterialApp(
  home: Scaffold(
    body: PeipButton(
      label: 'Confirmar compra',
      onPressed: onPressed,
      kind: kind,
      icon: icon,
      expand: expand,
    ),
  ),
);

void main() {
  testWidgets('muestra la etiqueta', (tester) async {
    await tester.pumpWidget(_conBoton(onPressed: () {}));
    expect(find.text('Confirmar compra'), findsOneWidget);
  });

  testWidgets('el icono solo aparece si se lo pasan', (tester) async {
    await tester.pumpWidget(_conBoton(onPressed: () {}));
    expect(find.byType(Icon), findsNothing);

    await tester.pumpWidget(_conBoton(onPressed: () {}, icon: Icons.refresh));
    expect(find.byIcon(Icons.refresh), findsOneWidget);
  });

  testWidgets('dispara el callback al tocarlo', (tester) async {
    var toques = 0;
    await tester.pumpWidget(_conBoton(onPressed: () => toques++));
    await tester.tap(find.text('Confirmar compra'));
    expect(toques, 1);
  });

  // onPressed en null es la forma de deshabilitarlo, no hay un flag aparte.
  testWidgets('con onPressed en null queda deshabilitado', (tester) async {
    await tester.pumpWidget(_conBoton());
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).enabled, false);
  });

  testWidgets('cada variante usa el botón de Material que le corresponde', (tester) async {
    for (final (kind, tipo) in [
      (PeipButtonKind.primary, FilledButton),
      (PeipButtonKind.danger, FilledButton),
      (PeipButtonKind.secondary, OutlinedButton),
      (PeipButtonKind.ghost, TextButton),
    ]) {
      await tester.pumpWidget(_conBoton(onPressed: () {}, kind: kind));
      expect(find.byType(tipo), findsOneWidget, reason: '$kind');
    }
  });

  testWidgets('expand decide si el botón ocupa todo el ancho', (tester) async {
    await tester.pumpWidget(_conBoton(onPressed: () {}, expand: false));
    final suelto = tester.getSize(find.byType(FilledButton)).width;

    await tester.pumpWidget(_conBoton(onPressed: () {}));
    expect(tester.getSize(find.byType(FilledButton)).width, greaterThan(suelto));
  });
}
