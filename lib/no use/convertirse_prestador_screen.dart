import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../services/api_service.dart';

class ConvertirsePrestadorScreen extends StatefulWidget {
  final String token;

  ConvertirsePrestadorScreen({required this.token});

  @override
  _ConvertirsePrestadorScreenState createState() => _ConvertirsePrestadorScreenState();
}

class _ConvertirsePrestadorScreenState extends State<ConvertirsePrestadorScreen> {
  final TextEditingController categoriaController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final LocationService locationService = LocationService();
  final ApiService apiService = ApiService();

  void convertir() async {
    try {
      var posicion = await locationService.getCurrentLocation();
      bool success = await apiService.convertirEnPrestador(
        widget.token,
        categoriaController.text,
        descripcionController.text,
        posicion.latitude,
        posicion.longitude
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ahora eres un prestador de servicio"))
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al cambiar de rol"))
        );
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Convertirse en Prestador")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: categoriaController, decoration: InputDecoration(labelText: "Categoría del Servicio")),
            TextField(controller: descripcionController, decoration: InputDecoration(labelText: "Descripción")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: convertir, child: Text("Guardar y Convertirse")),
          ],
        ),
      ),
    );
  }
}
