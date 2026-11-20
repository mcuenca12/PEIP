# [SPEC-004] Imágenes de portada de los eventos

## Metadatos
- ID: SPEC-004
- Fecha: 2026-11-18
- Autor: Jacobo Sandoval (Bloque D, entrega 4)
- Estado: APPROVED
- Épica relacionada: Épica 6 - Almacenamiento de imágenes (HU-17, HU-18). Ver .agents/memory/epics.md

## Contexto y Objetivo
Hasta ahora las tarjetas de los eventos muestran un bloque de color porque no
había de dónde sacar imágenes. El organizador debe poder subir una imagen de
portada para su evento y los asistentes deben verla en el listado, en los
resultados de búsqueda y en el detalle. Responde al requerimiento RX-02.

## Roles Involucrados
- Organizador: elige y sube la imagen de portada de sus eventos.
- Asistente: ve la imagen en el listado, en los resultados y en el detalle.

## Historias de Usuario

### HU-17: Imagen de portada del evento
- Como: Organizador
- Quiero: subir una imagen al crear o editar mi evento
- Para: que mi evento se vea más atractivo y fácil de reconocer

### HU-18: Visualización de la imagen
- Como: Asistente
- Quiero: ver la imagen del evento en el listado y en el detalle
- Para: identificar rápido de qué se trata

## Comportamiento por Pantalla / Flujo

### Crear / editar evento
- Punto de entrada: botón "+" de Explorar o "Editar" en un evento propio.
- Información mostrada: vista previa de la imagen o, si no hay, el bloque de color.
- Acciones disponibles: botón "Elegir imagen" que abre la galería.
- Estados:
  - vacío: sin imagen, se ve el bloque de color.
  - cargando: al publicar, el botón dice "Subiendo imagen..." y no se puede tocar.
  - error: "No se pudo subir la imagen." y el formulario sigue abierto.
  - éxito: el evento se guarda con su imagen.

### Tarjeta, fila de resultado y detalle
- Información mostrada: la imagen del evento recortada al espacio.
- Estados:
  - cargando, vacío o error: se ve el bloque de color.
  - éxito: se ve la imagen.

## Reglas de Negocio
- RN-01: La imagen es opcional.
- RN-02: El archivo se guarda en el servicio de archivos y en la base de datos solo su ruta.
- RN-03: Cualquiera puede ver las imágenes, porque los eventos son públicos.
- RN-04: Solo un usuario con sesión puede subir imágenes, y solo en su propia carpeta.
- RN-05: Si al editar no se elige otra imagen, se conserva la que había.

## Requerimientos No Funcionales
- Si no hay imagen o no hay conexión, nunca queda un espacio en blanco.

## Criterios de Aceptación (Gherkin)

```gherkin
Feature: Imagen de portada del evento

  Scenario: Publicar un evento con imagen
    Given que el organizador tiene sesión y está en "Crear evento"
    When llena los datos, elige una imagen y toca "Publicar"
    Then la tarjeta del evento muestra la imagen

  Scenario: Evento sin imagen
    Given un evento sin imagen
    When el asistente abre Explorar
    Then ve el bloque de color en la tarjeta

  Scenario: La imagen no carga
    Given un evento cuya imagen no se puede descargar
    When el asistente abre Explorar
    Then ve el bloque de color en lugar de la imagen

  Scenario: Falla la subida
    Given que el organizador eligió una imagen y no tiene conexión
    When toca "Publicar"
    Then ve "No se pudo subir la imagen."
    And sigue en el formulario
```

## Fuera de Alcance
- Tomar la foto con la cámara.
- Recortar la imagen dentro de la app.
- Borrar la imagen vieja cuando se cambia por otra.