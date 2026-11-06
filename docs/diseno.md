# Diseño: tokens y componentes

Vienen del prototipo de Figma de la entrega anterior (archivo
`wxeygKEoL5JQk18geRJSrf`). No hay que rediseñar nada, hay que respetarlo.

## Colores

| Token | Hex | Para qué |
|---|---|---|
| brand600 | `#5454E9` | acciones primarias, enlaces, activo |
| brand400 | `#7B7BF2` | acentos, segunda serie en gráficos |
| brand50 | `#EEF0FF` | fondo de chips y píldoras activas |
| surface | `#FFFFFF` | tarjetas, barras |
| canvas | `#F8F9FF` | fondo de pantalla |
| textPrimary | `#1A1A2E` | títulos y texto fuerte |
| textSecondary | `#6B7280` | texto de apoyo |
| textMuted | `#9EA6B5` | placeholders, texto terciario |
| border | `#E5E7EB` | bordes y divisores |
| success | `#22C582` | gratis, tendencia al alza |
| danger | `#D94040` | errores, cancelar |

El fondo de `Scaffold` es `canvas`, no blanco.

Para las imágenes de evento, mientras no haya fotos, se usa un bloque de color
desaturado. La paleta: `#736BC7`, `#B87A66`, `#4D8CB8`, `#619E85`, `#946B9E`,
`#CC8F4D`, `#66A37A`, `#A8737A`. Desaturados a propósito: los badges van encima
en blanco translúcido y necesitan contraste estable.

## Tipografía

Familia **Inter**. Si no se quiere empaquetar la fuente, usar la del sistema y
dejarlo anotado; lo que no se puede es mezclar.

`height` en Flutter es multiplicador, o sea interlineado dividido por tamaño.

| Estilo | Tamaño | Peso | Interlineado |
|---|---|---|---|
| displayLarge | 48 | w800 | 58 |
| headlineLarge | 32 | w800 | 40 |
| headlineMedium | 22 | w700 | 30 |
| titleLarge | 17 | w700 | 24 |
| bodyLarge | 16 | w400 | 26 |
| bodyMedium | 14 | w400 | 22 |
| bodySmall | 13 | w400 | 20 |
| labelLarge | 12 | w600 | 16 |
| labelSmall | 11 | w400 | 15 |

## Espaciado y radios

Espaciado: 4, 8, 12, 16, 20, 24, 32. Margen lateral en móvil: 16.
Radios: 8 (chips pequeños), 10 (inputs y botones), 12 (tarjetas),
16 (tarjetas destacadas), 20 (píldoras).

Sombra de tarjeta: `0 1 8` al 5 % de negro.
Sombra del botón primario: `0 4 14` con brand600 al 35 %.

## Galería de componentes → widgets

La galería de Figma tiene 14 componentes. Cada uno es un widget en
`lib/widgets/`, definido una sola vez. Esta tabla es el criterio de
correspondencia que el profesor puede verificar.

| Componente en Figma | Widget | Notas |
|---|---|---|
| Button (Primary / Secondary / Ghost) | `PeipButton` | variante por enum |
| Filter Chip (Default / Active) | `PeipChip` | |
| Text Input (Empty / Focused) | `PeipTextField` | |
| Form Field | `PeipFormField` | etiqueta + input |
| Badge (Match / Category / Free) | `PeipBadge` | tipo por enum |
| Event Card | `EventCard` | tarjeta de grilla, imagen 273×128 |
| Result Row | `ResultRow` | fila horizontal de resultados |
| Top Bar / Mobile | — | lo cubre el `AppBar` de cada Screen |
| Top Bar / Desktop | — | no aplica, la app es móvil |
| Bottom Nav Bar | — | lo cubre `NavigationBar` en `MainScreen` |
| Semantic Match Note | `SemanticNote` | el aviso de coincidencia por significado |
| Interest Tile | `InterestTile` | tile del onboarding |
| Ticket Type Option | `TicketTypeTile` | selector de tipo de entrada |
| Inferred Tag Row | `InferredTagRow` | etiqueta con barra de peso |

Tres componentes de la galería los resuelve Flutter con widgets nativos
(`AppBar`, `NavigationBar`). Eso está bien y hay que decirlo en el README del
proyecto, porque si no parece que faltan.

Widgets adicionales que la app necesita y conviene extraer, aunque no estén en
la galería de Figma: `SectionHeader`, `EmptyState`, `InfoRow`, `ReservaCard`,
`PeipSearchBar`. Anotarlos en el README como añadidos de la fase de código.

## Pantallas de Figma como referencia

Las 17 pantallas están en la página `Prototipo` del archivo. Las tres móviles
(`Mobile — Discover`, `Mobile — Results`, `Mobile — Event Detail`) son la
referencia directa de ancho 390. Las demás están en escritorio y hay que
adaptarlas a móvil, no copiarlas píxel a píxel.
