import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:peip/main.dart';
import 'package:peip/routes/app_routes.dart';

void main() {
  testWidgets('arranca en Login y navega a cada ruta', (tester) async {
    await tester.pumpWidget(const PeipApp());
    expect(find.text('Login'), findsOneWidget);

    for (final ruta in AppRoutes.routes.keys) {
      if (ruta == AppRoutes.login) continue;
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pushNamed(ruta);
      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsWidgets);
      navigator.pop();
      await tester.pumpAndSettle();
    }
  });
}
