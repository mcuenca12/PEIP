# Lecciones Aprendidas

Decisiones y hallazgos que conviene no volver a discutir desde cero.

## Entrega 3

- **El `Scaffold` va en la Screen, nunca en la Page.** La primera versión del
  prototipo tenía `Scaffold` en las once Pages y una sola Screen de 560
  líneas. Se reestructuró porque genera doble sombreado, superposición de
  barras de navegación y fallos en el cálculo del `SafeArea`.
- **Los argumentos de ruta pueden llevar callbacks.** Es lo que permite que
  una pantalla empujada modifique datos sin volverse dueña de ellos.
- **Los porcentajes de afinidad se mantienen entre 63 y 84.** La similitud
  coseno sobre embeddings reales rara vez supera 0.85; un 98 por ciento se
  lee como inventado.
- **Los datos del prototipo son de eventos académicos y profesionales.** Una
  versión anterior usaba eventos culturales y contradecía el documento de
  contexto.

## Entrega 4

- **Las skills de `.agents/` vienen del repo del curso y nombran el proyecto
  del profesor.** Hay que adaptarlas antes de usarlas o generan
  especificaciones sobre otra aplicación.
