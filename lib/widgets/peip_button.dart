import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum PeipButtonKind { primary, secondary, ghost, danger }

class PeipButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final PeipButtonKind kind;
  final IconData? icon;
  final bool expand;

  const PeipButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.kind = PeipButtonKind.primary,
    this.icon,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
        Flexible(
          child: Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
    );
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
    const pad = EdgeInsets.symmetric(vertical: 14, horizontal: 20);

    Widget button;
    switch (kind) {
      case PeipButtonKind.primary:
        button = FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
              backgroundColor: AppColors.brand600, padding: pad, shape: shape),
          child: child,
        );
      case PeipButtonKind.danger:
        button = FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger, padding: pad, shape: shape),
          child: child,
        );
      case PeipButtonKind.secondary:
        button = OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.border),
              padding: pad,
              shape: shape),
          child: child,
        );
      case PeipButtonKind.ghost:
        button = TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(foregroundColor: AppColors.brand600),
          child: child,
        );
    }
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
