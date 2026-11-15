---
name: c-plan
description: "Disena el plan tecnico Flutter para una spec existente en .agents/plans/<nombre>-plan.md: jerarquia Screen/Page/Widget, modelos, rutas, estado, widgets reutilizables y estrategia de pruebas, sin escribir codigo de produccion."
---

# Skill: /c-plan (Plan Tecnico de Implementacion)

Toma una spec (`.agents/specs/<nombre>-spec.md`) y define el **COMO** en la app Flutter `seminario_2026_02`.

## Principios
1. **Sin codigo de produccion**: solo firmas, responsabilidades y flujos; nada de cuerpos de metodos finales.
2. **Respetar convenciones**: leer antes [`.agents/conventions/`](../../conventions/) (`flutter_rules.md`, `component_hierarchy.md`, `git_conventions.md`) y [`.agents/memory/project_state.md`](../../memory/project_state.md).
3. **Jerarquia obligatoria**:
   - `lib/screens/`: unico lugar con `Scaffold`, `AppBar`, navegacion.
   - `lib/pages/`: contenido (`body`); prohibido `Scaffold` propio.
   - `lib/widgets/`: componentes atomicos reutilizables, agnosticos de navegacion, con constructor `const` y callbacks nullable en lugar de `print`.
   - `lib/model/`: modelos y datos mock. `lib/routes/app_routes.dart`: rutas con nombre.
4. **Reutilizar antes de crear**: revisar `lib/widgets/` y `lib/model/` existentes; preferir `StatelessWidget` pequenos sobre funciones `_buildX()`.
5. **Dependencias**: no agregar paquetes a `pubspec.yaml` sin justificarlo y marcarlo como decision a confirmar.
6. **Nombre de archivo**: `.agents/plans/<nombre-funcionalidad>-plan.md`. **Plantilla**: [`templates/plan-template.md`](templates/plan-template.md). Sin emojis; diagramas Mermaid.

## Flujo
1. **Insumos**: spec en estado `APPROVED` (o confirmada por el usuario), convenciones y estado del proyecto; inspeccionar `lib/` real.
2. **Mapa de componentes**: listar por capa lo que se crea o modifica (modelos, widgets, pages, screens, rutas, main), con ruta de archivo, responsabilidad y firma publica (parametros, callbacks).
3. **Estado y datos**: decidir donde vive el estado (StatefulWidget, elevacion de estado a la Screen, `IndexedStack`) y de donde vienen los datos (mock en `lib/model/mock_data.dart` o futura fuente). Justificar.
4. **Navegacion**: rutas nuevas, argumentos, `Navigator.push/pop`, integracion con la `NavigationBar` de `main_screen.dart`.
5. **Diagramas Mermaid**: arbol de widgets (`flowchart`) y flujo de navegacion o de estado (`sequenceDiagram` / `stateDiagram`).
6. **Estrategia de pruebas**: widget tests en `test/` por cada widget/page relevante, mapeados a los escenarios Gherkin.
7. **Calidad**: `flutter analyze` sin advertencias; opcionalmente invocar las skills `flutter-clean-code-linter` y `project-architecture-auditor` al finalizar.
8. **Salida**: crear o actualizar el plan y pedir revision antes de `/c-task`.
