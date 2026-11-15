---
name: flutter-clean-code-linter
description: "Audita y corrige Clean Code y analisis estatico en Flutter/Dart: resuelve incidencias de flutter analyze (flutter_lints), exige constructores const, inmutabilidad en StatelessWidget (campos final), erradica print() en produccion y asegura convenciones de nombres."
---

# Flutter Clean Code Linter Skill

Esta skill guia la auditoria, depuracion y correccion de estandares de calidad de codigo, buenas practicas de desarrollo en Dart y cumplimiento del paquete `flutter_lints` para el proyecto `seminario_2026_02`.

---

## Objetivos de Calidad

1. **Cero Advertencias en `flutter analyze`**: El codigo debe compilar con 0 errores, 0 advertencias y 0 lints.
2. **Uso Riguroso de `const`**:
   - Constructores `const` obligatorios en todo `StatelessWidget` con propiedades `final`.
   - Anteponer `const` en instancias de widgets y colecciones de hijos estaticos (`children: const [...]`).
3. **Inmutabilidad y Tipado**:
   - Campos de clase estrictamente inmutables (`final`) en `StatelessWidget`.
   - Tipado estricto; evitar `dynamic` e imports no utilizados (`unused_import`).
4. **Erradicacion de `print()` en Produccion**:
   - Prohibido el uso de `print(...)` en componentes visuales.
   - Reemplazar por callbacks desacoplados (`VoidCallback? onPressed`) o por `debugPrint(...)` en diagnosticos locales.
5. **Nomenclatura Effective Dart**:
   - Archivos: `snake_case` (ej. `user_profile_card.dart`).
   - Clases y Enums: `PascalCase` (ej. `UserProfileCard`).
   - Variables, metodos y parametros: `camelCase` (ej. `onTapAction`).

---

## Flujo Operativo de Auditoria y Correccion

### Paso 1: Ejecucion del Analisis Estatico Oficial

Ejecuta el linter oficial del proyecto en la terminal:

```bash
flutter analyze
```

Clasifica los hallazgos segun su severidad:
* `error`: Detiene la compilacion. Prioridad 1.
* `warning`: Imports sin usar, variables huerfanas o tipos ambiguos.
* `info`: Reglas de estilo como `avoid_print`, `prefer_const_constructors`, etc.

### Paso 2: Erradicacion de `avoid_print`

El linter marca `Don't invoke 'print' in production code`. Aplica la solucion adecuada segun el caso:

```dart
// INCORRECTO: Acopla el widget a la consola
IconButton(
  icon: const Icon(Icons.close),
  onPressed: () {
    print('Cerrando alerta');
  },
)

// CORRECTO (Opcion 1 - Delegacion por Callback):
final VoidCallback? onDismiss;
...
IconButton(
  icon: const Icon(Icons.close),
  onPressed: onDismiss,
)

// CORRECTO (Opcion 2 - Diagnostico local permitido):
debugPrint('Cerrando alerta con id: $id');
```

### Paso 3: Optimizacion con Constructores `const`

Verifica que el arbol visual aproveche la memoria en tiempo de compilacion:

```dart
// INCORRECTO: Reinstanciacion continua en cada frame
SizedBox(height: 16);
EdgeInsets.all(12);

// CORRECTO: Instancia canonica unica en memoria
const SizedBox(height: 16);
const EdgeInsets.all(12);
```

### Paso 4: Inmutabilidad en `StatelessWidget`

Todos los campos declarados dentro de un `StatelessWidget` deben ser inmutables:

```dart
// INCORRECTO
class UserCard extends StatelessWidget {
  String username; // Mutable
  UserCard({required this.username});
  ...
}

// CORRECTO
class UserCard extends StatelessWidget {
  final String username;
  const UserCard({super.key, required this.username});
  ...
}
```

### Paso 5: Limpieza de Imports Huerfanos y Formateo

1. Elimina imports no referenciados (ej. `unused_import` en `test/` o `lib/`).
2. Aplica formato estandarizado segun las reglas del compilador Dart:
   ```bash
   dart format lib test
   ```

---

## Herramienta de Automatizacion

Esta skill incluye un script de verificacion rapida para diagnosticar y auditar el codigo:

```bash
python .agents/skills/flutter-clean-code-linter/scripts/check_clean_code.py
```

El script inspecciona automaticamente el proyecto buscando llamadas a `print()`, campos mutables en `StatelessWidget` y corre `flutter analyze`.

---

## Checklist de Entrega

Antes de dar por concluida la tarea o commit, verifica:
- [ ] `flutter analyze` finaliza con mensaje `No issues found!`.
- [ ] No existen llamadas a `print(` dentro de ningun archivo de `lib/`.
- [ ] Todos los `StatelessWidget` tienen constructor `const` y propiedades `final`.
- [ ] Los nombres de archivo siguen estrictamente `snake_case.dart`.
- [ ] El codigo fue formateado con `dart format`.
