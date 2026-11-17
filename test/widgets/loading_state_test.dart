import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:peip/widgets/loading_state.dart';

void main() {
  testWidgets('muestra el indicador y el mensaje que recibe', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: LoadingState(mensaje: 'Cargando eventos...'))),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Cargando eventos...'), findsOneWidget);
  });
}
