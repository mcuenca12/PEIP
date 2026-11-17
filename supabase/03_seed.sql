-- PEIP, entrega 4. Bloque A: datos semilla.
--
-- Salen de lib/model/mock_data.dart: los mismos congresos, sedes, entradas,
-- etiquetas y organizadores, con los mismos ids para que nada cambie al migrar.
-- Las fechas van en hora de Colombia (-05).
--
-- Se ejecuta despues de 01_schema.sql y 02_policies.sql. El script corre como
-- postgres (SQL Editor de Supabase), que se salta la RLS.

-- ---------------------------------------------------------------------------
-- Catalogos
-- ---------------------------------------------------------------------------

insert into ciudad (id_ciudad, nombre) values
  (1, 'Bogotá'),
  (2, 'Medellín'),
  (3, 'Cali'),
  (4, 'Barranquilla'),
  (5, 'Bucaramanga');

insert into categoria (id_categoria, nombre, icono, color) values
  (1,  'Technology & Data',    'tech',             '#2563EB'),
  (2,  'Leadership',           'leadership',       '#7C3AED'),
  (3,  'Medical Education',    'medical',          '#DC2626'),
  (4,  'Research',             'research',         '#0EA5E9'),
  (5,  'Agile & Delivery',     'agile',            '#059669'),
  (6,  'Project Management',   'project',          '#D97706'),
  (7,  'Innovation',           'innovation',       '#DB2777'),
  (8,  'Entrepreneurship',     'entrepreneurship', '#EA580C'),
  (9,  'Public Speaking',      'speaking',         '#4F46E5'),
  (10, 'Finance & Economics',  'finance',          '#16A34A'),
  (11, 'Sustainability',       'sustainability',   '#22C582'),
  (12, 'Workplace Wellbeing',  'wellbeing',        '#0D9488');

insert into etiqueta (id_etiqueta, nombre) values
  (1,  'team leadership'),
  (2,  'agile delivery'),
  (3,  'data analytics'),
  (4,  'clinical research'),
  (5,  'public speaking'),
  (6,  'change management'),
  (7,  'innovation'),
  (8,  'product management'),
  (9,  'statistics'),
  (10, 'sustainability'),
  (11, 'coaching'),
  (12, 'certification');

-- El organizador 3 (Universidad Icesi) es el de la cuenta demo; se liga a Ana
-- Torres en el bloque del final. Los demas son instituciones sin cuenta.
insert into organizador (id_organizador, nombre) values
  (1, 'Cámara de Comercio de Bogotá'),
  (2, 'Ruta N'),
  (3, 'Universidad Icesi'),
  (4, 'ACIS'),
  (5, 'Centro de Convenciones Ágora');

insert into serie_evento (id_serie, nombre, periodicidad, id_organizador, id_categoria) values
  (1, 'Data Analytics Bootcamp', 'semestral', 2, 1);

-- Equivalencias espanol a ingles (de _sinonimos en lib/utils/busqueda.dart,
-- sin tildes y en minusculas).
insert into sinonimo (termino, equivalente) values
  ('liderazgo',      'leadership'),
  ('lider',          'leadership'),
  ('equipo',         'team'),
  ('equipos',        'team'),
  ('agil',           'agile'),
  ('agilidad',       'agile'),
  ('entrega',        'delivery'),
  ('datos',          'data'),
  ('analitica',      'analytics'),
  ('estadistica',    'statistics'),
  ('investigacion',  'research'),
  ('innovacion',     'innovation'),
  ('emprendimiento', 'entrepreneurship'),
  ('oratoria',       'speaking'),
  ('finanzas',       'finance'),
  ('economia',       'economics'),
  ('sostenibilidad', 'sustainability'),
  ('bienestar',      'wellbeing'),
  ('certificacion',  'certification'),
  ('cambio',         'change'),
  ('proyecto',       'project'),
  ('proyectos',      'project'),
  ('tecnologia',     'tech'),
  ('clinica',        'clinical'),
  ('salud',          'medical');

-- ---------------------------------------------------------------------------
-- Eventos
-- ---------------------------------------------------------------------------
-- El orden importa: el evento 7 apunta al 6 como edicion anterior.

insert into evento (
  id_evento, titulo, eslogan, descripcion, fecha_inicio, fecha_fin, todo_el_dia,
  lugar, estado, aforo, id_categoria, id_organizador, id_ciudad, id_serie, id_evento_anterior
) values
  (1, 'Congreso Nacional de Innovación 2025', 'Tres días para repensar la industria',
   'El congreso insignia del sector: conferencias magistrales, paneles de industria y una zona de innovación con casos reales.',
   '2026-11-24 00:00-05', '2026-11-26 00:00-05', true,
   'Centro de Convenciones Ágora', 'publicado', 1200, 1, 1, 1, null, null),

  (2, 'Cumbre de Transformación Digital', 'De la estrategia a la ejecución',
   'Casos de transformación digital en empresas colombianas, con foco en adopción y cambio organizacional.',
   '2026-12-02 08:00-05', '2026-12-03 17:00-05', false,
   'Corferias', 'publicado', 1800, 7, 2, 1, null, null),

  (3, 'Seminario de Investigación Clínica', 'Metodología y ética en investigación en salud',
   'Seminario para profesionales de la salud sobre diseño de estudios clínicos y buenas prácticas de investigación.',
   '2026-11-18 08:00-05', '2026-11-18 17:00-05', false,
   'Hotel Tequendama', 'publicado', 300, 3, 1, 1, null, null),

  (4, 'Foro de Bienestar Laboral', 'Equipos sanos, resultados sostenibles',
   'Foro sobre salud mental, carga laboral y políticas de bienestar en el trabajo, con casos de empresas de la región.',
   '2026-11-20 09:00-05', '2026-11-20 16:00-05', false,
   'Cámara de Comercio de Bogotá', 'borrador', 150, 12, 3, 1, null, null),

  (5, 'Scrum for Teams Workshop', 'Agilidad práctica para equipos reales',
   'Taller intensivo de Scrum con dinámicas de equipo y un caso de aplicación guiado de principio a fin.',
   '2026-11-28 08:00-05', '2026-11-28 17:00-05', false,
   'Universidad Icesi', 'publicado', 40, 5, 3, 3, null, null),

  (6, 'Data Analytics Bootcamp — Cohorte Septiembre', 'Edición anterior de la cohorte',
   'De datos crudos a decisiones: limpieza, análisis exploratorio y visualización, con proyecto final por equipos.',
   '2026-09-14 08:00-05', '2026-09-16 17:00-05', false,
   'Ruta N', 'publicado', 60, 1, 2, 2, 1, null),

  (7, 'Data Analytics Bootcamp — Cohorte Noviembre', 'Nueva cohorte, mismo formato intensivo',
   'Nueva edición del bootcamp: limpieza de datos, análisis exploratorio y visualización, con proyecto final por equipos.',
   '2026-11-30 08:00-05', '2026-12-02 17:00-05', false,
   'Ruta N', 'publicado', 60, 1, 2, 2, 1, 6),

  (8, 'Open Lecture: Ethics in AI', 'Una hora para pensar antes de programar',
   'Charla abierta sobre los dilemas éticos de la inteligencia artificial aplicada, con espacio de preguntas.',
   '2026-11-17 18:00-05', '2026-11-17 19:00-05', false,
   'Universidad de los Andes', 'publicado', 80, 4, 4, 1, null, null),

  (9, 'Product Leadership Meetup', 'Product managers compartiendo lo que funciona',
   'Meetup informal de liderazgo de producto: dos charlas cortas y networking entre profesionales del gremio.',
   '2026-11-21 18:00-05', '2026-11-21 20:00-05', false,
   'Ruta N', 'publicado', 60, 2, 2, 2, null, null),

  (10, 'Agile Leadership Workshop', 'Liderar equipos ágiles sin perder el rumbo',
   'Taller sobre liderazgo de equipos ágiles: delegación, manejo de conflicto y gestión del cambio en entornos de entrega continua.',
   '2026-12-04 08:00-05', '2026-12-04 17:00-05', false,
   'Cámara de Comercio de Bogotá', 'publicado', 50, 2, 1, 1, null, null),

  (11, 'Coaching for Team Leads', 'Herramientas de coaching para líderes de equipo',
   'Sesión práctica de coaching aplicado a la gestión de personas, pensada para líderes de equipos pequeños y medianos.',
   '2026-12-09 08:00-05', '2026-12-09 13:00-05', false,
   'Universidad Icesi', 'publicado', 35, 2, 3, 3, null, null),

  (12, 'Advanced Statistics Seminar', 'Estadística aplicada para investigadores',
   'Seminario de estadística avanzada orientado a investigadores: modelos, supuestos y errores comunes de interpretación.',
   '2026-11-14 08:00-05', '2026-11-14 17:00-05', false,
   'Universidad Nacional', 'publicado', 100, 4, 4, 1, null, null),

  (13, 'Research Methods Masterclass', 'Diseño de investigación de principio a fin',
   'Masterclass sobre diseño metodológico, recolección de datos y análisis para proyectos de investigación aplicada.',
   '2026-12-06 08:00-05', '2026-12-06 17:00-05', false,
   'Pontificia U. Javeriana', 'publicado', 70, 4, 4, 1, null, null);

-- Las etiquetas se insertan despues: el trigger recalcula el tsvector de cada
-- evento al agregarlas.
insert into evento_etiqueta (id_evento, id_etiqueta) values
  (1, 7), (1, 8), (1, 3),
  (2, 7), (2, 8),
  (3, 4), (3, 12),
  (4, 6), (4, 11),
  (5, 2), (5, 11),
  (6, 3), (6, 9),
  (7, 3), (7, 9),
  (8, 7), (8, 9),
  (9, 1), (9, 8),
  (10, 1), (10, 2), (10, 6),
  (11, 1), (11, 11),
  (12, 9), (12, 3),
  (13, 9), (13, 12);

insert into tipo_entrada (id_entrada, nombre, precio, beneficios, id_evento) values
  (1,  'General Access', 85000,  'Acceso a conferencias y zona de innovación', 1),
  (2,  'Professional',   180000, 'Incluye talleres y almuerzo los tres días', 1),
  (3,  'Corporate',      320000, 'Cupo para equipo de hasta 3 personas y sesión privada', 1),
  (4,  'General Access', 120000, 'Acceso a todas las charlas', 2),
  (5,  'Professional',   220000, 'Incluye los talleres prácticos', 2),
  (6,  'General Access', 95000,  null, 3),
  (7,  'General Access', 60000,  null, 4),
  (8,  'General Access', 150000, 'Materiales incluidos', 5),
  (9,  'General Access', 190000, null, 6),
  (10, 'General Access', 210000, null, 7),
  (11, 'Professional',   350000, 'Incluye mentoría individual post-bootcamp', 7),
  (12, 'Entrada libre',  0,      null, 8),
  (13, 'Entrada libre',  0,      null, 9),
  (14, 'General Access', 140000, null, 10),
  (15, 'General Access', 160000, null, 11),
  (16, 'General Access', 130000, null, 12),
  (17, 'General Access', 145000, null, 13);

-- Los ids se insertaron a mano: se adelantan las secuencias para que el
-- siguiente insert desde la app no choque.
select setval(pg_get_serial_sequence('public.ciudad', 'id_ciudad'),             (select max(id_ciudad) from ciudad));
select setval(pg_get_serial_sequence('public.categoria', 'id_categoria'),       (select max(id_categoria) from categoria));
select setval(pg_get_serial_sequence('public.etiqueta', 'id_etiqueta'),         (select max(id_etiqueta) from etiqueta));
select setval(pg_get_serial_sequence('public.serie_evento', 'id_serie'),        (select max(id_serie) from serie_evento));
select setval(pg_get_serial_sequence('public.evento', 'id_evento'),             (select max(id_evento) from evento));
select setval(pg_get_serial_sequence('public.tipo_entrada', 'id_entrada'),      (select max(id_entrada) from tipo_entrada));
-- organizador: puede haber filas creadas por el trigger de alta, no se pisa
-- una secuencia que ya va mas adelante.
select setval(pg_get_serial_sequence('public.organizador', 'id_organizador'),
              greatest((select max(id_organizador) from organizador), 5));

-- ---------------------------------------------------------------------------
-- Usuario demo (Ana Torres)
-- ---------------------------------------------------------------------------
-- No se puede insertar en auth.users desde aqui. Pasos:
--   1. Authentication > Users > Add user: ana.torres@icesi.edu.co, contrasena
--      123456, marcando "Auto Confirm User".
--   2. Ejecutar este bloque. Es idempotente: se puede repetir.
-- Si la cuenta no existe todavia, no hace nada.

do $$
declare
  v_ana uuid;
begin
  select id into v_ana from auth.users where email = 'ana.torres@icesi.edu.co';
  if v_ana is null then
    raise notice 'Ana Torres no existe en auth.users; crea la cuenta y vuelve a ejecutar este bloque.';
    return;
  end if;

  -- perfil (el trigger de alta ya lo creo con valores por defecto)
  update usuario set nombre = 'Ana Torres', id_ciudad = 3 where id_usuario = v_ana;

  -- sus eventos (4, 5 y 11) son del organizador 3: se le entrega a ella y se
  -- descarta el organizador que le creo el trigger
  delete from organizador where id_usuario = v_ana and id_organizador <> 3;
  update organizador set id_usuario = v_ana where id_organizador = 3;

  insert into usuario_interes (id_usuario, id_categoria) values
    (v_ana, 1), (v_ana, 2), (v_ana, 5)
  on conflict do nothing;

  insert into usuario_etiqueta (id_usuario, id_etiqueta, peso) values
    (v_ana, 1, 0.86),  -- team leadership
    (v_ana, 2, 0.74),  -- agile delivery
    (v_ana, 3, 0.69),  -- data analytics
    (v_ana, 4, 0.61),  -- clinical research
    (v_ana, 5, 0.55),  -- public speaking
    (v_ana, 6, 0.52)   -- change management
  on conflict (id_usuario, id_etiqueta) do update set peso = excluded.peso;

  insert into evento_guardado (id_usuario, id_evento, fecha_guardado) values
    (v_ana, 11, '2026-11-02 09:00-05'),
    (v_ana, 12, '2026-11-03 14:00-05'),
    (v_ana, 7,  '2026-11-04 20:00-05')
  on conflict do nothing;

  insert into reserva (cantidad, codigo_qr, fecha_reserva, fecha_uso, id_usuario, id_entrada) values
    (1, 'PEIP-DATA-SEP-0001',  '2026-09-01 10:00-05', '2026-09-14 08:10-05', v_ana, 9),
    (2, 'PEIP-AGILE-DIC-0002', '2026-11-05 10:00-05', null,                  v_ana, 14)
  on conflict (codigo_qr) do nothing;

  insert into busqueda_reciente (texto, fecha, id_usuario) values
    ('agile',       '2026-11-03 11:00-05', v_ana),
    ('estadística', '2026-11-04 19:00-05', v_ana)
  on conflict do nothing;
end;
$$;
