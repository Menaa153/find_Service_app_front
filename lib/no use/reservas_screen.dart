import 'package:flutter/material.dart';

class ReservasScreen extends StatelessWidget {
  final String token;

  ReservasScreen({required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Aquí estarán las reservas del usuario"),
      ),
    );
  }
}
