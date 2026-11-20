-- PEIP, entrega 4. Bloque D: almacenamiento de imagenes de portada.
-- Se ejecuta despues de 01_schema.sql, 02_policies.sql y 03_seed.sql.
-- En la tabla evento solo se guarda la ruta del archivo (evento.imagen_path).

-- Bucket publico: cualquiera puede ver las imagenes porque los eventos son
-- publicos (RN-03). Maximo 5 MB y solo formatos de imagen.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('portadas', 'portadas', true, 5242880,
        array['image/jpeg', 'image/png', 'image/webp'])
on conflict (id) do nothing;

-- Solo un usuario con sesion sube imagenes, y solo dentro de su carpeta,
-- que se llama igual que su uuid: <uuid>/<archivo> (RN-04).
create policy "portadas: subir en carpeta propia"
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'portadas'
  and (storage.foldername(name))[1] = auth.uid()::text
);