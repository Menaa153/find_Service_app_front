import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ReservasScreen extends StatefulWidget {
  final String token;

  ReservasScreen({required this.token});

  @override
  _ReservasScreenState createState() => _ReservasScreenState();
}

class _ReservasScreenState extends State<ReservasScreen> {
  bool isLoading = true;
  List<dynamic> reservas = [];

  @override
  void initState() {
    super.initState();
    _obtenerReservas();
  }

  // Método para obtener las reservas del cliente
  Future<void> _obtenerReservas() async {
    try {
      List<dynamic> result = await ApiService().obtenerReservas(widget.token);
      setState(() {
        reservas = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al obtener las reservas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tus Reservas")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: reservas.length,
              itemBuilder: (context, index) {
                final reserva = reservas[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: ListTile(
                    leading: Icon(Icons.calendar_today, color: Colors.blue),
                    title: Text('Fecha: ${reserva['fecha']}'),
                    subtitle: Text('Hora: ${reserva['hora']}'),
                    trailing: Icon(Icons.check_circle, color: reserva['confirmada'] ? Colors.green : Colors.red),
                    onTap: () {
                      // Agregar funcionalidad de detalles o edición de la reserva si es necesario
                    },
                  ),
                );
              },
            ),
    );
  }
}
