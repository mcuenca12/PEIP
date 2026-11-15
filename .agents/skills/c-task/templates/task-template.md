# [TASK-XXX] Lista de Tareas Verificables

## Metadatos
- ID: TASK-XXX
- Plan asociado: [PLAN-XXX](../plans/<nombre>-plan.md)
- Spec asociada: [SPEC-XXX](../specs/<nombre>-spec.md)
- Fecha: YYYY-MM-DD
- Estado general: [NOT_STARTED | IN_PROGRESS | DONE]

## Resumen de Progreso
- [ ] Tarea 1: Modelos y datos
- [ ] Tarea 2: Widgets reutilizables (paralelizables entre si)
- [ ] Tarea 3: Pages
- [ ] Tarea 4: Screens, rutas y navegacion
- [ ] Tarea 5: Cierre, calidad y documentacion

---

## Desglose Detallado

### - [ ] Tarea 1: Modelos y datos
- Dependencias previas: Ninguna
- Archivos involucrados:
  - `lib/model/nombre.dart` (crear)
  - `lib/model/mock_data.dart` (modificar)
- Acciones:
  - [ ] 1. Crear la clase de modelo con campos `final` y constructor `const`.
  - [ ] 2. Agregar datos mock necesarios.
- Verificacion:
  - [ ] `flutter analyze` sin problemas.

---

### - [ ] Tarea 2: Widget `NombreWidget`
- Dependencias previas: Tarea 1
- Archivos involucrados:
  - `lib/widgets/nombre_widget.dart` (crear)
  - `test/widgets/nombre_widget_test.dart` (crear)
- Acciones:
  - [ ] 1. Crear `StatelessWidget` con constructor `const` y callbacks nullable.
  - [ ] 2. Escribir widget test que cubra el escenario "[Gherkin]".
- Verificacion:
  - [ ] `flutter test test/widgets/nombre_widget_test.dart` en verde.
  - [ ] `flutter analyze` sin problemas.

---

### - [ ] Tarea 3: Page `NombrePage` (sin Scaffold)
- Dependencias previas: Tarea 2
- Archivos involucrados:
  - `lib/pages/nombre_page.dart` (crear)
- Acciones:
  - [ ] 1. Componer widgets existentes; sin `Scaffold`.
  - [ ] 2. Implementar estados vacio / error segun spec.
- Verificacion:
  - [ ] `flutter analyze` sin problemas.
  - [ ] Widget test del escenario "[Gherkin]" en verde.

---

### - [ ] Tarea 4: Screen, rutas y navegacion
- Dependencias previas: Tarea 3
- Archivos involucrados:
  - `lib/screens/nombre_screen.dart` (crear)
  - `lib/routes/app_routes.dart` (modificar)
  - `lib/main.dart` (modificar si aplica)
- Acciones:
  - [ ] 1. Crear Screen con `Scaffold` y `AppBar` que hospede la Page.
  - [ ] 2. Registrar la ruta y conectar la navegacion.
- Verificacion:
  - [ ] `flutter analyze` sin problemas.
  - [ ] `flutter test` completo en verde.
  - [ ] Manual (`flutter run`): [que flujo observar].

---

### - [ ] Tarea 5: Cierre y documentacion
- Dependencias previas: Tareas 1 a 4
- Archivos involucrados:
  - `.agents/memory/project_state.md` (modificar)
  - `.agents/memory/epics.md` (modificar)
- Acciones:
  - [ ] 1. Marcar HUs completadas en `epics.md`.
  - [ ] 2. Actualizar `project_state.md`.
  - [ ] 3. (Opcional) Ejecutar skills `project-architecture-auditor` y `flutter-clean-code-linter`.
- Verificacion:
  - [ ] `dart format --set-exit-if-changed lib test` sin cambios.
  - [ ] `flutter analyze` y `flutter test` en verde.
