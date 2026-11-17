import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:peip/widgets/error_state.dart';

void main() {
  testWidgets('muestra el mensaje de error', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorState(mensaje: 'Sin conexión.', onReintentar: () {}),
        ),
      ),
    );

    expect(find.text('Algo salió mal'), findsOneWidget);
    expect(find.text('Sin conexión.'), findsOneWidget);
  });

  testWidgets('tocar Reintentar dispara el callback', (tester) async {
    var intentos = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ErrorState(onReintentar: () => intentos++)),
      ),
    );

    await tester.tap(find.text('Reintentar'));
    expect(intentos, 1);
  });
}
