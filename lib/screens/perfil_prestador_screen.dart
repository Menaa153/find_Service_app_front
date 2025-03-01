import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'reserva_screen.dart';

class PerfilPrestadorScreen extends StatelessWidget {
  final String nombre;
  final String categoria;
  final String ubicacion;
  final String calificacion;
  final String descripcion;

  PerfilPrestadorScreen({
    required this.nombre,
    required this.categoria,
    required this.ubicacion,
    required this.calificacion,
    required this.descripcion,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(nombre)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/default_profile.png"), // Imagen por defecto
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombre,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      categoria,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow, size: 24),
                    Text(
                      calificacion,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(),
            Text(
              "Información",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Ubicación: $ubicacion"),
            Text("Servicios realizados: 10"), // modificar
            Text("Descripción: $descripcion"),
            SizedBox(height: 20),
            Divider(),
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
      ),
    );
  }
}
