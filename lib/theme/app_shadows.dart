import 'package:flutter/material.dart';

/// Sombras exactas de docs/diseno.md: nunca las había aplicado, aunque el
/// token ya estaba escrito desde la etapa de tema.
class AppShadows {
  /// "0 1 8 al 5% de negro" — tarjetas.
  static const tarjeta = [
    BoxShadow(color: Color(0x0D000000), offset: Offset(0, 1), blurRadius: 8),
  ];

  /// "0 4 14 con brand600 al 35%" — botón primario.
  static const boton = [
    BoxShadow(color: Color(0x595454E9), offset: Offset(0, 4), blurRadius: 14),
  ];
}
