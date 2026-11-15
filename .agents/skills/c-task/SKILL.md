---
name: c-task
description: "Descompone un plan Flutter en tareas atomicas y verificables en .agents/tasks/<nombre>-task.md con checkboxes y comandos de verificacion (flutter analyze, flutter test), ordenadas por dependencia y marcando paralelismo."
---

# Skill: /c-task (Tareas Atomicas Verificables)

Convierte `.agents/plans/<nombre>-plan.md` en tareas ejecutables para la app Flutter `seminario_2026_02`.

## Principios
1. **Atomicidad**: cada tarea entrega algo concreto y compilable (ej. modelo, un widget + su test, una page, una screen + ruta).
2. **Orden por dependencia**: modelos -> widgets -> pages -> screens -> rutas/main -> integracion y pruebas. Indicar que tareas pueden ir en paralelo (ej. widgets independientes).
3. **Verificacion obligatoria** por tarea, con comando explicito:
   - `flutter analyze` (debe terminar con 0 problemas)
   - `flutter test` o `flutter test test/<archivo>_test.dart`
   - `dart format --set-exit-if-changed lib test` cuando aplique
   - Verificacion manual con `flutter run -d <dispositivo>` solo para flujos visuales, describiendo que observar.
4. **Checkboxes**: `- [ ]` en resumen, tareas, acciones y verificaciones; el ejecutor marca `- [x]` solo tras verificar.
5. **Reglas de arquitectura** en cada tarea: `Scaffold` solo en `screens/`, sin `Scaffold` en `pages/`, `const` donde aplique, sin `print`.
6. **Nombre de archivo**: `.agents/tasks/<nombre-funcionalidad>-task.md`. **Plantilla**: [`templates/task-template.md`](templates/task-template.md). Sin emojis.
7. **Git**: sugerir un commit por tarea o grupo de tareas segun [`.agents/conventions/git_conventions.md`](../../conventions/git_conventions.md); no hacer commit sin que el usuario lo pida.

## Flujo
1. **Insumos**: plan en estado `READY_FOR_TASKS` y su spec.
2. **Grafo de dependencias** a partir de las capas del plan.
3. **Estructurar cada tarea**: titulo, dependencias, archivos exactos a crear/modificar, acciones numeradas con checkbox y criterios de verificacion con checkbox (cada escenario Gherkin debe quedar cubierto por al menos una verificacion).
4. **Resumen de progreso** al inicio con checkboxes.
5. **Tarea final** de cierre: `flutter analyze`, `flutter test` completo, auditoria opcional con `project-architecture-auditor`, y actualizacion de `.agents/memory/project_state.md` y `epics.md`.
6. **Salida**: crear o actualizar el archivo y pedir confirmacion antes de ejecutar.
