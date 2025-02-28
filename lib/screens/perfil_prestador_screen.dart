import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'reserva_screen.dart';

class PerfilPrestadorScreen extends StatelessWidget {
  final String nombre;
  final String categoria;
  final String ubicacion;
  final String calificacion;

  PerfilPrestadorScreen({
    required this.nombre,
    required this.categoria,
    required this.ubicacion,
    required this.calificacion,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(nombre)),
      body: Column(
        children: [
          Text("$nombre - $categoria"),
          Text("Ubicación: $ubicacion"),
          Text("Calificación: $calificacion ★"),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.chat),
                label: Text("Chat"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(roomId: nombre, sender: "Cliente"),
                    ),
                  );
                },
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.calendar_today),
                label: Text("Reservar"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReservaScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
