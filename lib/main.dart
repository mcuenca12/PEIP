import 'package:flutter/material.dart';

import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

class PeipApp extends StatelessWidget {
  const PeipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PEIP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.tema,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}

void main() {
  runApp(const PeipApp());
}
