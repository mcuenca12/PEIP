import 'package:flutter/material.dart';

import '../pages/ticket_page.dart';
import '../routes/route_args.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as TicketArgs;
    return Scaffold(
      appBar: AppBar(title: const Text('Mi ticket')),
      body: SafeArea(
        child: TicketPage(ticket: args.ticket, onCancelar: args.onCancelar),
      ),
    );
  }
}
