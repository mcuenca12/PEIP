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
- **Pendiente de agregar**: `supabase_flutter` y el `Supabase.initialize` del
  arranque. Las variables de entorno ya están documentadas en el README:
  `String.fromEnvironment` con `--dart-define-from-file=env.json`, y `env.json`
  está ignorado por git.

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
- `lib/widgets/` (22 archivos más el barrel): componentes reutilizables,
  correspondientes a la galería de la entrega 2 más los que hicieron falta en
  el código.
- `lib/model/`: una clase por tabla del MER, con `fromMap`/`toMap` contra las
  columnas reales, más `mock_data.dart`.
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
español-inglés. Pide dos coincidencias cuando la consulta trae varias palabras
y una cuando trae una sola, para no devolver medio catálogo por una palabra
suelta de una frase larga.

Los modelos ya saben leerse y escribirse contra las columnas de la base, de
modo que los servicios solo tienen que hacer las consultas. El identificador
de usuario es el uuid de `auth.users`, no un entero.

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

### Avance

- Santiago tiene el esquema y las políticas en la rama `dev-santiago`, con la
  vista `v_evento` y las funciones de búsqueda y afinidad. Falta mergear a
  `main` y falta el archivo de datos semilla.
- Alejandro tiene mergeada la especificación de autenticación; falta el
  cliente y la sesión.
- Mateo tiene los modelos serializados, los estados de carga y error, y las
  pruebas. Los servicios quedan bloqueados hasta que exista el cliente.
- Jacobo entra por `crear_evento_page.dart`, donde `imagenPath` ya se conserva
  al guardar.

### Decisiones resueltas

- El identificador de usuario es `uuid` y no entero, porque `usuario` referencia
  `auth.users (id)`. Era la decisión abierta del plan de persistencia.
- Los catálogos (ciudad, categoría, etiqueta, organizador, serie) se leen y no
  se escriben desde el cliente, así que sus modelos no llevan `toMap`.

---

## 6. Deuda Conocida

- `main_screen.dart` es el archivo más largo del proyecto (412 líneas). Es por
  diseño: concentra el estado de la aplicación y no tiene métodos `_build`.
- Quedan seis métodos `Widget _...` privados en `preferencias_page`,
  `pago_page`, `ticket_page`, `explorar_page` (dos) y `peip_badge`. Los dos de
  `explorar_page` son listas de eventos y probablemente sean un solo widget.
- `v_evento` ya expone `precio_minimo` y `afinidad` calculados, pero el modelo
  `Evento` todavía no los lee: los resuelve el cliente en `main_screen` y
  `lib/utils/busqueda.dart`. Salen de ahí cuando entren los servicios.
- `Usuario` conserva `email` y `contrasenaHash`, que no existen en el esquema
  porque viven en `auth.users`. Los quita el bloque de autenticación.
