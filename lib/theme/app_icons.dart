import 'package:flutter/material.dart';

/// Color hex (de Categoria.color) a Color de Flutter.
Color colorDeHex(String hex) =>
    Color(int.parse(hex.replaceFirst('#', ''), radix: 16) | 0xFF000000);

/// Icono para el nombre simbólico de Categoria.icono (ver mock_data.dart).
IconData iconoDe(String nombre) {
  switch (nombre) {
    case 'tech':
      return Icons.memory;
    case 'leadership':
      return Icons.groups;
    case 'medical':
      return Icons.local_hospital;
    case 'research':
      return Icons.science;
    case 'agile':
      return Icons.loop;
    case 'project':
      return Icons.view_kanban;
    case 'innovation':
      return Icons.lightbulb;
    case 'entrepreneurship':
      return Icons.rocket_launch;
    case 'speaking':
      return Icons.record_voice_over;
    case 'finance':
      return Icons.bar_chart;
    case 'sustainability':
      return Icons.eco;
    case 'wellbeing':
      return Icons.self_improvement;
    default:
      return Icons.event;
  }
}
