import 'dart:math';
import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../services/api_service.dart';
import 'perfil_prestador_screen.dart';

class InicioScreen extends StatefulWidget {
  final String token;
  final String nombreUsuario;

  InicioScreen({required this.token, required this.nombreUsuario});

  @override
  _InicioScreenState createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  final TextEditingController categoriaController = TextEditingController();
  final LocationService locationService = LocationService();
  final ApiService apiService = ApiService();
  List<dynamic> prestadores = [];
  bool isLoading = false;

  void buscar() async {
    String categoria = categoriaController.text.trim();

    if (categoria.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, ingresa una categoría")),
      );
      return;
    }

    setState(() {
      isLoading = true;
      prestadores = [];
    });

    try {
      var posicion = await locationService.getCurrentLocation();
      List<dynamic> resultados = await apiService.buscarPrestadores(
          posicion.latitude, posicion.longitude, categoria);

      setState(() {
        prestadores = resultados;
      });
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al buscar servicios")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  double generarCalificacion() {
    return (Random().nextDouble() * 2.0) + 3.0; // Genera valores entre 3.0 y 5.0
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hola, ${widget.nombreUsuario}"),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {}, // agregar funcionalidad de notificaciones
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de busqueda de categoria
            TextField(
              controller: categoriaController,
              decoration: InputDecoration(
                hintText: "Buscar servicio",
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: buscar, // Buscar al presionar el boton
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onSubmitted: (value) => buscar(), // Buscar al presionar enter
            ),

            SizedBox(height: 20),

            //mostrar cargando
            if (isLoading) CircularProgressIndicator(),

            // lsta de resultados
            Expanded(
              child: ListView.builder(
                itemCount: prestadores.length,
                itemBuilder: (context, index) {
                  final p = prestadores[index];
                  double calificacion = generarCalificacion();
                  return _prestadorItem(
                    p["username"],
                    p["categoria"],
                    p["email"],
                    calificacion,
                    p["descripcion"],
                    context, // pasamos el `context` para la navegacion
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _prestadorItem(String nombre, String categoria, String ubicacion, double calificacion, String descripcion, BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage("assets/default_profile.png"),
      ),
      title: Text(nombre),
      subtitle: Text("Categoría: $categoria\nUbicación: $ubicacion"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: Colors.yellow),
          Text(calificacion.toStringAsFixed(1)),
        ],
      ),
      onTap: () {
        // Navegamos a la pantalla de perfil del prestador con los datos correctos
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PerfilPrestadorScreen(
              nombre: nombre,
              categoria: categoria,
              ubicacion: ubicacion,
              calificacion: calificacion.toStringAsFixed(1),
              descripcion: descripcion,
            ),
          ),
        );
      },
    );
  }
}
