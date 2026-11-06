# Plan de trabajo y criterios

## Orden sugerido

Hacerlo por etapas y **commitear cada una por separado**. Un repo que aparece de
golpe en un solo commit de tres mil líneas se nota, y el historial es parte de
lo que se entrega.

1. **Esqueleto** — `flutter create`, estructura de carpetas, `AppRoutes` con las
   siete rutas apuntando a Screens vacías, `main.dart` conectado. Debe correr y
   navegar entre pantallas en blanco.
2. **Tema y modelos** — `theme/`, las clases de `model/`, `mock_data.dart` con
   los datos semilla. Sin interfaz todavía.
3. **Widgets** — los de `docs/diseno.md`, cada uno una sola vez. Conviene una
   pantalla temporal que los muestre todos para revisarlos; se borra después o
   se deja como galería.
4. **Login, registro y onboarding** — el tramo de entrada completo.
5. **MainScreen y sus cuatro pestañas** — acá vive el estado. Primero Explorar
   con la lista, después búsqueda, después las otras tres pestañas.
6. **Detalle y reserva** — incluye la pantalla de ticket con el QR.
7. **Crear y editar** — con lo de la edición anterior.
8. **Repaso** — `flutter analyze` limpio, revisar que ningún botón quede muerto,
   README, y el test de recorrido.

## Criterios de aceptación

Antes de entregar, verificar uno por uno:

- [ ] Ninguna Page tiene `Scaffold` ni `AppBar`. Comprobable con
      `grep -l "Scaffold(" lib/pages/` — debe salir vacío.
- [ ] Ninguna Page declara listas de eventos, guardados o reservas.
- [ ] `lib/screens/` tiene una Screen por ruta, no un archivo gigante.
- [ ] `AppRoutes` existe y `MaterialApp` usa `initialRoute` y `routes:`.
- [ ] No hay dependencias de manejo de estado en `pubspec.yaml`.
- [ ] Cada widget de la galería existe una vez y se usa desde `lib/widgets/`.
- [ ] Crear un evento lo hace aparecer en Explorar.
- [ ] Quitar un guardado lo hace desaparecer de Guardados.
- [ ] Editar los intereses cambia el orden de los recomendados.
- [ ] Apagar la personalización quita los porcentajes y reordena por fecha.
- [ ] Buscar "algo sobre liderazgo para mi equipo" devuelve los tres de
      liderazgo.
- [ ] Toda búsqueda ejecutada queda en `busquedas_recientes`.
- [ ] Ningún botón sin acción. Se recorre de punta a punta.
- [ ] `flutter analyze` sin warnings.
- [ ] Los nombres de campo de los modelos corresponden a las columnas del MER.

## Sobre el video

Máximo dos minutos. Guion que cubre todo sin apurarse:

entrar con el usuario de prueba · ver los recomendados · buscar "algo sobre
liderazgo para mi equipo" y señalar que los resultados no contienen la palabra ·
abrir un detalle · guardar · reservar y mostrar el QR · crear un evento y verlo
aparecer en la lista · ir a Ajustes y apagar la personalización · volver a
Explorar y mostrar que cambió.

Son unos noventa segundos a ritmo normal.

## Sobre que no parezca generado

Es un criterio que el equipo se puso, y es razonable. Lo que lo delata:

- Comentarios en cada función explicando lo obvio. Comentar el porqué en dos o
  tres lugares difíciles, no el qué en todos.
- Archivos de mil líneas. En el repo del curso las Pages van de 75 a 106 líneas
  y las Screens de 18 a 55. Si algo se dispara, falta extraer un widget.
- Un README enorme y exhaustivo. Debe ser corto: qué es, cómo se corre, cómo
  está organizado, usuario de prueba.
- Un solo commit gigante.
- Mezclar idiomas en los identificadores. El equipo venía nombrando en español
  (`Evento`, `TipoEntrada`, `idUsuario`); mantenerlo.
- Emojis en el código o en el README.

## Sobre MCP

**Para esta entrega no hace falta ninguno.** Es una app Flutter local con datos
en memoria; se construye con el SDK y nada más.

Dos notas por si acaso:

- **Figma MCP** serviría para leer el diseño directamente con
  `get_design_context` sobre el archivo `wxeygKEoL5JQk18geRJSrf`. No es
  necesario porque los tokens y las pantallas están descritos en `docs/`, y
  además la cuenta está en plan Starter con veinte llamadas al mes, ya agotadas.
  Si se activa Figma Education, vale la pena para la fase siguiente.
- **Supabase MCP** aparece en la semana 14 del curso. Es para cuando toque
  conectar a la nube. En esta entrega está prohibido, el enunciado dice
  explícitamente que todavía no se conecta.

## Lo que sigue

La semana 14 del repo del curso trae `spec-driven` y `supabase-services`. Los
modelos de `lib/model/` ya están pegados al MER, así que cuando toque conectar,
lo que cambia es de dónde salen los datos, no la forma de la app. Vale la pena
mantener `mock_data.dart` como única fuente para que ese cambio sea en un punto.
