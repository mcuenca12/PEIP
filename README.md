# PEIP

Módulo de búsqueda y recomendación de eventos para Peewah, del curso Seminario
en Ingeniería de Software (Icesi, 2026-2).

El prototipo navegable en Flutter se entregó en la entrega 3 con datos
simulados en memoria. La entrega 4 conserva la navegación, los componentes y
el manejo de estado, y cambia de dónde salen los datos: Supabase para la base,
la autenticación, la búsqueda de texto completo y las imágenes.

## Cómo correrlo

```
flutter pub get
flutter run
```

Mientras la capa de servicios no esté conectada, la aplicación arranca con los
datos de `lib/model/mock_data.dart` y no necesita credenciales.

## Variables de entorno

La URL y la llave pública del proyecto no van en el código. Se leen con
`String.fromEnvironment` y entran por archivo:

```
cp env.example.json env.json      # y se llenan los dos valores
flutter run --dart-define-from-file=env.json
```

`env.json` está en `.gitignore`. Lo que se entrega es `env.example.json`, con
las llaves presentes y los valores vacíos, para que se sepa qué hace falta sin
publicar nada.

## Usuario de prueba

- Correo: `ana.torres@icesi.edu.co`
- Contraseña: `123456`

Viene precargado en el formulario de login. Es un usuario de los datos
simulados; con la autenticación conectada se reemplaza por una cuenta real.

## Cómo está organizado

```
lib/
  main.dart     MaterialApp(initialRoute, routes) + tema
  routes/       AppRoutes y los argumentos de cada ruta
  model/        una clase por tabla del MER, serialización y datos semilla
  theme/        colores, tipografía e iconos de categoría
  screens/      Scaffold + AppBar, una por ruta
  pages/        el contenido de cada pantalla, sin Scaffold
  widgets/      componentes reutilizables de la galería
  utils/        formateo de fecha/precio, afinidad y búsqueda por significado
supabase/       esquema, políticas de acceso y datos semilla, en SQL
.agents/        especificaciones, planes y tareas por bloque de trabajo
test/           pruebas de serialización, de widgets y el recorrido completo
```

Nueve rutas, nueve Screens, doce Pages y veintidós widgets. Las Screens son
las únicas que llevan `Scaffold` y `AppBar`; `MainScreen` es dueña del estado
de la aplicación y las Pages reportan hacia arriba con callbacks.

Dos componentes de la galería de Figma no tienen widget propio porque los
resuelve Flutter: la barra superior es el `AppBar` de cada Screen, y la
inferior es el `NavigationBar` de `MainScreen`. En cambio `SectionHeader`,
`EmptyState`, `InfoRow`, `ReservaCard`, `PeipSearchBar`, `LoadingState` y
`ErrorState` hicieron falta en el código y no estaban en la galería.

## Sobre la búsqueda

En el prototipo la búsqueda por significado es simulada, sin embeddings:
compara palabras clave de la consulta, con un diccionario de sinónimos
español-inglés, contra título, descripción, categoría y etiquetas del evento
(`lib/utils/busqueda.dart`). En la entrega 4 la reemplaza la búsqueda de texto
completo de Postgres, con `tsvector`, índice GIN y una tabla de sinónimos
(`supabase/01_schema.sql`).

## Pruebas

```
flutter analyze
flutter test
```

`test/model/` cubre la traducción entre las columnas de la base y los campos
de los modelos. `test/widgets/` cubre los componentes de catálogo.
`test/widget_test.dart` recorre la aplicación de punta a punta: entrar, ver
recomendados, buscar, abrir un detalle, guardar, reservar, ver el QR, crear un
evento y apagar la personalización.
