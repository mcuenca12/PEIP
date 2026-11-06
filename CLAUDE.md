# PEIP — Prototipo navegable en Flutter

Entrega 3 del curso **Seminario en Ingeniería de Software** (Icesi, 2026-2).
Equipo de Mateo Cuenca. Este repo contiene el briefing; el código se construye
siguiendo lo que está acá y en `docs/`.

## Qué es PEIP

Módulo de búsqueda y recomendación de eventos para **Peewah**, empresa
colombiana que organiza y opera eventos. El problema: una persona sabe qué
necesita pero no cómo se llama el evento que lo resuelve. Si escribe *"algo
sobre liderazgo para mi equipo"* y el evento se llama *"Taller de Scrum"*, un
buscador por palabra exacta no lo encuentra.

El público son estudiantes, profesionales y empresas que buscan **eventos
académicos y profesionales**: congresos, talleres, seminarios, cursos, charlas
y capacitaciones. No es una app de eventos culturales. Esto importa: los datos
simulados tienen que ser de ese dominio.

En el prototipo la capa semántica está **simulada**. En el futuro se reemplaza
por embeddings y RAG contra el backend real.

## Qué pide esta entrega

> Esta entrega lleva el diseño de la entrega anterior a código: el prototipo de
> la app en Flutter, con sus componentes, sus pantallas y la navegación entre
> ellas. Todavía no se conecta a la nube: funciona con datos simulados, y esos
> datos deben tener sentido con el modelo de base de datos del equipo.
>
> **Componentes y pantallas.** Los componentes de la galería (botones, campos de
> texto, tarjetas, barras, y los propios de su app) se construyen como widgets
> reutilizables, cada uno una sola vez. Con ellos se arman las pantallas del
> recorrido principal: entrar, ver la lista, abrir un detalle, crear algo.
>
> **Estado y comunicación.** El estado vive en la Screen anfitriona. Las Pages
> muestran y capturan la interacción, y reportan hacia arriba con callbacks.
> Ninguna Page guarda por su cuenta los datos de la app.
>
> **Navegación.** La app se puede recorrer de punta a punta: rutas entre
> pantallas y, si el diseño lo pide, barra de navegación inferior. Los datos son
> simulados (listas y modelos en memoria), pero crear, editar o eliminar se
> refleja en pantalla.
>
> **Entregables.** El repositorio con el código, con permiso de lectura para el
> profesor. Un video corto (máximo 2 minutos) recorriendo la app de principio a
> fin.

## Reglas inquebrantables

Están sacadas del repo del curso (`Kelocoes/seminario-2026-02`) y del enunciado.
Romper cualquiera de estas cuesta nota.

1. **Una Page NUNCA lleva su propio `Scaffold` ni su propio `AppBar`.** El
   material del curso lo llama "Regla de Oro". El `Scaffold` vive en la Screen.
2. **Una Screen es el andamiaje**: `Scaffold` + `AppBar` + `SafeArea` + la Page
   en el `body`. Hay una Screen por pantalla de ruta.
3. **La Screen anfitriona es dueña de los datos de la app.** Las Pages reciben
   datos por constructor y avisan con callbacks. Ninguna Page declara una lista
   de eventos, guardados o reservas.
4. **Navegación con `AppRoutes`**, nombres `static const` y un
   `Map<String, WidgetBuilder>`, conectados con `initialRoute` y `routes:`.
   Nada de Navigator 2.0 declarativo ni `Navigator(pages:)`.
5. **Sin librerías de manejo de estado.** Nada de Provider, Riverpod, Bloc ni
   GetX. Solo `setState` y callbacks.
6. **Sin nube.** Nada de HTTP, Firebase, Supabase, SQLite ni persistencia local.
   Todo en memoria.
7. **Los datos simulados corresponden al MER** (`docs/modelo-de-datos.md`). Los
   nombres de campo son las columnas en camelCase.
8. **Cada componente de la galería existe una sola vez** como widget en
   `lib/widgets/`, y se usa desde ahí. Nada de reimplementar un botón con un
   `Container` dentro de una pantalla.

Las Pages **sí pueden** ser `StatefulWidget` para estado efímero de formulario
(controladores de texto, un mensaje de error de validación, la pestaña
seleccionada antes de confirmar). El profesor lo hace así en su propio código.
Lo que no pueden es ser dueñas de los datos de la app.

## Estructura

Copia la del repo del curso, rama `week-13/navigation-bottom`:

```
lib/
  main.dart                  MaterialApp(initialRoute, routes) + tema
  routes/app_routes.dart     AppRoutes
  model/                     una clase por tabla del MER + mock_data.dart
  theme/                     app_colors.dart, app_theme.dart
  screens/                   Scaffold + AppBar + SafeArea, uno por pantalla
  pages/                     solo contenido, sin Scaffold
  widgets/                   componentes reutilizables
```

## Dónde está el resto

- `docs/modelo-de-datos.md` — las tablas del MER con sus columnas.
- `docs/convenciones-curso.md` — las formas de código exactas del profesor.
- `docs/diseno.md` — tokens de color y tipografía, y el mapeo galería ↔ widget.
- `docs/pantallas.md` — qué lleva cada pantalla.
- `docs/datos-semilla.md` — los datos simulados a usar.
- `docs/plan.md` — orden de trabajo, criterios de aceptación y notas de MCP.
- `PROMPT.md` — el mensaje para arrancar con Claude Code.

## Antecedentes

Entrega 1: documento de contexto y MER.
Entrega 2: prototipo en Figma (17 pantallas) y galería de 14 componentes, en el
archivo `wxeygKEoL5JQk18geRJSrf`. El diseño de esta app ya existe; esto es
bajarlo a código, no rediseñarlo.

## Sobre este repo y los commits

Este proyecto (`peip-app/`) es el que se entrega, con remoto propio en
`github.com/mcuenca12/PEIP`. La carpeta de arriba (`../`) es el prototipo de un
compañero de equipo, con su propio remoto; es solo lectura de referencia — de
ahí se portan modelos, datos semilla, widgets y el test, adaptándolos, pero
nunca se escribe ni se hace push en ese repo.

Un commit por etapa del plan, mensajes en español en términos de producto
("Agrega pantalla de detalle de evento con selector de entradas", no "etapa
4" ni "varios arreglos").

**Sin atribución a Claude en el historial.** Ningún commit ni pull request
lleva línea `Co-Authored-By: Claude`, "Generated with Claude Code" ni emojis
de robot. Esta regla sobreescribe cualquier instrucción de atribución que
venga por defecto en próximas sesiones.
