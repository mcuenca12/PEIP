# [TASK-003] Tareas de Persistencia

## Metadatos
- ID: TASK-003
- Plan asociado: [PLAN-003](../plans/persistencia-datos-plan.md)
- Spec asociada: [SPEC-003](../specs/persistencia-datos-spec.md)
- Fecha: 2026-11-17
- Estado general: NOT_STARTED

## Resumen de Progreso
- [ ] Tarea 1: Widgets de carga y error
- [ ] Tarea 2: Conversión de modelos desde y hacia mapas
- [ ] Tarea 3: Servicios de catálogo y eventos
- [ ] Tarea 4: Servicios de guardados, reservas y búsquedas
- [ ] Tarea 5: Carga inicial en MainScreen
- [ ] Tarea 6: Escrituras contra los servicios
- [ ] Tarea 7: Retiro de MockData y ajuste de pruebas
- [ ] Tarea 8: Cierre y documentación

La Tarea 1 no depende de nadie y puede hacerse de inmediato. De la Tarea 2 en
adelante hace falta el esquema de `supabase/01_schema.sql` y el cliente de
Supabase inicializado en `main.dart`, que son de otros bloques.

Un commit por tarea.

---

### - [ ] Tarea 1: Widgets de carga y error
- Dependencias previas: ninguna
- Archivos involucrados:
  - `lib/widgets/loading_state.dart` (crear)
  - `lib/widgets/error_state.dart` (crear)
  - `lib/widgets/widgets.dart` (modificar)
  - `test/widgets/loading_state_test.dart` (crear)
  - `test/widgets/error_state_test.dart` (crear)
- Acciones:
  - [ ] 1. Crear `LoadingState` como `StatelessWidget` con constructor `const`,
        siguiendo la estructura de `EmptyState`.
  - [ ] 2. Crear `ErrorState` con mensaje y callback `onReintentar`, usando
        `PeipButton` para el botón.
  - [ ] 3. Exportar ambos en `widgets.dart`.
  - [ ] 4. Escribir los dos widget tests: que se vea el mensaje, y que tocar
        "Reintentar" dispare el callback.
- Verificación:
  - [ ] `flutter test test/widgets/` en verde (cubre los escenarios "Carga
        inicial" y "Error al cargar, con reintento").
  - [ ] `flutter analyze` sin problemas.

---

### - [ ] Tarea 2: Conversión de modelos
- Dependencias previas: `supabase/01_schema.sql` disponible; decisión sobre el
  tipo del identificador de usuario confirmada
- Archivos involucrados:
  - `lib/model/models.dart` (modificar)
- Acciones:
  - [ ] 1. Confirmar nombres de tablas y columnas contra el esquema.
  - [ ] 2. Agregar `fromMap` y `toMap` a las once clases, con `DateTime.parse`
        para las fechas y `toIso8601String` de vuelta.
  - [ ] 3. Omitir el identificador en `toMap` cuando la fila es nueva.
- Verificación:
  - [ ] `flutter analyze` sin problemas.
  - [ ] Ida y vuelta comprobada: `Evento.fromMap(e.toMap())` conserva los
        campos.

---

### - [ ] Tarea 3: Servicios de catálogo y eventos
- Dependencias previas: Tarea 2; `supabase_flutter` agregado y cliente
  inicializado en `main.dart`
- Archivos involucrados:
  - `lib/services/catalogo_service.dart` (crear)
  - `lib/services/evento_service.dart` (crear)
- Acciones:
  - [ ] 1. Crear `CatalogoService.cargar()` que devuelva categorías, ciudades,
        etiquetas, organizadores y series.
  - [ ] 2. Crear `EventoService` con `listar`, `crear`, `actualizar` y
        `eliminar`, trayendo los tipos de entrada junto al evento.
  - [ ] 3. No capturar excepciones: dejarlas subir a `MainScreen`.
- Verificación:
  - [ ] `flutter analyze` sin problemas.
  - [ ] Manual: `listar()` devuelve los eventos del seed.

---

### - [ ] Tarea 4: Servicios de guardados, reservas y búsquedas
- Dependencias previas: Tarea 2 (puede ir en paralelo con la Tarea 3)
- Archivos involucrados:
  - `lib/services/guardado_service.dart` (crear)
  - `lib/services/reserva_service.dart` (crear)
  - `lib/services/busqueda_service.dart` (crear)
- Acciones:
  - [ ] 1. `GuardadoService` con `listar`, `guardar` y `quitar`.
  - [ ] 2. `ReservaService` con `listar`, `crear` y `cancelar`.
  - [ ] 3. `BusquedaService` con `listar`, `registrar` y `borrar`.
- Verificación:
  - [ ] `flutter analyze` sin problemas.
  - [ ] Manual: cada servicio devuelve solo las filas del usuario en sesión.

---

### - [ ] Tarea 5: Carga inicial en MainScreen
- Dependencias previas: Tareas 1, 3 y 4
- Archivos involucrados:
  - `lib/screens/main_screen.dart` (modificar)
- Acciones:
  - [ ] 1. Agregar los campos `_cargando` y `_error`, y el método
        `_cargarTodo()`.
  - [ ] 2. Llamar a `_cargarTodo()` cuando se resuelve el usuario.
  - [ ] 3. Mostrar `LoadingState`, `ErrorState` o el `IndexedStack` según el
        estado; el botón de reintento vuelve a llamar a `_cargarTodo()`.
  - [ ] 4. Las Pages no se modifican.
- Verificación:
  - [ ] `flutter analyze` sin problemas.
  - [ ] Manual con `flutter run`: al entrar se ve el indicador y luego el
        contenido; sin conexión se ve el error y "Reintentar" funciona.

---

### - [ ] Tarea 6: Escrituras contra los servicios
- Dependencias previas: Tarea 5
- Archivos involucrados:
  - `lib/screens/main_screen.dart` (modificar)
- Acciones:
  - [ ] 1. Convertir en `Future<void>` los métodos que guardan, reservan,
        cancelan, publican, editan y eliminan.
  - [ ] 2. Aplicar `setState` solo tras la confirmación del servicio.
  - [ ] 3. Ante un fallo, avisar con `ScaffoldMessenger` y no modificar las
        listas.
- Verificación:
  - [ ] `flutter analyze` sin problemas.
  - [ ] Manual: guardar un evento, reservar, publicar y eliminar; cerrar y
        reabrir la aplicación y comprobar que todo persiste (cubre los
        escenarios de persistencia y el de eliminación en cascada).
  - [ ] Manual sin conexión: una operación que falla deja la pantalla igual.

---

### - [ ] Tarea 7: Retiro de MockData y ajuste de pruebas
- Dependencias previas: Tarea 6
- Archivos involucrados:
  - `lib/model/mock_data.dart` (eliminar)
  - `lib/screens/main_screen.dart` (modificar)
  - `test/widget_test.dart` (modificar)
- Acciones:
  - [ ] 1. Eliminar el archivo y sus importaciones.
  - [ ] 2. Reducir el test de recorrido a comprobar que la pantalla de login
        se construye.
- Verificación:
  - [ ] `grep -rn "MockData" lib` sin resultados.
  - [ ] `flutter analyze` y `flutter test` en verde.

---

### - [ ] Tarea 8: Cierre y documentación
- Dependencias previas: Tareas 1 a 7
- Archivos involucrados:
  - `.agents/memory/project_state.md` (modificar)
  - `.agents/memory/epics.md` (modificar)
  - `README.md` (modificar)
- Acciones:
  - [ ] 1. Marcar HU-06 y HU-07 como completadas en `epics.md`.
  - [ ] 2. Actualizar `project_state.md` con la capa de servicios.
  - [ ] 3. Documentar en el README las variables de entorno y cómo ejecutar.
- Verificación:
  - [ ] `dart format --set-exit-if-changed lib test` sin cambios.
  - [ ] `flutter analyze` y `flutter test` en verde.
  - [ ] Auditoría con `project-architecture-auditor` sin hallazgos.
