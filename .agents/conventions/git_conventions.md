# Políticas de Control de Versiones y Git

Este documento especifica los estándares de nomenclatura de ramas, formato de mensajes de confirmación (*commits*) y buenas prácticas para el trabajo colaborativo en Git dentro del proyecto `seminario_2026_02`.

---

## 1. Nomenclatura de Ramas

Toda nueva tarea o funcionalidad debe desarrollarse en una rama independiente originada a partir de la rama principal (`main` o base del sprint).

### Estructura Estandarizada
```text
week-<numero_semana>/<nombre-tarea>
```

### Reglas
- Usar minúsculas y separar palabras con guiones medios (`kebab-case`).
- Incluir el prefijo de la semana académica correspondiente al cronograma del curso.
- El nombre debe ser conciso y describir directamente la funcionalidad o módulo.

### Ejemplos Válidos
- `week-10/agents-intro`
- `week-11/auth-supabase`
- `week-12/exercise-catalog`
- `week-13/routine-management`
- `week-14/realtime-notifications`

---

## 2. Formato de Mensajes de Confirmación (Conventional Commits)

Los mensajes de commit deben seguir la especificación de *Conventional Commits* para facilitar la trazabilidad del historial, la generación de changelogs y la revisión de código por pares.

### Estructura del Mensaje
```text
<tipo>(<alcance opcional>): <descripcion breve en modo imperativo>
```

### Tipos Permitidos

| Tipo | Propósito | Ejemplo |
| :--- | :--- | :--- |
| **`feat`** | Incorporación de una nueva funcionalidad, pantalla o widget | `feat(widgets): create DescriptionCard reusable component` |
| **`fix`** | Corrección de un fallo o error en código existente | `fix(test): update smoke test to assert LayoutDemoScreen` |
| **`refactor`** | Reestructuración de código que no altera el comportamiento externo | `refactor(pages): extract reusable card styles` |
| **`test`** | Creación o actualización de pruebas unitarias o de widgets | `test(widgets): add unit tests for DescriptionCard` |
| **`docs`** | Modificaciones exclusivas en documentación o archivos de memoria | `docs(conventions): define flutter and git rules` |
| **`chore`** | Actualización de dependencias, scripts o configuración del proyecto | `chore(deps): upgrade supabase_flutter package` |
| **`style`** | Ajustes cosméticos de espaciado o formato sin impacto lógico | `style(lib): format files with dart format` |

### Reglas para la Descripción
- Escribir en minúsculas y modo imperativo/presente (ej. `add`, `update`, `fix`, `create` o en español `agrega`, `actualiza`, `corrige`).
- No colocar punto final en la primera línea.
- Limitar la primera línea a un máximo de 72 caracteres.
- Si se requiere mayor contexto, dejar una línea en blanco y añadir un cuerpo explicativo detallando el porqué del cambio.

---

## 3. Verificación Previa a la Confirmación

Antes de realizar `git commit` y `git push`, se debe asegurar que:
1. `flutter analyze` reporte 0 errores y advertencias.
2. `flutter test` pase con 100% de éxito.
3. No se incluyan archivos temporales, binarios de compilación (`build/`) o credenciales en el commit.
