# Jerarquía de Interfaz de Usuario (UI)

Este documento define la estructura de capas visuales y la separación estricta de responsabilidades entre pantallas, páginas y widgets dentro del proyecto `peip`.

---

## 1. Distinción Didáctica del Proyecto

La arquitectura de interfaz del repositorio separa el código en tres niveles claros según su responsabilidad y relación con el andamiaje (`Scaffold`):

```
+--------------------------------------------------------+
| Screen (lib/screens/)                                  |
| - Provee el Scaffold, AppBar, TabBar/BottomNav, Drawer |
|   +--------------------------------------------------+ |
|   | Page (lib/pages/)                                | |
|   | - Contenido alojado en el body del Scaffold      | |
|   | - SIN Scaffold propio                            | |
|   |   +--------------------------------------------+ | |
|   |   | Widgets (lib/widgets/)                     | | |
|   |   | - Componentes visuales atómicos            | | |
|   |   | - Tarjetas, botones, badges, modales       | | |
|   |   +--------------------------------------------+ | |
|   +--------------------------------------------------+ |
+--------------------------------------------------------+
```

---

## 2. Nivel 1: Screens (`lib/screens/`)

### Responsabilidad
Una **Screen** representa una pantalla completa a nivel de ruta y navegación en la aplicación. Es la encargada exclusiva de proveer el andamiaje visual fundamental mediante el widget `Scaffold`.

### Características y Reglas
- **Contiene**:
  - `Scaffold` raíz.
  - Barras superiores (`AppBar`), inferiores (`BottomNavigationBar` o `TabBar`), botones flotantes (`FloatingActionButton`) o cajones laterales (`Drawer`).
- **Navegación**: Define y recibe argumentos de rutas y transiciones entre pantallas.
- **Ejemplo en el proyecto**:
  - `LayoutDemoScreen` (`lib/screens/layout_demo_screen.dart`): Configura el `Scaffold` principal y utiliza un `DefaultTabController` para alternar entre diferentes páginas sin necesidad de gestionar estado mutable.

---

## 3. Nivel 2: Pages (`lib/pages/`)

### Responsabilidad
Una **Page** representa el contenido específico o la vista temática que se hospeda dentro del cuerpo (`body`) de una `Screen`.

### Características y Reglas
- **Regla Fundamental**: Una `Page` **NUNCA debe llevar su propio `Scaffold`**.
  - Si una Page incluyera su propio `Scaffold`, se generarían problemas de doble sombreado, superposición indebida de barras de navegación y fallos en el cálculo de zonas seguras (`SafeArea`).
- **Composición**: Organiza y estructura el diseño mediante contenedores, filas, columnas y widgets de scroll seguro (`SingleChildScrollView`, `ListView`).
- **Ejemplos en el proyecto**:
  - `LinearLayoutPage` (`lib/pages/linear_layout_page.dart`)
  - `BoxCompositionPage` (`lib/pages/box_composition_page.dart`)
  - `ScrollSafePage` (`lib/pages/scroll_safe_page.dart`)
  - `PageExample` (`lib/pages/page_example.dart`): Muestrario de widgets.

---

## 4. Nivel 3: Widgets (`lib/widgets/`)

### Responsabilidad
Los **Widgets** son piezas visuales atómicas, autónomas y altamente reutilizables. No dependen de la navegación ni de qué pantalla los contenga.

### Características y Reglas
- **Agnósticos de Navegación**: No deben acoplarse rígidamente a rutas específicas; reciben sus datos y delegan sus eventos a través de propiedades en su constructor (`props` y `callbacks`).
- **Diseño Autónomo**: Gestionan su propio espaciado interno (`padding`), decoración (`decoration`, `borderRadius`, `boxShadow`) y tipografía alineada al tema institucional (`Theme.of(context)`).
- **Ejemplos en el proyecto**:
  - `EventCard`: Tarjeta de evento con imagen, categoría, fecha y precio.
  - `ResultRow`: Fila horizontal de un resultado de búsqueda.
  - `SemanticNote`: Aviso de coincidencia por significado.
  - `PeipBadge`: Etiqueta de afinidad, categoría o entrada gratuita.
  - `PeipButton`: Botón con variantes principal, secundaria y fantasma.

---

## 5. Resumen de Decisión para Desarrolladores y Agentes

Antes de crear un nuevo archivo de interfaz, responde a la siguiente pregunta:

1. ¿Es una pantalla completa accesible por una ruta con su propia barra superior/inferior? -> Crear en `lib/screens/` con `Scaffold`.
2. ¿Es el contenido o formulario que se renderiza dentro de una pantalla existente? -> Crear en `lib/pages/` sin `Scaffold`.
3. ¿Es un elemento visual que se puede usar en múltiples pantallas (tarjeta, botón, ficha, banner)? -> Crear en `lib/widgets/`.
