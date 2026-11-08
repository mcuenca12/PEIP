import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  /// Devuelve un mensaje de error, o null si el ingreso fue exitoso.
  final String? Function(String email, String password) onLogin;
  final VoidCallback onIrRegistro;

  const LoginPage(
      {super.key, required this.onLogin, required this.onIrRegistro});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController(text: 'ana.torres@icesi.edu.co');
  final _pass = TextEditingController(text: '123456');
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _submit() =>
      setState(() => _error = widget.onLogin(_email.text, _pass.text));

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('PEIP',
                  style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: AppColors.brand600)),
              const SizedBox(height: 8),
              const Text('Encuentra el evento que resuelve lo que necesitas.',
                  style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 32),
              const Text('Bienvenido de nuevo',
                  style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 20),
              PeipFormField(
                label: 'Correo',
                child: PeipTextField(
                    hint: 'tu@correo.com',
                    controller: _email,
                    keyboardType: TextInputType.emailAddress),
              ),
              const SizedBox(height: 14),
              PeipFormField(
                label: 'Contraseña',
                child: PeipTextField(controller: _pass, obscure: true),
              ),
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!, style: const TextStyle(color: AppColors.danger)),
              ],
              const SizedBox(height: 20),
              PeipButton(label: 'Iniciar sesión', onPressed: _submit),
              const SizedBox(height: 8),
              Center(
                child: PeipButton(
                    label: '¿No tienes cuenta? Regístrate',
                    kind: PeipButtonKind.ghost,
                    expand: false,
                    onPressed: widget.onIrRegistro),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
