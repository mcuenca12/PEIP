# [SPEC-001] Persistencia, aislamiento de datos y búsqueda por significado

## Metadatos
- ID: SPEC-001
- Fecha: 2026-11-16
- Autor: Santiago Laverde (Bloque A, entrega 4)
- Estado: DRAFT
- Épica relacionada: Épica 2 - Persistencia de la información (HU-04, HU-05); Épica 3 - Descubrimiento, búsqueda y recomendación (HU-08, HU-09, HU-11); Épica 7 - Perfil de gustos y privacidad (HU-20, solo el efecto sobre el listado). Ver .agents/memory/epics.md

## Contexto y Objetivo
Hoy PEIP guarda todo en memoria: al cerrar la aplicación los datos se pierden, todos los usuarios comparten la misma información y la búsqueda necesita al menos dos palabras que coincidan. Por eso buscar "liderazgo" a secas no devuelve nada.

Esta especificación define cómo se comportan los datos de PEIP cuando pasan a un servicio de datos en la nube:

1. Los eventos, entradas, reservas, guardados, intereses y búsquedas recientes se conservan entre sesiones.
2. Cada persona solo accede a su información personal. El catálogo de eventos publicados es de consulta pública.
3. La búsqueda por significado y la recomendación personalizada se resuelven en el servicio de datos y no en el teléfono, de esta forma el dispositivo solo recibe lo que necesita mostrar.

No cambia ninguna pantalla ni agrega funcionalidades. Define de dónde salen los datos y qué reglas se cumplen sobre ellos. Las pantallas se comportan como en la entrega 3.

## Roles Involucrados
- Asistente: explora el listado recomendado, busca eventos, guarda eventos, reserva entradas y administra su perfil de gustos. Solo ve su propia información personal.
- Organizador: publica y gestiona eventos y tipos de entrada. Solo modifica los eventos de su propio organizador. Toda cuenta nueva puede ejercer este rol.
- Visitante sin sesión: solo consulta los eventos publicados.

## Historias de Usuario

### HU-04: Base de datos desplegada
- Como: Equipo de desarrollo
- Quiero: que el modelo de datos exista en la nube, con entidades, relaciones y restricciones coherentes con el modelo entidad-relación de la entrega 1
- Para: que la aplicación trabaje con información real y cualquier integrante pueda reconstruir la base desde cero

### HU-05: Aislamiento de datos entre usuarios
- Como: Asistente
- Quiero: que nadie más vea mis eventos guardados, mis reservas, mis intereses ni mis búsquedas
- Para: proteger mi privacidad

### HU-08: Búsqueda por significado
- Como: Asistente
- Quiero: describir con mis palabras lo que necesito y encontrar eventos relacionados aunque no usen los mismos términos, incluso con una sola palabra
- Para: llegar al evento que resuelve mi necesidad sin saber cómo se llama

### HU-09: Resultados cercanos cuando no hay coincidencia
- Como: Asistente
- Quiero: que la aplicación me proponga eventos cercanos cuando mi búsqueda no encuentra nada
- Para: no quedarme con una pantalla vacía

### HU-11: Orden por afinidad
- Como: Asistente
- Quiero: que los eventos que más me interesan salgan primero, con un porcentaje que explique la recomendación
- Para: descubrir más rápido eventos que me sirven

### HU-20 (parcial): Efecto de la personalización en el listado
- Como: Asistente
- Quiero: que al desactivar la personalización el listado deje de ordenarse por afinidad y no muestre porcentajes
- Para: controlar cómo la plataforma usa mis datos

## Comportamiento por Pantalla / Flujo

### Explorar: listado recomendado
- Punto de entrada: pestaña Explorar de la pantalla principal, con sesión iniciada.
- Información mostrada: eventos vigentes (publicados y no cancelados) con categoría, ciudad, fecha, precio mínimo de entrada y, si la personalización está activa, el porcentaje de afinidad.
- Acciones disponibles: filtrar por categoría, buscar, guardar o quitar de guardados, abrir el detalle.
- Estados:
  - cargando: indicador de carga mientras llegan los eventos.
  - vacío: mensaje "Sin eventos" cuando ninguno cumple el filtro.
  - error: mensaje con opción de reintentar cuando no hay conexión.
  - éxito: lista ordenada por afinidad descendente y, si hay empate, por fecha de inicio ascendente.

### Explorar: búsqueda por significado
- Punto de entrada: barra de búsqueda de Explorar.
- Información mostrada: cantidad de resultados, aviso de coincidencia por significado y los eventos encontrados, del más relevante al menos relevante.
- Acciones disponibles: escribir y confirmar una consulta, limpiar la búsqueda, abrir un resultado.
- Estados:
  - cargando: indicador de carga mientras se resuelve la búsqueda.
  - vacío: si ningún evento coincide, se muestran los tres eventos más afines al usuario con un aviso que explica que no hay coincidencia exacta.
  - error: mensaje con opción de reintentar.
  - éxito: eventos que coinciden, ordenados por relevancia, luego por afinidad y luego por fecha.

### Guardados y Mis tickets
- Punto de entrada: pestañas Guardados y Tickets.
- Información mostrada: solo los eventos guardados y las reservas de la persona con sesión iniciada.
- Estados: cargando, vacío (sin guardados o sin reservas), error con reintento y éxito.
- Un evento con reserva propia sigue apareciendo en Tickets aunque su organizador lo haya pasado a borrador o lo haya cancelado.

### Registro de cuenta (efecto sobre los datos)
- Punto de entrada: pantalla Crear cuenta.
- Al terminar el registro, la persona queda con un perfil (nombre y ciudad) y con un organizador propio, sin pasos extra.

## Reglas de Negocio
- RN-01 Afinidad: el puntaje de un evento para un usuario suma 2 puntos si la categoría del evento está entre sus intereses, más la suma de los pesos de las etiquetas del evento que el usuario tiene inferidas, más 1 punto si el evento es en su ciudad. El puntaje se divide entre 4, se limita al rango de 0 a 1 y se convierte en un entero entre 63 y 84. El rango se acota para que el porcentaje no parezca inventado.
- RN-02 Personalización apagada: sin personalización no se calcula ni se muestra la afinidad, y el listado se ordena solo por fecha de inicio.
- RN-03 Listado vigente: Explorar y la búsqueda nunca incluyen eventos cancelados.
- RN-04 Texto buscable: la búsqueda mira el título, el eslogan, la descripción, la categoría y las etiquetas del evento. El título pesa más que la categoría y las etiquetas, estas más que el eslogan, y el eslogan más que la descripción.
- RN-05 Tolerancia: la búsqueda ignora mayúsculas, tildes y palabras sin contenido ("algo", "sobre", "para"), reconoce variantes de una misma palabra (singular, plural, conjugaciones) y trata como equivalentes los términos en español e inglés del catálogo, por ejemplo "liderazgo" y "leadership".
- RN-06 Cobertura: una consulta con varias palabras primero devuelve los eventos que cubren todos sus conceptos. Si ninguno los cubre todos, devuelve los que cubren alguno. Con una sola palabra útil ya se devuelven resultados.
- RN-07 Sin coincidencia: si ningún evento cubre ni un concepto de la consulta, la aplicación muestra los tres eventos más afines con un aviso (HU-09).
- RN-08 Visibilidad de eventos: los eventos publicados los ve cualquier persona, incluso sin sesión. Los borradores y cancelados solo los ve el organizador dueño y quienes tengan una reserva en ellos.
- RN-09 Información personal: el perfil, los intereses, las etiquetas inferidas, los eventos guardados, las reservas y las búsquedas recientes solo los ve y modifica su dueño.
- RN-10 Gestión de eventos: solo el organizador dueño de un evento puede editarlo o eliminarlo, y gestionar sus tipos de entrada y etiquetas. Nadie puede crear eventos a nombre de otro organizador.
- RN-11 Eliminación en cascada: al eliminar un evento se eliminan sus tipos de entrada, sus guardados y las reservas sobre esas entradas.
- RN-12 Credenciales: la contraseña nunca se guarda en la información propia de la aplicación. La maneja el servicio de autenticación.
- RN-13 Datos iniciales: la base se entrega con los mismos eventos, sedes, tipos de entrada, etiquetas y organizadores del prototipo de la entrega 3, y con una cuenta de demostración que trae su perfil de gustos.
- RN-14 Reproducibilidad: los scripts versionados en el repositorio bastan para reconstruir la base completa desde cero.

## Requerimientos No Funcionales
- Rendimiento: el filtrado, el ordenamiento y la búsqueda se resuelven en el servicio de datos con índices. El dispositivo no descarga el catálogo completo para filtrarlo.
- Seguridad: el aislamiento de la información personal lo aplica el servicio de datos y no depende de que la aplicación filtre bien. Una cuenta no puede leer ni modificar datos de otra, aunque consulte directamente.
- Escalabilidad: agregar eventos no obliga a cambiar la aplicación, y la búsqueda debe seguir respondiendo con catálogos mucho más grandes que el del prototipo.
- Experiencia: toda operación remota tiene estado de carga y estado de error con reintento.
- Trazabilidad: los scripts de esquema, políticas y datos iniciales viven en el repositorio y se ejecutan en un orden definido.

## Criterios de Aceptación (Gherkin)

```gherkin
Feature: Persistencia, aislamiento de datos y búsqueda por significado

  Scenario: Búsqueda con una sola palabra
    Given que Ana tiene sesión iniciada y está en la pestaña "Explorar"
    When busca "liderazgo"
    Then ve los eventos "Agile Leadership Workshop", "Product Leadership Meetup" y "Coaching for Team Leads"
    And ninguno de los eventos mostrados está cancelado

  Scenario: Búsqueda en lenguaje natural
    Given que Ana tiene sesión iniciada y está en la pestaña "Explorar"
    When busca "algo sobre liderazgo para mi equipo"
    Then ve exactamente los tres eventos de liderazgo
    And el título de ninguno contiene la palabra "liderazgo"

  Scenario: Búsqueda sin tildes ni mayúsculas
    Given que Ana tiene sesión iniciada
    When busca "ESTADISTICA"
    Then ve los mismos eventos que al buscar "estadística"

  Scenario: Búsqueda que cubre solo algunos conceptos
    Given que ningún evento cubre a la vez los conceptos "liderazgo" y "ventas"
    When Ana busca "liderazgo ventas"
    Then ve los eventos que cubren "liderazgo"

  Scenario: Búsqueda sin coincidencias
    Given que ningún evento cubre alguna palabra de la consulta
    When Ana busca "pizza"
    Then ve los tres eventos más afines a ella
    And ve un aviso que indica que no hay coincidencia exacta

  Scenario: Listado ordenado por afinidad
    Given que Ana tiene la personalización activa y los intereses "Technology & Data", "Leadership" y "Agile & Delivery"
    When abre la pestaña "Explorar"
    Then ve "Agile Leadership Workshop" con 84% antes que "Product Leadership Meetup" con 78%
    And todos los porcentajes están entre 63% y 84%

  Scenario: Personalización apagada
    Given que Ana desactivó la personalización en Ajustes
    When abre la pestaña "Explorar"
    Then no ve ningún porcentaje de afinidad
    And los eventos aparecen ordenados por fecha de inicio ascendente

  Scenario: Filtro por categoría
    Given que Ana está en la pestaña "Explorar"
    When elige la categoría "Leadership"
    Then solo ve eventos de esa categoría, ordenados por afinidad

  Scenario: Aislamiento de reservas y guardados
    Given que Ana tiene dos reservas y tres eventos guardados
    And que Bob tiene sesión iniciada y no tiene reservas ni guardados
    When Bob abre las pestañas "Guardados" y "Tickets"
    Then ve ambas pestañas vacías
    And no puede modificar ni cancelar las reservas de Ana

  Scenario: Borrador visible solo para su organizador
    Given que Ana tiene un evento en estado "borrador"
    When Bob abre la pestaña "Explorar"
    Then no ve ese evento
    When Ana abre la pestaña "Explorar"
    Then sí lo ve

  Scenario: Un evento con reserva sigue visible
    Given que Ana tiene una reserva en un evento publicado
    When el organizador pasa el evento a "borrador"
    Then Ana sigue viendo su ticket en la pestaña "Tickets"
    And los demás usuarios dejan de ver el evento

  Scenario: Solo el organizador dueño modifica un evento
    Given que "Scrum for Teams Workshop" pertenece al organizador de Ana
    When Bob intenta editar o eliminar ese evento
    Then el cambio no se aplica

  Scenario: Eliminar un evento arrastra sus datos
    Given que un evento tiene entradas y guardados
    When su organizador lo elimina
    Then el evento, sus entradas y sus guardados dejan de existir

  Scenario: Los datos sobreviven al cerrar la aplicación
    Given que Ana guardó un evento
    When cierra la aplicación y la vuelve a abrir
    Then el evento sigue en "Guardados"

  Scenario: Cuenta nueva
    Given que Carla se registra con su nombre, correo, contraseña y ciudad
    When termina el registro
    Then queda con un perfil y puede publicar eventos

  Scenario: Reconstruir la base desde cero
    Given una base de datos vacía
    When se ejecutan en orden los scripts de esquema, políticas y datos iniciales
    Then la base queda con el catálogo completo y la cuenta de demostración puede consultarlo
```

## Fuera de Alcance
- Búsqueda vectorial con embeddings reales (RX-03 de la constitution). Queda como especificación de trabajo futuro: `busqueda-semantica-vectorial-spec.md`.
- Autenticación, registro y sesión persistente desde la aplicación (Bloque B).
- Capa de servicios de la aplicación, migración de la pantalla principal y estados de carga y error en la interfaz (Bloque C).
- Almacenamiento y visualización de imágenes de portada (Bloque D).
- Inferencia automática de las etiquetas del perfil a partir del comportamiento. Los pesos iniciales se siembran y no se recalculan en esta entrega.
- Conexión con sistemas reales de Peewah y pasarela de pago.
