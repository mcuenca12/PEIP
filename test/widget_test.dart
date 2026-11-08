import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:peip/main.dart';

/// Recorrido completo, el mismo guion del video de docs/plan.md: entrar,
/// ver recomendados, buscar por significado, abrir un detalle, guardar,
/// reservar y ver el QR, crear un evento y verlo arriba, y apagar la
/// personalización desde Ajustes.
void main() {
  testWidgets('recorrido de punta a punta', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 3000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    // Entrar con el usuario de prueba (ya viene precargado).
    await tester.pumpWidget(const PeipApp());
    expect(find.text('Bienvenido de nuevo'), findsOneWidget);
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pumpAndSettle();

    // Ver los recomendados.
    expect(find.text('Recomendados para ti'), findsOneWidget);
    expect(find.textContaining('% afinidad'), findsWidgets);

    // Buscar "algo sobre liderazgo para mi equipo": el resultado no
    // contiene la palabra "liderazgo" en ningún título.
    await tester.enterText(
        find.byType(TextField).first, 'algo sobre liderazgo para mi equipo');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.text('3 resultados'), findsOneWidget);
    // Ninguno de los tres resultados tiene "liderazgo" en el título: la
    // coincidencia es por significado (categoría/etiquetas), no literal.
    for (final titulo in [
      'Product Leadership Meetup',
      'Agile Leadership Workshop',
      'Coaching for Team Leads',
    ]) {
      expect(find.text(titulo), findsOneWidget);
      expect(titulo.toLowerCase().contains('liderazgo'), false);
    }

    // Abrir un detalle y guardarlo (este no viene guardado de entrada).
    await tester.tap(find.text('Agile Leadership Workshop').first);
    await tester.pumpAndSettle();
    expect(find.text('Detalle'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.bookmark_border));
    await tester.pump();
    expect(find.byIcon(Icons.bookmark), findsOneWidget);

    // Reservar y ver el ticket con el QR.
    await tester.tap(find.text('General Access'));
    await tester.pump();
    await tester.tap(find.text('Reservar'));
    await tester.pumpAndSettle();
    expect(find.text('Mi ticket'), findsOneWidget);
    expect(find.byType(QrImageView), findsOneWidget);

    // Volver (Ticket se empujó sobre Explorar), limpiar la búsqueda y
    // crear un evento, que debe aparecer arriba en la lista.
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    final campos = find.byType(TextFormField);
    await tester.enterText(campos.at(0), 'Charla de cierre del recorrido');
    await tester.enterText(campos.at(3), 'Auditorio Central');
    await tester.tap(find.text('Publicar'));
    await tester.pumpAndSettle();
    expect(
        find.descendant(
            of: find.byType(Card).first,
            matching: find.text('Charla de cierre del recorrido')),
        findsOneWidget);

    // Ir a Ajustes y apagar la personalización.
    await tester.tap(find.text('Ajustes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Personalización activa'));
    await tester.pumpAndSettle();

    // Volver a Explorar y mostrar que cambió: sin porcentajes, por fecha.
    await tester.tap(find.text('Explorar'));
    await tester.pumpAndSettle();
    expect(find.textContaining('% afinidad'), findsNothing);
  });
}
