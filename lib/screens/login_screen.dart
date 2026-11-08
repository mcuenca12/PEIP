import 'package:flutter/material.dart';

import '../model/mock_data.dart';
import '../pages/login_page.dart';
import '../routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  String? _intentarLogin(BuildContext context, String email, String password) {
    final correo = email.trim().toLowerCase();
    final encontrado = MockData.usuarios.where((u) =>
        u.email.toLowerCase() == correo &&
        u.contrasenaHash == hashSimulado(password));
    if (encontrado.isEmpty) return 'Correo o contraseña incorrectos.';
    Navigator.pushReplacementNamed(context, AppRoutes.main,
        arguments: encontrado.first);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LoginPage(
          onLogin: (email, password) =>
              _intentarLogin(context, email, password),
          onIrRegistro: () => Navigator.pushNamed(context, AppRoutes.registro),
        ),
      ),
    );
  }
}
