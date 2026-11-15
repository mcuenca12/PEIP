# Épicas e Historias de Usuario

Desglose de los requerimientos de la constitución en épicas e historias de
usuario con criterios de aceptación. Las casillas reflejan el progreso real
del desarrollo.

---

## Estado Global de Épicas

- [x] Base Técnica: navegación, componentes reutilizables y pantallas
- [ ] Épica 1: Autenticación y gestión de usuarios
- [ ] Épica 2: Persistencia de la información
- [ ] Épica 3: Descubrimiento, búsqueda y recomendación
- [ ] Épica 4: Publicación y gestión de eventos
- [ ] Épica 5: Reservas y tickets
- [ ] Épica 6: Almacenamiento de imágenes
- [ ] Épica 7: Perfil de gustos y privacidad

La Base Técnica se completó en la entrega 3. Las siete épicas restantes
corresponden a la entrega 4: su comportamiento ya existe contra datos en
memoria y debe pasar a operar contra la base de datos.

---

## Base Técnica: navegación, componentes y pantallas

- [x] **HU-00: Recorrido completo de la aplicación**
  - Como usuario quiero recorrer la aplicación de punta a punta para conocer
    todas sus funcionalidades.
  - Criterios: nueve rutas registradas en `AppRoutes`; barra de navegación
    inferior con cuatro pestañas; ningún botón sin acción; `Scaffold`
    únicamente en `lib/screens/`.

---

## Épica 1: Autenticación y gestión de usuarios

- [ ] **HU-01: Registro de cuenta**
  - Como visitante quiero crear una cuenta con mi correo y ciudad para empezar
    a recibir recomendaciones.
  - Criterios: la credencial se gestiona con el servicio de autenticación y no
    se guarda en tablas propias; se crea un perfil asociado a la cuenta;
    correos duplicados se rechazan con mensaje claro.

- [ ] **HU-02: Inicio y cierre de sesión**
  - Como usuario registrado quiero iniciar sesión para acceder a mi
    información.
  - Criterios: credenciales inválidas muestran error sin salir de la pantalla;
    cerrar sesión regresa al login y limpia el estado.

- [ ] **HU-03: Sesión persistente**
  - Como usuario quiero que la aplicación me recuerde para no escribir mis
    datos cada vez que la abro.
  - Criterios: con sesión activa la aplicación entra directamente a la
    pantalla principal sin pasar por el login.

---

## Épica 2: Persistencia de la información

- [ ] **HU-04: Base de datos desplegada**
  - Como equipo queremos que el modelo de datos exista en la nube para que la
    aplicación opere sobre información real.
  - Criterios: entidades, relaciones y restricciones coherentes con el MER;
    el script del repositorio reproduce la base desde cero.

- [ ] **HU-05: Aislamiento de datos entre usuarios**
  - Como usuario quiero que nadie más vea mis guardados ni mis reservas.
  - Criterios: políticas de acceso por fila; verificado con dos cuentas
    distintas.

- [ ] **HU-06: Operaciones contra la base de datos**
  - Como usuario quiero que lo que hago quede guardado para encontrarlo al
    volver a abrir la aplicación.
  - Criterios: ninguna pantalla consulta datos en memoria; toda consulta pasa
    por una clase de servicio.

- [ ] **HU-07: Estados de carga y error**
  - Como usuario quiero saber cuándo la aplicación está trabajando y cuándo
    algo falló.
  - Criterios: indicador de carga en toda operación remota; mensaje de error
    con opción de reintentar cuando no hay conexión.

---

## Épica 3: Descubrimiento, búsqueda y recomendación

- [ ] **HU-08: Búsqueda por significado**
  - Como usuario quiero describir lo que necesito con mis palabras y encontrar
    eventos relacionados aunque no coincidan los términos.
  - Criterios: la consulta se resuelve en la base de datos con índice;
    "algo sobre liderazgo para mi equipo" devuelve eventos de liderazgo;
    una consulta de una sola palabra también devuelve resultados.

- [ ] **HU-09: Resultados cercanos cuando no hay coincidencia**
  - Como usuario quiero que la aplicación me proponga algo aunque mi búsqueda
    no encuentre nada exacto.
  - Criterios: se muestran los eventos más afines con un aviso que lo explica.

- [ ] **HU-10: Búsquedas recientes**
  - Como usuario quiero ver y borrar mis búsquedas anteriores.
  - Criterios: cada búsqueda ejecutada queda registrada; son eliminables.

- [ ] **HU-11: Orden por afinidad**
  - Como usuario quiero que los eventos que más me interesan aparezcan de
    primero.
  - Criterios: el porcentaje considera intereses, etiquetas inferidas y
    ciudad; con la personalización apagada el orden pasa a ser por fecha.

---

## Épica 4: Publicación y gestión de eventos

- [ ] **HU-12: Publicar un evento**
  - Como organizador quiero publicar un evento con sus tipos de entrada.
  - Criterios: el evento queda almacenado y aparece en el listado; se puede
    guardar como borrador.

- [ ] **HU-13: Editar y eliminar eventos propios**
  - Como organizador quiero corregir o retirar los eventos que publiqué.
  - Criterios: solo se habilita sobre eventos propios; eliminar pide
    confirmación y arrastra sus entradas.

- [ ] **HU-14: Partir de una edición anterior**
  - Como organizador de un evento recurrente quiero crear la siguiente edición
    a partir de la anterior para no reconstruirla desde cero.
  - Criterios: el formulario se precarga con los datos de la edición previa y
    queda registrada la relación entre ambas.

---

## Épica 5: Reservas y tickets

- [ ] **HU-15: Reservar una entrada**
  - Como asistente quiero reservar entradas para un evento.
  - Criterios: selección de tipo y cantidad, resumen previo a confirmar, y
    generación de un código único.

- [ ] **HU-16: Consultar y cancelar mis tickets**
  - Como asistente quiero ver mis reservas y cancelar las que ya no necesito.
  - Criterios: listado propio con su código QR; la cancelación se refleja de
    inmediato.

---

## Épica 6: Almacenamiento de imágenes

- [ ] **HU-17: Imagen de portada del evento**
  - Como organizador quiero subir una imagen que represente mi evento.
  - Criterios: el archivo se almacena en el servicio de archivos y su
    referencia queda en la base de datos.

- [ ] **HU-18: Visualización de la imagen**
  - Como asistente quiero ver la imagen del evento en el listado y el detalle.
  - Criterios: mientras carga o si no hay imagen, se muestra el bloque de
    color actual como respaldo.

---

## Épica 7: Perfil de gustos y privacidad

- [ ] **HU-19: Perfil de gustos**
  - Como usuario quiero entender qué ha aprendido la aplicación sobre mí.
  - Criterios: se muestran las etiquetas inferidas con su peso.

- [ ] **HU-20: Control de la personalización**
  - Como usuario quiero poder desactivar la personalización.
  - Criterios: el interruptor tiene efecto observable en el orden del listado
    y en la visibilidad del porcentaje de afinidad.
