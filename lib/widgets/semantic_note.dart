import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SemanticNote extends StatelessWidget {
  final bool coincidenciaExacta;

  const SemanticNote({super.key, this.coincidenciaExacta = true});

  @override
  Widget build(BuildContext context) {
    final texto = coincidenciaExacta
        ? 'Resultados por significado: pueden no contener tus palabras exactas.'
        : 'Sin coincidencia exacta. Te mostramos lo más cercano por significado.';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.brand50, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, size: 18, color: AppColors.brand600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(texto, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}
