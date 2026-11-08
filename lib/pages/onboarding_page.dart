import 'package:flutter/material.dart';

import '../model/models.dart';
import '../widgets/widgets.dart';

class OnboardingPage extends StatefulWidget {
  final List<Categoria> categorias;
  final ValueChanged<Set<int>> onTerminar;

  const OnboardingPage(
      {super.key, required this.categorias, required this.onTerminar});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const _minimo = 3;
  final Set<int> _seleccion = {};

  void _toggle(int id) => setState(() {
        if (!_seleccion.add(id)) _seleccion.remove(id);
      });

  @override
  Widget build(BuildContext context) {
    final listo = _seleccion.length >= _minimo;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('¿Qué te mueve?',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text('Elige al menos tres intereses. PEIP aprende de ellos '
              'para recomendarte mejor.'),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                for (final c in widget.categorias)
                  InterestTile(
                    categoria: c,
                    selected: _seleccion.contains(c.idCategoria),
                    onTap: () => _toggle(c.idCategoria),
                  ),
              ],
            ),
          ),
          Row(children: [
            Expanded(
              child: PeipButton(
                label: 'Saltar',
                kind: PeipButtonKind.ghost,
                onPressed: () => widget.onTerminar(const {}),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: PeipButton(
                label: 'Continuar (${_seleccion.length})',
                onPressed: listo ? () => widget.onTerminar(_seleccion) : null,
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
