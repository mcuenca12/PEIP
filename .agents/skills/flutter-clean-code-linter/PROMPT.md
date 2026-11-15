# Prompt Maestro para Generar esta Skill

Si eres estudiante del Seminario de Ingenieria de Software y deseas que un asistente de IA (como Antigravity, Cursor, Copilot o Claude Code) genere esta skill desde cero para tu proyecto, copia y pega el siguiente prompt:

---

```markdown
Actua como un lider tecnico experto en Flutter, Dart y desarrollo asistido por agentes (Agentic AI).

Crea una Skill autocontenida ubicada en `.agents/skills/flutter-clean-code-linter/` siguiendo el estandar de SKILL.md con frontmatter YAML (name y description).

La skill debe guiar al agente a realizar una auditoria de Clean Code, buenas practicas de Dart y resolucion de advertencias de analisis estatico en Flutter con las siguientes responsabilidades:

1. Ejecutar y resolver todas las incidencias reportadas por `flutter analyze` (`flutter_lints`).
2. Erradicar el uso de `print()` en produccion (`avoid_print`), ofreciendo la guia de refactorizacion hacia callbacks desacoplados (`VoidCallback`) o `debugPrint()`.
3. Exigir constructores `const` en todos los widgets inmutables e instancias estaticas para optimizar el rendimiento y la memoria.
4. Validar que todo `StatelessWidget` mantenga exclusivamente campos inmutables (`final`).
5. Limpiar imports no utilizados (`unused_import`) y asegurar convenciones de nombres de Effective Dart (archivos en `snake_case`, clases en `PascalCase`, variables en `camelCase`).
6. Incluir un script en Python (`scripts/check_clean_code.py`) que automatice la busqueda de prints, campos mutables y ejecute `flutter analyze`.
7. Proveer un checklist claro de entrega para antes de hacer commit.
```

---

### Instrucciones de Uso para el Estudiante:
1. Copia el bloque de prompt superior.
2. Pegalo en tu sesion de chat con el agente interactivo (`/skill` o prompt directo).
3. El agente creara automaticamente la carpeta `.agents/skills/flutter-clean-code-linter/` con las directrices procedimentales y el script de validacion.
