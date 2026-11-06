import 'package:flutter/material.dart';

import 'routes/app_routes.dart';

class PeipApp extends StatelessWidget {
  const PeipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PEIP',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}

void main() {
  runApp(const PeipApp());
}
