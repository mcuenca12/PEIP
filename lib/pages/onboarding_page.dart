import 'package:flutter/material.dart';

import '../model/models.dart';
import '../theme/app_colors.dart';
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('¿Qué te mueve?',
                        style:
                            TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    const Text(
                        'Elige al menos tres intereses. PEIP aprende de ellos '
                        'para recomendarte mejor.'),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                onPressed: () => widget.onTerminar(const {}),
                child: const Text('Saltar'),
              ),
            ],
          ),
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text('${_seleccion.length} seleccionadas',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textSecondary)),
              ),
              const SizedBox(width: 12),
              PeipButton(
                label: 'Continuar',
                expand: false,
                onPressed: listo ? () => widget.onTerminar(_seleccion) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
