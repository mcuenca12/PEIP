# Estado Actual del Proyecto

## 1. Resumen Ejecutivo

- **Proyecto**: PEIP — módulo de búsqueda y recomendación de eventos de Peewah
- **Repositorio**: github.com/mcuenca12/PEIP (el proyecto Flutter vive en `peip-app/`)
- **Rama de trabajo**: `main`
- **Plataforma objetivo**: Flutter, móvil
- **Estado general**: prototipo navegable completo con datos simulados en
  memoria. Entrega 3 cerrada. Arrancando la entrega 4, que lleva la aplicación
  a funcionar contra Supabase.

---

## 2. Dependencias y Configuración

- **SDK**: Dart `^3.13.5`
- **Dependencias**: `cupertino_icons`, `qr_flutter` (generación del código QR
  del ticket)
- **Análisis**: `flutter_lints` activo
- **Pendiente de agregar**: `supabase_flutter`, y la configuración de variables
  de entorno con `String.fromEnvironment` y `--dart-define-from-file`

---

## 3. Arquitectura

### Navegación

Nueve rutas registradas en `lib/routes/app_routes.dart`, conectadas con
`initialRoute` y `routes:` en `main.dart`:

`/` login · `/registro` · `/onboarding` · `/preferencias` · `/main` ·
`/evento` detalle · `/crear-evento` · `/pago` · `/ticket`

Las pantallas empujadas reciben sus datos y sus callbacks mediante objetos de
argumentos definidos en `lib/routes/route_args.dart` (`DetalleArgs`,
`PagoArgs`, `TicketArgs`, `CrearEventoArgs`), leídos con
`ModalRoute.of(context)!.settings.arguments`.

### Screen anfitriona

`lib/screens/main_screen.dart` es dueña de todo el estado de la aplicación:
eventos, tipos de entrada, reservas, guardados, búsquedas recientes y el
usuario en sesión. Usa `IndexedStack` más `NavigationBar` con cuatro destinos:
Explorar, Guardados, Tickets y Ajustes. Las Pages reciben datos por
constructor y reportan con callbacks.

### Jerarquía de capas

- `lib/screens/` (9 archivos): únicos con `Scaffold`, `AppBar` y navegación.
- `lib/pages/` (12 archivos): contenido del `body`, sin `Scaffold`. Ocho son
  `StatefulWidget` por estado efímero de formulario.
- `lib/widgets/` (18 archivos): componentes reutilizables correspondientes a
  la galería de la entrega 2.
- `lib/model/`: una clase por tabla del MER, más `mock_data.dart`.
- `lib/theme/`: colores, tipografía, iconos y sombras del diseño.
- `lib/utils/`: formateo de fecha y precio, cálculo de afinidad y búsqueda por
  significado.

---

## 4. Origen de los Datos

Actualmente toda la información proviene de `lib/model/mock_data.dart`,
cargada en memoria por `MainScreen` al iniciar. El cálculo de afinidad y la
búsqueda por significado se resuelven en el dispositivo, en
`lib/utils/busqueda.dart`.

La búsqueda compara palabras clave de la consulta contra título, eslogan,
descripción, categoría y etiquetas, con un diccionario de sinónimos
español-inglés. Exige al menos dos coincidencias, lo que hace que una consulta
de una sola palabra no devuelva resultados. Esa limitación desaparece al
mover la búsqueda a la base de datos.

---

## 5. Lo que Cambia en la Entrega 4

La arquitectura de navegación, componentes y gestión de estado se conserva. Lo
que cambia es de dónde salen los datos.

- **Base de datos y búsqueda** (Santiago Laverde): esquema, políticas de
  acceso por fila, datos semilla, y la búsqueda de texto completo con índice
  dentro de Postgres.
- **Autenticación** (Alejandro Arango): registro, inicio y cierre de sesión,
  perfil ligado a la cuenta y sesión persistente.
- **Servicios e integración** (Mateo Cuenca): capa `lib/services/`,
  reemplazo de `MockData` en `MainScreen`, y estados de carga y error.
- **Almacenamiento de imágenes** (Jacobo Sandoval): bucket, carga desde el
  formulario de evento y visualización en tarjetas y detalle.

Cada integrante escribe la especificación, el plan y las tareas de su propio
bloque antes de escribir código.

---

## 6. Deuda Conocida

- `main_screen.dart` (408 líneas) y `crear_evento_page.dart` (421 líneas)
  superan el tamaño habitual del resto del proyecto.
- Al editar un evento no se ofrecen ediciones anteriores: el argumento llega
  siempre vacío.
- `CLAUDE.md` en la raíz todavía describe la entrega 3 y prohíbe el uso de la
  nube. Debe actualizarse al arrancar esta entrega.
