import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

// Llegan desde env.json con --dart-define-from-file. Los nombres son los de
// env.example.json; los valores nunca se escriben en el código.
const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabaseKey = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

class PeipApp extends StatelessWidget {
  // Se recibe por constructor para que las pruebas construyan la app sin
  // Supabase y para que la guardia de sesión decida dónde arrancar.
  final String initialRoute;

  const PeipApp({super.key, this.initialRoute = AppRoutes.login});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PEIP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.tema,
      initialRoute: initialRoute,
      routes: AppRoutes.routes,
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseKey);
  runApp(const PeipApp());
}
