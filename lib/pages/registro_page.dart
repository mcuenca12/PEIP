import 'package:flutter/material.dart';

import '../model/models.dart';
import '../theme/app_colors.dart';
import '../widgets/widgets.dart';

class RegistroPage extends StatefulWidget {
  final List<Ciudad> ciudades;

  // null si quedó bien, si no el mensaje de error
  final String? Function(String nombre, String email, String password, int idCiudad) onRegistro;

  const RegistroPage({super.key, required this.ciudades, required this.onRegistro});

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final _nombre = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  late int _idCiudad = widget.ciudades.first.idCiudad;
  String? _error;

  @override
  void dispose() {
    _nombre.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _submit() =>
      setState(() => _error = widget.onRegistro(_nombre.text, _email.text, _pass.text, _idCiudad));

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
              const PasoIndicador(actual: 1, total: 3),
              const SizedBox(height: 20),
              PeipFormField(
                label: 'Nombre',
                child: PeipTextField(controller: _nombre),
              ),
              const SizedBox(height: 14),
              PeipFormField(
                label: 'Correo',
                child: PeipTextField(controller: _email, keyboardType: TextInputType.emailAddress),
              ),
              const SizedBox(height: 14),
              PeipFormField(
                label: 'Contraseña (mín. 6)',
                child: PeipTextField(controller: _pass, obscure: true),
              ),
              const SizedBox(height: 14),
              PeipFormField(
                label: 'Ciudad',
                child: DropdownButtonFormField<int>(
                  initialValue: _idCiudad,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (final c in widget.ciudades)
                      DropdownMenuItem(value: c.idCiudad, child: Text(c.nombre)),
                  ],
                  onChanged: (v) => setState(() => _idCiudad = v!),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!, style: const TextStyle(color: AppColors.danger)),
              ],
              const SizedBox(height: 20),
              PeipButton(label: 'Registrarme', onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
