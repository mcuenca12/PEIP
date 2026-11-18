# [TASK-001] Lista de Tareas Verificables: base de datos y búsqueda

## Metadatos
- ID: TASK-001
- Plan asociado: [PLAN-001](../plans/base-datos-busqueda-plan.md)
- Spec asociada: [SPEC-001](../specs/base-datos-busqueda-spec.md)
- Fecha: 2026-11-16
- Estado general: NOT_STARTED

## Resumen de Progreso
- [ ] Tarea 1: Esquema, búsqueda y afinidad (`01_schema.sql`)
- [ ] Tarea 2: Políticas de seguridad (`02_policies.sql`)
- [ ] Tarea 3: Datos iniciales (`03_seed.sql`)
- [ ] Tarea 4: Cierre, verificación en Supabase y documentación

Cada tarea es un commit. Van en este orden porque cada script depende del anterior. Este bloque es SQL, así que no hay widgets, pages ni screens, y `flutter analyze` solo se corre en la tarea 4 para confirmar que no se rompió nada.

---

## Desglose Detallado

### - [ ] Tarea 1: Esquema, búsqueda y afinidad
- Dependencias previas: Ninguna
- Archivos involucrados:
  - `supabase/01_schema.sql` (crear)
- Acciones:
  - [ ] 1. Crear la extensión `unaccent` y la configuración de texto `peip_es`.
  - [ ] 2. Crear las 15 tablas con sus llaves, checks e índices, más el trigger `handle_new_user` sobre `auth.users`.
  - [ ] 3. Crear la columna `evento.busqueda`, sus triggers y el índice GIN `evento_busqueda_idx`.
  - [ ] 4. Crear `peip_tsquery`, `afinidad`, la vista `v_evento` y las funciones `recomendar_eventos`, `buscar_eventos_tsq` y `buscar_eventos`.
- Verificacion:
  - [ ] El script corre completo sobre una base vacía, sin errores.
  - [ ] `explain` de una búsqueda usa `evento_busqueda_idx`.
  - [ ] Al insertar una fila en `auth.users` se crean su `usuario` y su `organizador`.
- Aviso: no ejecutar este script en Supabase sin el de la tarea 2. Las tablas quedarían sin RLS.
- Commit sugerido: `feat(db): agrega esquema, busqueda y afinidad`

---

### - [ ] Tarea 2: Políticas de seguridad (RLS)
- Dependencias previas: Tarea 1
- Archivos involucrados:
  - `supabase/02_policies.sql` (crear)
- Acciones:
  - [ ] 1. Crear las funciones auxiliares `es_mi_organizador`, `es_dueno_evento` y `tengo_reserva_en_evento` (`security definer`).
  - [ ] 2. Activar RLS en las 15 tablas.
  - [ ] 3. Crear las políticas: catálogos de lectura pública, eventos publicados públicos, borradores solo para el dueño o quien tenga reserva, tablas personales solo del dueño, escritura de eventos y entradas solo del organizador dueño.
- Verificacion:
  - [ ] Con dos cuentas, Bob ve 0 reservas, 0 guardados y solo su usuario, y no puede modificar ni borrar lo de Ana.
  - [ ] El evento 4 (borrador) lo ve Ana y no lo ve Bob ni un usuario anónimo.
  - [ ] Bob no puede editar, borrar ni crear eventos o entradas de Ana.
  - [ ] Ninguna consulta falla por recursión infinita entre `evento` y `tipo_entrada`.
  - [ ] Todas las tablas aparecen con RLS activo.
- Commit sugerido: `feat(db): agrega politicas de seguridad por fila`

---

### - [ ] Tarea 3: Datos iniciales
- Dependencias previas: Tareas 1 y 2
- Archivos involucrados:
  - `supabase/03_seed.sql` (crear)
- Acciones:
  - [ ] 1. Insertar 5 ciudades, 12 categorías, 12 etiquetas, 5 organizadores, 1 serie, 13 eventos, sus etiquetas, 17 tipos de entrada y 25 sinónimos, con los mismos ids del prototipo.
  - [ ] 2. Reiniciar las secuencias con `setval`.
  - [ ] 3. Agregar el bloque idempotente que arma el perfil de Ana (intereses, pesos de etiquetas, guardados, reservas y búsquedas) si su cuenta ya existe en `auth.users`.
- Verificacion:
  - [ ] `buscar_eventos('liderazgo')` y `buscar_eventos('algo sobre liderazgo para mi equipo')` devuelven exactamente los eventos 9, 10 y 11.
  - [ ] `buscar_eventos('ESTADISTICA')` y `buscar_eventos('estadística')` devuelven lo mismo.
  - [ ] `buscar_eventos('pizza')` devuelve cero filas.
  - [ ] `recomendar_eventos()` como Ana: evento 10 con 84, evento 9 con 78, todos entre 63 y 84.
  - [ ] Con `personalizacion_activa = false` la afinidad es null y el orden es por fecha.
  - [ ] `recomendar_eventos(2)` devuelve solo Leadership.
  - [ ] Al borrar el evento 5 desaparecen sus entradas y guardados.
  - [ ] Correr el seed dos veces no duplica datos ni da error.
- Commit sugerido: `feat(db): agrega datos iniciales y cuenta demo`

---

### - [ ] Tarea 4: Cierre, verificación en Supabase y documentación
- Dependencias previas: Tareas 1 a 3
- Archivos involucrados:
  - `.agents/memory/project_state.md` (modificar)
  - `.agents/memory/epics.md` (modificar)
  - `.agents/plans/base-datos-busqueda-plan.md` (modificar, estado)
  - `.agents/specs/base-datos-busqueda-spec.md` (modificar, estado)
- Acciones:
  - [ ] 1. Crear a Ana en Authentication de Supabase (Auto Confirm) y correr `01`, `02` y `03` en ese orden en el proyecto real.
  - [ ] 2. Confirmar los dos supuestos del plan: `unaccent` queda en el esquema `extensions` y el SQL Editor deja crear el trigger sobre `auth.users`.
  - [ ] 3. Repetir las verificaciones de las tareas 2 y 3 sobre el proyecto real.
  - [ ] 4. Avisar a los bloques B, C y D lo que les toca (ver "Interfaces con otros bloques" en el plan).
  - [ ] 5. Marcar las HUs completadas en `epics.md` y actualizar `project_state.md`.
  - [ ] 6. Pasar el estado de la spec y del plan a `COMPLETED`.
- Verificacion:
  - [ ] Los tres scripts corren en orden sobre el proyecto de Supabase sin errores.
  - [ ] `flutter analyze` y `flutter test` en verde, para confirmar que la app no se afectó.
  - [ ] Cada escenario Gherkin de la spec quedó cubierto por alguna verificación de las tareas 2 y 3.
- Commit sugerido: `docs(memory): actualiza estado del proyecto y epicas`
