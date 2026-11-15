# Constitución del Proyecto: PEIP — Peewah Event Intelligence Platform

## 1. Visión y Contexto General

Peewah es una empresa colombiana que organiza y opera eventos. Su plataforma
maneja registros, pagos y procesos durante todo el año, por lo cual cualquier
mejora debe pensarse sin afectar lo que ya está en funcionamiento.

Hoy se presentan dos problemas. Quienes organizan eventos recurrentes deben
reconstruir formularios, comunicaciones y tareas en cada edición. Y quienes
buscan eventos dependen de buscadores que solo entienden palabras exactas.

El segundo problema es el que aborda este proyecto. Una persona casi siempre
sabe qué necesita, pero no sabe cómo se llama el evento que lo resuelve. Si
escribe "algo sobre liderazgo para mi equipo" y el evento se llama "Taller de
Scrum", un buscador convencional no lo encuentra. A esto se suma que los
listados son idénticos para todos, sin considerar intereses ni ciudad.

PEIP es el módulo de búsqueda y recomendación de eventos de Peewah. Se apoya
en tres ideas:

- **Búsqueda por significado**: la persona escribe lo que necesita con sus
  propias palabras y la plataforma encuentra eventos relacionados aunque no
  compartan términos. Si no hay coincidencia exacta, muestra los más cercanos.
- **Recomendación personalizada**: cada evento muestra un porcentaje de
  afinidad que varía según los intereses declarados, la ciudad, los eventos
  guardados y las etiquetas que la plataforma infiere del comportamiento.
- **Transparencia**: el usuario puede entender por qué se le recomienda un
  evento y puede desactivar la personalización desde privacidad.

El público objetivo son estudiantes, profesionales y empresas que buscan
eventos académicos y profesionales en Colombia: congresos, talleres,
seminarios, cursos, charlas y capacitaciones. Los intereses se agrupan en doce
áreas temáticas.

---

## 2. Roles del Sistema

1. **Asistente**: persona que explora el catálogo, busca eventos, guarda los
   que le interesan, reserva entradas y administra su perfil de gustos y su
   configuración de privacidad.
2. **Organizador**: entidad que publica eventos, define sus tipos de entrada y
   gestiona sus ediciones. Una misma cuenta puede ejercer ambos roles: los
   eventos propios se distinguen del resto y habilitan edición y eliminación.

---

## 3. Especificación de Características y Requerimientos Funcionales

### RF-01: Autenticación y Gestión de Cuenta
- Registro con nombre, correo, contraseña y ciudad de residencia.
- Inicio y cierre de sesión con persistencia entre aperturas de la aplicación.
- La credencial nunca se almacena en las tablas propias de la aplicación.

### RF-02: Onboarding de Intereses
- Selección de al menos tres áreas de interés entre las doce disponibles.
- Captura de la ciudad del usuario, usada después como señal de recomendación.
- Los intereses son editables en cualquier momento desde ajustes.

### RF-03: Exploración y Recomendación Personalizada
- Listado de eventos vigentes ordenado por afinidad con el usuario.
- Filtrado por categoría.
- El porcentaje de afinidad considera intereses declarados, etiquetas
  inferidas del comportamiento y coincidencia de ciudad.
- Con la personalización desactivada, el listado se ordena por fecha y no se
  muestra el porcentaje.

### RF-04: Búsqueda por Significado
- Consulta en lenguaje natural sobre título, eslogan, descripción, categoría y
  etiquetas del evento.
- La búsqueda debe encontrar eventos que no contengan literalmente los
  términos consultados.
- Registro de búsquedas recientes del usuario, consultables y eliminables.
- Cuando no hay coincidencia, se presentan los eventos más cercanos en lugar
  de un resultado vacío.

### RF-05: Detalle del Evento
- Información completa: fechas, lugar, ciudad, organizador, descripción,
  etiquetas y tipos de entrada disponibles.
- Indicación de la afinidad calculada para el usuario.
- Acciones de guardar y de iniciar la reserva.

### RF-06: Eventos Guardados
- Marcar y desmarcar eventos de interés.
- Listado propio de eventos guardados, visible solo por su dueño.

### RF-07: Reserva de Entradas y Ticket
- Selección de tipo de entrada y cantidad.
- Resumen de compra previo a la confirmación.
- Generación de un código QR único por reserva.
- Consulta de las reservas propias y cancelación.

### RF-08: Publicación y Gestión de Eventos
- Creación de eventos con título, eslogan, descripción, categoría, ciudad,
  lugar, fechas, aforo y etiquetas.
- Definición de uno o varios tipos de entrada con nombre, precio y beneficios.
- Estado del evento: borrador, publicado o cancelado.
- Edición y eliminación de los eventos propios.

### RF-09: Eventos Recurrentes
- Un evento puede pertenecer a una serie con su periodicidad.
- Un evento puede declarar cuál fue su edición anterior.
- Al crear un evento se puede partir de una edición previa, precargando sus
  datos.

### RF-10: Perfil de Gustos y Privacidad
- Visualización de las etiquetas inferidas con su peso.
- Edición de los intereses declarados.
- Interruptor de personalización que desactiva el ordenamiento por afinidad.

---

## 4. Requerimientos Extras

### RX-01: Persistencia en la Nube
- Toda la información reside en una base de datos gestionada. La aplicación no
  depende de datos en memoria como fuente principal.
- La información permanece disponible al cerrar y volver a abrir la aplicación.

### RX-02: Almacenamiento de Imágenes
- Los eventos pueden tener una imagen de portada cargada por el organizador.
- Las imágenes se almacenan en un servicio de archivos y su referencia se
  gestiona desde la base de datos.

### RX-03: Búsqueda Vectorial (trabajo futuro)
- Reemplazo de la búsqueda por significado simulada por una basada en
  embeddings y distancia vectorial. Documentado como alcance posterior.

---

## 5. Requerimientos No Funcionales

- **Plataforma**: aplicación móvil construida en Flutter. La interfaz está
  diseñada a ancho de teléfono.
- **Seguridad**: aislamiento estricto de datos entre usuarios. Los eventos son
  de consulta pública; guardados, reservas e intereses solo son accesibles por
  su dueño. Las credenciales no se almacenan en tablas propias.
- **Rendimiento**: el filtrado y la búsqueda se resuelven en la base de datos
  con índices, no trayendo el catálogo completo al dispositivo.
- **Experiencia**: toda operación remota contempla estado de carga y estado de
  error con posibilidad de reintentar.
- **Trazabilidad**: el desarrollo se documenta mediante especificaciones,
  planes y tareas antes de escribir código.
