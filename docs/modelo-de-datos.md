# Modelo de datos

Es el MER que entregó el equipo en la fase anterior. Cada tabla se vuelve una
clase en `lib/model/`, con los campos nombrados como las columnas en camelCase.
Las tablas puente no son clases: se representan como colecciones dentro de la
entidad dueña.

## Entidades

**ciudad** — `id_ciudad` (PK), `nombre`

**categoria** — `id_categoria` (PK), `nombre`, `icono`, `color`

**etiqueta** — `id_etiqueta` (PK), `nombre`

**organizador** — `id_organizador` (PK), `nombre`

**serie_evento** — `id_serie` (PK), `nombre`, `periodicidad`,
`id_organizador` (FK), `id_categoria` (FK)

**evento** — `id_evento` (PK), `titulo`, `eslogan`, `descripcion`,
`fecha_inicio`, `fecha_fin`, `todo_el_dia`, `lugar`, `estado`, `aforo`,
`id_categoria` (FK), `id_organizador` (FK), `id_ciudad` (FK),
`id_serie` (FK, opcional), `id_evento_anterior` (FK a evento, opcional)

`estado` toma `borrador`, `publicado` o `cancelado`.
`id_evento_anterior` es la autorreferencia que permite crear una edición nueva
partiendo de la anterior. Es lo que conecta la app con el tema de eventos
recurrentes del reto, así que vale la pena que se use de verdad.

**tipo_entrada** — `id_entrada` (PK), `nombre`, `precio`, `beneficios`,
`id_evento` (FK)

Un evento tiene uno o varios tipos de entrada. El precio que se muestra en las
tarjetas es el mínimo de sus tipos de entrada. `precio = 0` es gratis.

**reserva** — `id_reserva` (PK), `cantidad`, `codigo_qr` (único),
`fecha_reserva`, `fecha_uso`, `id_usuario` (FK), `id_entrada` (FK)

`fecha_uso` en null significa que la entrada no se ha usado. Es lo que permite
contar "eventos a los que asististe".

Ojo: la reserva apunta a `tipo_entrada`, no a `evento`. Para saber de qué evento
es una reserva hay que pasar por el tipo de entrada.

**usuario** — `id_usuario` (PK), `nombre`, `email` (único), `contrasena_hash`,
`personalizacion_activa`, `id_ciudad` (FK)

## Tablas puente

**usuario_interes** (`id_usuario`, `id_categoria`) → `Set<int> intereses` en Usuario.
Son las categorías que escogió en el onboarding.

**usuario_etiqueta** (`id_usuario`, `id_etiqueta`, `peso`) →
`Map<int, double> pesosEtiquetas` en Usuario. Son las etiquetas que el sistema
infiere de la actividad, con un peso entre 0 y 1.

**evento_guardado** (`id_usuario`, `id_evento`, `fecha_guardado`) → una lista
de `EventoGuardado` en la Screen anfitriona.

**evento_etiqueta** (`id_evento`, `id_etiqueta`) → `List<int> idEtiquetas` en Evento.

**busqueda_reciente** (`id_busqueda`, `texto`, `fecha`, `id_usuario`) → una lista
en la Screen anfitriona. **Cada búsqueda que el usuario ejecuta debe agregarse
acá**, si no la tabla queda muerta y se nota.

## Cómo se simula la recomendación

No hay embeddings. El puntaje de afinidad se calcula así:

1. Tomar las etiquetas del evento (`evento_etiqueta`).
2. Sumar el peso que el usuario tiene para cada una (`usuario_etiqueta`).
3. Sumar un bono si la categoría del evento está en sus intereses
   (`usuario_interes`), y otro si el evento es en su ciudad.
4. Normalizar el resultado al rango **63–84 %**.

Ese rango no es arbitrario: la similitud coseno sobre embeddings de oraciones
rara vez pasa de 0.85 en corpus reales, y en el prototipo de Figma ya usamos ese
rango. Un 98 % es la primera cosa que alguien cuestiona.

Si `usuario.personalizacionActiva` es false, el puntaje no se muestra y la lista
sale en orden de fecha, igual para todos.

## Cómo se simula la búsqueda por significado

El texto del usuario se compara contra título, eslogan, descripción, nombre de
categoría y **nombres de etiquetas**. Como los eventos están etiquetados,
buscar "liderazgo" devuelve el *Agile Leadership Workshop* aunque su título no
contenga la palabra. Eso es lo que hay que poder mostrar en el video.

Cuando no hay ninguna coincidencia, la pantalla no se queda vacía: muestra los
tres eventos con mayor puntaje de afinidad bajo el rótulo de que no hubo
coincidencia exacta pero esto es lo más cercano.
