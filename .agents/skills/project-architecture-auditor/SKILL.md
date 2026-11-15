---
name: project-architecture-auditor
description: "Audita la arquitectura y organizacion del proyecto Flutter: inspecciona los ultimos 5 commits, valida la jerarquia Screen vs Page vs Widget (Scaffold anidado), comprueba la reutilizacion de componentes y evalua el principio de composicion frente a widgets monoliticos."
---

# Project Architecture Auditor Skill

Esta skill guia la auditoria tecnica y arquitectonica del repositorio Flutter `seminario_2026_02`. Esta disenada para verificar de manera determinista si los cambios recientes respetan la organizacion por capas del proyecto, la reutilizacion de componentes atomicos y las buenas practicas de composicion de widgets.

---

## Objetivos de la Auditoria

1. **Trazabilidad Git**: Evaluar los ultimos 5 commits para entender el contexto, intencion y alcance de los cambios recientes.
2. **Jerarquia Visual Estricta**: Comprobar la regla de oro del proyecto:
   - `lib/screens/` -> Hospeda exclusivamente el `Scaffold` raiz, `AppBar`, tabs y navegacion.
   - `lib/pages/` -> Contenido interno (`body`). PROHIBIDO incluir `Scaffold` propio.
   - `lib/widgets/` -> Componentes atomicos reutilizables y agnosticos de navegacion.
3. **Reutilizacion de Componentes**: Evitar la duplicacion de codigo visual promoviendo el uso de widgets existentes en `lib/widgets/` (`ActionButton`, `StatusBadge`, `UserProfileCard`, `NotificationBanner`, `DescriptionCard`).
4. **Principio de Composicion**: Favorecer la composicion (composition over inheritance / monoliths). Desaconsejar funciones privadas `Widget _buildSection()` en favor de `StatelessWidget` pequenos y reutilizables.

---

## Flujo Operativo Paso a Paso

### Paso 1: Inspeccion de los Ultimos 5 Commits

1. Ejecuta el comando para revisar el historial reciente:
   ```bash
   git log -n 5 --oneline --stat
   ```
2. Analiza los mensajes de commit:
   - Siguen Conventional Commits (`feat:`, `fix:`, `chore:`, `docs:`)?
   - Que archivos fueron creados o modificados en cada commit?
3. Extrae la lista de archivos `.dart` tocados en los ultimos 5 commits para enfocar la auditoria en los cambios recientes.

### Paso 2: Validacion de Organizacion y Jerarquia de Capas

Inspecciona cada archivo modificado segun su carpeta de destino:

| Ubicacion | Rol Permitido | Regla Critica |
| :--- | :--- | :--- |
| **`lib/screens/`** | Pantalla principal / Ruta | DEBE contener `Scaffold`. Maneja barras de navegacion y routing. |
| **`lib/pages/`** | Lienzo / Vistas internas | PROHIBIDO el uso de `Scaffold`. Si necesita scroll, usa `SingleChildScrollView` o `ListView`. |
| **`lib/widgets/`** | Bloques visuales atomicos | PROHIBIDO el uso de `Scaffold`. No debe hacer navegacion directa (usa callbacks). |

> [!CAUTION]
> **Antipatron del Scaffold Anidado**:
> Si una `Page` contiene un `Scaffold`, causara problemas de doble sombreado, conflictos de `SafeArea` y mal comportamiento del teclado virtual.

### Paso 3: Evaluacion de Reutilizacion de Componentes

Revisa si el nuevo codigo reinventa elementos que ya existen en `lib/widgets/`:

* Se creo un boton estilizado cuando ya existe `ActionButton`?
* Se creo una pildora o etiqueta de estado cuando ya existe `StatusBadge`?
* Se creo un aviso o alerta cuando ya existe `NotificationBanner`?
* Se diseno una ficha de usuario cuando ya existe `UserProfileCard`?

**Accion recomendada**: Reemplazar duplicados importando el widget comun y pasando las propiedades requeridas via constructor.

### Paso 4: Principio de Composicion vs. Monolitos

Verifica la estructura interna de los metodos `build()`:

1. **Evitar la Piramide de la Muerte**: Metodos `build()` con mas de 80 lineas o con mas de 4 niveles de anidacion profunda (`Column` -> `Container` -> `Padding` -> `Row` -> `Expanded` -> ...).
2. **Antipatron de Metodos Auxiliares**:
   ```dart
   // INCORRECTO: Reconstruye todo el arbol innecesariamente
   Widget _buildUserHeader() {
     return Row(...);
   }

   // CORRECTO: Widget extraido por composicion, optimizable con const
   class UserHeader extends StatelessWidget {
     const UserHeader({super.key});
     @override
     Widget build(BuildContext context) => const Row(...);
   }
   ```
3. **Composicion de Widgets**: Construir vistas complejas componiendo widgets pequenos, independientes e inmutables.

---

## Herramienta de Automatizacion

Esta skill incluye un script de diagnostico en Python para acelerar la auditoria:

```bash
python .agents/skills/project-architecture-auditor/scripts/audit_architecture.py
```

El script inspecciona automaticamente los ultimos 5 commits de Git y escanea el arbol de `lib/` buscando `Scaffold` indebidos y metodos monoliticos.

---

## Plantilla del Reporte de Auditoria

Al finalizar la auditoria, genera un informe con el siguiente formato:

```markdown
# Reporte de Auditoria de Arquitectura

## 1. Resumen de Commits Auditados (Ultimos 5)
- `<hash>` - `<mensaje>`: `<breve evaluacion de impacto>`

## 2. Jerarquia de Componentes (Screen vs. Page vs. Widget)
- [CONFORME / NO CONFORME] `lib/screens/`: Correcto uso de Scaffold.
- [CONFORME / NO CONFORME] `lib/pages/`: Ausencia de Scaffolds anidados.
- [CONFORME / NO CONFORME] `lib/widgets/`: Componentes atomicos desacoplados.

## 3. Reutilizacion de Widgets
- Oportunidades de reutilizacion identificadas:
  - `<detalle>`

## 4. Principio de Composicion
- Evaluacion de metodos build monoliticos y sub-widgets.

## 5. Plan de Accion Inmediato
1. `<Accion correctiva 1>`
2. `<Accion correctiva 2>`
```
