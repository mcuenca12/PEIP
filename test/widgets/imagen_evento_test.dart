import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peip/services/imagen_service.dart';
import 'package:peip/widgets/imagen_evento.dart';

Widget _envolver(Widget hijo) => MaterialApp(home: Scaffold(body: hijo));

void main() {
  testWidgets('sin imagen muestra el bloque de color', (tester) async {
    await tester.pumpWidget(
      _envolver(
        const ImagenEvento(
          imagenPath: null,
          color: Colors.purple,
          height: 120,
          child: Icon(Icons.memory),
        ),
      ),
    );

    expect(find.byType(Image), findsNothing);
    expect(find.byIcon(Icons.memory), findsOneWidget);
  });

  testWidgets('con imagen pide la URL pública del bucket', (tester) async {
    await tester.pumpWidget(
      _envolver(
        const ImagenEvento(
          imagenPath: 'abc/1.jpg',
          color: Colors.purple,
          height: 120,
        ),
      ),
    );

    final imagen = tester.widget<Image>(find.byType(Image));
    expect(
      (imagen.image as NetworkImage).url,
      endsWith('/storage/v1/object/public/portadas/abc/1.jpg'),
    );
  });

  test('urlPublica devuelve null si el evento no tiene imagen', () {
    expect(ImagenService.urlPublica(null), isNull);
    expect(ImagenService.urlPublica(''), isNull);
  });
}