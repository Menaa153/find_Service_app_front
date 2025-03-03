import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Asegúrate de importar intl
import 'package:http/http.dart' as http;

class ReservaScreen extends StatefulWidget {
  final String token;
  final String prestadorId;

  ReservaScreen({required this.token, required this.prestadorId});

  @override
  _ReservaScreenState createState() => _ReservaScreenState();
}

class _ReservaScreenState extends State<ReservaScreen> {
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController horaController = TextEditingController();
  final TextEditingController ubicacionController = TextEditingController();

  bool isLoading = false;

  // Método para convertir la hora de formato AM/PM a formato 24 horas
  String convertirHora(String hora) {
    var format12 = DateFormat("hh:mm a");  // Formato de 12 horas (AM/PM)
    var formatoHora = format12.parse(hora);  // Convierte la hora AM/PM a DateTime
    var formato24 = DateFormat("HH:mm").format(formatoHora);  // Formato de 24 horas (HH:mm)
    return formato24;
  }

  // Método para seleccionar la fecha
  Future<void> seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        fechaController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // Método para seleccionar la hora
  Future<void> seleccionarHora() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );
    if (picked != null) {
      setState(() {
        horaController.text = picked.format(context);  // Formato hh:mm AM/PM
      });
    }
  }

  // Método para enviar la reserva al backend
  Future<void> enviarReserva() async {
    setState(() {
      isLoading = true;
    });

    String fecha = fechaController.text.trim();
    String hora = horaController.text.trim();

    // Verifica que los campos no estén vacíos
    if (fecha.isEmpty || hora.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Por favor, completa todos los campos")));
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Convierte la hora a formato 24 horas
    String horaConvertida = convertirHora(hora);

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/reservas/'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'prestador_id': widget.prestadorId,
          'fecha': fecha,
          'hora': horaConvertida,  // Enviar la hora convertida
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Reserva realizada con éxito")));
        setState(() {
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al realizar la reserva")));
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al enviar la reserva")));
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reserva Servicio")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo para seleccionar la fecha con el calendario nativo
            TextField(
              controller: fechaController,
              decoration: InputDecoration(
                labelText: "Fecha (yyyy-MM-dd)",
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              readOnly: true, // Impide que el usuario escriba, solo puede seleccionar
              onTap: seleccionarFecha, // Abre el calendario al hacer clic
            ),
            SizedBox(height: 20),
            // Campo para ingresar la hora con el selector nativo
            TextField(
              controller: horaController,
              decoration: InputDecoration(labelText: "Hora (hh:mm AM/PM)"),
              readOnly: true, // Impide que el usuario escriba, solo puede seleccionar
              onTap: seleccionarHora, // Abre el selector de hora al hacer clic
            ),
            SizedBox(height: 20),
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else
              ElevatedButton(
                onPressed: enviarReserva,
                child: Text("Confirmar Reserva"),
              ),
          ],
        ),
      ),
    );
  }
}