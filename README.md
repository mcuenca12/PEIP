# PEIP

Módulo de búsqueda y recomendación de eventos para Peewah. Prototipo
navegable en Flutter — entrega 3 del curso Seminario en Ingeniería de
Software (Icesi, 2026-2). Datos simulados en memoria, sin conexión a la nube.

## Cómo correrlo

```
flutter pub get
flutter run
```

## Usuario de prueba

- Correo: `ana.torres@icesi.edu.co`
- Contraseña: `123456`

(Ya viene precargado en el formulario de login.)

## Cómo está organizado

```
lib/
  main.dart     MaterialApp(initialRoute, routes) + tema
  routes/       AppRoutes y los argumentos de cada ruta
  model/        una clase por tabla del MER, y los datos semilla
  theme/        colores, tipografía e iconos de categoría
  screens/      Scaffold + AppBar, una por ruta
  pages/        el contenido de cada pantalla, sin Scaffold
  widgets/      componentes reutilizables de la galería
  utils/        formateo de fecha/precio, afinidad y búsqueda por significado
```

Dos componentes de la galería de Figma no tienen widget propio porque los
resuelve Flutter: la barra superior es el `AppBar` de cada Screen, y la
inferior es el `NavigationBar` de `MainScreen`. `SectionHeader`, `EmptyState`,
`InfoRow`, `ReservaCard` y `PeipSearchBar` son widgets que hicieron falta en
el código pero no estaban en la galería de Figma.

La búsqueda por significado es simulada (sin embeddings): compara palabras
clave de la consulta, con sinónimos español-inglés, contra título,
descripción, categoría y etiquetas del evento. Ver `lib/utils/busqueda.dart`
y `docs/modelo-de-datos.md`.
