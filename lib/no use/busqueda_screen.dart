import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../services/api_service.dart';

class BusquedaScreen extends StatefulWidget {
  @override
  _BusquedaScreenState createState() => _BusquedaScreenState();
}

class _BusquedaScreenState extends State<BusquedaScreen> {
  final LocationService locationService = LocationService();
  final ApiService apiService = ApiService();
  final TextEditingController categoriaController = TextEditingController();
  List<dynamic> prestadores = [];

  void buscar() async {
    try {
      var posicion = await locationService.getCurrentLocation();
      String categoria = categoriaController.text.trim();

      if (categoria.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Por favor, ingresa una categoría")),
        );
        return;
      }

      List<dynamic> resultados = await apiService.buscarPrestadores(
          posicion.latitude, posicion.longitude, categoria);

      setState(() {
        prestadores = resultados;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Buscar Servicios Cercanos")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: categoriaController,
              decoration: InputDecoration(labelText: "Categoría del Servicio"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: buscar,
              child: Text("Buscar Servicios"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: prestadores.length,
                itemBuilder: (context, index) {
                  final p = prestadores[index];
                  return ListTile(
                    title: Text(p["username"]),
                    subtitle: Text(
                      "Categoría: ${p["categoria"]}\n"
                      "Descripción: ${p["descripcion"]}\n"
                      "Distancia: ${p["distancia_km"].toStringAsFixed(2)} km",
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
