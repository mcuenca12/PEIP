# Prompt Maestro para Generar esta Skill

Si eres estudiante del Seminario de Ingenieria de Software y deseas que un asistente de IA (como Antigravity, Cursor, Copilot o Claude Code) genere esta skill desde cero para tu proyecto, copia y pega el siguiente prompt:

---

```markdown
Actua como un arquitecto de software experto en Flutter y en desarrollo con agentes de IA (Agentic AI).

Crea una Skill autocontenida ubicada en `.agents/skills/project-architecture-auditor/` siguiendo el estandar de SKILL.md con frontmatter YAML (name y description).

La skill debe guiar al agente a realizar una auditoria de arquitectura y calidad sobre una aplicacion Flutter, con las siguientes responsabilidades y pasos:

1. Inspeccionar los ultimos 5 commits de Git (`git log -n 5`) para identificar los cambios recientes, su intencion y los archivos modificados.
2. Validar el respeto a la jerarquia de interfaz de 3 capas:
   - `lib/screens/`: Pantallas anfitrionas con Scaffold, AppBar y navegacion.
   - `lib/pages/`: Contenido visual para el body del Scaffold, con PROHIBICION total de Scaffolds anidados.
   - `lib/widgets/`: Widgets atomicos, inmutables y agnosticos de navegacion.
3. Revisar el uso y reutilizacion de componentes comunes existentes en `lib/widgets/` en lugar de duplicar codigo visual.
4. Aplicar el principio de composicion de widgets (composition over inheritance / monoliths), desaconsejando funciones privadas `Widget _buildX()` y promoviendo la extraccion de `StatelessWidget` pequenos y eficientes.
5. Incluir un script en Python (`scripts/audit_architecture.py`) que automatice la revision de commits en Git y escanee violaciones como Scaffolds en `lib/pages/`.
6. Proveer una plantilla estructurada de reporte de auditoria con estado de evaluacion.
```

---

### Instrucciones de Uso para el Estudiante:
1. Copia el bloque de prompt superior.
2. Pegalo en tu sesion de chat con el agente interactivo (`/skill` o prompt directo).
3. El agente creara automaticamente la carpeta `.agents/skills/project-architecture-auditor/` con su especificacion procedimental y script de diagnostico.
