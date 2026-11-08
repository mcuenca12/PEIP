import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Barra de búsqueda. Mantiene solo el controlador del texto (estado de UI);
/// reporta el texto enviado con [onSubmitted].
class PeipSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  const PeipSearchBar({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.border),
    );
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: 'Busca por lo que quieres aprender o resolver…',
        prefixIcon: const Icon(Icons.search),
        suffixIcon:
            IconButton(icon: const Icon(Icons.close), onPressed: onClear),
        filled: true,
        fillColor: AppColors.surface,
        border: border,
        enabledBorder: border,
      ),
    );
  }
}
