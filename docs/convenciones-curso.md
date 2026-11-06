# Convenciones del curso

Sacadas de `github.com/Kelocoes/seminario-2026-02`, ramas `week-12/state-hoisting`
y `week-13/navigation-bottom`. Son las formas que el profesor enseñó y espera.

## La regla de oro, en sus palabras

El comentario aparece literal en `lib/screens/layout_demo_screen.dart`:

> - Una SCREEN representa la pantalla completa a nivel de ruta y navegación. Es
>   la encargada de proveer el "andamiaje" visual mediante un `Scaffold` (con
>   AppBar, BottomNavigationBar o TabBar, Drawer, etc.).
> - Una PAGE representa el contenido específico que se hospeda dentro del `body`
>   de una Screen. Una Page NUNCA debe llevar su propio Scaffold.

Y en una de las páginas de demo hay un banner que dice:

> Regla de Oro en Flutter: Nunca anides un Scaffold dentro de una Page. Mantén
> el Scaffold en la Screen.

## Screen simple

```dart
class RoutinesScreen extends StatelessWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Rutinas'), centerTitle: true),
      body: const SafeArea(child: RoutinesPage()),
    );
  }
}
```

Nótese que es `StatelessWidget`. Una Screen solo es stateful cuando de verdad
es dueña de estado.

## Screen que recibe argumentos

```dart
class RoutineDetailScreen extends StatelessWidget {
  const RoutineDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routine = ModalRoute.of(context)!.settings.arguments as Routine;
    return Scaffold(
      appBar: AppBar(title: Text(routine.name)),
      body: SafeArea(child: RoutineDetailPage(routine: routine)),
    );
  }
}
```

## Rutas

```dart
class AppRoutes {
  static const String login = '/';
  static const String main = '/main';
  static const String routineDetail = '/routine-detail';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginScreen(),
    main: (context) => const MainScreen(),
    routineDetail: (context) => const RoutineDetailScreen(),
  };
}
```

```dart
MaterialApp(
  initialRoute: AppRoutes.login,
  routes: AppRoutes.routes,
)
```

## Screen anfitriona con barra inferior

```dart
class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Routine App'), centerTitle: true),
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: _pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: 'Rutinas',
          ),
          // ...
        ],
      ),
    );
  }
}
```

`NavigationBar` + `NavigationDestination` (Material 3), no `BottomNavigationBar`.
`IndexedStack` para no perder el estado de cada pestaña al cambiar.

## Tema

El profesor usa `ColorScheme.fromSeed`. Nosotros lo mantenemos como base pero
sobrescribimos con los tokens exactos del diseño; ver `docs/diseno.md`.

## Tamaños de archivo de referencia

En el repo del curso: las Screens van de 18 a 55 líneas, las Pages de 75 a 106,
los widgets de 31 a 34. Si una Page pasa de ~150 líneas, probablemente hay un
widget que no se extrajo. Útil como señal, no como regla.

## Cómo se pasan datos y callbacks

El profesor pasa un modelo por `settings.arguments`. Para esta app, las
pantallas empujadas (detalle, crear, ticket) necesitan además poder modificar
los datos que vive en `MainScreen`. La forma, sin salirse de lo enseñado, es
pasar un objeto de argumentos que lleve los datos **y** los callbacks:

```dart
class DetalleArgs {
  final Evento evento;
  final bool guardado;
  final VoidCallback onToggleGuardado;
  final void Function(int idEntrada, int cantidad) onReservar;
  const DetalleArgs({...});
}

Navigator.pushNamed(context, AppRoutes.detalle, arguments: DetalleArgs(...));
```

Así el estado sigue viviendo en la Screen anfitriona y la Page empujada no
guarda nada propio.
