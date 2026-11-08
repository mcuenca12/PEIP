import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/widgets.dart';

// estas preguntas todavía no afectan las recomendaciones, es para más
// adelante
class PreferenciasPage extends StatefulWidget {
  final VoidCallback onTerminar;

  const PreferenciasPage({super.key, required this.onTerminar});

  @override
  State<PreferenciasPage> createState() => _PreferenciasPageState();
}

class _PreferenciasPageState extends State<PreferenciasPage> {
  String _formato = 'Cualquiera';
  String _horario = 'Cualquiera';

  Widget _pregunta(
    String titulo,
    List<String> opciones,
    String valor,
    ValueChanged<String> onElegir,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final o in opciones)
                PeipChip(label: o, selected: valor == o, onTap: () => onElegir(o)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PasoIndicador(actual: 3, total: 3),
          const SizedBox(height: 20),
          const Text(
            'Unas últimas preguntas',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text('Nos sirven para afinar tus recomendaciones más adelante.'),
          const SizedBox(height: 24),
          _pregunta(
            '¿Cómo prefieres los eventos?',
            const ['Presencial', 'Virtual', 'Cualquiera'],
            _formato,
            (v) => setState(() => _formato = v),
          ),
          _pregunta(
            '¿Cuándo te queda mejor?',
            const ['Entre semana', 'Fines de semana', 'Cualquiera'],
            _horario,
            (v) => setState(() => _horario = v),
          ),
          const Spacer(),
          PeipButton(label: 'Empezar a explorar', onPressed: widget.onTerminar),
        ],
      ),
    );
  }
}
