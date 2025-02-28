import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  final String role;
  final String token;  // 🔹 Agregar token

  HomeScreen({required this.role, required this.token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService authService = AuthService();
  String currentRole = "";

  @override
  void initState() {
    super.initState();
    currentRole = widget.role;
  }

  void switchRole() async {
    String newRole = currentRole == "cliente" ? "prestador" : "cliente";
    bool success = await authService.cambiarRol(widget.token, newRole);
    
    if (success) {
      setState(() {
        currentRole = newRole;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cambiar de rol"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home - Rol: $currentRole")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),

          // 🔹 Botón para buscar prestadores cercanos
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/buscar-prestadores'),
            child: Text("Buscar Prestadores Cercanos"),
          ),

          SizedBox(height: 20),

          // 🔹 Mostrar "Convertirse en Prestador" solo si el usuario es cliente
          if (currentRole == "cliente")
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                '/convertirse-prestador',
                arguments: {"token": widget.token},
              ),
              child: Text("Convertirse en Prestador"),
            ),

          SizedBox(height: 20),

          // 🔹 Botón para cambiar de rol entre cliente y prestador
          ElevatedButton(
            onPressed: switchRole,
            child: Text("Cambiar a ${currentRole == "cliente" ? "prestador" : "cliente"}"),
          ),
          
                    // 🔹 Botón para ir al perfil del usuario
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(
              context,
              '/perfil',
              arguments: {"token": widget.token},
            ),
            child: Text("Mi Cuenta"),
          ),
        ],
      ),
    );
  }

  
}
