import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  // null si quedó bien, si no el mensaje de error
  final String? Function(String email, String password) onLogin;
  final VoidCallback onIrRegistro;

  const LoginPage({super.key, required this.onLogin, required this.onIrRegistro});

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

  void _submit() => setState(() => _error = widget.onLogin(_email.text, _pass.text));

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _Hero(),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bienvenido de nuevo',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Entra a tu cuenta de PEIP para continuar.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),
                PeipFormField(
                  label: 'Correo',
                  child: PeipTextField(
                    hint: 'tu@correo.com',
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                  ),
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
                    onPressed: widget.onIrRegistro,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// quitamos lo de iniciar con Google, no tenemos nube
class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
      color: AppColors.brand600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PEIP',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          const SizedBox(height: 20),
          const Text(
            'Encuentra el evento\nque resuelve lo que necesitas',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Congresos, talleres y charlas — por significado, no por palabra exacta.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
          ),
          const SizedBox(height: 18),
          const _Bullet('Busca por lo que necesitas, no por etiquetas'),
          const _Bullet('Mejora mientras más lo usas'),
          const _Bullet('Los eventos nuevos se ven de una'),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String texto;
  const _Bullet(this.texto);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(texto, style: TextStyle(color: Colors.white.withValues(alpha: 0.92))),
          ),
        ],
      ),
    );
  }
}
