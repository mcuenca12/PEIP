import 'package:flutter/material.dart';

import '../screens/crear_evento_screen.dart';
import '../screens/detalle_evento_screen.dart';
import '../screens/login_screen.dart';
import '../screens/main_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/preferencias_screen.dart';
import '../screens/registro_screen.dart';
import '../screens/ticket_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String registro = '/registro';
  static const String onboarding = '/onboarding';
  static const String preferencias = '/preferencias';
  static const String main = '/main';
  static const String detalle = '/evento';
  static const String crearEvento = '/crear-evento';
  static const String ticket = '/ticket';

  static Map<String, WidgetBuilder> get routes => {
        login: (context) => const LoginScreen(),
        registro: (context) => const RegistroScreen(),
        onboarding: (context) => const OnboardingScreen(),
        preferencias: (context) => const PreferenciasScreen(),
        main: (context) => const MainScreen(),
        detalle: (context) => const DetalleEventoScreen(),
        crearEvento: (context) => const CrearEventoScreen(),
        ticket: (context) => const TicketScreen(),
      };
}
