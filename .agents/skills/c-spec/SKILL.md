---
name: c-spec
description: "Guia y genera especificaciones funcionales agnosticas a la tecnologia en .agents/specs/<nombre>-spec.md para la app Flutter: historias de usuario vinculadas a las epicas, flujos de pantalla, reglas de negocio y criterios de aceptacion en Gherkin."
---

# Skill: /c-spec (Especificacion Funcional)

Captura el **QUE** de una funcionalidad de la app Flutter `seminario_2026_02` (Plataforma de Actividad Fisica - Universidad Icesi), sin decidir el como.

## Principios
1. **Agnostico a la tecnologia**: no mencionar widgets, clases Dart, paquetes ni rutas de archivos. Describir comportamiento observable por el usuario (pantallas, acciones, mensajes, estados).
2. **Trazable**: cada historia referencia la epica y la HU correspondiente de [`.agents/memory/epics.md`](../../memory/epics.md) y los roles/requerimientos de [`.agents/memory/constitution.md`](../../memory/constitution.md).
3. **Nombre de archivo**: `.agents/specs/<nombre-funcionalidad>-spec.md` (kebab-case). Ej: `routine-creation-spec.md`.
4. **Plantilla**: [`templates/spec-template.md`](templates/spec-template.md).
5. **Sin emojis**, estilo tecnico formal.

## Flujo
1. **Insumos**: leer `constitution.md`, `epics.md` y `project_state.md`; revisar si ya existe una spec similar en `.agents/specs/`.
2. **Levantamiento**: confirmar con el usuario objetivo, roles (Usuario, Entrenador, Administrador), casos de uso, casos de error y bordes. Hacer preguntas solo si algo bloquea la spec.
3. **Historias de usuario**: formato Como / Quiero / Para, con la epica asociada.
4. **Comportamiento por pantalla**: para cada pantalla o flujo, describir datos mostrados, acciones disponibles, navegacion de entrada/salida y estados (cargando, vacio, error, exito). Describir campos de formularios con tipo, obligatoriedad y validaciones.
5. **Reglas de negocio** y requerimientos no funcionales relevantes (accesibilidad, responsividad movil/web/escritorio).
6. **Criterios de aceptacion en Gherkin**: camino feliz, validaciones fallidas, estados vacios/error y restricciones por rol.
7. **Salida**: crear o actualizar el archivo y pedir confirmacion antes de pasar a `/c-plan`. Estado inicial: `DRAFT`.
