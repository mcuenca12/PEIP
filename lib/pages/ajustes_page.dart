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
  final VoidCallback onCerrarSesion;

  const AjustesPage({
    super.key,
    required this.usuario,
    required this.ciudad,
    required this.categorias,
    required this.etiquetas,
    required this.onTogglePersonalizacion,
    required this.onActualizarIntereses,
    required this.onCerrarSesion,
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
        PeipSectionCard(
          titulo: 'Perfil',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                usuario.nombre,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                usuario.email,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 4),
              InfoRow(icon: Icons.location_on_outlined, texto: ciudad.nombre),
              const Divider(height: 24),
              Center(
                child: TextButton(
                  onPressed: onCerrarSesion,
                  child: const Text(
                    'Cerrar sesión',
                    style: TextStyle(
                      color: AppColors.danger,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        PeipSectionCard(
          titulo: 'Privacidad',
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () =>
                onTogglePersonalizacion(!usuario.personalizacionActiva),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Personalización activa',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Ordena por afinidad y muestra el porcentaje de cada evento.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IgnorePointer(
                  child: Switch(
                    value: usuario.personalizacionActiva,
                    onChanged: onTogglePersonalizacion,
                  ),
                ),
              ],
            ),
          ),
        ),
        PeipSectionCard(
          titulo: 'Tus intereses',
          subtitulo: 'Los que elegiste al registrarte. Puedes cambiarlos cuando quieras.',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in categorias)
                PeipChip(
                  label: c.nombre,
                  selected: usuario.intereses.contains(c.idCategoria),
                  icon: usuario.intereses.contains(c.idCategoria)
                      ? Icons.check
                      : null,
                  onTap: () => _toggleInteres(c.idCategoria),
                ),
            ],
          ),
        ),
        if (usuario.pesosEtiquetas.isNotEmpty)
          PeipSectionCard(
            titulo: 'Lo que hemos inferido',
            subtitulo: 'A partir de lo que has abierto y guardado.',
            child: Column(
              children: [
                for (final entrada in usuario.pesosEtiquetas.entries)
                  InferredTagRow(
                    etiqueta: etiquetas
                        .firstWhere((t) => t.idEtiqueta == entrada.key)
                        .nombre,
                    peso: entrada.value,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
