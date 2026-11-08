import 'package:flutter_test/flutter_test.dart';

import 'package:peip/main.dart';

void main() {
  testWidgets('arranca en Login y permite ir a Registro', (tester) async {
    await tester.pumpWidget(const PeipApp());
    expect(find.text('Bienvenido de nuevo'), findsOneWidget);

    await tester.tap(find.text('¿No tienes cuenta? Regístrate'));
    await tester.pumpAndSettle();
    expect(find.text('Crear cuenta'), findsOneWidget);
  });
}
