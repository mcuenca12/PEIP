# Estándares de Código Dart y Flutter

Este documento establece las directrices obligatorias de programación y estilo para el proyecto `seminario_2026_02`. Todo agente de desarrollo debe validar que el código propuesto cumpla con estas reglas antes de integrarlo al repositorio.

---

## 1. Uso Estricto de Constructores `const`

### Razón Técnica
En Flutter, el uso de `const` permite al compilador y al motor de renderizado instanciar los widgets en tiempo de compilación y reutilizar la misma instancia en memoria en lugar de recrearla en cada frame del ciclo de vida del árbol de widgets.

### Reglas
1. **Constructores de Widgets**:
   - Todo widget que no gestione estado mutable interno (`StatelessWidget`) y cuyas propiedades sean finales (`final`) debe declarar un constructor `const`.
   ```dart
   // Correcto
   class StatusBadge extends StatelessWidget {
     final String state;
     const StatusBadge({super.key, required this.state});
     ...
   }
   ```
2. **Instanciación en Árboles Visuales**:
   - Anteponer `const` a cualquier widget o colección de widgets cuyos parámetros sean constantes en tiempo de compilación.
   ```dart
   // Correcto
   const SizedBox(height: 16);
   const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
   ```
3. **Evitar Reconstrucciones Innecesarias**:
   - Si una lista de hijos en un `Column` o `Row` contiene elementos estáticos, declararlos como `const` para evitar llamadas a sus métodos `build` cuando el padre cambie.

---

## 2. Reglas de Nomenclatura

Siguiendo las directrices oficiales de *Effective Dart*:

| Elemento | Convención | Ejemplo |
| :--- | :--- | :--- |
| **Archivos y Directorios** | `snake_case` | `description_card.dart`, `layout_demo_screen.dart` |
| **Clases, Widgets y Enums** | `PascalCase` | `DescriptionCard`, `ExerciseCategory` |
| **Extensiones y Mixins** | `PascalCase` | `StringExtensions`, `ResponsiveMixin` |
| **Variables y Parámetros** | `camelCase` | `actionText`, `exerciseList`, `onTap` |
| **Funciones y Métodos** | `camelCase` | `calculateProgress()`, `buildHeader()` |
| **Constantes en Código** | `lowerCamelCase` | `defaultPadding`, `kAnimationDuration` |

---

## 3. Manejo de Advertencias de Linter (`flutter_lints`)

El proyecto cuenta con el paquete oficial `flutter_lints` configurado en `analysis_options.yaml`. Todo código debe superar `flutter analyze` con cero errores y advertencias.

### Regla `avoid_print`
- **Prohibido**: No usar `print()` en componentes de interfaz o código de producción.
- **Alternativas requeridas**:
  - En widgets reutilizables, delegar la acción mediante un callback nullable:
    ```dart
    // Correcto
    final VoidCallback? onPressed;
    ```
  - Si es indispensable registrar información en depuración, utilizar `debugPrint()` de Flutter:
    ```dart
    // Permitido exclusivamente para diagnóstico local
    debugPrint('Sesión inicializada');
    ```

### Inmutabilidad de Propiedades en `StatelessWidget`
- Todos los campos de clase en un `StatelessWidget` deben ser estrictamente inmutables (`final`).

### Null Safety y Tipado Explícito
- Evitar el uso de `dynamic` cuando sea posible inferir o especificar el tipo concreto.
- Declarar constructores con parámetros requeridos explícitos (`required this.title`) o valores predeterminados seguros.
