import 'package:flutter/material.dart';

class ReservaScreen extends StatelessWidget {
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController horaController = TextEditingController();
  final TextEditingController ubicacionController = TextEditingController();

  void confirmarReserva() {
    print("Reserva confirmada");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reserva Servicio")),
      body: Column(
        children: [
          TextField(controller: fechaController, decoration: InputDecoration(labelText: "Fecha")),
          TextField(controller: horaController, decoration: InputDecoration(labelText: "Hora")),
          TextField(controller: ubicacionController, decoration: InputDecoration(labelText: "Ubicación")),
          ElevatedButton(onPressed: confirmarReserva, child: Text("Confirmar Reserva"))
        ],
      ),
    );
  }
}
