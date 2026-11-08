import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// El input en sí, sin etiqueta. Para el campo con etiqueta, ver
/// [PeipFormField].
class PeipTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final bool obscure;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const PeipTextField({
    super.key,
    this.hint,
    this.controller,
    this.obscure = false,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.border),
    );
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      maxLines: obscure ? 1 : maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.surface,
        suffixIcon: suffixIcon,
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
            borderSide:
                const BorderSide(color: AppColors.brand600, width: 1.6)),
      ),
    );
  }
}
