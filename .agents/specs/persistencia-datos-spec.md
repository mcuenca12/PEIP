# [SPEC-003] Persistencia de la información y estados de comunicación

## Metadatos
- ID: SPEC-003
- Fecha: 2026-11-16
- Autor: Mateo Cuenca
- Estado: DRAFT
- Épica relacionada: Épica 2 - Persistencia de la información (HU-06, HU-07).
  Toca también HU-10, HU-12, HU-13, HU-15 y HU-16 (ver .agents/memory/epics.md)

## Contexto y Objetivo
Hoy todo lo que el usuario hace vive solo mientras la aplicación está abierta:
al cerrarla se pierden los eventos guardados, las reservas y los eventos
publicados. Además, la aplicación nunca espera por nada, así que no tiene forma
de decir "estoy cargando" ni "algo falló".

Esta funcionalidad no cambia qué puede hacer el usuario. Cambia que lo que hace
perdura, y que la aplicación le informa cuándo está trabajando y cuándo no pudo
completar una operación.

## Roles Involucrados
- Asistente: sus eventos guardados, reservas y búsquedas recientes se conservan
  entre sesiones.
- Organizador: los eventos que publica, edita o elimina se conservan y los ven
  los demás usuarios.

## Historias de Usuario

### HU-06: Operaciones contra la base de datos
- Como: usuario
- Quiero: que lo que hago quede guardado
- Para: encontrarlo al volver a abrir la aplicación

### HU-07: Estados de carga y error
- Como: usuario
- Quiero: saber cuándo la aplicación está trabajando y cuándo algo falló
- Para: no quedarme esperando frente a una pantalla que no responde

## Comportamiento por Pantalla / Flujo

### Pantalla principal (Explorar, Guardados, Tickets, Ajustes)
- Punto de entrada: después de iniciar sesión.
- Información mostrada: eventos vigentes, eventos guardados, reservas y
  búsquedas recientes del usuario en sesión.
- Acciones disponibles: las mismas de hoy.
- Estados:
  - cargando: mientras llega la información se muestra un indicador de carga
    en lugar del contenido.
  - vacío: los mensajes actuales de cada pestaña ("no tienes eventos
    guardados", etc.).
  - error: un mensaje que explica que no se pudo cargar, con un botón para
    reintentar.
  - éxito: el contenido de siempre.

### Acciones que modifican información
Guardar o quitar un evento, reservar, cancelar una reserva, publicar, editar o
eliminar un evento, y registrar o borrar una búsqueda reciente.

- Mientras la operación está en curso, el control que la disparó no admite un
  segundo toque.
- Si la operación se completa, la pantalla refleja el cambio.
- Si la operación falla, se muestra un aviso breve y la pantalla queda como
  estaba antes.

## Reglas de Negocio
- RN-01: La información que muestra la aplicación proviene de la base de datos.
  Ningún dato en memoria actúa como fuente principal.
- RN-02: Un cambio se refleja en pantalla solo después de confirmarse que quedó
  guardado.
- RN-03: Si una operación falla, el usuario es informado y la información
  visible no cambia.
- RN-04: Las categorías, ciudades y etiquetas son catálogos de solo consulta.
- RN-05: Eliminar un evento elimina también sus tipos de entrada, sus reservas
  y las veces que fue guardado.
- RN-06: Cada usuario ve únicamente sus propios guardados, reservas y
  búsquedas recientes.

## Requerimientos No Funcionales
- Los mensajes de error se escriben en lenguaje del usuario, sin códigos ni
  detalles técnicos.
- La carga inicial ocurre una vez al entrar a la pantalla principal; cambiar de
  pestaña no vuelve a cargar.

## Criterios de Aceptación (Gherkin)

```gherkin
Feature: Persistencia de la información

  Scenario: Un evento guardado sigue guardado al reabrir
    Given que el usuario guardó el evento "Agile Leadership Workshop"
    When cierra la aplicación y la vuelve a abrir
    Then el evento aparece en la pestaña "Guardados"

  Scenario: Una reserva sigue disponible al reabrir
    Given que el usuario reservó una entrada
    When cierra la aplicación y la vuelve a abrir
    Then la reserva aparece en la pestaña "Tickets" con su código QR

  Scenario: Un evento publicado lo ven otros usuarios
    Given que un organizador publicó un evento
    When otro usuario abre la pestaña "Explorar"
    Then ve el evento en el listado

  Scenario: Carga inicial
    Given que el usuario acaba de iniciar sesión
    When la información todavía no ha llegado
    Then ve un indicador de carga en lugar del contenido

  Scenario: Error al cargar, con reintento
    Given que no hay conexión
    When el usuario entra a la pantalla principal
    Then ve un mensaje de error con el botón "Reintentar"
    And al recuperar la conexión y tocar "Reintentar" ve el contenido

  Scenario: Una operación que falla no cambia la pantalla
    Given que no hay conexión
    When el usuario intenta guardar un evento
    Then ve un aviso de que no se pudo guardar
    And el evento sigue apareciendo como no guardado

  Scenario: Eliminar un evento arrastra lo asociado
    Given un evento propio con reservas
    When el organizador lo elimina
    Then el evento desaparece del listado
    And sus reservas desaparecen de la pestaña "Tickets"
```

## Fuera de Alcance
- La definición de tablas y de permisos por usuario (spec de base de datos).
- Registro, inicio y cierre de sesión (spec de autenticación).
- Carga y visualización de imágenes (spec de almacenamiento).
- La búsqueda por significado dentro de la base de datos; aquí solo se conserva
  el registro de búsquedas recientes.
- Uso sin conexión: la aplicación no guarda copias locales para trabajar sin
  red.
- Actualización en tiempo real entre dispositivos.
