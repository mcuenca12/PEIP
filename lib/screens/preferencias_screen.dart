import 'package:flutter/material.dart';

import '../model/models.dart';
import '../pages/preferencias_page.dart';
import '../routes/app_routes.dart';

class PreferenciasScreen extends StatelessWidget {
  const PreferenciasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = ModalRoute.of(context)!.settings.arguments as Usuario;
    return Scaffold(
      body: SafeArea(
        child: PreferenciasPage(
          onTerminar: () => Navigator.pushReplacementNamed(
              context, AppRoutes.main,
              arguments: usuario),
        ),
      ),
    );
  }
}
