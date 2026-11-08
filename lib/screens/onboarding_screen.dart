import 'package:flutter/material.dart';

import '../model/mock_data.dart';
import '../model/models.dart';
import '../pages/onboarding_page.dart';
import '../routes/app_routes.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = ModalRoute.of(context)!.settings.arguments as Usuario;
    return Scaffold(
      body: SafeArea(
        child: OnboardingPage(
          categorias: MockData.categorias,
          onTerminar: (intereses) => Navigator.pushReplacementNamed(
              context, AppRoutes.main,
              arguments: usuario.copyWith(intereses: intereses)),
        ),
      ),
    );
  }
}
