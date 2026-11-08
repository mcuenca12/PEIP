import 'package:flutter/material.dart';

import '../model/mock_data.dart';
import '../model/models.dart';
import '../pages/registro_page.dart';
import '../routes/app_routes.dart';

class RegistroScreen extends StatelessWidget {
  const RegistroScreen({super.key});

  String? _intentarRegistro(BuildContext context, String nombre, String email,
      String pass, int idCiudad) {
    if (nombre.trim().isEmpty || !email.contains('@')) {
      return 'Escribe un nombre y un correo válido.';
    }
    if (pass.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres.';
    }
    final correo = email.trim().toLowerCase();
    if (MockData.usuarios.any((u) => u.email.toLowerCase() == correo)) {
      return 'Ese correo ya está registrado.';
    }
    final siguienteId =
        MockData.usuarios.fold(0, (m, u) => u.idUsuario > m ? u.idUsuario : m) +
            1;
    final nuevo = Usuario(
      idUsuario: siguienteId,
      nombre: nombre.trim(),
      email: email.trim(),
      contrasenaHash: hashSimulado(pass),
      idCiudad: idCiudad,
    );
    Navigator.pushReplacementNamed(context, AppRoutes.onboarding,
        arguments: nuevo);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SafeArea(
        child: RegistroPage(
          ciudades: MockData.ciudades,
          onRegistro: (nombre, email, pass, idCiudad) =>
              _intentarRegistro(context, nombre, email, pass, idCiudad),
        ),
      ),
    );
  }
}
