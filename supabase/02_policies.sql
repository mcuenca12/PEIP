-- PEIP, entrega 4. Bloque A: seguridad por fila (RLS).
--
-- Modelo de acceso:
--   * Catalogos (ciudad, categoria, etiqueta, sinonimo, organizador,
--     serie_evento): lectura publica, sin escritura desde la app.
--   * Eventos publicados: lectura publica. Los borradores y cancelados solo los
--     ve su organizador (y quien tenga una reserva en ellos).
--   * Crear, editar y borrar eventos, entradas y etiquetas de evento: solo el
--     organizador dueno (organizador.id_usuario = auth.uid()).
--   * usuario, intereses, etiquetas inferidas, guardados, reservas y busquedas
--     recientes: solo su dueno (auth.uid() = id_usuario).
--
-- A diferencia del ejemplo de clase, nada queda abierto a anon salvo la lectura
-- del catalogo y de eventos publicados.

-- ---------------------------------------------------------------------------
-- Funciones auxiliares
-- ---------------------------------------------------------------------------
-- security definer para leer organizador/reserva sin disparar su RLS. Sin esto
-- las politicas de evento y tipo_entrada se referirian entre si y Postgres
-- aborta con "infinite recursion detected in policy".

create function es_mi_organizador(p_id_organizador integer)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.organizador o
    where o.id_organizador = p_id_organizador
      and o.id_usuario = auth.uid()
  );
$$;

create function es_dueno_evento(p_id_evento integer)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.evento e
    join public.organizador o on o.id_organizador = e.id_organizador
    where e.id_evento = p_id_evento
      and o.id_usuario = auth.uid()
  );
$$;

-- Un asistente sigue viendo el evento de una reserva suya aunque el organizador
-- lo haya pasado a borrador o cancelado, para no romper "Mis tickets".
create function tengo_reserva_en_evento(p_id_evento integer)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.reserva r
    join public.tipo_entrada t on t.id_entrada = r.id_entrada
    where t.id_evento = p_id_evento
      and r.id_usuario = auth.uid()
  );
$$;

-- ---------------------------------------------------------------------------
-- Activar RLS
-- ---------------------------------------------------------------------------

alter table ciudad            enable row level security;
alter table categoria         enable row level security;
alter table etiqueta          enable row level security;
alter table sinonimo          enable row level security;
alter table organizador       enable row level security;
alter table serie_evento      enable row level security;
alter table usuario           enable row level security;
alter table evento            enable row level security;
alter table tipo_entrada      enable row level security;
alter table evento_etiqueta   enable row level security;
alter table reserva           enable row level security;
alter table evento_guardado   enable row level security;
alter table busqueda_reciente enable row level security;
alter table usuario_interes   enable row level security;
alter table usuario_etiqueta  enable row level security;

-- ---------------------------------------------------------------------------
-- Catalogos: lectura publica
-- ---------------------------------------------------------------------------

create policy ciudad_select on ciudad
  for select to anon, authenticated using (true);

create policy categoria_select on categoria
  for select to anon, authenticated using (true);

create policy etiqueta_select on etiqueta
  for select to anon, authenticated using (true);

create policy sinonimo_select on sinonimo
  for select to anon, authenticated using (true);

create policy organizador_select on organizador
  for select to anon, authenticated using (true);

create policy serie_evento_select on serie_evento
  for select to anon, authenticated using (true);

-- ---------------------------------------------------------------------------
-- Eventos
-- ---------------------------------------------------------------------------

create policy evento_select on evento
  for select to anon, authenticated
  using (
    estado = 'publicado'
    or public.es_mi_organizador(id_organizador)
    or public.tengo_reserva_en_evento(id_evento)
  );

create policy evento_insert on evento
  for insert to authenticated
  with check (public.es_mi_organizador(id_organizador));

create policy evento_update on evento
  for update to authenticated
  using (public.es_mi_organizador(id_organizador))
  with check (public.es_mi_organizador(id_organizador));

create policy evento_delete on evento
  for delete to authenticated
  using (public.es_mi_organizador(id_organizador));

-- Una entrada o una etiqueta de evento es visible si el evento lo es. El
-- subselect pasa por la RLS de evento.

create policy tipo_entrada_select on tipo_entrada
  for select to anon, authenticated
  using (exists (select 1 from evento e where e.id_evento = tipo_entrada.id_evento));

create policy tipo_entrada_insert on tipo_entrada
  for insert to authenticated
  with check (public.es_dueno_evento(id_evento));

create policy tipo_entrada_update on tipo_entrada
  for update to authenticated
  using (public.es_dueno_evento(id_evento))
  with check (public.es_dueno_evento(id_evento));

create policy tipo_entrada_delete on tipo_entrada
  for delete to authenticated
  using (public.es_dueno_evento(id_evento));

create policy evento_etiqueta_select on evento_etiqueta
  for select to anon, authenticated
  using (exists (select 1 from evento e where e.id_evento = evento_etiqueta.id_evento));

create policy evento_etiqueta_insert on evento_etiqueta
  for insert to authenticated
  with check (public.es_dueno_evento(id_evento));

create policy evento_etiqueta_delete on evento_etiqueta
  for delete to authenticated
  using (public.es_dueno_evento(id_evento));

-- ---------------------------------------------------------------------------
-- Datos personales: solo el dueno
-- ---------------------------------------------------------------------------
-- El perfil lo crea el trigger handle_new_user; el insert propio queda
-- permitido por si algun dia se crea desde la app.

create policy usuario_select on usuario
  for select to authenticated using (auth.uid() = id_usuario);

create policy usuario_insert on usuario
  for insert to authenticated with check (auth.uid() = id_usuario);

create policy usuario_update on usuario
  for update to authenticated
  using (auth.uid() = id_usuario)
  with check (auth.uid() = id_usuario);

create policy usuario_interes_all on usuario_interes
  for all to authenticated
  using (auth.uid() = id_usuario)
  with check (auth.uid() = id_usuario);

create policy usuario_etiqueta_all on usuario_etiqueta
  for all to authenticated
  using (auth.uid() = id_usuario)
  with check (auth.uid() = id_usuario);

create policy evento_guardado_all on evento_guardado
  for all to authenticated
  using (auth.uid() = id_usuario)
  with check (auth.uid() = id_usuario);

create policy busqueda_reciente_all on busqueda_reciente
  for all to authenticated
  using (auth.uid() = id_usuario)
  with check (auth.uid() = id_usuario);

-- Reservas: ver, crear y cancelar (borrar) las propias. No se editan.

create policy reserva_select on reserva
  for select to authenticated using (auth.uid() = id_usuario);

create policy reserva_insert on reserva
  for insert to authenticated with check (auth.uid() = id_usuario);

create policy reserva_delete on reserva
  for delete to authenticated using (auth.uid() = id_usuario);
