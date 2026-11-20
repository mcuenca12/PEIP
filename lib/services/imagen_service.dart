import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

// Sube y ubica las imágenes de portada en el bucket "portadas" de Storage.
// En la base de datos solo se guarda la ruta (evento.imagen_path).
class ImagenService {
  final _db = Supabase.instance.client;
  static const _bucket = 'portadas';
  static const _url = String.fromEnvironment('SUPABASE_URL');

  // Guarda la imagen en la carpeta del usuario y devuelve su ruta.
  // La política del bucket solo deja subir dentro de la carpeta propia.
  Future<String> subirPortada(Uint8List bytes, String extension) async {
    final idUsuario = _db.auth.currentUser!.id;
    final ruta =
        '$idUsuario/${DateTime.now().millisecondsSinceEpoch}.$extension';
    await _db.storage
        .from(_bucket)
        .uploadBinary(
          ruta,
          bytes,
          fileOptions: FileOptions(
            contentType: 'image/${extension == 'jpg' ? 'jpeg' : extension}',
          ),
        );
    return ruta;
  }

  // Arma la URL pública a partir de la ruta, sin llamar al servidor.
  // Es estática para que los widgets la usen sin crear el cliente.
  static String? urlPublica(String? ruta) {
    if (ruta == null || ruta.isEmpty) return null;
    return '$_url/storage/v1/object/public/$_bucket/$ruta';
  }
}