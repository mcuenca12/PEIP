# [TASK-004] Tareas de imágenes de portada

## Metadatos
- ID: TASK-004
- Plan asociado: [PLAN-004](../plans/almacenamiento-imagenes-plan.md)
- Spec asociada: [SPEC-004](../specs/almacenamiento-imagenes-spec.md)
- Autor: Jacobo Sandoval (Bloque D, entrega 4)
- Fecha: 2026-11-20
- Estado general: NOT_STARTED

## Resumen de Progreso
- [ ] Tarea 1: Bucket y política en Storage
- [ ] Tarea 2: `ImagenService`
- [ ] Tarea 3: Widget `ImagenEvento`
- [ ] Tarea 4: Imagen en tarjeta, fila de resultado y detalle
- [ ] Tarea 5: Dependencia `image_picker`
- [ ] Tarea 6: Subida desde el formulario de evento
- [ ] Tarea 7: Cierre y documentación

Un commit por tarea.

Dependencias externas: la Tarea 1 necesita los scripts del Bloque A
desplegados. Para probar la Tarea 6 de punta a punta hace falta la sesión
del Bloque B y `EventoService` del Bloque C.

---

## Desglose Detallado

### - [ ] Tarea 1: Bucket y política en Storage
- Dependencias previas: ninguna
- Archivos involucrados:
  - `supabase/04_storage.sql` (crear)
- Acciones:
  - [ ] 1. Crear el bucket `portadas`, público, de máximo 5 MB y solo para jpeg, png y webp.
  - [ ] 2. Crear la política de `insert` para `authenticated` que solo permite la carpeta `auth.uid()`.
  - [ ] 3. Ejecutar el archivo en el SQL Editor del proyecto `oqgftzulvfedjxptbltl`.
- Verificación:
  - [ ] Manual: el bucket aparece en Storage marcado como público.
  - [ ] Manual: la política aparece en Storage > Policies.
- Commit sugerido: `feat(storage): crea el bucket de portadas y su politica`

---

### - [ ] Tarea 2: `ImagenService`
- Dependencias previas: Tarea 1
- Archivos involucrados:
  - `lib/services/imagen_service.dart` (crear)
- Acciones:
  - [ ] 1. Crear `subirPortada(bytes, extension)` que sube a `<uuid>/<fecha>.<ext>` y devuelve la ruta.
  - [ ] 2. Crear `urlPublica(ruta)` estática, que devuelve null si no hay ruta.
- Verificación:
  - [ ] `flutter analyze` sin problemas.
- Commit sugerido: `feat(services): agrega servicio de imagenes de portada`

---

### - [ ] Tarea 3: Widget `ImagenEvento`
- Dependencias previas: Tarea 2
- Archivos involucrados:
  - `lib/widgets/imagen_evento.dart` (crear)
  - `lib/widgets/widgets.dart` (modificar)
  - `test/widgets/imagen_evento_test.dart` (crear)
- Acciones:
  - [ ] 1. Crear `StatelessWidget` con `Image.network` y el bloque de color en `loadingBuilder` y `errorBuilder`.
  - [ ] 2. Exportarlo en `widgets.dart`.
  - [ ] 3. Probar el escenario "Evento sin imagen" y que con ruta pida la URL del bucket.
- Verificación:
  - [ ] `flutter test test/widgets/imagen_evento_test.dart` en verde.
  - [ ] `flutter analyze` sin problemas.
- Commit sugerido: `feat(widgets): agrega ImagenEvento con respaldo de color`

---

### - [ ] Tarea 4: Imagen en tarjeta, fila de resultado y detalle
- Dependencias previas: Tarea 3
- Archivos involucrados:
  - `lib/widgets/event_card.dart` (modificar)
  - `lib/widgets/result_row.dart` (modificar)
  - `lib/pages/detalle_evento_page.dart` (modificar)
- Acciones:
  - [ ] 1. Cambiar el `Container` de color por `ImagenEvento` en los tres lugares.
- Verificación:
  - [ ] `flutter test` completo en verde (las pruebas de `EventCard` y `ResultRow` no cambian).
  - [ ] `flutter analyze` sin problemas.
- Commit sugerido: `feat(eventos): muestra la portada en tarjeta, resultado y detalle`

---

### - [ ] Tarea 5: Dependencia `image_picker`
- Dependencias previas: ninguna
- Archivos involucrados:
  - `pubspec.yaml` y `pubspec.lock` (modificar)
  - `ios/Runner/Info.plist` (modificar)
- Acciones:
  - [ ] 1. `flutter pub add image_picker`.
  - [ ] 2. Agregar `NSPhotoLibraryUsageDescription` en `Info.plist`.
- Verificación:
  - [ ] `flutter analyze` sin problemas.
- Commit sugerido: `chore(deps): agrega image_picker para elegir la portada`

---

### - [ ] Tarea 6: Subida desde el formulario de evento
- Dependencias previas: Tareas 2, 3 y 5
- Archivos involucrados:
  - `lib/pages/crear_evento_page.dart` (modificar)
- Acciones:
  - [ ] 1. Sección "Imagen de portada" con vista previa y botón "Elegir imagen".
  - [ ] 2. `_guardar` asíncrono: si hay imagen nueva la sube antes de `onGuardar`; si no, conserva la anterior (RN-05).
  - [ ] 3. Mientras sube, el botón dice "Subiendo imagen..." y no se puede tocar.
  - [ ] 4. Si falla, aviso "No se pudo subir la imagen." y el formulario sigue abierto.
- Verificación:
  - [ ] `flutter analyze` sin problemas y `flutter test` en verde.
  - [ ] Manual: crear un evento con imagen y verla en la tarjeta y en Storage.
  - [ ] Manual: sin wifi, "Publicar" muestra el aviso.
- Commit sugerido: `feat(eventos): sube la portada al crear o editar un evento`

---

### - [ ] Tarea 7: Cierre y documentación
- Dependencias previas: Tareas 1 a 6
- Archivos involucrados:
  - `.agents/memory/epics.md`, `.agents/memory/project_state.md` (modificar)
  - `.agents/specs/almacenamiento-imagenes-spec.md`, este archivo (modificar)
  - `README.md` (modificar)
- Acciones:
  - [ ] 1. Marcar HU-17 y HU-18 en `epics.md`.
  - [ ] 2. Actualizar `project_state.md` y el README con `04_storage.sql`.
  - [ ] 3. Correr `project-architecture-auditor` y `flutter-clean-code-linter`.
- Verificación:
  - [ ] `flutter analyze` y `flutter test` en verde.
`