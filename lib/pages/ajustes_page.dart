import 'package:flutter/material.dart';

import '../model/models.dart';
import '../theme/app_colors.dart';
import '../widgets/widgets.dart';

class AjustesPage extends StatelessWidget {
  final Usuario usuario;
  final Ciudad ciudad;
  final List<Categoria> categorias;
  final List<Etiqueta> etiquetas;
  final ValueChanged<bool> onTogglePersonalizacion;
  final ValueChanged<Set<int>> onActualizarIntereses;

  const AjustesPage({
    super.key,
    required this.usuario,
    required this.ciudad,
    required this.categorias,
    required this.etiquetas,
    required this.onTogglePersonalizacion,
    required this.onActualizarIntereses,
  });

  void _toggleInteres(int idCategoria) {
    final nuevos = Set<int>.of(usuario.intereses);
    if (!nuevos.add(idCategoria)) nuevos.remove(idCategoria);
    onActualizarIntereses(nuevos);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(usuario.nombre,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary)),
        Text(usuario.email,
            style: const TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        InfoRow(icon: Icons.location_on_outlined, texto: ciudad.nombre),
        const SectionHeader(titulo: 'Privacidad'),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: usuario.personalizacionActiva,
          onChanged: onTogglePersonalizacion,
          title: const Text('Personalización activa'),
          subtitle: const Text(
              'Ordena por afinidad y muestra el porcentaje de cada evento.'),
        ),
        const SectionHeader(titulo: 'Tus intereses'),
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (final c in categorias)
              InterestTile(
                categoria: c,
                selected: usuario.intereses.contains(c.idCategoria),
                onTap: () => _toggleInteres(c.idCategoria),
              ),
          ],
        ),
        if (usuario.pesosEtiquetas.isNotEmpty) ...[
          const SectionHeader(titulo: 'Lo que hemos inferido'),
          for (final entrada in usuario.pesosEtiquetas.entries)
            InferredTagRow(
              etiqueta:
                  etiquetas.firstWhere((t) => t.idEtiqueta == entrada.key).nombre,
              peso: entrada.value,
            ),
        ],
      ],
    );
  }
}
