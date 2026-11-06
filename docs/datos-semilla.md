# Datos semilla

Dominio **académico y profesional**. Es el que dice el documento de contexto y
el que quedó en el prototipo de Figma. Nada de conciertos, maratones ni
gastronomía: eso era una versión vieja y ya se corrigió en el diseño.

## Ciudades

Bogotá, Medellín, Cali, Barranquilla, Bucaramanga.

## Categorías — las doce áreas del documento de contexto

Technology & Data · Leadership · Medical Education · Research ·
Agile & Delivery · Project Management · Innovation · Entrepreneurship ·
Public Speaking · Finance & Economics · Sustainability · Workplace Wellbeing

Cada una con su `icono` (nombre simbólico que se mapea a un `IconData`) y su
`color` en hex.

## Organizadores

Cámara de Comercio de Bogotá · Ruta N · Universidad Icesi · ACIS ·
Centro de Convenciones Ágora

## Sedes

Centro de Convenciones Ágora (Bogotá) · Cámara de Comercio de Bogotá ·
Corferias (Bogotá) · Universidad Icesi (Cali) · Ruta N (Medellín) ·
Hotel Tequendama (Bogotá) · Centro de Eventos Valle del Pacífico (Cali) ·
Universidad de los Andes · Universidad Nacional · Pontificia U. Javeriana

## Eventos

Entre diez y doce, repartidos en categorías y ciudades, con al menos dos de la
misma serie para que la edición anterior tenga sentido. Los que ya están en el
prototipo de Figma:

- **Congreso Nacional de Innovación 2025** — Technology & Data, Ágora Bogotá,
  tres días, el evento "ancla" con tres tipos de entrada
- **Cumbre de Transformación Digital** — Innovation, Corferias
- **Seminario de Investigación Clínica** — Medical Education, Hotel Tequendama
- **Foro de Bienestar Laboral** — Workplace Wellbeing, Cámara de Comercio
- **Scrum for Teams Workshop** — Agile & Delivery, Universidad Icesi
- **Data Analytics Bootcamp** — Technology & Data, Ruta N
- **Open Lecture: Ethics in AI** — Research, Universidad de los Andes, gratis
- **Product Leadership Meetup** — Leadership, Ruta N, gratis
- **Agile Leadership Workshop** — Leadership, Cámara de Comercio
- **Coaching for Team Leads** — Leadership, Universidad Icesi
- **Advanced Statistics Seminar** — Research, Universidad Nacional
- **Research Methods Masterclass** — Research, Pontificia U. Javeriana

Al menos uno en `estado: 'borrador'`, para que el estado no sea decorativo.
Al menos uno con `todoElDia: true`.
Al menos un par ligados por `idSerie` con uno apuntando al otro con
`idEventoAnterior`.

## Tipos de entrada

Tres niveles donde aplique: **General Access**, **Professional**, **Corporate**.
Precios en pesos colombianos, con separador de miles: `$85.000`, `$180.000`,
`$320.000`. Los eventos gratuitos llevan un solo tipo con `precio: 0`, que se
muestra como "Gratis".

## Etiquetas

team leadership · agile delivery · data analytics · clinical research ·
public speaking · change management · innovation · product management ·
statistics · sustainability · coaching · certification

## Usuario de prueba

Uno ya registrado, con intereses, pesos de etiquetas, dos o tres eventos
guardados y una reserva usada más una sin usar. Así el perfil y la pestaña de
tickets no arrancan vacíos.

Pesos de etiquetas sugeridos, que son los que están en el Figma:
`team leadership` 0.86, `agile delivery` 0.74, `data analytics` 0.69,
`clinical research` 0.61, `public speaking` 0.55, `change management` 0.52.

## Búsquedas que tienen que funcionar en el video

**`algo sobre liderazgo para mi equipo`** — es textualmente el ejemplo del
documento de contexto. Debe devolver *Agile Leadership Workshop*,
*Coaching for Team Leads* y *Product Leadership Meetup*, aunque la palabra
"liderazgo" no esté en ningún título. Esa es la demostración de la búsqueda por
significado y es el momento más importante del video.

**`certificación en seguridad industrial nivel 3`** — no debe encontrar nada, y
debe disparar el estado de "sin coincidencia exacta" con los tres más cercanos.
