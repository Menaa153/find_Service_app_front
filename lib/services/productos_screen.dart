import 'package:flutter/material.dart';
import 'api_service.dart';

class ProductosScreen extends StatefulWidget {
  @override
  _ProductosScreenState createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  ApiService apiService = ApiService();
  late Future<List<dynamic>> productos;

  //@override
  //void initState() {
  //  super.initState();
  // productos = apiService.fetchProductos();
  //}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Productos')),
      body: FutureBuilder<List<dynamic>>(
        future: productos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var producto = snapshot.data![index];
                return ListTile(
                  title: Text(producto['nombre']),
                  subtitle: Text('Precio: \$${producto['precio']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
