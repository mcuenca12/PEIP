import 'package:flutter/material.dart';

import '../services/imagen_service.dart';

// Portada del evento. Si no hay imagen, mientras carga o si falla la
// descarga, muestra el bloque de color de siempre (nunca queda en blanco).
class ImagenEvento extends StatelessWidget {
  final String? imagenPath;
  final Color color;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final Widget? child; // lo que va encima del bloque de color, p. ej. un icono

  const ImagenEvento({
    super.key,
    required this.imagenPath,
    required this.color,
    this.width,
    this.height,
    this.borderRadius = BorderRadius.zero,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final respaldo = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: color, borderRadius: borderRadius),
      child: child == null ? null : Center(child: child),
    );
    final url = ImagenService.urlPublica(imagenPath);
    if (url == null) return respaldo;
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (context, imagen, progreso) =>
            progreso == null ? imagen : respaldo,
        errorBuilder: (context, error, stack) => respaldo,
      ),
    );
  }
}