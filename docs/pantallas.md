# Pantallas

Siete rutas. Cada una es una Screen (el `Scaffold`) más una Page (el contenido).
`MainScreen` hospeda cuatro Pages en pestañas, así que son once Pages en total.

## Rutas

```dart
class AppRoutes {
  static const String login      = '/';
  static const String registro   = '/registro';
  static const String onboarding = '/onboarding';
  static const String main       = '/main';
  static const String detalle    = '/evento';
  static const String crearEvento= '/crear-evento';
  static const String ticket     = '/ticket';
}
```

## 1. Login — `/`

`LoginScreen` (stateless) + `LoginPage` (stateful: controladores y mensaje de
error). Campos de correo y contraseña, botón primario, enlace a registro.
Valida contra la lista de usuarios semilla; si falla, muestra el error.
Al entrar, `pushReplacementNamed` a `/main`.

Usuario de prueba y contraseña van en el README del proyecto.

## 2. Registro — `/registro`

`RegistroScreen` + `RegistroPage`. Nombre, correo, contraseña y **selector de
ciudad** (`usuario.id_ciudad` es obligatorio en el MER). Rechaza correos
repetidos. Al registrarse va a `/onboarding`.

## 3. Onboarding — `/onboarding`

`OnboardingScreen` + `OnboardingPage`. Rejilla de las doce áreas de interés
usando `InterestTile`, con un mínimo de tres para continuar y un contador de
seleccionadas. Guarda en `usuario_interes`. Botón de saltar.

## 4. Principal — `/main`

**`MainScreen` es la Screen anfitriona.** Es la dueña de:

- la lista de eventos, tipos de entrada, reservas y guardados
- el usuario en sesión
- las búsquedas recientes
- el índice de pestaña y el texto de búsqueda actual

Usa `IndexedStack` más `NavigationBar` con cuatro destinos: Explorar, Guardados,
Tickets y Ajustes. El `AppBar` cambia de título según la pestaña.

### 4.1 Explorar

Barra de búsqueda, chips de categoría, y la lista de recomendados ordenada por
afinidad. Al escribir, pasa a modo resultados: muestra el conteo, el aviso de
coincidencia por significado (`SemanticNote`) y las filas con `ResultRow`.
Cuando no hay coincidencias, el estado vacío con los tres más cercanos.

Botón flotante o acción en el AppBar para crear un evento.

### 4.2 Guardados

Lista de los eventos guardados, con la posibilidad de quitarlos. Quitar uno hace
desaparecer la tarjeta de inmediato: ese es el caso de **eliminar** que pide el
enunciado. Estado vacío cuando no hay ninguno.

### 4.3 Tickets

Las reservas del usuario, cada una con su evento y tipo de entrada resueltos.
Tocar una abre `/ticket`. Se pueden cancelar.

### 4.4 Ajustes

Nombre y ciudad del usuario, intereses editables (ese es el caso de **editar**),
y el bloque de privacidad con el interruptor de
`usuario.personalizacion_activa`. Apagarlo tiene efecto real: la lista de
Explorar deja de ordenarse por afinidad y deja de mostrar el porcentaje. Que se
note en el video.

## 5. Detalle del evento — `/evento`

`DetalleEventoScreen` + `DetalleEventoPage`. Recibe `DetalleArgs` por
`settings.arguments`, con el evento y los callbacks.

Lleva el bloque de cabecera con categoría y título, el badge de afinidad, la
información de fecha, lugar, ciudad y organizador, la descripción, las
etiquetas, y el selector de tipo de entrada con cantidad. Botón de guardar y
botón de reservar. Si el evento es del usuario, también editar y eliminar.

Si el evento viene de una serie o tiene edición anterior, mostrarlo. Es lo que
conecta con los eventos recurrentes del reto.

Al reservar, crea la `Reserva` con su `codigo_qr` y navega a `/ticket`.

## 6. Crear o editar evento — `/crear-evento`

`CrearEventoScreen` + `CrearEventoPage` (stateful por el formulario). Si recibe
un evento en los argumentos, es edición; si no, creación.

Campos: título, eslogan, descripción, categoría, ciudad, lugar, fecha de inicio
y fin, interruptor de todo el día, aforo, y una lista editable de tipos de
entrada con nombre, precio y beneficios. Etiquetas seleccionables. Botones de
guardar borrador y publicar, que escriben `evento.estado`.

**Partir de una edición anterior**: un selector opcional que precarga el
formulario con los datos de un evento pasado del mismo organizador y deja
`id_evento_anterior` apuntando a él. Es barato y es el diferencial del proyecto.

Al guardar, el evento aparece arriba en Explorar. Ese es el caso de **crear**.

## 7. Ticket — `/ticket`

`TicketScreen` + `TicketPage`. El QR generado con `qr_flutter` a partir del
`codigo_qr`, el código en texto, y el resumen: evento, tipo de entrada,
cantidad, lugar, fecha del evento y fecha de reserva. Botón de cancelar.

## Dónde vive cada cosa

| Dato | Dueño |
|---|---|
| eventos, tipos de entrada, reservas, guardados, búsquedas, usuario | `MainScreen` |
| índice de pestaña, texto de búsqueda, filtro de categoría | `MainScreen` |
| controladores de texto, errores de validación | la Page del formulario |
| tipo de entrada y cantidad seleccionados antes de reservar | `DetalleEventoPage` |

Login, registro y onboarding ocurren antes de `/main`. Para no complicar, el
usuario en sesión se pasa a `/main` por `settings.arguments` y de ahí en
adelante `MainScreen` lo administra.
